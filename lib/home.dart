import 'api_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:emission/theme/theme_manager.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int? userID;
  String? userEmail;
  String? userName;
  String? userDisplayName;

  int? totalPoints;
  

  ApiService apiService = new ApiService();

  @override
  void initState() {
    super.initState();
    getUserInfo();
    _getTotalPoints().then((value) {
      setState(() {
        totalPoints = value;
      });
    });
  }

  Future<dynamic> getUserID() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.getInt("userID");
    return pref.getInt("userID");
  }

  Future<int?> _getTotalPoints() async {
    print("totalPointsCalled");
    var userID = await getUserID();
    print(userID);
    var response = await apiService.get('getEarnedPoints?userID=${userID}');

    if (response.statusCode == 200) {
      var jsonResponse = response.data;
      print(jsonResponse);
      var totalPointsFromJson =
          jsonResponse['results'][0]['total_points'] as int? ?? 0;
      return totalPointsFromJson as int;
    } else {
      throw Exception("Failed to load post");
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: themeManager.currentTheme.colorScheme.primary,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(20)
              ),
              border: Border.all(
                color: Colors.grey.withOpacity(0.5),
                width: 0.5,
              ),
            ),
            height: MediaQuery.of(context).size.height / 4,
            child: Center(
              child: profilePic(themeManager),
            ),
          ),
          Expanded(
            child: Container(
              color: themeManager.currentTheme.colorScheme.background,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 10),
                    Text(
                      "Total Points: ${totalPoints ?? ""}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget profilePic(themeManager) {
    return Container(
      child: Column(children: [
        SizedBox(height: 20),
        CircleAvatar(
          radius: 50,
          backgroundColor: themeManager.currentTheme.colorScheme.tertiary,
          child: const CircleAvatar(
            radius: 45,
            backgroundImage: AssetImage('assets/images/plant.jpg'),
          ),
        ),
        Container(
          child: userName == null
              ? const Text(
                  "Your Name",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                )
              : Text(userName!,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 24)),
        ),
      ]),
    );
  }

  Widget progressBar() {
    return Container(
      child: const LinearProgressIndicator(
        value: 0.4,
      ),
    );
  }

  void getUserInfo() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    userID = pref.getInt("userID");
    userEmail = pref.getString("email");
    userName = pref.getString("userName");
    userDisplayName = pref.getString("displayName");
    setState(() {});
  }
}
