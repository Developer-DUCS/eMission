
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
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
          fit: BoxFit.fitHeight,
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
            // Login Form
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Center(child: Text("Create Account", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),
                const SizedBox(height: 4,),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                ),
                const SizedBox(height: 4,),
                TextFormField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                  ),
                ),
                const SizedBox(height: 4,),
                TextFormField(
                  controller: displayNameController,
                  decoration: const InputDecoration(
                    labelText: 'Display Name',
                  ),
                ),
                const SizedBox(height: 4,),
                TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                ),
                const SizedBox(height: 4,),
                TextFormField(
                  controller: confirmPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
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
                    child: const Text('Create')
                  ),
                ),
                const SizedBox(height: 4,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    const SizedBox(width: 4,),
                    GestureDetector(
                      child: const Text("Login", style: TextStyle(decoration: TextDecoration.underline, fontWeight: FontWeight.w600),),
                      onTap: () => Navigator.pushNamed(context, 'login'),
                    )
                  ],
                )      
              ],
            ),
            // Text Button
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