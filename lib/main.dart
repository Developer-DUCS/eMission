//
import 'dart:io';

import 'package:emission/vehicles.dart';
import 'package:flutter/material.dart';
import 'package:emission/layout.dart';
import 'package:emission/login.dart';
import 'package:emission/create-account.dart';
import 'package:emission/challenge_page.dart';
import 'package:emission/carbon_report.dart';
import 'package:emission/settings.dart';
import 'package:emission/home.dart';
import 'package:emission/drive-button.dart';
import 'package:emission/manual.dart';
import 'package:emission/leaderboard.dart';

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

/* */
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'eMission',
      initialRoute: 'create-account',
      routes: {
        'create-account': (context) => const Layout(
              body: CreateAccount(),
              appBar: false,
              bottomBar: false,
              driveButton: false,
            ),
        'login': (context) => const Layout(
              body: Login(),
              appBar: false,
              bottomBar: false,
              driveButton: false,
            ),
        'home': (context) => Layout(
              body: Home(),
              pageIndex: 1,
            ),
        'leaderboard': (context) =>
            const Layout(body: Leaderboard(), pageIndex: 0, driveButton: false),
        'settings': (context) => const Layout(
              body: Settings(),
              pageIndex: 2,
              driveButton: false,
            ),
        'button-page': (context) => const Layout(
              body: ButtonPage(),
              appBar: true,
              driveButton: false,
            ),
        'challenges': (context) => Layout(
              body: ChallengePage(),
            ),
        'past_challenges': (context) => Layout(
              body: PastChallengesPage(),
            ),
        'carbon_report': (context) => Layout(
              body: CarbonReportPage(),
            ),
        'manual_input': (context) => const Layout(
              body: Manual(),
            ),
        'vehicles': (context) => const Layout(
              body: Vehicles(),
            ),
      },
    );
  }
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}