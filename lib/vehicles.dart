import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:emission/theme/theme_manager.dart';

class Vehicles extends StatefulWidget {
  const Vehicles({super.key});

  @override
  State<StatefulWidget> createState() => VehiclesState();
}

class VehiclesState extends State<Vehicles> {
  List<Map<String, dynamic>> vehicles = [];

  @override
  void initState() {
    super.initState();
    fetchVehicles();
  }

  void fetchVehicles() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    http
        .get(Uri.parse(
            'https://mcs.drury.edu/emission/vehicles?owner=${pref.getInt("userID")}'))
        .then((res) {
      setState(() {
        vehicles = List<dynamic>.from(json.decode(res.body))
            .map((item) => Map<String, dynamic>.from(item))
            .toList();
      });
    });
  }

  void deleteVehicle(int id) {
    http
        .delete(Uri.parse('https://mcs.drury.edu/emission/vehicles?id=${id}'))
        .then((value) => fetchVehicles());
  }

  @override
  Widget build(BuildContext context) {
    ThemeManager themeManager =  Provider.of<ThemeManager>(context);
    return Container(
      decoration: BoxDecoration(color: themeManager.currentTheme.colorScheme.primary),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      alignment: Alignment.center,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Container(
          decoration: BoxDecoration(
              color: themeManager.currentTheme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              ListView.separated(
                shrinkWrap: true,
                itemCount: vehicles.length,
                itemBuilder: (context, index) {
                  final vehicle = vehicles[index];
                  return GestureDetector(
                      onTap: () => openEditModal(context, vehicle),
                      child: Container(
                          padding: const EdgeInsets.only(left: 8),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    vehicle['carName'],
                                    style: const TextStyle(
                                        color: Colors.black45,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Text(
                                    "${vehicle['year']} ${vehicle['make']} ${vehicle['model']}",
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.black45),
                                  )
                                ],
                              ),
                              IconButton(
                                  onPressed: () =>
                                      deleteVehicle(vehicle['carID']),
                                  icon: const Icon(Icons.delete))
                            ],
                          )));
                },
                separatorBuilder: (context, index) => const SizedBox(
                  height: 8,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Center(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: themeManager.currentTheme.colorScheme.background,
                      backgroundColor: themeManager.currentTheme.colorScheme.secondary,
                    ),
                    onPressed: vehicles.length < 2
                        ? () {
                            openAddModal(context);
                          }
                        : null,
                    child: const Text('Add Vehicle')),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void openAddModal(BuildContext context) {
    showDialog(
            context: context,
            builder: (BuildContext context) => const AddVehicleDialog())
        .then((value) {
      fetchVehicles();
    });
  }

  void openEditModal(BuildContext context, Map<String, dynamic> vehicle) {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            AddVehicleDialog(vehicle: vehicle)).then((value) {
      fetchVehicles();
    });
  }
}

class AddVehicleDialog extends StatefulWidget {
  final Map<String, dynamic> vehicle;

  const AddVehicleDialog({super.key, this.vehicle = const {}});

  @override
  State<StatefulWidget> createState() =>
      AddVehicleDialogState(vehicle: vehicle);
}

class AddVehicleDialogState extends State<AddVehicleDialog> {
  Map<String, dynamic> vehicle;
  bool isEdit = false;

  List<Map<String, dynamic>> vehicleMakes = [];
  List<Map<String, dynamic>> allModels = [];
  List<Map<String, dynamic>> vehicleModels = [];
  List<Map<String, dynamic>> vehicleYears = [];

  TextEditingController vehicleNameController = TextEditingController();
  Map<String, dynamic> selectedMake = {};
  Map<String, dynamic> selectedModel = {};
  Map<String, dynamic> selectedYear = {};
  TextEditingController vehicleMileageController = TextEditingController();

  AddVehicleDialogState({required this.vehicle});

  @override
  void initState() {
    super.initState();

    vehicleNameController.addListener(() => setState(() {}));
    vehicleMileageController.addListener(() => setState(() {}));

    isEdit = vehicle.isNotEmpty;

    http.get(Uri.parse('https://mcs.drury.edu/emission/makes')).then((res) {
      vehicleMakes = List<dynamic>.from(json.decode(res.body))
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
      if (isEdit) {
        setState(() {
          vehicleNameController.text = vehicle['carName'];
          vehicleMileageController.text = vehicle['currentMileage'];
          handleSelectedMake(vehicleMakes.firstWhere(
                  (e) => e['data']['attributes']['name'] == vehicle['make']))
              .then((_) => handleSelectedModel(vehicleModels.firstWhere((e) =>
                          e['data']['attributes']['name'] == vehicle['model']))
                      .then((_) {
                    selectedYear = vehicleYears.firstWhere((e) =>
                        e['data']['attributes']['year'].toString() ==
                        vehicle['year']);
                  }));
        });
      }
    });
  }

  Future handleSelectedMake(Map<String, dynamic> make) {
    Completer completer = Completer();

    http
        .get(Uri.parse(
            'https://mcs.drury.edu/emission/models?makeId=${make['data']['id']}'))
        .then((res) {
      setState(() {
        selectedMake = make;
        allModels = List<dynamic>.from(json.decode(res.body))
            .map((item) => Map<String, dynamic>.from(item))
            .toList();
        vehicleModels = allModels.fold([], (previousValue, element) {
          if (!previousValue.any((e) =>
              e['data']['attributes']['name'] ==
              element['data']['attributes']['name'])) {
            previousValue.add(element);
          }
          return previousValue;
        });
        completer.complete();
      });
    });

    return completer.future;
  }

  Future handleSelectedModel(Map<String, dynamic> model) {
    Completer completer = Completer();

    setState(() {
      selectedModel = model;
      vehicleYears = allModels
          .where((element) =>
              element['data']['attributes']['name'] ==
              selectedModel['data']['attributes']['name'])
          .map((e) => allModels.firstWhere((element) =>
              element['data']['attributes']['year'] ==
              e['data']['attributes']['year']))
          .toSet()
          .toList();

      Future.microtask(() {
        completer.complete();
      });
    });

    return completer.future;
  }

  void addVehicle(BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    http
        .post(Uri.parse('https://mcs.drury.edu/emission/vehicles?isEdit=false'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'owner': pref.getInt('userID'),
              'name': vehicleNameController.text,
              'make': selectedMake['data']['attributes']['name'],
              'model': selectedModel['data']['attributes']['name'],
              'year': selectedYear['data']['attributes']['year'].toString(),
              'makeId': selectedMake['data']['id'],
              'modelId': selectedYear['data']['id'],
              'mileage': vehicleMileageController.text
            }))
        .then((res) {
      Navigator.pop(context);
    });
  }

  void editVehicle(BuildContext context) {
    http
        .post(Uri.parse('https://mcs.drury.edu/emission/vehicles?isEdit=true'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'id': vehicle['carID'],
              'name': vehicleNameController.text,
              'make': selectedMake['data']['attributes']['name'],
              'model': selectedModel['data']['attributes']['name'],
              'year': selectedYear['data']['attributes']['year'].toString(),
              'makeId': selectedMake['data']['id'],
              'modelId': selectedYear['data']['id'],
              'mileage': vehicleMileageController.text
            }))
        .then((res) {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(isEdit ? 'Edit Vehicle' : 'Add Vehicle'),
      contentPadding: const EdgeInsets.all(20),
      children: [
        TextFormField(
          controller: vehicleNameController,
          decoration: const InputDecoration(
            labelText: 'Nickname',
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Autocomplete<Map<String, dynamic>>(
          optionsBuilder: (value) {
            if (value.text.isEmpty) return vehicleMakes;
            return vehicleMakes.where((element) => element['data']['attributes']
                    ['name']
                .toString()
                .toLowerCase()
                .contains(value.text.toLowerCase()));
          },
          displayStringForOption: (option) =>
              option['data']['attributes']['name'],
          onSelected: handleSelectedMake,
          fieldViewBuilder:
              (context, textEditingController, focusNode, onFieldSubmitted) {
            textEditingController.text = selectedMake.isNotEmpty
                ? selectedMake['data']['attributes']['name']
                : '';
            focusNode.addListener(() {
              if (!focusNode.hasFocus) {
                var make = vehicleMakes.firstWhere(
                  (e) =>
                      e['data']['attributes']['name'] ==
                      textEditingController.text,
                  orElse: () => {},
                );
                if (make.isNotEmpty) {
                  handleSelectedMake(make);
                } else {
                  textEditingController.text = '';
                  setState(() {
                    vehicleModels = [];
                    selectedMake = {};
                  });
                }
              }
            });
            return TextFormField(
              controller: textEditingController,
              focusNode: focusNode,
              decoration: const InputDecoration(labelText: 'Make'),
            );
          },
          optionsViewBuilder: (context, onSelected, options) => Align(
              alignment: Alignment.topLeft,
              child: Material(
                child: Container(
                    width: 208,
                    height: options.length * 48,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        var option = options.elementAt(index);
                        return InkWell(
                          onTap: () => onSelected(option),
                          child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: InkWell(
                                  child: Text(
                                option['data']['attributes']['name'],
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ))),
                        );
                      },
                    )),
              )),
        ),
        const SizedBox(
          height: 20,
        ),
        Autocomplete<Map<String, dynamic>>(
          optionsBuilder: (value) {
            if (value.text.isEmpty) return vehicleModels;
            return vehicleModels.where((element) => element['data']
                    ['attributes']['name']
                .toString()
                .toLowerCase()
                .contains(value.text.toLowerCase()));
          },
          displayStringForOption: (option) =>
              option['data']['attributes']['name'],
          onSelected: handleSelectedModel,
          fieldViewBuilder:
              (context, textEditingController, focusNode, onFieldSubmitted) {
            textEditingController.text = selectedModel.isNotEmpty
                ? selectedModel['data']['attributes']['name']
                : '';
            focusNode.addListener(() {
              if (!focusNode.hasFocus) {
                var model = vehicleModels.firstWhere(
                  (e) =>
                      e['data']['attributes']['name'] ==
                      textEditingController.text,
                  orElse: () => {},
                );
                if (model.isNotEmpty) {
                  handleSelectedModel(model);
                } else {
                  textEditingController.text = '';
                  setState(() {
                    vehicleYears = [];
                    selectedModel = {};
                  });
                }
              }
            });
            return TextFormField(
              enabled: selectedMake.isNotEmpty,
              controller: textEditingController,
              focusNode: focusNode,
              decoration: const InputDecoration(labelText: 'Model'),
            );
          },
          optionsViewBuilder: (context, onSelected, options) => Align(
              alignment: Alignment.topLeft,
              child: Material(
                child: Container(
                    width: 208,
                    height: options.length * 48,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        var option = options.elementAt(index);
                        return InkWell(
                          onTap: () => onSelected(option),
                          child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: InkWell(
                                  child: Text(
                                option['data']['attributes']['name'],
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ))),
                        );
                      },
                    )),
              )),
        ),
        const SizedBox(
          height: 20,
        ),
        Autocomplete<Map<String, dynamic>>(
          optionsBuilder: (value) {
            if (value.text.isEmpty) return vehicleYears;
            return vehicleYears.where((element) => element['data']['attributes']
                    ['year']
                .toString()
                .toLowerCase()
                .contains(value.text.toLowerCase()));
          },
          displayStringForOption: (option) =>
              option['data']['attributes']['year'].toString(),
          onSelected: (option) {
            setState(() {
              selectedYear = option;
            });
          },
          fieldViewBuilder:
              (context, textEditingController, focusNode, onFieldSubmitted) {
            textEditingController.text = selectedYear.isNotEmpty
                ? selectedYear['data']['attributes']['year'].toString()
                : '';
            focusNode.addListener(() {
              if (!focusNode.hasFocus) {
                var year = vehicleYears.firstWhere(
                  (e) =>
                      e['data']['attributes']['year'].toString() ==
                      textEditingController.text,
                  orElse: () => {},
                );
                if (year.isNotEmpty) {
                  setState(() {
                    selectedYear = year;
                  });
                } else {
                  textEditingController.text = '';
                  setState(() {
                    selectedYear = {};
                  });
                }
              }
            });
            return TextFormField(
              enabled: selectedModel.isNotEmpty,
              controller: textEditingController,
              focusNode: focusNode,
              decoration: const InputDecoration(labelText: 'Year'),
              keyboardType: TextInputType.number,
            );
          },
          optionsViewBuilder: (context, onSelected, options) => Align(
              alignment: Alignment.topLeft,
              child: Material(
                child: Container(
                    width: 208,
                    height: options.length * 48,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        var option = options.elementAt(index);
                        return InkWell(
                          onTap: () => onSelected(option),
                          child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: InkWell(
                                  child: Text(
                                option['data']['attributes']['year'].toString(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ))),
                        );
                      },
                    )),
              )),
        ),
        const SizedBox(
          height: 20,
        ),
        TextFormField(
          controller: vehicleMileageController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(
            labelText: 'Mileage',
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Provider.of<ThemeManager>(context).currentTheme.colorScheme.secondary, //Color.fromRGBO(244, 248, 6, 0.957),
                    foregroundColor: Colors.black),
                child: const Text("Close")),
            ElevatedButton(
                onPressed: vehicleNameController.text.isEmpty ||
                        selectedMake.isEmpty ||
                        selectedModel.isEmpty ||
                        selectedYear.isEmpty ||
                        vehicleMileageController.text.isEmpty
                    ? null
                    : () => isEdit ? editVehicle(context) : addVehicle(context),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Provider.of<ThemeManager>(context).currentTheme.colorScheme.secondary, //const Color.fromARGB(244, 244, 248, 6),
                    foregroundColor: Colors.black),
                child: const Text("Submit")),
          ],
        )
      ],
    );
  }
}
