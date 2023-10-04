import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

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
              settingsButton("Account", "manual", context),
              settingsButton("Notifications", "", context),
              settingsButton("Appearance", "", context),
              settingsButton("Privacy", "", context),
              settingsButton("Support", "", context),
              settingsButton("About", "", context)
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
}