///
/// challenge_page.dart
/// Initializes ChallengePage and PastChallengesPage classes for eMision Application.
///
///
/// Created: Chris Warren
/// Edited: Jali Purcell

// import statements

import 'api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    };
  }
}

Future<List<Challenge>> _getChallenges() async {
  var userID = await getUserID();
  List<Challenge> challenges = [];

  var response = await ApiService().post("getChallenges2", {"userID": userID});

  for (var challenge in response.data['results']) {
    Challenge thisOne = Challenge(
        challengeID: challenge['challengeID'],
        name: challenge['name'],
        points: challenge['points'],
        description: challenge['description'],
        length: challenge['length'],
        expirationDate: null);
    challenges.add(thisOne);
  }
  return challenges;
}

Future<dynamic> getUserID() async {
  final SharedPreferences pref = await SharedPreferences.getInstance();
  print(pref.getInt("userID"));
  print("^ Pref");
  pref.getInt("userID");
  print(pref.getInt("userID"));
  return pref.getInt("userID");
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
    getUserID();
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
    var userID = await getUserID();
    var list = [];
    List<Challenge> challengeList = await challenges;
    selectedChallenges =
        challengeList.where((challenge) => challenge.isSelected).toList();

    if (selectedChallenges.isNotEmpty) {
      for (Challenge challenge in selectedChallenges) {
        list.add(challenge.toJson());
      }

      var requestBody = {
        "UserID": userID,
        "challenges": list,
      };

      var response = await ApiService()
          .post<List<dynamic>>("acceptNewChallenges", requestBody);

      List<String> challengeSummaries = [];

      for (var message in response.data) {
        var name = message['challengeData']['name'];
        var dateFinished = message['challengeData']['dateFinished'];
        var status = "accepted";

        if (name == null) {
          name = "";
        }

        if (dateFinished != null) {
          status = "You have already completed that challenge.";
        }
        challengeSummaries.add('${name}  ${status}');
      }
      _showDialog(context, "Update", challengeSummaries.join('\n'));
    } else {
      _showDialog(
          context, "Update", "Please select challenges to accept them.");
    }
  }

  /* Future<void> _loadChallenges() async {
    Future<List<Challenge>> challenges = await _getChallenges();
    setState(() {
      _challenges = challenges;
    });
  } */

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: const Color.fromRGBO(255, 168, 48, 100),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ToggleButton(isPastPage: false),
          Center(
            child: Text(
              "Select the challenges you'd like to try.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
          ),
          SizedBox(
            height: screenHeight * .5,
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
                    child: Container(
                      color: const Color.fromRGBO(160, 197, 89, 100),
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
                            focusColor: Colors.white,
                            title: Text(challenge.name),
                            subtitle:
                                Text("Points: ${snapshot.data![index].points}"),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.info),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        var expirationDate = snapshot
                                            .data![index].expirationDate;
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
                                                    'Points for completing challenge: ${snapshot.data![index].points}'),
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

  const ToggleButton({Key? key, required this.isPastPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    double paddingFactor = screenWidth * .07;
    double fontSizeFactor = screenWidth * .04;

    return CupertinoSegmentedControl<String>(
      padding: EdgeInsets.all(paddingFactor),
      borderColor: Colors.black,
      children: {
        'Past': Container(
          color: isPastPage
              ? const Color.fromRGBO(160, 197, 89, 100)
              : Colors.grey[300],
          padding: EdgeInsets.fromLTRB(7, 5, 8, 5.5),
          child: Text(
            "My Challenges",
            style: TextStyle(
              fontFamily: 'Nunito',
              color: Colors.black,
              fontSize: fontSizeFactor,
            ),
          ),
        ),
        'Current': Container(
          color: isPastPage
              ? Colors.grey[300]
              : const Color.fromRGBO(160, 197, 89, 100),
          padding: EdgeInsets.fromLTRB(1, 5, 1.3, 5.8),
          child: Text(
            "New Challenges",
            style: TextStyle(
              fontFamily: 'Nunito',
              color: Colors.black,
              fontSize: fontSizeFactor,
            ),
          ),
        ),
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
      var userID = await getUserID();
      var list = [];
      List<UserChallenge> challengeList = await userChallenges;
      selectedChallenges =
          challengeList.where((challenge) => challenge.isSelected).toList();
      if (selectedChallenges.isNotEmpty) {
        for (UserChallenge challenge in selectedChallenges) {
          list.add(challenge.toAcceptedJson());
        }

        // Make a POST request with the JSON body
        ApiService().post("completeChallenges",
            {"UserID": userID, "challenges": list}).then((response) {
          print('Challenges completed successfully');
          _showDialog(context, 'Success', 'Challenges completed successfully');
        });
      } else {
        _showDialog(
            context, 'Update', 'Please select challenges to complete them.');
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

// User Challenge - a challenge in acceptedChallenges
// short for user Accepted Challege
  Future<List<UserChallenge>> _getUserChallenges() async {
    print("here");
    var userID = await getUserID();
    print(userID);
    List<UserChallenge> challenges = [];

    var response = await ApiService().post(
      'getCurrentUserChallenges',
      {'earnerID': userID.toString()},
    );

    for (var challenge in response.data['results']) {
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
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Color.fromRGBO(124, 184, 22, 100),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ToggleButton(isPastPage: true),
          Center(
            child: Text(
              "Your Current Challenges: ",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
          ),
          SizedBox(
            height: screenHeight * .5,
            child: FutureBuilder<List<UserChallenge>>(
              future: userChallenges,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<UserChallenge> challenges = snapshot.data!;
                  return Container(
                    padding: EdgeInsets.fromLTRB(7, 5, 8, 5.5),
                    color: Colors.grey[300],
                    child: Scrollbar(
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
                                Text("Points: ${snapshot.data![index].points}"),
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
