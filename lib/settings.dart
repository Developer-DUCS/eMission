import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:first_flutter_app/challenge_page.dart';
import 'package:first_flutter_app/encryption.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  // main section
  SettingsSection active = SettingsSection.main;

  // profile
  TextEditingController emailController = new TextEditingController();
  TextEditingController usernameController = new TextEditingController();
  TextEditingController displayNameController = new TextEditingController();
  int userID = 0;

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
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((pref) {
      emailController.text = pref.getString("email") ?? "";
      usernameController.text = pref.getString("userName") ?? "";
      displayNameController.text = pref.getString("displayName") ?? "";
      userID = pref.getInt('userID') ?? 0;
    });
  }

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
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: body,
      ),
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
        child: Column(children: [
          settingsButton("Account", SettingsSection.account),
          settingsButton("Preferences", SettingsSection.preferences),
          settingsButton("Privacy", SettingsSection.privacy),
          settingsButton("Support", SettingsSection.support),
          settingsButton("About", SettingsSection.about)
        ]));
  }

  Widget settingsButton(String text, SettingsSection route) {
    return OutlinedButton(
        style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Colors.white),
            foregroundColor: MaterialStatePropertyAll(Colors.black54),
            overlayColor: MaterialStatePropertyAll(Colors.black12)),
        onPressed: () {
          changeActive(route);
        },
        child: Align(alignment: Alignment.center, child: Text(text)));
  }

  Widget account() {
    void updateAccount(BuildContext context) {
      http
          .patch(Uri.parse('http://10.0.2.2:3000/user'),
              headers: {'Content-Type': 'application/json'},
              body: json.encode({
                'id': userID,
                'username': usernameController.text,
                'displayName': displayNameController.text
              }))
          .then((res) {
        if (res.statusCode == 200) {
          Flushbar(
            title: 'Success',
            message: 'Account information succesfully updated.',
            backgroundColor: Colors.greenAccent,
            flushbarPosition: FlushbarPosition.TOP,
          ).show(context);
          SharedPreferences.getInstance().then((pref) {
            pref.setString('username', usernameController.text);
            pref.setString('displayName', displayNameController.text);
          });
        } else {
          Flushbar(
            title: 'Error',
            message: 'There was a problem with the server. Please try again.',
            backgroundColor: Colors.redAccent,
            flushbarPosition: FlushbarPosition.TOP,
          ).show(context);
        }
      });
    }

    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 75,
              backgroundColor: Colors.grey.shade200,
              child: const CircleAvatar(
                radius: 70,
                backgroundImage:
                    AssetImage('assets/images/pexels-robert-so-18127674-2.jpg'),
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
                    ]),
                child: const Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Icon(Icons.add_a_photo, color: Colors.black),
                ),
              ),
            ),
          ],
        )
      ]),
      Container(
        decoration: const BoxDecoration(
            color: Color.fromRGBO(160, 214, 66, 1),
            border: Border(),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Email",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextFormField(
              controller: emailController,
              enabled: false,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Username",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextFormField(controller: usernameController),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Display Name",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextFormField(
              controller: displayNameController,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          openPasswordModal(context);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(244, 244, 248, 6),
                            foregroundColor: Colors.black),
                        child: const Text("Change Password")),
                    ElevatedButton(
                        onPressed: () => updateAccount(context),
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(244, 244, 248, 6),
                            foregroundColor: Colors.black),
                        child: const Text("Update"))
                  ],
                )
              ],
            )
          ],
        ),
      )
    ]);
  }

  Widget preferences() {
    return Column(children: [
      const Text(
        "Preferences",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      ),
      Container(
          decoration: const BoxDecoration(
            color: Color.fromRGBO(160, 214, 66, 1),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          margin: const EdgeInsets.only(top: 16),
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Application Audio"),
                  Switch(
                      value: applicationAudio,
                      onChanged: (value) {
                        setState(() {
                          applicationAudio = value;
                        });
                      })
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Face ID"),
                  Switch(
                      value: faceId,
                      onChanged: (value) {
                        setState(() {
                          faceId = value;
                        });
                      })
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Dark Mode"),
                  Switch(
                      value: darkMode,
                      onChanged: (value) {
                        setState(() {
                          darkMode = value;
                        });
                      })
                ],
              )
            ],
          ))
    ]);
  }

  Widget privacy() {
    return Column(children: [
      const Text(
        "Privacy",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      ),
      Container(
          decoration: const BoxDecoration(
            color: Color.fromRGBO(160, 214, 66, 1),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          margin: const EdgeInsets.only(top: 16),
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Access Location"),
                  Switch(
                      value: accessLocation,
                      onChanged: (value) {
                        setState(() {
                          accessLocation = value;
                        });
                      })
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Access Photos"),
                  Switch(
                      value: accessPhotos,
                      onChanged: (value) {
                        setState(() {
                          accessPhotos = value;
                        });
                      })
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Access Contacts"),
                  Switch(
                      value: accessContacts,
                      onChanged: (value) {
                        setState(() {
                          accessContacts = value;
                        });
                      })
                ],
              )
            ],
          ))
    ]);
  }

  Widget support() {
    return Column(children: [
      const Text(
        "Support",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      ),
      Container(
          decoration: const BoxDecoration(
            color: Color.fromRGBO(160, 214, 66, 1),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          margin: const EdgeInsets.only(top: 16),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text("Have any feedback or problems? Let us know:"),
              Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  margin: const EdgeInsets.only(top: 16),
                  child: const TextField(
                    maxLines: 3,
                    decoration: InputDecoration(border: OutlineInputBorder()),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Submit anonymously:"),
                  Checkbox(
                      value: anonymous,
                      onChanged: (value) {
                        setState(() {
                          anonymous = value ?? false;
                        });
                      })
                ],
              ),
              ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(244, 244, 248, 6),
                      foregroundColor: Colors.black),
                  child: const Text("Submit"))
            ],
          ))
    ]);
  }

  Widget about() {
    return Column(children: [
      const Text(
        "About",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      ),
      Container(
          decoration: const BoxDecoration(
            color: Color.fromRGBO(160, 214, 66, 1),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          margin: const EdgeInsets.only(top: 16),
          padding: const EdgeInsets.all(20),
          child: const Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Build Number",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text("1.4.5")
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Build Date",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text("10/06/23")
                ],
              )
            ],
          ))
    ]);
  }

  void openPasswordModal(BuildContext context) {
    TextEditingController oldPassword = new TextEditingController();
    TextEditingController newPassword = new TextEditingController();
    TextEditingController confirmPassword = new TextEditingController();

    void changePassword(BuildContext context) async {
      if (newPassword.text != confirmPassword.text) {
        Flushbar(
          title: 'Error',
          message: 'New password does not match confirmation password.',
          backgroundColor: Colors.redAccent,
          flushbarPosition: FlushbarPosition.TOP,
        ).show(context);
        return;
      }

      if (newPassword.text == oldPassword.text) {
        Flushbar(
          title: 'Error',
          message: 'Old password and new password cannot match.',
          backgroundColor: Colors.redAccent,
          flushbarPosition: FlushbarPosition.TOP,
        ).show(context);
        return;
      }

      http
          .patch(Uri.parse('http://10.0.2.2:3000/password'),
              headers: {'Content-Type': 'application/json'},
              body: json.encode({
                'id': userID,
                'oldPassword': encryptPassword(oldPassword.text),
                'newPassword': encryptPassword(newPassword.text)
              }))
          .then((res) {
        if (res.statusCode == 200) {
          Flushbar(
            title: 'Success',
            message: 'Password succesfully changed.',
            backgroundColor: Colors.greenAccent,
            flushbarPosition: FlushbarPosition.TOP,
          ).show(context);
        } else if (res.statusCode == 401) {
          Flushbar(
            title: 'Error',
            message: 'Password is not correct.',
            backgroundColor: Colors.redAccent,
            flushbarPosition: FlushbarPosition.TOP,
          ).show(context);
        } else {
          Flushbar(
            title: 'Error',
            message: 'There was a problem with the server. Please try again.',
            backgroundColor: Colors.redAccent,
            flushbarPosition: FlushbarPosition.TOP,
          ).show(context);
        }
      });
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Change Password'),
            contentPadding: const EdgeInsets.all(20),
            children: [
              TextFormField(
                controller: oldPassword,
                decoration: const InputDecoration(labelText: 'Old Password'),
                obscureText: true,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: newPassword,
                decoration: const InputDecoration(labelText: 'New Password'),
                obscureText: true,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: confirmPassword,
                decoration:
                    const InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(244, 244, 248, 6),
                          foregroundColor: Colors.black),
                      child: const Text("Close")),
                  ElevatedButton(
                      onPressed: () => changePassword(context),
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(244, 244, 248, 6),
                          foregroundColor: Colors.black),
                      child: const Text("Change")),
                ],
              )
            ],
          );
        });
  }
}

enum SettingsSection { main, account, preferences, privacy, support, about }
