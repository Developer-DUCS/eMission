import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:emission/theme/theme_manager.dart';

class Manual extends StatefulWidget {
  const Manual({Key? key});

  @override
  _ManualState createState() => _ManualState();
}

class _ManualState extends State<Manual> {
  TextEditingController textController = TextEditingController();
  List<Map<String, dynamic>> vehicles = [];
  Map<String, dynamic>? selectedVehicle;

  @override
  void initState() {
    super.initState();
    fetchVehicles();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  // Fetch the user's vehicles
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

        // Print the items in the vehicles list
        for (var vehicle in vehicles) {
          print(vehicle);
        }
      });
    });
  }

  void carbonReport(distance, vehicle, userID, carID) async {
    print("carbon report called");
    var results = await http.get(Uri.parse(
        'https://mcs.drury.edu/emission/vehicleCarbonReport?vehicleId=${vehicle}&distance=${distance}&userID=${userID}'));
    Map<String, dynamic> resultsMap = json.decode(results.body);
    print(resultsMap);

    // Extract the data
    var carbonLb = resultsMap['data']['data']['attributes']['carbon_lb'];
    var carbonKg = resultsMap['data']['data']['attributes']['carbon_kg'];
    if (carbonLb != null && carbonKg != null) {
      var body = {
        "vehicleID": carID,
        "distance": distance,
        "userID": userID,
        "carbon_lb": carbonLb,
        "carbon_kg": carbonKg
      };
      var res = await http.post(Uri.parse('https://mcs.drury.edu/emission/updateDrives'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(body));
      if (res.statusCode == 200) {
        showResultAlert(context, carbonLb);
      } else {
        showErrorAlert(context);
      }
    }
  }

  // Submits miles and trip
  void submitMiles(carID, distance, modelID) async {
    print('Submitting Miles...');
    print('carID');
    SharedPreferences pref = await SharedPreferences.getInstance();

    // Data to be sent
    var data = {
      'distance': distance,
      'vehicle': carID,
      'userID': pref.getInt("userID")
    };
    print("Hi 1");
    // API call to update milage and calculate trip distance
    var res = await http.post(Uri.parse('https://mcs.drury.edu/emission/updateDistance'),
        headers: {'Content-Type': 'application/json'}, body: json.encode(data));
    print("Hi 2");
    // Parse the JSON string into a Map
    Map<String, dynamic> responseMap = json.decode(res.body);

    print(responseMap);
    // Access the value associated with the "data" key
    dynamic dataValue = responseMap['data'];
    print("Data value");
    print(dataValue);

    if (dataValue == null) {
      showErrorAlert(context);
    } else {
      // Establish data to send to Carbon Interface API
      var tripDistance = dataValue;
      var vehicle = modelID;
      try {
        carbonReport(tripDistance, vehicle, pref.getInt("userID"), carID);
      } catch (err) {
        print(err);
      }

      /*  // API request to Carbon Interface
      var results = await http.get(Uri.parse(
          'http://10.0.2.2:3000/vehicleCarbonReport?vehicleId=${vehicle}&distance=${tripDistance}'));

      // Parse the JSON string into a Map
      Map<String, dynamic> resultsMap = json.decode(results.body);

      // Extract the data
      var carbonLb = resultsMap['data']['data']['attributes']['carbon_lb'];

      // Create pop-up
      showResultAlert(context, carbonLb); */
    }
    ;
  }

  // Creates a pop-up with results of the trip
  void showResultAlert(BuildContext context, double carbonLb) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Trip Results'),
          content:
              Text('During your trip, you emitted $carbonLb lbs of carbon!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Creates a pop-up with error if trip distance is not 1 or greater
  void showErrorAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Trip Submission Error'),
          content: Text(
              'There was an error submitting your trip! Please ensure you enter your total mileage as shown on the odometer, and that the odometer has changed since your last submission!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeManager themeManager = Provider.of<ThemeManager>(context);
    return Container(
      decoration: BoxDecoration(color: themeManager.currentTheme.colorScheme.primary),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 175),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: themeManager.currentTheme.colorScheme.primaryContainer,
                border: Border(),
                borderRadius: BorderRadius.all(Radius.circular(10))),
              padding: const EdgeInsets.all(50),
              margin: EdgeInsets.only(left: 30, right: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    color: Colors.white,
                    margin: EdgeInsets.only(bottom: 10),
                    child: Container(
                        child: DropdownButton<Map<String, dynamic>>(
                          padding: EdgeInsets.only(left: 80, right: 80),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          style: TextStyle(color: themeManager.currentTheme.colorScheme.onBackground, fontWeight: FontWeight.bold),
                          focusColor: themeManager.currentTheme.colorScheme.secondary,
                          value: selectedVehicle,
                          onChanged: (Map<String, dynamic>? newValue) {
                            if (newValue != null) {
                              setState(() {
                                selectedVehicle = newValue;
                                print(selectedVehicle);
                                // Handle the selected value (newValue)
                              });
                            }
                          },
                          items: vehicles.map((Map<String, dynamic> vehicle) {
                            return DropdownMenuItem<Map<String, dynamic>>(
                              value: vehicle,
                              child: Text(vehicle['carName'] ?? ''),
                            );
                          }).toList(),
                        ),
                      ),
                  ),
                  textBox(),
                  submitButton(themeManager)
                ],
              ),
            ),
          ],
        ),
      ), 
    );
  }

  Widget textBox() {
    return TextField(
      controller: textController,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Enter Your Total Milage',
      ),
      keyboardType: TextInputType.number,
    );
  }

  Widget submitButton(themeManager) {
    return Container(
      margin:EdgeInsets.only(top: 10),
      child: SizedBox(
        height: 40,
        width: 250,
        child: TextButton(
          style: TextButton.styleFrom(
            foregroundColor: themeManager.currentTheme.colorScheme.background,
            backgroundColor: themeManager.currentTheme.colorScheme.secondary,
          ),
          onPressed: () {
            int milesTotal = int.parse(textController.text);

            // Check if vehicles list is not empty and selectedVehicle is not null
            if (vehicles.isNotEmpty && selectedVehicle != null) {
              // Get the selected vehicle from the list based on its ID
              var selectedVehicleFromList = vehicles.firstWhere(
                  (vehicle) => vehicle['carID'] == selectedVehicle?['carID']);

              // Ensure that the selected vehicle is found
              if (selectedVehicleFromList != null) {
                submitMiles(selectedVehicleFromList['carID'], milesTotal,
                    selectedVehicleFromList['modelID']);
              }
            }
          },
          child: const Text('Submit')),
      ),
    ); 
  }
}
