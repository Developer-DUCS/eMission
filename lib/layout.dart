import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Layout extends StatelessWidget {
  final Widget body;
  final bool appBar;
  final bool bottomBar;
  final int pageIndex;

  static const List<String> pages = ['leaderboard', 'home', 'settings'];

  const Layout({super.key, required this.body, this.appBar = true, this.bottomBar = true, this.pageIndex = 1});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar ? AppBar(title: const Text('eMission'), backgroundColor: Colors.white, foregroundColor: Colors.black54,) : null,
      body: body,
      bottomNavigationBar: bottomBar ? BottomNavigationBar(
        onTap: (index) => { Navigator.pushNamed(context, pages[index])},
        currentIndex: pageIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.green,
        items: [
          BottomNavigationBarItem(icon: SvgPicture.asset('./assets/images/leaderboard-outline.svg', color: Colors.black54), activeIcon: SvgPicture.asset('./assets/images/leaderboard-outline.svg', color: Colors.green), label: ''),
          const BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ''),
          const BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: '')
        ]
      ) : null,
    );
  }
}