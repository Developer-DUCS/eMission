/// carbon_report.dart
///
/// This is a page on the eMission flutter application that constructs the CarbonReportPage Widget.
/// The carbon_report page is responsible for displaying user's carbon footprint information --drive length in miles,
/// the car make and model, the estimated carbon emission score and a short message --following a drive.
///
/// This page will allow users to screenshot their report and share it with other user's or members of
/// the challenge group.
///
/// Created: Sept 28, 2023
/// Author: Chris Warren

// import statements
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:screenshot/screenshot.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';

/*
    Initializes ChallengePage Class and returns a container of the pages various Widgets
*/
class CarbonReportPage extends StatefulWidget {
  CarbonReportPage({Key? key}) : super(key: key);

  String carName = "";
  double amount = 0.0;
  String unitOfMeasure = 'mi';
  double carbon_lb = 0.0;
  int points_earned = 0;
  DateTime date_earned = DateTime.now();

  @override
  _CarbonReportPageState createState() => _CarbonReportPageState();
}

class _CarbonReportPageState extends State<CarbonReportPage> {
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    initAsyncState();
  }

  Future<void> initAsyncState() async {
    getMostRecentDrive();
    // Other asynchronous initialization logic can go here
  }

  void getMostRecentDrive() async {
    print("hi");
    SharedPreferences pref = await SharedPreferences.getInstance();
    print(pref);
    print(pref.getInt("userID"));
    http
        .get(Uri.parse(
            'http://10.0.2.2:3000/getRecentDrive?userID=${pref.getInt("userID")}'))
        .then((res) {
      setState(() {
        print(res.body);
        var jsonResponse = json.decode(res.body);
        var firstDataItem = jsonResponse["data"][0];
        widget.carName = firstDataItem["carName"];
        widget.amount = firstDataItem["amount"];
        widget.unitOfMeasure = firstDataItem["unitOfMeasure"];
        widget.carbon_lb = firstDataItem["carbon_lb"];
        widget.points_earned = firstDataItem["points_earned"];
        widget.date_earned = DateTime.parse(firstDataItem["date_earned"]);

        print(widget.carName);
      });
    });
  }

  /* @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25.0),
      color: const Color.fromRGBO(124, 184, 22, 1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.fromLTRB(40, 40, 40, 40),
            decoration: BoxDecoration(
              border:
                  Border.all(color: const Color.fromRGBO(206, 213, 92, 100)),
              color: const Color.fromRGBO(160, 197, 89, 100),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: const Text(
                      "Your Carbon Footprint",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                        fontFamily: 'Nunito',
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: const Text(
                    "Your Car Here",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                      fontFamily: 'Nunito',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: const Text(
                    "[#] total [unit]",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                      fontFamily: 'Nunito',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: const Text(
                    "Your carbon footprint is equal to: ",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                      fontFamily: 'Nunito',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: const Text(
                    "[Carbon Emission Score]",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                      fontFamily: 'Nunito',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: const Text(
                    $"That is {carbon_lb/30} than the daily average for most Americans today.",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                      fontFamily: 'Nunito',
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  OutlinedButton(
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            Color.fromRGBO(227, 167, 27, 100)),
                        foregroundColor: MaterialStatePropertyAll(Colors.white),
                        overlayColor: MaterialStatePropertyAll(
                            Color.fromRGBO(139, 141, 43, 100)),
                        shadowColor: MaterialStatePropertyAll(Colors.black),
                      ),
                      onPressed: () {
                        null;
                      },
                      child: const Align(
                          alignment: Alignment.center,
                          child: Text("Save To Photos"))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} */
  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: screenshotController,
      child: Container(
        padding: const EdgeInsets.all(25.0),
        color: const Color.fromRGBO(124, 184, 22, 1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.fromLTRB(40, 40, 40, 40),
              decoration: BoxDecoration(
                border:
                    Border.all(color: const Color.fromRGBO(206, 213, 92, 100)),
                color: const Color.fromRGBO(160, 197, 89, 100),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        "Your Recent Carbon Footprint",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0,
                          fontFamily: 'Nunito',
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      "${widget.amount} total ${widget.unitOfMeasure}",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                        fontFamily: 'Nunito',
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      "Your carbon footprint is equal to: ${widget.carbon_lb} pounds of carbon",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                        fontFamily: 'Nunito',
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      "That is ${(widget.carbon_lb / 30) * 100}% of the daily average for most Americans today.",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                        fontFamily: 'Nunito',
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      "Date Earned: ${DateFormat('MM/dd/yyyy h:mm a').format(widget.date_earned.toLocal())}",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                        fontFamily: 'Nunito',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: 150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    OutlinedButton(
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                          Color.fromRGBO(227, 167, 27, 100),
                        ),
                        foregroundColor: MaterialStatePropertyAll(Colors.white),
                        overlayColor: MaterialStatePropertyAll(
                          Color.fromRGBO(139, 141, 43, 100),
                        ),
                        shadowColor: MaterialStatePropertyAll(Colors.black),
                      ),
                      onPressed: () async {
                        // Request permission
                        var status = await Permission.storage.request();
                        if (status.isGranted) {
                          // Permission is granted, capture the screenshot
                          final imageBytes =
                              await screenshotController.capture();

                          // Save the image to photos or perform any other action
                          // You may use the imageBytes to save the screenshot as an image file
                        } else {
                          // Permission denied
                          // Handle the case where the user denied access to the gallery
                        }
                      },
                      child: const Align(
                        alignment: Alignment.center,
                        child: Text("Save To Photos"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
