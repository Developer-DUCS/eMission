///
/// challenge_page.dart
/// Initializes ChallengePage and PastChallengesPage classes for eMision Application.
///
///
/// Created: Chris Warren
/// Edited: Jali Purcell

// import statements

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class Challenge {
  final int challengeID;
  final int points;
  final String description;
  final String length;
  final DateTime? expirationDate;
  final String name;
  bool isSelected;
  DateTime? dateAccepted;
  int daysInProgress;
  DateTime? dateFinished;

  Challenge(
      {required this.challengeID,
      required this.points,
      required this.description,
      required this.length,
      required this.expirationDate,
      required this.name,
      this.isSelected = false,
      this.dateAccepted = null,
      this.daysInProgress = 0,
      this.dateFinished = null});

  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
        challengeID: json['challengeID'],
        points: json['points'],
        description: json['description'],
        length: json['length'],
        expirationDate: json['expirationDate'],
        name: json['name']);
  }
  Map<String, dynamic> toJson() {
    return {
      'challengeID': challengeID,
      'points': points,
      'description': description,
      'length': length,
      'expirationDate': expirationDate,
      'name': name
    };
  }
}

class UserChallenge {
  final int challengeID;
  final int points;
  final String description;
  final String length;
  final String name;
  bool isSelected;
  DateTime? dateAccepted;
  String daysInProgress;
  DateTime? dateFinished;

  UserChallenge(
      {required this.challengeID,
      required this.points,
      required this.description,
      required this.length,
      required this.name,
      this.isSelected = false,
      this.dateAccepted = null,
      this.daysInProgress = '0',
      this.dateFinished = null});

  // updat these
  factory UserChallenge.fromJson(Map<String, dynamic> json) {
    return UserChallenge(
        challengeID: json['challengeID'],
        points: json['points'],
        description: json['description'],
        length: json['length'],
        name: json['name']);
  }
  Map<String, dynamic> toJson() {
    return {
      'challengeID': challengeID,
      'points': points,
      'description': description,
      'length': length,
      'name': name
    };
  }

  Map<String, dynamic> toAcceptedJson() {
    return {
      'challengeID': challengeID,
      // change when store userID locally
      'userID': 1,
      //'dateAccepted': dateAccepted,
      'daysInProgress': daysInProgress,
      //'dateFinished':
    };
  }
}

Future<List<Challenge>> _getChallenges() async {
  print("here");
  // this is the url for using a Android emulator
  // Apple emulators use localhost like normal
  String url = 'http://10.0.2.2:3000/getChallenges';
  List<Challenge> challenges = [];

  var response = await http.get(Uri.parse(url));
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');
  print(response.statusCode);
  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body);
    print("JSON RESPONSE");
    print(jsonResponse);
    for (var challenge in jsonResponse['results']) {
      Challenge thisOne = Challenge(
          challengeID: challenge['challengeID'],
          name: challenge['name'],
          points: challenge['points'],
          description: challenge['description'],
          length: challenge['length'],
          expirationDate: challenge['expirationDate']);
      challenges.add(thisOne);
    }
    return challenges;
  } else {
    throw Exception("Failed to load post");
  }
}

/*
    Initializes ChallengePage Class and returns a container of the pages various Widgets
*/
class ChallengePage extends StatefulWidget {
  //const ChallengePage({super.key});
  ChallengePage({Key? key}) : super(key: key);

  @override
  State<ChallengePage> createState() => _ChallengePageState();
}

@override
class _ChallengePageState extends State<ChallengePage> {
  late Future<List<Challenge>> challenges;
  List<Challenge> selectedChallenges = [];
  List<CheckboxExample> checkboxes = [];
  List<Widget> checkboxList = [];
  List<bool?> selectedCheckboxes = [];

  @override
  void initState() {
    super.initState();
    challenges = _getChallenges();
  }

  void addCheckbox(CheckboxExample checkbox) {
    checkboxes.add(checkbox);
    selectedCheckboxes.add(false);
  }

  void _deselectCheckboxes(List<Challenge> challenges) {
    for (var check in challenges) {
      check.isSelected = false;
    }
  }

  void _showDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _acceptChallenges(BuildContext context) async {
    try {
      var list = [];
      List<Challenge> challengeList =
          await challenges; // Wait for the Future to complete
      selectedChallenges =
          challengeList.where((challenge) => challenge.isSelected).toList();
      print(selectedChallenges);
      print('Selected Challenges: $selectedChallenges');
      String url = "http://10.0.2.2:3000/acceptChallenges";
      for (Challenge challenge in selectedChallenges) {
        list.add(challenge.toJson());
      }
      String jsonBody = jsonEncode(list);

      var response = await http.post(
        Uri.parse("http://10.0.2.2:3000/acceptNewChallenges"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonBody,
      );

      if (response.statusCode == 200) {
        print('Challenges accepted successfully');
        List<dynamic> responseMessages = json.decode(response.body);

        List<String> challengeSummaries = [];

        for (var message in responseMessages) {
          var name = message['challengeData']['name'];
          var dateFinished = message['challengeData']['dateFinished'];
          var status = message['status'];

          if (name == null) {
            name = "";
          }

          if (dateFinished != null) {
            status = "You have already completed that challenge.";
          }
          challengeSummaries.add('${name}  ${status}');
        }

        // Show a single dialog box with the summary of all challenges
        _showDialog(context, "Update", challengeSummaries.join('\n'));
      } else {
        print('Failed to accept challenges');
        _showDialog(
            context, "Error", "Something went wrong, please try again later.");
      }
    } catch (e) {
      print('Error accepting challenges: $e');
      _showDialog(context, "Error", e.toString());
    }
    /* setState(() {
       for (var challenge in selectedChallenges) {
          challenge.isSelected = false;
        }
      }); */
  }

  /* Future<void> _loadChallenges() async {
    Future<List<Challenge>> challenges = await _getChallenges();
    setState(() {
      _challenges = challenges;
    });
  } */

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: const Color.fromRGBO(255, 168, 48, 100),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ToggleButton(isPastPage: false),
          Center(
            child: Text(
              "Challenge yourself with any of the following eFriendly challenges",
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 300,
            child: FutureBuilder<List<Challenge>>(
              future: challenges,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Challenge> challengeList = snapshot.data!;
                  List<Challenge> filteredChallenges = challengeList
                      .where((challenge) =>
                          !selectedChallenges.contains(challenge))
                      .toList();

                  return Scrollbar(
                    trackVisibility: true,
                    showTrackOnHover: true,
                    thickness: 5,
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: filteredChallenges.length,
                      itemBuilder: (context, index) {
                        Challenge challenge = filteredChallenges[index];
                        CheckboxExample myCheck =
                            CheckboxExample(challenge: challenge);
                        addCheckbox(myCheck);
                        return ListTile(
                          title: Text(challenge.name),
                          subtitle:
                              Text(snapshot.data![index].points.toString()),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.info),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      var expirationDate =
                                          snapshot.data![index].expirationDate;
                                      String expirationDateText =
                                          (expirationDate != null)
                                              ? expirationDate.toString()
                                              : 'Never';
                                      return AlertDialog(
                                        title: Text('Challenge Description'),
                                        content: Container(
                                          width: 200,
                                          height: 200,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(snapshot
                                                  .data![index].description),
                                              SizedBox(height: 5),
                                              Text(
                                                  'Expires: $expirationDateText'),
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('Close'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                              myCheck,
                            ],
                          ),
                        );
                      },
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else {
                  return Container(
                    color: const Color.fromRGBO(255, 168, 48, 100),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            ),
          ),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: const Color.fromARGB(244, 0, 0, 0),
                backgroundColor: const Color.fromARGB(244, 244, 248, 6),
              ),
              onPressed: () {
                _acceptChallenges(context);
              },
              child: const Text('Accept Selected Challenges'),
            ),
          ),
        ],
      ),
    );
  }
}

//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16.0),
//       color: const Color.fromRGBO(255, 168, 48, 100),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: <Widget>[
//           ToggleButton(isPastPage: false),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Text(
//                 'Duration',
//                 style: TextStyle(
//                   fontSize: 21,
//                   fontWeight: FontWeight.bold,
//                   letterSpacing: 2.0,
//                   fontFamily: 'Nunito',
//                 ),
//               ),
//               Text(
//                 'Pts',
//                 style: TextStyle(
//                   fontSize: 20.0,
//                   fontWeight: FontWeight.bold,
//                   letterSpacing: 2.0,
//                   fontFamily: 'Nunito',
//                 ),
//               ),
//               Text(
//                 'Challenge',
//                 style: TextStyle(
//                   fontSize: 20.0,
//                   fontWeight: FontWeight.bold,
//                   letterSpacing: 2.0,
//                   fontFamily: 'Nunito',
//                 ),
//               )
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

/*
    A custom ToggleButton Widget that returns a CupertinoSegmentedControl Button.
    This button gives the user the ability to toggle between the current and past challenges.
    The constructor initializes a boolean value (isPastPage) that determines whether or not the past 
    challenges page is being displayed. 
    
    If isPastPage is true, the past_challenges route is pushed from the Navigator and the Segmented Button color is changed.
*/
class ToggleButton extends StatelessWidget {
  final bool isPastPage;

  const ToggleButton({super.key, required this.isPastPage});

  @override
  Widget build(BuildContext context) {
    return CupertinoSegmentedControl<String>(
      padding: const EdgeInsets.all(20.0),
      borderColor: Colors.black,
      children: {
        'Past': Container(
          color: isPastPage
              ? const Color.fromRGBO(160, 197, 89, 100)
              : Colors.grey[300],
          padding: const EdgeInsets.fromLTRB(7, 5, 8, 5.5),
          child: const Text("My Challenges",
              style: TextStyle(fontFamily: 'Nunito', color: Colors.black)),
        ),
        'Current': Container(
            color: isPastPage
                ? Colors.grey[300]
                : const Color.fromRGBO(160, 197, 89, 100),
            padding: const EdgeInsets.fromLTRB(1, 5, 1.3, 5.8),
            child: const Text("New Challenges",
                style: TextStyle(fontFamily: 'Nunito', color: Colors.black))),
      },
      onValueChanged: (String value) {
        if (value == 'Past') {
          Navigator.of(context).pop();
          Navigator.pushNamed(context, 'past_challenges');
        } else {
          Navigator.of(context).pop();
          Navigator.pushNamed(context, 'challenges');
        }
      },
    );
  }
}

/* 
    The PastChallengesPage custom widget class returns a container with the widgets and assets necessary to display the user's 
    past/completed challenges, along with any badges the user has earned.
*/

class PastChallengesPage extends StatefulWidget {
  //const ChallengePage({super.key});
  PastChallengesPage({Key? key}) : super(key: key);

  @override
  State<PastChallengesPage> createState() => _PastChallengesPageState();
}

@override
class _PastChallengesPageState extends State<PastChallengesPage> {
  late Future<List<UserChallenge>> userChallenges;
  List<UserChallenge> selectedChallenges = [];
  List<CheckboxExample2> checkboxes = [];
  List<Widget> checkboxList = [];
  List<bool?> selectedCheckboxes = [];
  @override
  void initState() {
    super.initState();
    userChallenges = _getUserChallenges();
  }

  void _acceptUserChallenges(BuildContext context) async {
    print("updating user challenges");
    try {
      var list = [];
      List<UserChallenge> challengeList = await userChallenges;
      selectedChallenges =
          challengeList.where((challenge) => challenge.isSelected).toList();
      print(selectedChallenges);
      print('Selected Challenges: $selectedChallenges');
      for (UserChallenge challenge in selectedChallenges) {
        list.add(challenge.toAcceptedJson());
      }
      String jsonBody = jsonEncode(list);

      // Make a POST request with the JSON body
      var response = await http.post(
        Uri.parse("http://10.0.2.2:3000/completeChallenges"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonBody,
      );

      if (response.statusCode == 200) {
        print('Challenges accepted successfully');
        _showDialog(context, 'Success', 'Challenges accepted successfully');
      } else {
        print('Failed to accept challenges');
        _showDialog(context, 'Error', 'Failed to update challenges');
      }
    } catch (e) {
      print('Error updating challenges: $e');
      _showDialog(context, 'Error', 'Error updating challenges: $e');
    }
    /* setState(() {
       for (var challenge in selectedChallenges) {
          challenge.isSelected = false;
        }
      }); */
  }

  void _showDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<List<UserChallenge>> _getUserChallenges() async {
    print("here");
    // this is the url for using a Android emulator
    // Apple emulators use localhost like normal
    String url = 'http://10.0.2.2:3000/getCurrentUserChallenges';
    List<UserChallenge> challenges = [];

    var response = await http.get(Uri.parse(url));
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print("JSON RESPONSE");
      print(jsonResponse);
      print("JSON.RESULTS");
      print(jsonResponse['results']);

      for (var challenge in jsonResponse['results']) {
        UserChallenge thisOne = UserChallenge(
            challengeID: challenge['challengeID'],
            name: challenge['name'],
            description: challenge['description'],
            dateAccepted: challenge['dateAccepted'],
            points: challenge['points'],
            length: challenge['length']);

        /* challengeID: challenge['challengeID'],
            points: challenge['points'],
            name: challenge['name'],
            description: challenge['description'],
            length: challenge['length'],
            // getting weird error when trying to get dateAccepted...
            //dateAccepted: DateTime.parse(challenge['dateAccepted']),
            daysInProgress: challenge['daysInProgress']); */

        //dateFinished: null);
        print(thisOne);
        challenges.add(thisOne);
      }
      return challenges;
    } else {
      throw Exception("Failed to load post");
    }
  }

  /* @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(16.0),
        color: const Color.fromRGBO(124, 184, 22, 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const ToggleButton(isPastPage: true),
          ],
        ));
  }
}*/
  void addCheckbox2(CheckboxExample2 checkbox) {
    checkboxes.add(checkbox);
    selectedCheckboxes.add(false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Color.fromRGBO(124, 184, 22, 100),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ToggleButton(isPastPage: true),
          Center(
            child: Text(
              "Here is all the challenges you have currently accepted. Check them off as you complete them.",
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 300,
            child: FutureBuilder<List<UserChallenge>>(
              future: userChallenges,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<UserChallenge> challenges = snapshot.data!;

                  //    .where((challenge) =>
                  //        !selectedChallenges.contains(challenge))
                  //    .toList();
                  //List<Challenge> challengeList = snapshot.data!;
                  // change to check
                  //List<Challenge> filteredChallenges = challengeList
                  //    .where((challenge) =>
                  //        !selectedChallenges.contains(challenge))
                  //    .toList();

                  return Scrollbar(
                    trackVisibility: true,
                    showTrackOnHover: true,
                    thickness: 5,
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: challenges.length,
                      itemBuilder: (context, index) {
                        UserChallenge challenge = challenges[index];
                        CheckboxExample2 myCheck =
                            CheckboxExample2(challenge: challenge);
                        addCheckbox2(myCheck);
                        return ListTile(
                          title: Text(challenge.name),
                          subtitle:
                              Text(snapshot.data![index].points.toString()),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.info),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Challenge Description'),
                                        content: Container(
                                          width: 200,
                                          height: 200,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(snapshot
                                                  .data![index].description),

                                              //SizedBox(height: 16),
                                              //(
                                              ///   'Expires: $expirationDateText')

                                              //Text(snapshot
                                              //    .data![index].daysInProgress),
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('Close'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                              myCheck,
                            ],
                          ),
                        );
                      },
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else {
                  return Container(
                    color: const Color.fromRGBO(255, 168, 48, 100),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            ),
          ),
          SizedBox(height: 16),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: const Color.fromARGB(244, 0, 0, 0),
                backgroundColor: const Color.fromARGB(244, 244, 248, 6),
              ),
              onPressed: () {
                _acceptUserChallenges(context);
              },
              child: const Text('Update Challenge Progress'),
            ),
          ),
        ],
      ),
    );
  }
}

/* 
    The Checkbox Example class creates and returns a Checkbox Widget that is rendered on the ChallengePage.
    This checkbox can be clicked by the user changing it's state and color accordingly.
 */
class CheckboxExample extends StatefulWidget {
  final Challenge challenge;

  const CheckboxExample({required this.challenge, Key? key}) : super(key: key);

  @override
  State<CheckboxExample> createState() => _CheckboxExampleState();
}

class _CheckboxExampleState extends State<CheckboxExample> {
  late bool isChecked;

  @override
  void initState() {
    super.initState();
    isChecked = widget.challenge.isSelected;
  }

  @override
  Widget build(BuildContext context) {
    return Checkbox(
        checkColor: Colors.lightGreen,
        fillColor: MaterialStateColor.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.blue; // Color when checkbox is selected
          }
          return Colors.white; // Color when checkbox is unselected
        }),
        value: isChecked,
        onChanged: (bool? value) {
          setState(() {
            isChecked = value ?? false;
            widget.challenge.isSelected = isChecked;
          });
          print(widget.challenge.name);
          print(widget.challenge.isSelected);
        });
  }
}

class CheckboxExample2 extends StatefulWidget {
  final UserChallenge challenge;

  const CheckboxExample2({required this.challenge, Key? key}) : super(key: key);

  @override
  State<CheckboxExample2> createState() => _CheckboxExampleState2();
}

class _CheckboxExampleState2 extends State<CheckboxExample2> {
  late bool isChecked;

  @override
  void initState() {
    super.initState();
    isChecked = widget.challenge.isSelected;
  }

  @override
  Widget build(BuildContext context) {
    return Checkbox(
        checkColor: Colors.lightGreen,
        fillColor: MaterialStateColor.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.blue; // Color when checkbox is selected
          }
          return Colors.white; // Color when checkbox is unselected
        }),
        value: isChecked,
        onChanged: (bool? value) {
          setState(() {
            isChecked = value ?? false;
            widget.challenge.isSelected = isChecked;
          });
          print(widget.challenge.name);
          print(widget.challenge.isSelected);
        });
  }
}

/* 
    The ChallengesTable Widget class returns a Table Widget to the application's Challenges Page. 
    This table has 5 columns and lists the current challenges that the user can attempt alongside the number of points
    the challenge is worth. 
*/
/* class ChallengesTable extends StatelessWidget {
  const ChallengesTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Table(
        border: const TableBorder(
            horizontalInside: BorderSide(
                width: 1, color: Colors.blue, style: BorderStyle.solid)),
        columnWidths: const <int, TableColumnWidth>{
          0: FixedColumnWidth(45),
          1: FixedColumnWidth(95),
          2: FixedColumnWidth(95),
          3: FixedColumnWidth(95),
          4: FixedColumnWidth(90),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: const <TableRow>[
          TableRow(
            children: <Widget>[
              TableCell(
                child: CheckboxExample(),
              ),
              TableCell(
                child: Center(child: Text('1 day')),
              ),
              TableCell(
                child: Center(child: Text('30')),
              ),
              TableCell(
                child: Center(child: Text('Make an eco-brick')),
              ),
              TableCell(
                  child: IconButton(
                icon: Icon(Icons.info),
                color: Colors.grey,
                onPressed: null,
              )),
            ],
          ),
          TableRow(
            children: <Widget>[
              TableCell(
                child: CheckboxExample(),
              ),
              TableCell(
                child: Center(child: Text('1 week')),
              ),
              TableCell(
                child: Center(child: Text('100')),
              ),
              TableCell(
                child: Center(child: Text('Bike to the store')),
              ),
              TableCell(
                  child: IconButton(
                icon: Icon(Icons.info),
                color: Colors.grey,
                onPressed: null,
              )),
            ],
          ),
          TableRow(
            children: <Widget>[
              TableCell(
                child: CheckboxExample(),
              ),
              TableCell(
                child: Center(child: Text('1 day')),
              ),
              TableCell(
                child: Center(child: Text('20')),
              ),
              TableCell(
                child: Center(child: Text('Meatless Monday')),
              ),
              TableCell(
                  child: IconButton(
                icon: Icon(Icons.info),
                color: Colors.grey,
                onPressed: null,
              )),
            ],
          ),
          TableRow(
            children: <Widget>[
              TableCell(
                child: CheckboxExample(),
              ),
              TableCell(
                child: Center(child: Text('2 weeks')),
              ),
              TableCell(
                child: Center(child: Text('150')),
              ),
              TableCell(
                child: Center(child: Text('Use reusable coffee')),
              ),
              TableCell(
                  child: IconButton(
                icon: Icon(Icons.info),
                color: Colors.grey,
                onPressed: null,
              )),
            ],
          ),
          TableRow(
            children: <Widget>[
              TableCell(
                child: CheckboxExample(),
              ),
              TableCell(
                child: Center(child: Text('1 week')),
              ),
              TableCell(
                child: Center(child: Text('50')),
              ),
              TableCell(
                child: Center(child: Text('Drive Track Streak')),
              ),
              TableCell(
                  child: IconButton(
                icon: Icon(Icons.info),
                color: Colors.grey,
                onPressed: null,
              )),
            ],
          ),
        ]);
  }
} */
