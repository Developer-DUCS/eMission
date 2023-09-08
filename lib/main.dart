import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() => runApp(const MyApp());

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
              SvgPicture.asset('assets/images/drawing_new.svg', height: 100),
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
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor:const Color.fromARGB(244, 0, 0, 0),
            backgroundColor: const Color.fromARGB(244, 244, 248, 6),
          ),
          onPressed: () { },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}

class HomePage extends StatelessWidget {
    const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: Center(child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text('BUTTON')
      ))
    );
  }
}

