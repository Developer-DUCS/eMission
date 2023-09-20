/*
import 'package:flutter/material.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isGreen = false; // Track whether the button is green or not
  String buttonText = "Press to start drive";
  Timer? timer;
  int secondsElapsed = 0;

  void toggleColor() {
    setState(() {
      isGreen = !isGreen; // Toggle the color state
      if (isGreen) {
        buttonText = "Drive time";
        startTimer();
      } else {
        buttonText = "Press to start drive";
        stopTimer();
      }
    });
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        secondsElapsed++;
      });
    });
  }

  void stopTimer() {
    if (timer != null) {
      timer!.cancel();
      setState(() {
        secondsElapsed = 0;
      });
    }
  }

  @override
  void dispose() {
    stopTimer(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color buttonColor = isGreen ? Color(0xFF7CB816) : Color(0xFFE3A71B); // Define the button color

    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              buttonText,
              style: TextStyle(fontSize: 30.0),
            ),

            SizedBox(height: 20.0),
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
                      width:10.0,
                    ),
                  ),
                ),
                Container(
                  width: 290,
                  height: 290,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white, // Border color same as button color
                      width: 15.0, // Border width same as the white border
                    ),
                  ),
                  child: RawMaterialButton(
                    onPressed: toggleColor, // Call toggleColor when the button is pressed
                    elevation: 2.0,
                    fillColor: buttonColor, // Set the button color dynamically
                    child: Icon(
                      Icons.directions_car,
                      size: 100.0,
                    ),
                    shape: CircleBorder(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30.0),
            Text(

              'Drive Time: ${Duration(seconds: secondsElapsed).toString().split('.').first}',
              style: TextStyle(fontSize: 30.0),
            ),

          ],

        ),

      ),

    );
  }
}
*/
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_svg/flutter_svg.dart';


/*
void main() {
  runApp(MyApp());
}
*/

/*class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}*/

class ButtonPage extends StatefulWidget {
  const ButtonPage({Key? key});

  @override
  _ButtonPageState createState() => _ButtonPageState();
}

class _ButtonPageState extends State<ButtonPage> {
  bool isGreen = false; // Track whether the button is green or not
  bool isDone = false;
  String buttonText = "Press to start drive";
  Timer? timer;
  int secondsElapsed = 0;
  //Currentpage = getCurrentPage()
  bool isHome = false;
  bool isLeaderboard=false;
  bool isSettings=false;

  /*void getCurrentPage(){

  }*/

  void toggleColor() {
    setState(() {
      isGreen = !isGreen; // Toggle the color state
      if (isGreen) {
        buttonText = "Drive time";
        startTimer();
      }
      else {
        buttonText = "Press to start drive";
        stopTimer();
      }
    });
  }


  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        secondsElapsed++;
      });
    });
  }

  void stopTimer() {
    if (timer != null) {
      timer!.cancel();
      setState(() {
        secondsElapsed = 0;
        isDone=true;
        //displayStats();
      });
    }
  }




  @override
  void dispose() {
    stopTimer(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color buttonColor = isGreen ? Color(0xFF7CB816) : Color(0xFFE3A71B); // Custom colors

    return Scaffold(
      appBar: AppBar(title:
      const Text('eMission',
        style: TextStyle(color: Colors.black,
        fontFamily: 'Sarpanch',),
        ),

        backgroundColor: Color(0xFF7CB816),


      ),
      endDrawer:
        Drawer(
            backgroundColor: Colors.black,

            child: ListView(
                padding: EdgeInsets.zero,
                children: const [
                  DrawerHeader(
                      decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: Text('Drawer Header'),
                  ),
                  ListTile(
                    title: Text('Item 1'),
                    textColor: Colors.yellow,
                  ),
                ]
            )
            //icon: Icon(Icons.menu, color:Colors.black),
        ),

      body: Column(
        children: [
          Expanded(
            flex: 2, // Top part of the screen
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    buttonText,
                    style: TextStyle(fontSize: 24.0), // Increase font size
                  ),
                  SizedBox(height: 50.0), // Increase the space between text and button
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
                            width: 10.0,
                          ),
                        ),
                      ),
                      Container(
                        width: 290,
                        height: 290,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white, // Border color same as button color
                            width: 15.0, // Border width same as the white border
                          ),
                        ),
                        child: RawMaterialButton(
                          onPressed: toggleColor, // Call toggleColor when the button is pressed
                          elevation: 2.0,
                          fillColor: buttonColor, // Set the button color dynamically
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

          Container(
            width: double.infinity,
            height: 66, // Adjust the height as needed
            padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 10), // Adjust vertical padding
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0x26C7C7C7),
                  blurRadius: 14,
                  offset: Offset(1, 1),
                  spreadRadius: 6,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: RawMaterialButton(
                    onPressed: (){},
                    child: SvgPicture.asset(
                      './assets/images/leaderboard-outline.svg',
                      height:30,
                      //width: 200.0, // Adjust the icon width
                      //height: 295.0, // Adjust the icon height

                    ),
                  ),
                ),
                SizedBox(width: 20.0),
                Expanded(
                  child: RawMaterialButton(
                    onPressed:(){},
                    child: Icon(
                      Icons.home_outlined,
                      size: 34.0, // Adjust the icon size
                    ),
                  ),
                ),
                SizedBox(width: 20.0),

                Expanded(

                    child: RawMaterialButton(
                      onPressed:(){

                      },
                      child: Icon (Icons.settings_outlined,
                      size: 34.0), // Adjust the icon size
                    ),
                  ),


              ],
            )

          ),
        ],
      ),
    );
  }
}