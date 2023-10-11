//
import 'package:flutter/material.dart';
import 'package:first_flutter_app/layout.dart';
import 'package:first_flutter_app/login.dart';
import 'package:first_flutter_app/challenge_page.dart';
import 'package:first_flutter_app/carbon_report.dart';
import 'package:first_flutter_app/settings.dart';
import 'package:first_flutter_app/home.dart';
import 'package:first_flutter_app/drive-button.dart';
import 'package:first_flutter_app/manual.dart';

void main() => runApp(const MyApp());

/* */
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'eMission',
      initialRoute: 'login',
      routes: {
        'login': (context) => const Layout(
              body: Login(),
              appBar: false,
              bottomBar: false,
              driveButton: false,
            ),
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
              driveButton: false,
            ),
        'button-page': (context) => const Layout(
              body: ButtonPage(),
              appBar: false,
              driveButton: false,
            ),
        'challenges': (context) => const Layout(
              body: ChallengePage(),
            ),
        'past_challenges': (context) => const Layout(
              body: PastChallengesPage(),
            ),
        'carbon_report': (context) => const Layout(
              body: CarbonReportPage(),
            ),
        'manual_input': (context) => const Layout(
          body: Manual(),
        )
      },
    );
  }
}
