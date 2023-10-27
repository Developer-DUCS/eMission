import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:first_flutter_app/encryption.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

      // Declare TextEditingController variables for email and password
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

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
                  controller: emailController, // Attach the controller to the TextFormField
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                ),
                const SizedBox(height: 4,),
                TextFormField(
                  controller: passwordController, // Attach the controller to the TextFormField
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
                    onPressed: () { 
                      // Get the text entered in the TextFormFields using controllers
                      String email = emailController.text;
                      String password = passwordController.text;
                      
                      // Encrypt the password
                      String encryptedPassword = encryptPassword(password);
                      print('Encrypted password: $encryptedPassword');

                      // VALIDATE PASSWORD FROM DB HERE BEFORE LOGIN
                      Navigator.pushNamed(context, 'home'); 
                      },
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
}
