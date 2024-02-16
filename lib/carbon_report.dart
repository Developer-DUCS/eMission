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
import 'package:first_flutter_app/api_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:screenshot/screenshot.dart';
import 'package:intl/intl.dart';

/*
    Initializes ChallengePage Class and returns a container of the pages various Widgets
*/
class CarbonReportPage extends StatefulWidget {
  CarbonReportPage({Key? key}) : super(key: key);

  String carName = "";
  int amount = 0;
  String unitOfMeasure = 'mi';
  double carbon_lb = 0.0;
  int points_earned = 0;
  DateTime date_earned = DateTime.now();

  @override
  _CarbonReportPageState createState() => _CarbonReportPageState();
}

class _CarbonReportPageState extends State<CarbonReportPage> {
  ScreenshotController screenshotController = ScreenshotController();
  ApiService apiService = new ApiService();

  @override
  void initState() {
    print("Init state called");
    super.initState();
    getMostRecentDrive();
  }

  Future<Map<String, dynamic>> getMostRecentDrive2() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    ApiResponse res =
        await apiService.get('/getRecentDrive?userID=${pref.getInt("userID")}');
    return res.data;
  }

  Future<void> getMostRecentDrive() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    apiService
        .get('/getRecentDrive?userID=${pref.getInt("userID")}')
        .then((res) {
      setState(() {
        var jsonResponse = res.data;
        var firstDataItem = jsonResponse["data"][0];
        widget.carName = firstDataItem["carName"];
        widget.amount = firstDataItem["amount"];
        widget.unitOfMeasure = firstDataItem["unitOfMeasure"];
        widget.carbon_lb = firstDataItem["carbon_lb"];
        widget.points_earned = firstDataItem["points_earned"];
        widget.date_earned = DateTime.parse(firstDataItem["date_earned"]);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: getMostRecentDrive2(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While the data is being fetched, display a loading indicator
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // If there's an error during the fetch, display an error message
          return Text('Error: ${snapshot.error}');
        } else {
          // Once the data is available, update the widget's properties
          var firstDataItem = snapshot.data!["data"][0];
          widget.carName = firstDataItem["carName"];
          widget.amount = firstDataItem["amount"];
          widget.unitOfMeasure = firstDataItem["unitOfMeasure"];
          widget.carbon_lb = firstDataItem["carbon_lb"];
          widget.points_earned = firstDataItem["points_earned"];
          widget.date_earned = DateTime.parse(firstDataItem["date_earned"]);

          // Return your UI with the updated values
          return Container(
            padding: const EdgeInsets.all(25.0),
            color: const Color.fromRGBO(124, 184, 22, 1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.fromLTRB(40, 40, 40, 40),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromRGBO(206, 213, 92, 100)),
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
                          "That is ${(widget.carbon_lb / 25) * 100}% of the daily average for most Americans today.",
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
              ],
            ),
          );
        }
      },
    );
  }
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