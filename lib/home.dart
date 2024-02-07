import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

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
    var userID = await getUserID();
    var jsonBody = jsonEncode({"userID": userID});

    var response = await http.post(
      Uri.parse("http://10.0.2.2:3000/getEarnedPoints"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonBody,
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      var totalPointsFromJson = jsonResponse['results'][0]['totalPointsBoth'] ??
          0; // Access the total points field
      return totalPointsFromJson as int;
    } else {
      throw Exception("Failed to load post");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: const Color.fromRGBO(202, 217, 150, 1),
              border: Border.all(
                color: Colors.black,
                width: 2.0,
              ),
            ),
            height: MediaQuery.of(context).size.height / 4,
            child: Center(
              child: profilePic(),
            ),
          ),
          Expanded(
            child: Container(
              color: const Color.fromRGBO(124, 184, 22, 1),
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

  Widget profilePic() {
    return Container(
      child: Column(children: [
        SizedBox(height: 20),
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.grey.shade200,
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
