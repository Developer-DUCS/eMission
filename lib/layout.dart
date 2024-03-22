import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:emission/theme/theme_manager.dart';
import 'package:provider/provider.dart';


class Layout extends StatelessWidget {
  final Widget body;
  final bool appBar;
  final bool driveButton;
  final bool bottomBar;
  final int? pageIndex;

  static const List<String> pages = ['leaderboard', 'home', 'settings'];

  const Layout({
    super.key,
    required this.body,
    this.appBar = true,
    this.bottomBar = true,
    this.pageIndex,
    this.driveButton = true,
  });
  void navigateToButtonPage(BuildContext context) {
    Navigator.pushNamed(context, 'button-page');
  }

  Future<void> clearUserPref() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
    print(pref.getInt("userID"));
    print(pref.getString("displayName"));
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);

    return Scaffold(
      appBar: appBar
          ? AppBar(
              title: const Text('eMission'),
              automaticallyImplyLeading: false,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1.0),
                child: Container(
                  height: 1.0,
                  color: Colors.grey.withOpacity(0.5),
                ),
              ),
            )
          : null,
      endDrawer: Drawer(
          child: ListView(padding: EdgeInsets.zero, children: [
            DrawerHeader(
              decoration: BoxDecoration(
              color: themeManager.currentTheme.colorScheme.secondary,
              ),
              child: Text(
                'eMission',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  fontFamily: 'Nunito',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(8, 2.5, 4, 2.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Dark Mode",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                      fontFamily: 'Nunito',
                    ),
                  ),
                  CupertinoSwitch(
                    // This bool value toggles the switch.
                    value: themeManager.isDark,
                    activeColor: CupertinoColors.activeBlue,
                    onChanged: (value) {
                      // This is called when the user toggles the switch.
                      themeManager.toggleTheme();
                    },
                  ),
                  //switch
                ],
              ),
            ),
            ListTile(
              title: const Text('Manual Drive Input'),
              textColor: themeManager.currentTheme.colorScheme.onBackground,
              hoverColor: Colors.amber,
              onTap: () {
                Navigator.pushNamed(context, 'manual_input');
              }, // will link to manual drive input page when it is completed
            ),
            ListTile(
              title: const Text('eFriendly Challenges'),
              textColor: themeManager.currentTheme.colorScheme.onBackground,
              onTap: () {
                Navigator.pushNamed(context, 'challenges');
              },
            ),
            // taking out since not functioning
            /* ListTile(
              title: Text('Challenge Groups'),
              textColor: Colors.black,
              onTap:
                  null, // will link to Challenge Groups Page when it is completed
            ), */
            ListTile(
              title: const Text('Vehicles'),
              textColor: themeManager.currentTheme.colorScheme.onBackground,
              onTap: () {
                Navigator.pushNamed(context, 'vehicles');
              },
            ),
            ListTile(
              title: const Text('Reports'),
              textColor: themeManager.currentTheme.colorScheme.onBackground,
              onTap: () {
                Navigator.pushNamed(context, 'carbon_report');
              },
            ),
            ListTile(
              title: const Text('Logout'),
              textColor: themeManager.currentTheme.colorScheme.onBackground,
              onTap: () {
                Navigator.pushNamed(context, 'login');
                clearUserPref();
              }, // will link to login page
            ),
          ]
        )
      ),
      floatingActionButton: driveButton
          ? FloatingActionButton(
            shape: const CircleBorder(),
              onPressed: () {
                Navigator.pushNamed(context, 'button-page');
              },
              child: const Icon(Icons.directions_car),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: body,
      bottomNavigationBar: bottomBar
        ? Container(
          decoration: BoxDecoration (
            color: Colors.grey.withOpacity(0.5),
            border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1.0))),
        child: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 5.0,
          onTap: (index) => {Navigator.pushNamed(context, pages[index])},
          currentIndex: pageIndex ?? 0, 
          items: [
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                    './assets/images/leaderboard-outline.svg',
                    width: 26,
                    height: 26,
                    color: themeManager.isDark 
                      ? Color.fromRGBO(166, 164, 165, 1) 
                      : Color.fromRGBO(115, 114, 115, 1)),
                activeIcon: SvgPicture.asset(
                    './assets/images/leaderboard-outline.svg',
                    width: 26,
                    height: 26,
                    color: pageIndex != null
                        ? Colors.green
                        : themeManager.isDark ? Color.fromRGBO(166, 164, 165, 1) : Color.fromRGBO(115, 114, 115, 1) ),
                label: ''),
            const BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined), label: ''),
            const BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined), label: ''),
            ]
          )
        ) 
      : null,
    );
  }
}
