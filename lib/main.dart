//
import 'package:first_flutter_app/layout.dart';
import 'package:first_flutter_app/login.dart';
import 'settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'drive-button.dart';

//
void main() => runApp(const MyApp());

/* */
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'eMission',
      initialRoute: 'home',
      routes: {
        'login': (context) =>
            const Layout(body: Login(), appBar: false, bottomBar: false),
        'home': (context) => const Layout(
              body: Settings(),
              pageIndex: 1,
            ),
        'leaderboard': (context) => const Layout(
              body: Settings(),
              pageIndex: 0,
            ),
        'settings': (context) => const Layout(
              body: Settings(),
              pageIndex: 2,
            )
      },
    );
  }
}
