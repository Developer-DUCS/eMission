import 'package:first_flutter_app/challenge_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});
  
  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  // main section
  SettingsSection active = SettingsSection.main;

  // profile
  String email = 'example@email.com';
  String username = 'username';
  String displayName = 'Display Name';

  // preferences
  bool applicationAudio = false;
  bool faceId = true;
  bool darkMode = false;

  // preferences
  bool accessLocation = true;
  bool accessPhotos = false;
  bool accessContacts = false;

  // support
  bool anonymous = false;

  @override
  Widget build(BuildContext context) {
    Widget body;

    switch (active) {
      case SettingsSection.account:
        body = account();
        break;
      case SettingsSection.preferences:
        body = preferences();
        break;
      case SettingsSection.privacy:
        body = privacy();
        break;
      case SettingsSection.support:
        body = support();
        break;
      case SettingsSection.about:
        body = about();
        break;
      default:
        body = main();
        break;
    }

    return Container(
      decoration: const BoxDecoration(color: Color.fromRGBO(124, 184, 22, 1)),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      alignment: Alignment.center,
      child: SingleChildScrollView(padding: const EdgeInsets.all(30), child: body,),
    );
  }

  void changeActive(SettingsSection value) {
    setState(() {
      active = value;
    });
  }

  Widget main() {
    return SizedBox(
      width: 200,
      child: Column(
        children: [
          settingsButton("Account", SettingsSection.account),
          settingsButton("Preferences", SettingsSection.preferences),
          settingsButton("Privacy", SettingsSection.privacy),
          settingsButton("Support", SettingsSection.support),
          settingsButton("About", SettingsSection.about)
        ]
      )
    );
  }

  Widget settingsButton(String text, SettingsSection route) {
    return OutlinedButton(
      style: const ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(Colors.white),
        foregroundColor: MaterialStatePropertyAll(Colors.black54),
        overlayColor: MaterialStatePropertyAll(Colors.black12)
      ),
      onPressed: ( ) { changeActive(route); },
      child: Align(alignment: Alignment.center, child: Text(text))
    );
  }

  Widget account() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row( mainAxisAlignment: MainAxisAlignment.center, children: [Stack( 
          children: [
            CircleAvatar(
              radius: 75,
              backgroundColor: Colors.grey.shade200,
              child: const CircleAvatar(
                radius: 70,
                backgroundImage: AssetImage('assets/images/pexels-robert-so-18127674-2.jpg'),
              ),
            ),
            Positioned(
              bottom: 1,
              right: 1,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 3,
                    color: Colors.white,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(
                      50,
                    ),
                  ),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(2, 4),
                      color: Colors.black.withOpacity(
                        0.3,
                      ),
                      blurRadius: 3,
                    ),
                  ]
                ),
                child: const Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Icon(Icons.add_a_photo, color: Colors.black),
                ),
              ),
            ),
          ],
        )]),
        Container(
          decoration: const BoxDecoration(color: Color.fromRGBO(160, 214, 66, 1), border: Border(), borderRadius: BorderRadius.all(Radius.circular(10))),
          margin: const EdgeInsets.only(top: 20),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Email", style: TextStyle(fontWeight: FontWeight.bold),),
              TextFormField(initialValue: email, enabled: false,),
              const SizedBox(height: 20,),
              const Text("Username", style: TextStyle(fontWeight: FontWeight.bold),),
              TextFormField(initialValue: username),
              const SizedBox(height: 20,),
              const Text("Display Name", style: TextStyle(fontWeight: FontWeight.bold),),
              TextFormField(initialValue: displayName),
              const SizedBox(height: 20,),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Column(children: [
                  ElevatedButton(onPressed: () {openPasswordModal(context);}, style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(244, 244, 248, 6), foregroundColor: Colors.black), child: const Text("Change Password")),
                  ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(244, 244, 248, 6), foregroundColor: Colors.black), child: const Text("Update"))
                ],)
              ],)
            ],
          ),
        )
      ]
    );
  }
  
  Widget preferences() {
    return Column(children: [
      const Text("Preferences", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
      Container(
        decoration: const BoxDecoration(color: Color.fromRGBO(160, 214, 66, 1), borderRadius: BorderRadius.all(Radius.circular(10)),),
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.all(12),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Application Audio"),
              Switch(value: applicationAudio, onChanged: (value) {setState(() {
                applicationAudio = value;
              });})
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Face ID"),
              Switch(value: faceId, onChanged: (value) {setState(() {
                faceId = value;
              });})
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Dark Mode"),
              Switch(value: darkMode, onChanged: (value) {setState(() {
                darkMode = value;
              });})
            ],
          )
        ],)
      )
    ]);
  }

  Widget privacy() {
    return Column(children: [
      const Text("Privacy", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
      Container(
        decoration: const BoxDecoration(color: Color.fromRGBO(160, 214, 66, 1), borderRadius: BorderRadius.all(Radius.circular(10)),),
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.all(12),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Access Location"),
              Switch(value: accessLocation, onChanged: (value) {setState(() {
                accessLocation = value;
              });})
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Access Photos"),
              Switch(value: accessPhotos, onChanged: (value) {setState(() {
                accessPhotos = value;
              });})
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Access Contacts"),
              Switch(value: accessContacts, onChanged: (value) {setState(() {
                accessContacts = value;
              });})
            ],
          )
        ],)
      )
    ]);
  }

  Widget support() {
    return Column(children: [
      const Text("Support", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
      Container(
        decoration: const BoxDecoration(color: Color.fromRGBO(160, 214, 66, 1), borderRadius: BorderRadius.all(Radius.circular(10)),),
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          const Text("Have any feedback or problems? Let us know:"),
          Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5),), margin: const EdgeInsets.only(top: 16), child: const TextField(maxLines: 3, decoration: InputDecoration(border: OutlineInputBorder()),)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            const Text("Submit anonymously:"),
            Checkbox(value: anonymous, onChanged: (value) { setState(() {
              anonymous = value ?? false;
            }); })
          ],),
          ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(244, 244, 248, 6), foregroundColor: Colors.black), child: const Text("Submit"))
        ],)
      )
    ]);
  }

  Widget about() {
    return Column(children: [
      const Text("About", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
      Container(
        decoration: const BoxDecoration(color: Color.fromRGBO(160, 214, 66, 1), borderRadius: BorderRadius.all(Radius.circular(10)),),
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.all(20),
        child: const Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Build Number", style: TextStyle(fontWeight: FontWeight.bold),), Text("1.4.5")],),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Build Date", style: TextStyle(fontWeight: FontWeight.bold),), Text("10/06/23")],)
        ],)
      )
    ]);
  }

  void openPasswordModal(BuildContext context) {
    showDialog(context: context, builder: (BuildContext context) {
      return SimpleDialog(
        title: const Text('Change Password'),
        contentPadding: const EdgeInsets.all(20),
        children: [
          TextFormField(decoration: const InputDecoration(labelText: 'New Password'),),
          const SizedBox(height: 20,),
          TextFormField(decoration: const InputDecoration(labelText: 'Confirm Password'),),
          const SizedBox(height: 20,),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            ElevatedButton(onPressed: () { Navigator.pop(context); }, style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(244, 244, 248, 6), foregroundColor: Colors.black), child: const Text("Close")),
            ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(244, 244, 248, 6), foregroundColor: Colors.black), child: const Text("Change")),
          ],)
        ],
      );
    });
  }

}

enum SettingsSection {
  main,
  account,
  preferences,
  privacy,
  support,
  about
}