import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Layout extends StatelessWidget {
  final Widget body;
  final bool appBar;
  final bool driveButton;
  final bool bottomBar;
  final int pageIndex;

  static const List<String> pages = ['leaderboard', 'home', 'settings'];

  const Layout({super.key, required this.body, this.appBar = true, this.bottomBar = true, this.pageIndex = 1, this.driveButton = true,});
  void navigateToButtonPage(BuildContext context){
    Navigator.pushNamed(context, 'button-page');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar ? AppBar(title: const Text('eMission'), backgroundColor: Colors.white, foregroundColor: Colors.black54,) : null,
      endDrawer: Drawer(
        backgroundColor: const Color.fromRGBO(255, 255, 255, 100),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Text('eMission', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2.0, fontFamily: 'Nunito',),),
            ),
            ListTile(
              title: const Text('Manual Drive Input'),
              textColor: Colors.black,
              hoverColor: Colors.amber,
              onTap: null, // will link to manual drive input page when it is completed
            ),
            ListTile(
              title: const Text('eFriendly Challenges'),
              textColor: Colors.black,
              onTap: () { Navigator.pushNamed(context,'challenges'); },
            ),
            ListTile(
              title: Text('Challenge Groups'),
              textColor: Colors.black,
              onTap: null, // will link to Challenge Groups Page when it is completed
            ),
            ListTile(
              title: const Text('Reports'),
              textColor: Colors.black,
              onTap: () {Navigator.pushNamed(context, 'carbon_report');},
            ),
            ListTile(
              title: const Text('Logout'),
              textColor: Colors.black,
              onTap: () { Navigator.pushNamed(context,'login'); }, // will link to login page 
            ),
          ]
        )
      ),
      floatingActionButton :  driveButton ? FloatingActionButton(
          backgroundColor: Colors.orangeAccent,
          foregroundColor: const Color.fromARGB(255, 98, 91, 91),
          shape: const CircleBorder(),
          splashColor: Colors.white,
          onPressed: () { Navigator.pushNamed(context,'button-page'); },
          child: const Icon(Icons.directions_car),

      ): null,
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