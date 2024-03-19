import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:emission/theme/theme_manager.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'api_service.dart';

class User {
  final int userID;
  final int points;
  final String username;

  User({required this.userID, required this.points, required this.username});
}

Future<int> _getUserRank() async {
  var userID = await getUserID();
  var response = await ApiService().get("getUserRank?userID=${userID}");
  print("Response from service: ");
  print(response.data["results"][0]["leaderboard_rank"]);
  var rank = response.data["results"][0]["leaderboard_rank"];
  if (response.statusCode == 200) {
    if (rank != null) {
      return rank;
    } else {
      return 0;
    }
  } else {
    throw Exception(
        "Failed to get user rank. Status code: ${response.statusCode}");
  }
}

Future<List<User>> _getUsers() async {
  var response = await http.get(
    Uri.parse("http://10.0.2.2:3300/getTopTen"),
    headers: {
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body);
    List<User> users = [];
    for (var challenge in jsonResponse['results']) {
      users.add(User(
          userID: challenge['userID'],
          points: challenge['total_points'],
          username: challenge['username']));
    }
    return users;
  } else {
    throw Exception("Failed to load post");
  }
}

Future<int> getUserID() async {
  final SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getInt("userID") ?? 0;
}

class Leaderboard extends StatefulWidget {
  const Leaderboard({Key? key}) : super(key: key);

  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  late Future<int?> userRankFuture;
  late Future<List<User>> usersFuture;

  @override
  void initState() {
    super.initState();
    userRankFuture = _getUserRank();
    usersFuture = _getUsers();
  }

  @override
  Widget build(BuildContext context) {
    ThemeManager themeManager = Provider.of<ThemeManager>(context);
    return Stack(
      children: [
        Scaffold(
          body: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 40),
                height: 330,
                decoration: BoxDecoration(
                  color: themeManager.currentTheme.colorScheme.primary,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: themeManager.currentTheme.colorScheme.secondary,
                          child: const CircleAvatar(
                            radius: 45,
                              backgroundImage: AssetImage("assets/images/plant.jpg"),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FutureBuilder<int?>(
                      future: userRankFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          int? userRank = snapshot.data;

                          return Column(
                            children: [
                              Text(
                                "Your Rank",
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 20),
                              Divider(
                                thickness: 1,
                                indent: 20,
                                endIndent: 20,
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        "#${userRank ?? 'N/A'}",
                                        style: TextStyle(
                                          fontSize: 42,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.black.withOpacity(0.9),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Leaderboard",
                style: TextStyle(fontSize: 20),
              ),
              FutureBuilder<List<User>>(
                future: usersFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Expanded(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final user = snapshot.data![index];
                          return ListTile(
                            title: Row(
                              children: [
                                SizedBox(
                                  width: 3,
                                ),
                                Text("${user.username}"),
                              ],
                            ),
                            leading: Text(
                              "#${index + 1}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            trailing: Text("Points: ${user.points}",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          );
                        },
                        separatorBuilder: (context, index) => Divider(
                          thickness: 1,
                          color: Color.fromRGBO(160, 197, 89, 100),
                          indent: 10,
                          endIndent: 10,
                        ),
                        itemCount: snapshot.data!.length,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
  }
                
                  