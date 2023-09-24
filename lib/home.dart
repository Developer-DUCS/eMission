import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Color.fromRGBO(124, 184, 22, 1)),
      padding: const EdgeInsets.only(left: 40),
      width: double.infinity,
      child: Align(
        alignment: Alignment.centerLeft,
        child: SizedBox(
          width: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              profilePic(),
              progressBar()
            ]
          )
        )
      ),
    );
  }

  Widget settingsButton(String text, String route, BuildContext context) {
    return OutlinedButton(
      style: const ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(Colors.white),
        foregroundColor: MaterialStatePropertyAll(Colors.black54),
        overlayColor: MaterialStatePropertyAll(Colors.black12)
      ),
      onPressed: ( ) { Navigator.pushNamed(context, route); },
      child: Align(alignment: Alignment.centerLeft, child: Text(text))
    );
  }

  Widget profilePic() {
    return Stack(
      children: [
        CircleAvatar(
          radius: 75,
          backgroundColor: Colors.grey.shade200,
          child: CircleAvatar(
            radius: 70,
            backgroundImage: AssetImage('assets/images/pexels-robert-so-18127674-2.jpg'),
          ),
        ),
        Positioned(
          bottom: 1,
          right: 1,
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Icon(Icons.add_a_photo, color: Colors.black),
            ),
            decoration: BoxDecoration(
              border: Border.all(
                width: 3,
                color: Colors.white,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(
                  50,
                ),
              ),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: Offset(2, 4),
                  color: Colors.black.withOpacity(
                    0.3,
                  ),
                  blurRadius: 3,
                ),
              ]
            ),
          ),
        ),
      ],
    );
  }

  Widget progressBar() {
    return Container(
      child: LinearProgressIndicator(
        value: 0.4,
      ),
    );
  }

}