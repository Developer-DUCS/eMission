import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:first_flutter_app/encryption.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  // TextEditingControllers are objects used to retrieve the input values
  // of the TextFieldForms.
  late TextEditingController emailController;
  late TextEditingController usernameController;
  late TextEditingController displayNameController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  // The form key is used to validate the form.
  final _formKey = GlobalKey<FormState>();

  // Constructor responsible for initiating the state of the Widget.
  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    usernameController = TextEditingController();
    displayNameController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  // void method responisble for creating an http request to the server.
  // this request will insert the user's login information.
  void _submitForm(context) async {
    // android emulator url
    String url = 'http://10.0.2.2:3000/insertUser';

    // Encrypt the password
    String encryptedPassword = encryptPassword(confirmPasswordController.text);

    // User's input data
    Map<String, String?> formData = {
      'email': emailController.text,
      'username': usernameController.text,
      'display_name': displayNameController.text,
      'password': encryptedPassword,
      'confirm_password': encryptedPassword,
    };

    try {
      // http request here
      var response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(formData));
      debugPrint('Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        Navigator.pushNamed(context, 'login');
      }
      if (response.statusCode == 401) {
        Flushbar(
          title: 'Error',
          message: 'An account with that email already exists.',
          backgroundColor: Colors.redAccent,
          flushbarPosition: FlushbarPosition.TOP,
        ).show(context);
      } else {
        Flushbar(
          title: 'Error',
          message: 'There was a server error. Please try again.',
          backgroundColor: Colors.redAccent,
          flushbarPosition: FlushbarPosition.TOP,
        ).show(context);
      }
    } catch (error) {
      debugPrint('Error: $error');
    }
  }

  // build goes here
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/pexels-robert-so-18127674-2.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
            child: SingleChildScrollView(
                child: Column(
          children: <Widget>[
            SvgPicture.asset('assets/images/eMission_logo.svg', height: 150),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 50.0),
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Color.fromRGBO(238, 230, 231, 0.877),
              ),
              // Login Form
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Center(
                      child: Text(
                    "Create Account",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )),
                  const SizedBox(
                    height: 4,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: emailController,
                          decoration: const InputDecoration(labelText: 'Email'),
                          validator: (value) {
                            bool isEmailValid = RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value!);
                            if (!isEmailValid) {
                              return 'Please enter a valid email';
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        TextFormField(
                          controller: usernameController,
                          decoration:
                              const InputDecoration(labelText: 'Username'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        TextFormField(
                          controller: displayNameController,
                          decoration:
                              const InputDecoration(labelText: 'Display Name'),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        TextFormField(
                          controller: passwordController,
                          decoration:
                              const InputDecoration(labelText: 'Password'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          obscureText: true,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        TextFormField(
                          controller: confirmPasswordController,
                          decoration: const InputDecoration(
                              labelText: 'Confirm Password'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            if (value != passwordController.text) {
                              return "Passwords have to match";
                            }
                            return null;
                          },
                          obscureText: true,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Center(
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor:
                                    const Color.fromARGB(244, 0, 0, 0),
                                backgroundColor:
                                    const Color.fromARGB(244, 244, 248, 6),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _submitForm(context);
                                }
                              },
                              child: const Text('Create')),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?"),
                      const SizedBox(
                        width: 4,
                      ),
                      GestureDetector(
                        child: const Text(
                          "Login",
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w600),
                        ),
                        onTap: () => Navigator.pushNamed(context, 'login'),
                      )
                    ],
                  )
                ],
              ),
              // Text Button
            ),
          ],
        ))));
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
