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
      endDrawer: Drawer(
        backgroundColor: Colors.black,
        child: ListView(
          padding: EdgeInsets.zero,
          children: const [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: Text('Item 1'),
              textColor: Colors.yellow,
            ),
          ]
        )
      ),
      floatingActionButton: const FloatingActionButton(
        shape: CircleBorder(),
        splashColor: Colors.white,
        backgroundColor: Colors.orangeAccent,
        foregroundColor: Color.fromARGB(255, 98, 91, 91),
        onPressed: null,
        child: Icon(Icons.directions_car),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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