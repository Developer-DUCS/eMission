import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ButtonPage extends StatefulWidget {
  const ButtonPage({Key? key});

  @override
  _ButtonPageState createState() => _ButtonPageState();
}

class _ButtonPageState extends State<ButtonPage> {
  bool isGreen = false;
  bool isDone = false;
  int lastDrive = 0;
  String buttonText = "Press to start drive";
  Timer? timer;
  int secondsElapsed = 0;
  bool isOverlayVisible = false;
  late StreamSubscription<Position> locationStream;
  Position? lastPosition;
  double totalDistance = 0.0;
  List<Map<String, dynamic>> vehicles = [];
  Map<String, dynamic>? selectedVehicle;

  void initLocationService() async {
    await Geolocator.requestPermission();
  }

  void startLocationUpdates() {
    locationStream = Geolocator.getPositionStream().listen((Position position) {
      print(position.latitude);
      // Handle new location data
      if (lastPosition != null) {
        double distance = Geolocator.distanceBetween(
          lastPosition!.latitude,
          lastPosition!.longitude,
          position.latitude,
          position.longitude,
        );
        double distanceInMiles = distance * 0.00062137;

        totalDistance += distanceInMiles;
        print(
            'Distance: $distanceInMiles miles | Total Distance: $totalDistance miles');
      }
      lastPosition = position;
    });
  }

  void fetchVehicles() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    http
        .get(Uri.parse(
            'http://10.0.2.2:3000/vehicles?owner=${pref.getInt("userID")}'))
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

  void toggleColor() {
    setState(() {
      isGreen = !isGreen; // Toggle the color state
      if (isGreen) {
        buttonText = "Drive in Progress";
        startTimer();
      } else {
        buttonText = "Press to start drive";
        stopTimer();
        showCustomDialog();
      }
    });
  }

  void startTimer() {
    initLocationService();
    vehicles = [];
    fetchVehicles();
    startLocationUpdates();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        isDone = false;
        lastDrive = 0;
        secondsElapsed++;
      });
    });
  }

  void stopTimer() {
    locationStream.cancel();
    if (timer != null) {
      timer!.cancel();
      setState(() {
        lastDrive = secondsElapsed;
        secondsElapsed = 0;
        isDone = true;
        isOverlayVisible = true;
      });
    }
  }

  void closeOverlay() {
    setState(() {
      locationStream.cancel();
      isOverlayVisible = false;
    });
  }

  @override
  void dispose() {
    stopTimer();
    locationStream.cancel();
    super.dispose();
  }

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

  void submitMiles2(carID, distance, modelID) async {
    print('Submitting Miles...');
    SharedPreferences pref = await SharedPreferences.getInstance();

    // Data to be sent
    var data = {
      'distance': distance,
      'vehicle': carID,
      'userID': pref.getInt("userID")
    };
    print(data);

    // API call to update milage and calculate trip distance
    var res = await http.post(Uri.parse('http://10.0.2.2:3000/addDistance'),
        headers: {'Content-Type': 'application/json'}, body: json.encode(data));

    // Parse the JSON string into a Map
    Map<String, dynamic> responseMap = json.decode(res.body);
    // Access the value associated with the "data" key
    dynamic dataValue = responseMap['data'];

    if (dataValue == null) {
      showErrorAlert(context);
    } else {
      // Establish data to send to Carbon Interface API
      var tripDistance = dataValue;
      var vehicle = modelID;

      // API request to Carbon Interface
      var results = await http.get(Uri.parse(
          'http://10.0.2.2:3000/vehicleCarbonReport?vehicleId=${vehicle}&distance=${tripDistance}'));

      // Parse the JSON string into a Map
      Map<String, dynamic> resultsMap = json.decode(results.body);

      // Extract the data
      var carbonLb = resultsMap['data']['data']['attributes']['carbon_lb'];

      // Create pop-up
      showResultAlert(context, carbonLb);
    }
    ;
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
    var res = await http.post(Uri.parse('http://10.0.2.2:3000/addDistance'),
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
        //carbonReport(tripDistance, vehicle, pref.getInt("userID"), carID);
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

  void carbonReport(distance, vehicle, userID, carID) async {
    print("carbon report called");
    var results = await http.get(Uri.parse(
        'http://10.0.2.2:3000/vehicleCarbonReport?vehicleId=${vehicle}&distance=${distance}&userID=${userID}'));
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
      var res = await http.post(Uri.parse('http://10.0.2.2:3000/updateDrives'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(body));
      if (res.statusCode == 200) {
        showResultAlert(context, carbonLb);
      } else {
        showErrorAlert(context);
      }
    }
  }

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
                Navigator.pushNamed(context, 'carbon_report');
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> showCustomDialog() async {
    //const make = 'Toyota';
    // final response =
    //    await http.get(Uri.parse('http://10.0.2.2:3000/makeId?make=$make'));

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text(
              'Drive: $lastDrive seconds elapsed, miles: ${totalDistance.toStringAsFixed(2)}',
              style: GoogleFonts.nunito(),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Select a vehicle:',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Container(
                  child: DropdownButton<Map<String, dynamic>>(
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
                SizedBox(height: 10),
                selectedVehicle != null
                    ? Text(
                        'Selected Car: ${selectedVehicle?['carName']}',
                        style: TextStyle(fontSize: 16),
                      )
                    : Container(),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () {
                      //closeOverlay();
                      var selectedVehicleFromList = vehicles.firstWhere(
                          (vehicle) =>
                              vehicle['carID'] == selectedVehicle?['carID']);

                      if (selectedVehicle != null) {
                        print(totalDistance);
                        print(selectedVehicle?['carID']);
                        var chosenVehicle = vehicles.firstWhere((vehicle) =>
                            vehicle['carID'] == selectedVehicle?['carID']);

                        //print('Submitted Miles: $milesTotal');
                        //print('Selected Car: ${selectedVehicle['carName']}');
                        //print('Selected Vehicle ID: ${selectedVehicle['carID']}');
                        submitMiles2(chosenVehicle['carID'], totalDistance,
                            chosenVehicle['modelID']);
                      }
                      //Navigator.of(context).pop();
                      //Navigator.pushNamed(context, 'carbon_report');
                      //Navigator.of(context).pop();
                      //Navigator.pushNamed(context, 'carbon_report');
                    },
                    child: Text('See My Carbon Footprint'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green, // Use your desired color
                    ),
                  ),
                ),
              ],
            ),
            /* actions: <Widget>[
              TextButton(
                onPressed: () {
                  closeOverlay();
                },
                child: Text('Close'),
              ),
            ], */
          );
        });
      },
    );
  }

  Future<void> showCustomDialog1() async {
    //final apiService = CalculateApiService();
    //final response = await apiService.calculateCarbonFootprint();
    const make = 'Toyota';
    final response =
        await http.get(Uri.parse('http://10.0.2.2:3000/makeId?make=$make'));
    print(response);
    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Drive: $lastDrive seconds elapsed, miles: ${totalDistance.toStringAsFixed(2)}',
            style: GoogleFonts.nunito(),
          ),
          content: Text(
              "This Drive button is still in a demo format. We thank you for your patience in our development process."),

          /* content: Text(
            'API Response: $response',
            style: GoogleFonts.nunito(),
          ), */
          actions: <Widget>[
            TextButton(
              onPressed: () {
                closeOverlay();
                Navigator.of(context).pop();
                Navigator.pushNamed(context, 'carbon_report');
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // @override
  // void showCustomDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text(
  //           'Drive: $lastDrive seconds elapsed',
  //           style: GoogleFonts.nunito(),
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             onPressed: () {
  //               closeOverlay();
  //               Navigator.of(context).pop();
  //             },
  //             child: Text('Close'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    Color buttonColor = isGreen ? Color(0xFF7CB816) : Color(0xFFE3A71B);
    Color originalColor = Color(0xFFf18f47); // Original color

    Color lighterColor = Color.fromARGB(
      originalColor.alpha,
      (originalColor.red + 255) ~/ 2,
      (originalColor.green + 255) ~/ 2,
      (originalColor.blue + 255) ~/ 2,
    );

    return Container(
      color: lighterColor,
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    buttonText,
                    style: GoogleFonts.nunito(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 50.0),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 315,
                        height: 315,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: buttonColor,
                            width: 15.0,
                          ),
                        ),
                      ),
                      Container(
                        width: 290,
                        height: 290,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors
                                .white, // Border color same as button color
                            width:
                                15.0, // Border width same as the white border
                          ),
                        ),
                        child: RawMaterialButton(
                          onPressed: () {
                            toggleColor();
                          },
                          elevation: 2.0,
                          fillColor: buttonColor,
                          child: Icon(
                            Icons.directions_car,
                            size: 100.0,
                          ),
                          shape: CircleBorder(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 50.0),
                  Text(
                    'Drive Time: ${Duration(seconds: secondsElapsed).toString().split('.').first}',
                    style: TextStyle(fontSize: 20.0), // Increase font size
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
