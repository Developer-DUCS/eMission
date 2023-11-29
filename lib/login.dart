import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:first_flutter_app/encryption.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // TextEditingControllers are objects used to retrieve the input values
  // of the TextFieldForms.
  late TextEditingController emailController;
  late TextEditingController passwordController;

  // The form key is used to validate the form.
  final _formKey = GlobalKey<FormState>(); 

  // status code variable that is returned from _submitForm()
  int? code;

  // Constructor responsible for initiating the state of the Widget.
  @override
  void initState(){
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }


  // Future<int> method responisble for creating an http request to the server.
  // this request will authenticate the user's login information, storing response data
  // and returning the response statuse code.
  Future<int> _submitForm(context) async {
    // android emulator url
    String url = 'http://10.0.2.2:3000/authUser';

    // Encrypt the password
    String encryptedPassword = encryptPassword(passwordController.text);
    
    // User's input data
    var formData = {
      'email': emailController.text,
      'password': encryptedPassword,
    };

    // http request here
    var res = await http.post(Uri.parse(url),
                              headers: {'Content-Type': 'application/json'}, 
                              body: json.encode(formData));

    // store the responses status code and username
    var resCode = res.statusCode;
    var responseBody = res.body;
    debugPrint(responseBody);
    var response = Map<String, dynamic>.from(json.decode(responseBody));
    debugPrint(response["userName"]);

    // verify the request code
    if(resCode==200){
      saveUserInfo(response); // store username
      Navigator.pushNamed(context, 'home'); // push to home page
      return resCode; // return status code for form validation
    } else if (resCode == 401) {
      return resCode;
    } else {
      return resCode;
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
                  color:  Color.fromRGBO(238, 230, 231, 0.877),
                ), 
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Center(child: Text("Login", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),
                    const SizedBox(height: 4),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            validator: (value) {
                              if(value == null || value.isEmpty) {
                                return 'Please enter some text';
                              } 
                              return null;
                            },
                            controller: emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                            ),
                          ),
                          const SizedBox(height: 4),
                          TextFormField(
                            validator: (value) {
                              if(value == null || value.isEmpty) {
                                code = null;
                                return 'Please enter some text';
                              } else if(code==401){
                                code = null;
                                return 'The username and/or password are not correct.';
                              }
                              code = null;
                              return null;
                            },
                            controller: passwordController,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                            ),
                            obscureText: true,
                          ),
                          const SizedBox(height: 8),
                          Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor:const Color.fromARGB(244, 0, 0, 0),
                                backgroundColor: const Color.fromARGB(244, 244, 248, 6),
                              ),
                              onPressed: () { 
                                if(_formKey.currentState!.validate()){
                                  _submitForm(context).then((value) {
                                    code = value;
                                  });
                                }
                              },
                              child: const Text('Login')
                            ),
                          ),
                          const SizedBox(height: 4),
                        ]
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?"),
                        const SizedBox(width: 4),
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
          )
        )
      )
    );
  }

  // 
  Future<void> saveUserInfo(info) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt("userID", info["userID"]);
    pref.setString("email", info["email"]);
    pref.setString("userName", info["userName"]);
  }


  // 
  @override
  void dispose(){
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

}
