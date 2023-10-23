import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/svg.dart';
import 'dart:convert';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController emailController;
  late TextEditingController usernameController;
  late TextEditingController displayNameController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    usernameController = TextEditingController();
    displayNameController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  void _submitForm(context) async {
    print("here");
    // this is the url for using a Android emulator
    // Apple emulators use localhost like normal
    String url = 'http://10.0.2.2:3000/insertUser';

    Map<String, String?> formData = {
      'email': emailController.text,
      'username': usernameController.text,
      'display_name': displayNameController.text,
      'password': passwordController.text,
      'confirm_password': confirmPasswordController.text,
    };
    print(formData);

    try {
      var response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(formData));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      Navigator.pushNamed(context, 'home');
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/pexels-robert-so-18127674-2.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Center( child: SingleChildScrollView( child: Column(
        children: <Widget>[
          SvgPicture.asset('assets/images/eMission_logo.svg', height: 150),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 50.0),
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration( 
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color:  Color.fromRGBO(238, 230, 231, 0.877),
            ), 
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Center(child: Text("Login", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),
                const SizedBox(height: 4,),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                ),
                const SizedBox(height: 4,),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                ),
                const SizedBox(height: 8,),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor:const Color.fromARGB(244, 0, 0, 0),
                      backgroundColor: const Color.fromARGB(244, 244, 248, 6),
                    ),
                    onPressed: () { _submitForm(context); },
                    child: const Text('Login')
                  ),
                ),
                const SizedBox(height: 4,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    const SizedBox(width: 4,),
                    GestureDetector(
                      child: const Text("Create One", style: TextStyle(decoration: TextDecoration.underline, fontWeight: FontWeight.w600),),
                      onTap: () => Navigator.pushNamed(context, 'create-account'),
                    )
                  ],
                )        
              ],
            ),
          ),
        ],
      )))
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    usernameController.dispose();
    displayNameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
