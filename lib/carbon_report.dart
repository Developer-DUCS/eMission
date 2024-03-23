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
import 'api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:emission/theme/theme_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:intl/intl.dart';

/*
    Initializes ChallengePage Class and returns a container of the pages various Widgets
*/
// ignore: must_be_immutable
class CarbonReportPage extends StatefulWidget {
  CarbonReportPage({Key? key}) : super(key: key);

  String carName = "";
  int amount = 0;
  String unitOfMeasure = 'mi';
  double carbon_lb = 0.0;
  int points_earned = 0;
  DateTime date_earned = DateTime.now();
  double lifetime_carbon = 0;

  @override
  _CarbonReportPageState createState() => _CarbonReportPageState();
}

class _CarbonReportPageState extends State<CarbonReportPage> {
  //ScreenshotController screenshotController = ScreenshotController();
  ApiService apiService = new ApiService();

  @override
  void initState() {
    print("Init state called");
    super.initState();
    getMostRecentDrive();
    getLifetimeCarbon();
  }

  Future<Map<String, dynamic>> getMostRecentDrive2() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    ApiResponse res =
        await apiService.get('getRecentDrive?userID=${pref.getInt("userID")}');
    return res.data ?? {}; // Return empty map if data is null
  }

  void getLifetimeCarbon() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    ApiResponse res =
        await apiService.get('lifetimeCarbon?userID=${pref.getInt("userID")}');
    setState(() {
      widget.lifetime_carbon = res.data['lifetime_carbon'];
    });
  }

  Future<void> getMostRecentDrive() async {
    print("hi");
    SharedPreferences pref = await SharedPreferences.getInstance();
    print(pref);
    print(pref.getInt("userID"));
    apiService
        .get('getRecentDrive?userID=${pref.getInt("userID")}')
        .then((res) {
      if (res.statusCode == 200) {
        var jsonResponse = res.data;

        // Check if "data" key exists in the response
        if (jsonResponse.containsKey("data") &&
            jsonResponse["data"].isNotEmpty) {
          var firstDataItem = jsonResponse["data"][0];
          setState(() {
            widget.carName = firstDataItem["carName"];
            widget.amount = firstDataItem["amount"];
            widget.unitOfMeasure = firstDataItem["unitOfMeasure"];
            widget.carbon_lb = firstDataItem["carbon_lb"];
            widget.points_earned = firstDataItem["points_earned"];
            widget.date_earned = DateTime.parse(firstDataItem["date_earned"]);
            print(widget.carName);
          });
        } else {
          print("No data received or empty data array.");
        }
      } else {
        print("HTTP request failed with status code: ${res.statusCode}");
      }
    }).catchError((error) {
      print("Error during HTTP request: $error");
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
        } else if (snapshot.data!["data"] == null || snapshot.data!["data"].isEmpty) {
          //Handle case when data is empty
          return Text('No data available');
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
            color: Provider.of<ThemeManager>(context).currentTheme.colorScheme.primary,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.fromLTRB(40, 40, 40, 40),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromRGBO(206, 213, 92, 100)),
                    color: Provider.of<ThemeManager>(context).currentTheme.colorScheme.background,
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
                      Container(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Text(
                          "Lifetime Carbon Footprint: ${widget.lifetime_carbon} lbs",
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
                          "Over the span of a year it would take ${(widget.lifetime_carbon / 55).toStringAsFixed(2)} trees to offset your carbon footprint.",
                          style: TextStyle(
                            fontSize: 11,
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