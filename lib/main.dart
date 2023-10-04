//
import 'package:first_flutter_app/layout.dart';
import 'package:first_flutter_app/login.dart';
import 'package:first_flutter_app/challenge_page.dart';
import 'settings.dart';
import 'home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'drive-button.dart';
import 'manual.dart';

//
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
        'login': (context) => const Layout(body: Login(), appBar: false, bottomBar: false),
        'home': (context) => const Layout(body: Home(), pageIndex: 1,),
        'leaderboard': (context) => const Layout(body: Settings(), pageIndex: 0,),
        'settings': (context) => const Layout(body: Settings(), pageIndex: 2,),
        'button-page': (context) => const Layout(body: ButtonPage(),pageIndex:0,appBar: false),
        'challenges': (context) => const Layout(body: ChallengePage(), pageIndex: 1,),
        'past_challenges': (context) => const Layout(body: PastChallengesPage(), pageIndex: 1,),
        'manual': (context) => const Layout(body: Manual(), pageIndex: 1)
      },
    );
  }
}
