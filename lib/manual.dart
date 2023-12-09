import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

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
        .get(Uri.parse('http://localhost:3000/vehicles?owner=${pref.getInt("userID")}'))
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

  // Submits miles and trip
  void submitMiles(carID, distance, modelID) async {
    print('Submitting Miles...');
    SharedPreferences pref = await SharedPreferences.getInstance();

    // Data to be sent
    var data = {
      'distance': distance,
      'vehicle': carID,
      'userID': pref.getInt("userID")
    };

    // API call to update milage and calculate trip
    var res = await http.post(Uri.parse('http://localhost:3000/updateDistance'),
     headers: {'Content-Type': 'application/json'},
     body: json.encode(data));

    // Parse the JSON string into a Map
    Map<String, dynamic> responseMap = json.decode(res.body);
    // Access the value associated with the "data" key
    dynamic dataValue = responseMap['data'];

    // Establish data to send to Carbon Interface API
    var tripDistance = dataValue;
    var vehicle = modelID;

    // API request to Carbon Interface
    var results = await http.get(Uri.parse('http://localhost:3000/vehicleCarbonReport?vehicleId=${vehicle}&distance=${tripDistance}'));

    // Parse the JSON string into a Map
    Map<String, dynamic> resultsMap = json.decode(results.body);
    
    // Extract the data
    var carbonLb = resultsMap['data']['data']['attributes']['carbon_lb'];
    
    // Create pop-up
    showResultAlert(context, carbonLb);
  }

  // Creates a pop-up with results of the trip
  void showResultAlert(BuildContext context, double carbonLb) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Trip Results'),
        content: Text('During your trip, you emitted $carbonLb lbs of carbon!'),
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
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                Container(
                  color: Color.fromRGBO(124, 184, 22, 1),
                  padding: EdgeInsets.only(top: 200.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      child: DropdownButton<Map<String, dynamic>>(
                        value: selectedVehicle,
                        onChanged: (Map<String, dynamic>? newValue) {
                          if (newValue != null) {
                            setState(() {
                              selectedVehicle = newValue;
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
                ),
                Expanded(
                  child: Container(
                    color: Color.fromRGBO(124, 184, 22, 1),
                    child: Center(
                      child: textBox(),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Color.fromRGBO(124, 184, 22, 1),
                    child: Center(
                      child: submitButton(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget textBox() {
    return Container(
      width: 200, // Set the desired width here
      child: TextField(
        controller: textController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter Your Total Milage',
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }

  Widget submitButton() {
    return Container(
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        height: 30,
        width: 250,
        child: TextButton(
          style: TextButton.styleFrom(
            foregroundColor:const Color.fromARGB(244, 0, 0, 0),
            backgroundColor: const Color.fromARGB(244, 244, 248, 6),
          ),
          onPressed: () {
            int milesTotal = int.parse(textController.text);
            var selectedVehicle = vehicles.isNotEmpty ? vehicles[0] : null;
            if (selectedVehicle != null) {
              //print('Submitted Miles: $milesTotal');
              //print('Selected Car: ${selectedVehicle['carName']}');
              //print('Selected Vehicle ID: ${selectedVehicle['carID']}');
              submitMiles(selectedVehicle['carID'], milesTotal, selectedVehicle['modelID']);
            }
          },
        child: const Text('Submit')),
      ),
    ); 
  }

}