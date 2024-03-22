import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:emission/theme/theme_manager.dart';
import 'package:another_flushbar/flushbar.dart';
import 'challenge_page.dart';
import 'encryption.dart';
import 'package:flutter/material.dart';
import 'api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        body = preferences(context);
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
      decoration: BoxDecoration(color: Provider.of<ThemeManager>(context).currentTheme.colorScheme.primary),
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
        style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Provider.of<ThemeManager>(context).currentTheme.colorScheme.secondary),
            foregroundColor: MaterialStatePropertyAll(Colors.white),
            overlayColor: MaterialStatePropertyAll(Colors.black12)),
        onPressed: () {
          changeActive(route);
        },
        child: Align(alignment: Alignment.center, child: Text(text, style: TextStyle(fontWeight: FontWeight.bold))));
  }

  Widget account() {
    void updateAccount(BuildContext context) {
      ApiService().patch('user', {
        'id': userID,
        'username': usernameController.text,
        'displayName': displayNameController.text
      }).then((res) {
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
              radius: 78,
              backgroundColor: Provider.of<ThemeManager>(context).currentTheme.colorScheme.secondary,
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
        decoration: BoxDecoration(
            color: Provider.of<ThemeManager>(context).currentTheme.colorScheme.background,
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
              style: TextStyle(color: Colors.black26)
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Username",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextFormField(
              controller: usernameController,
              style: TextStyle(color: Colors.black)
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Display Name",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextFormField(
              controller: displayNameController,
              style: TextStyle(color: Colors.black)
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
                            backgroundColor: Provider.of<ThemeManager>(context).currentTheme.colorScheme.secondary,
                            foregroundColor: Provider.of<ThemeManager>(context).currentTheme.colorScheme.background,
                          ),
                            
                        child: const Text("Change Password")),
                    ElevatedButton(
                        onPressed: () => updateAccount(context),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Provider.of<ThemeManager>(context).currentTheme.colorScheme.secondary,
                            foregroundColor: Provider.of<ThemeManager>(context).currentTheme.colorScheme.background,
                          ),
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

  Widget preferences(context) {
    return Column(children: [
      const Text(
        "Preferences",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      ),
      Container(
          decoration: BoxDecoration(
            color: Provider.of<ThemeManager>(context).currentTheme.colorScheme.background,
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
                    activeColor: Provider.of<ThemeManager>(context).currentTheme.colorScheme.background,
                    inactiveThumbColor: Provider.of<ThemeManager>(context).currentTheme.colorScheme.onBackground,
                    activeTrackColor: Provider.of<ThemeManager>(context).currentTheme.colorScheme.secondary,
                    inactiveTrackColor: Provider.of<ThemeManager>(context).currentTheme.colorScheme.background,
                    trackOutlineColor: MaterialStatePropertyAll(Provider.of<ThemeManager>(context).currentTheme.colorScheme.onBackground),
                    trackOutlineWidth: MaterialStatePropertyAll(1.5),
                    onChanged: (value) {
                      setState(() {
                        applicationAudio = value;
                      });
                    }
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Face ID"),
                  Switch(
                    value: faceId,
                    activeColor: Provider.of<ThemeManager>(context).currentTheme.colorScheme.background,
                    inactiveThumbColor: Provider.of<ThemeManager>(context).currentTheme.colorScheme.onBackground,
                    activeTrackColor: Provider.of<ThemeManager>(context).currentTheme.colorScheme.secondary,
                    inactiveTrackColor: Provider.of<ThemeManager>(context).currentTheme.colorScheme.background,
                    trackOutlineColor: MaterialStatePropertyAll(Provider.of<ThemeManager>(context).currentTheme.colorScheme.onBackground),
                    trackOutlineWidth: MaterialStatePropertyAll(1.5),
                    onChanged: (value) {
                      setState(() {
                        faceId = value;
                      });
                    }
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Dark Mode"),
                  Switch(
                    value: darkMode,
                    activeColor: Provider.of<ThemeManager>(context).currentTheme.colorScheme.background,
                    inactiveThumbColor: Provider.of<ThemeManager>(context).currentTheme.colorScheme.onBackground,
                    activeTrackColor: Provider.of<ThemeManager>(context).currentTheme.colorScheme.secondary,
                    inactiveTrackColor: Provider.of<ThemeManager>(context).currentTheme.colorScheme.background,
                    trackOutlineColor: MaterialStatePropertyAll(Provider.of<ThemeManager>(context).currentTheme.colorScheme.onBackground),
                    trackOutlineWidth: MaterialStatePropertyAll(1.5),
                    onChanged: (value) {
                      setState(() {
                        darkMode = value;
                      });
                    },
                  ),
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
          decoration: BoxDecoration(
            color: Provider.of<ThemeManager>(context).currentTheme.colorScheme.background,
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
                    activeColor: Provider.of<ThemeManager>(context).currentTheme.colorScheme.background,
                    inactiveThumbColor: Provider.of<ThemeManager>(context).currentTheme.colorScheme.onBackground,
                    activeTrackColor: Provider.of<ThemeManager>(context).currentTheme.colorScheme.secondary,
                    inactiveTrackColor: Provider.of<ThemeManager>(context).currentTheme.colorScheme.background,
                    trackOutlineColor: MaterialStatePropertyAll(Provider.of<ThemeManager>(context).currentTheme.colorScheme.onBackground),
                    trackOutlineWidth: MaterialStatePropertyAll(1.5),
                    onChanged: (value) {
                      setState(() {
                        accessLocation = value;
                      });
                    }
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Access Photos"),
                  Switch(
                    value: accessPhotos,
                    activeColor: Provider.of<ThemeManager>(context).currentTheme.colorScheme.background,
                    inactiveThumbColor: Provider.of<ThemeManager>(context).currentTheme.colorScheme.onBackground,
                    activeTrackColor: Provider.of<ThemeManager>(context).currentTheme.colorScheme.secondary,
                    inactiveTrackColor: Provider.of<ThemeManager>(context).currentTheme.colorScheme.background,
                    trackOutlineColor: MaterialStatePropertyAll(Provider.of<ThemeManager>(context).currentTheme.colorScheme.onBackground),
                    trackOutlineWidth: MaterialStatePropertyAll(1.5),
                    onChanged: (value) {
                      setState(() {
                        accessPhotos = value;
                      });
                    }
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Access Contacts"),
                  Switch(
                    value: accessContacts,
                    activeColor: Provider.of<ThemeManager>(context).currentTheme.colorScheme.background,
                    inactiveThumbColor: Provider.of<ThemeManager>(context).currentTheme.colorScheme.onBackground,
                    activeTrackColor: Provider.of<ThemeManager>(context).currentTheme.colorScheme.secondary,
                    inactiveTrackColor: Provider.of<ThemeManager>(context).currentTheme.colorScheme.background,
                    trackOutlineColor: MaterialStatePropertyAll(Provider.of<ThemeManager>(context).currentTheme.colorScheme.onBackground),
                    trackOutlineWidth: MaterialStatePropertyAll(1.5),
                    onChanged: (value) {
                      setState(() {
                        accessContacts = value;
                      });
                    }
                  )
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
          decoration: BoxDecoration(
            color: Provider.of<ThemeManager>(context).currentTheme.colorScheme.primaryContainer,
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
                    style: TextStyle(color: Colors.black),
                    maxLines: 3,
                    decoration: InputDecoration(border: OutlineInputBorder()),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Submit anonymously:"),
                  Checkbox(
                      value: anonymous,
                      activeColor: Provider.of<ThemeManager>(context).currentTheme.colorScheme.secondary,
                      checkColor: Provider.of<ThemeManager>(context).currentTheme.colorScheme.onBackground,
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
                      backgroundColor: Provider.of<ThemeManager>(context).currentTheme.colorScheme.secondary,
                      foregroundColor: Provider.of<ThemeManager>(context).currentTheme.colorScheme.background,),
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
          decoration: BoxDecoration(
            color: Provider.of<ThemeManager>(context).currentTheme.colorScheme.background,
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

      ApiService().patch('password', {
        'id': userID,
        'oldPassword': encryptPassword(oldPassword.text),
        'newPassword': encryptPassword(newPassword.text)
      }).then((res) {
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
            backgroundColor: Provider.of<ThemeManager>(context).currentTheme.colorScheme.primaryContainer,
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
                              Provider.of<ThemeManager>(context).currentTheme.colorScheme.secondary,//const Color.fromARGB(244, 244, 248, 6),
                          foregroundColor: Provider.of<ThemeManager>(context).currentTheme.colorScheme.background),
                      child: const Text("Close")),
                  ElevatedButton(
                      onPressed: () => changePassword(context),
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Provider.of<ThemeManager>(context).currentTheme.colorScheme.secondary,
                          foregroundColor: Provider.of<ThemeManager>(context).currentTheme.colorScheme.background),
                      child: const Text("Change")),
                ],
              )
            ],
          );
        });
  }
}

enum SettingsSection { main, account, preferences, privacy, support, about }
