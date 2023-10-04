//
import 'package:first_flutter_app/layout.dart';
import 'package:first_flutter_app/login.dart';
import 'package:first_flutter_app/challenge_page.dart';
//import 'package:mysql1/mysql1.dart';
import 'settings.dart';
import 'home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'drive-button.dart';
import 'sql-db.dart';
//import 'package:mysql1/mysql1.dart';
import 'models/note.dart';
import 'db/notes_database.dart';

//
Future<void> main() async {
  // Test the MySQL database connection
  await testMySQLConnection();

  // Run the Flutter app
  runApp(const MyApp());
}


Future<void> testMySQLConnection() async {
  //testMySQLConnect();
  print("Testing my connection");
  var notes = await NotesDatabase.instance.readAllNotes();
  print(notes.length);
}
/* */
class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'eMission',
      initialRoute: 'login',
      routes: {
        'login': (context) =>
            const Layout(body: Login(), appBar: false, bottomBar: false),
        'home': (context) => const Layout(
              body: Home(),
              pageIndex: 1,
            ),
        'leaderboard': (context) => const Layout(
              body: Settings(),
              pageIndex: 0,
            ),
        'settings': (context) => const Layout(
              body: Settings(),
              pageIndex: 2,
            ),
        'button-page': (context) =>
            const Layout(body: ButtonPage(), pageIndex: 0, appBar: false),
        'challenges': (context) => const Layout(
              body: ChallengePage(),
              pageIndex: 1,
            ),
        'past_challenges': (context) => const Layout(
              body: PastChallengesPage(),
              pageIndex: 1,
            )
      },
    );
  }
}
