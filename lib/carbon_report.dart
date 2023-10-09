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



/*
    Initializes ChallengePage Class and returns a container of the pages various Widgets
*/
class CarbonReportPage extends StatelessWidget{
  const CarbonReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25.0),
      color: const Color.fromRGBO(124, 184, 22, 1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:<Widget> [
          Container(
            padding: const EdgeInsets.fromLTRB(40, 40, 40, 40),
            decoration: BoxDecoration(
              border: Border.all(color: const Color.fromRGBO(206, 213, 92, 100)),
              color: const Color.fromRGBO(160, 197, 89, 100),

            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: const Text(
                    "Your Carbon Footprint",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                      fontFamily: 'Nunito',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: const Text(
                    "2016 Chevorlet Trax",
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
                    "20 total miles",
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
                    "That is [percentage] [less/more] than the daily average for most Americans today.",
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
                    backgroundColor: MaterialStatePropertyAll(Color.fromRGBO(227, 167, 27, 100)),
                    foregroundColor: MaterialStatePropertyAll(Colors.white),
                    overlayColor: MaterialStatePropertyAll(Color.fromRGBO(139, 141, 43, 100)),
                    shadowColor: MaterialStatePropertyAll(Colors.black),
                    ),
                    onPressed: ( ) { null; },
                    child: const Align(alignment: Alignment.center, child: Text("Save To Photos"))
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