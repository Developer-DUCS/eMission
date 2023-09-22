//
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'drive-button.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

//
void main() => runApp(const MyApp());

/* */
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'eMission',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('eMission Application'),
          backgroundColor: const Color.fromRGBO(124, 184, 22, 40),
        ),
        body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image:
                    AssetImage("assets/images/pexels-robert-so-18127674-2.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: <Widget>[
                SvgPicture.asset('assets/images/eMission_logo.svg',
                    height: 100),
                Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 50.0),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Color.fromRGBO(238, 230, 231, 0.877),
                  ),
                  // Login Form
                  child: const MyCustomForm(),
                  // Text Button
                ),
              ],
            )),
      ),
    );
  }
}

/* */
class MyCustomForm extends StatelessWidget {
  const MyCustomForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: TextFormField(
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'email',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: TextFormField(
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'username',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: TextFormField(
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'display name',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: TextFormField(
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'password',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: TextFormField(
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'confirm password',
            ),
          ),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.only(bottom: 10),
          child: SizedBox(
            height: 30,
            width: 250,
            child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: const Color.fromARGB(244, 0, 0, 0),
                  backgroundColor: const Color.fromARGB(244, 244, 248, 6),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ButtonPage()));
                },
                child: const Text('Submit')),
          ),
        ),
      ],
    );
  }
}/*

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isGreen = false; // Track whether the button is green or not

  void toggleColor() {
    setState(() {
      isGreen = !isGreen; // Toggle the color state
    });
  }

  @override
  Widget build(BuildContext context) {
    Color buttonColor = isGreen ? Colors.green : Colors.amber; // Define the button color

    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: Center(
        child: RawMaterialButton(
          constraints: BoxConstraints.tight(Size(300, 300)),
          onPressed: toggleColor, // Call toggleColor when button is pressed
          elevation: 2.0,
          fillColor: buttonColor, // Set the button color dynamically
          child: Icon(
            Icons.directions_car,
            size: 100.0,
          ),
          shape: CircleBorder(),
        ),
      ),
    );
  }
}*/



/*
*//* *//*
class HomePage extends StatelessWidget {
    const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: Center(child: RawMaterialButton(
        constraints: BoxConstraints.tight(Size(300,300)),
        onPressed: () {// change color here
          },
          elevation: 2.0,
          fillColor: Colors.amber,
          child: Icon(
            Icons.directions_car,
            size: 100.0,
          ),
          shape: CircleBorder(),
      )
    )
        //child: const Text('BUTTON')

      );
  }
}*/



