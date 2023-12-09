import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

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
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        isDone = false;
        lastDrive = 0;
        secondsElapsed++;
      });
    });
  }

  void stopTimer() {
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
      isOverlayVisible = false;
    });
  }

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }

  Future<void> showCustomDialog() async {
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
            'Drive: $lastDrive seconds elapsed',
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
