//
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'home.dart'; // Import the home page

//
void main() => runApp(const MyApp());

class Routes extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Redirect Example',
      initialRoute: '/', // Specify the initial route
      routes: {
        '/': (context) => MyCustomForm(), // Define the root route
        '/home': (context) => HomePage(), // Define the route to the Home Page
      },
    );
  }
}

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
        body:  Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/pexels-robert-so-18127674-2.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: <Widget>[
              SvgPicture.asset('assets/images/eMission_logo.svg', height: 100),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                decoration: const BoxDecoration( 
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color:  Color.fromRGBO(238, 230, 231, 0.877),
                ), 
                // Login Form
                child: const MyCustomForm(),
                // Text Button
              ),
            ],
          )

        ),
      ),
    );
  }
}



/* */
class  MyCustomForm extends StatelessWidget {
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
              foregroundColor:const Color.fromARGB(244, 0, 0, 0),
              backgroundColor: const Color.fromARGB(244, 244, 248, 6),
            ),
            onPressed: () {
              Navigator.pushNamed(
                context, '/home'
              );
             },
            child: const Text('Submit')),
          ),
        ),        
      ],
    );
  }
}