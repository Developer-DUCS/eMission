//
import 'dart:ui';
import 'package:flutter/material.dart';



/* Color Scheme stylesheet for light mode. Includes primary colors & style info
 * for application widgets and features. 
*/
ThemeData lightMode = ThemeData(

  //
  // Color Scheme (light mode)
  //
  colorScheme: ColorScheme.light(
    primary: const Color.fromRGBO(0, 180, 92, 1),
    secondary: const Color.fromRGBO(232, 140, 140, 1),
    tertiary: const Color.fromRGBO(223, 194, 146, 1),
    background: const Color.fromRGBO(255, 255, 255, 1), 
    onBackground: const Color.fromRGBO(22, 25, 21, 1),
    primaryContainer: const Color.fromRGBO(238, 230, 231, 0.877),
  ),


  //
  // App Bar Theme
  // 
  appBarTheme: AppBarTheme(
    backgroundColor: const Color.fromRGBO(251, 251, 251, 1),
    foregroundColor: const Color.fromRGBO(22, 25, 21, 1),
  ),


  //
  // Bottom Nav Bar Theme
  // 
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: const Color.fromRGBO(0, 180, 92, 1),
    backgroundColor: const Color.fromRGBO(251, 251, 251, 1),
  ),

  //
  // Input Decoration Theme 
  //
  inputDecorationTheme: InputDecorationTheme(
    fillColor: const Color.fromRGBO(251, 251, 251, 1),
    filled: true,
    focusColor: Colors.blueAccent,
    // text style for input label
    labelStyle: TextStyle(
      color: const Color.fromRGBO(22, 25, 21, 1),
    ),
    // text style for floating label
    floatingLabelStyle: TextStyle(
      color: const Color.fromRGBO(0, 180, 92, 1),
    ), 
  ),

  //
  // Floating Action Button Theme
  //
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: const Color.fromRGBO(232, 140, 140, 1),
    foregroundColor: const  Color.fromRGBO(251, 251, 251, 1),
    splashColor: const Color.fromRGBO(251, 251, 251, 1),
  ),


  //
  // Drawer Theme
  //
  drawerTheme: DrawerThemeData(
    backgroundColor: const Color.fromRGBO(251, 251, 251, 1),
  ),

  //
  // Divider Theme
  //
  dividerTheme: DividerThemeData(
    color: const Color.fromRGBO(223, 194, 146, 1),
  ),


);





/* Color Scheme stylesheet for dark mode. Includes primary colors & style info
 * for application widgets and features. 
*/

ThemeData darkMode = ThemeData(
  
  //
  //Color Scheme (dark mode)
  //
  colorScheme: ColorScheme.dark(
    primary: const Color.fromRGBO(0, 180, 92, 1),
    secondary:const Color.fromRGBO(4, 156, 156, 1),
    tertiary:  const Color.fromRGBO(148, 129, 97, 1), // const Color.fromRGBO(223, 194, 146, 1), //
    background: const Color.fromRGBO(22, 25, 21, 1),  
    onBackground: const Color.fromRGBO(208, 206, 204, 1),
    primaryContainer: const Color.fromRGBO(22, 25, 21, 1), 

  ),

  //
  // App Bar Theme
  //
  appBarTheme: AppBarTheme(
    backgroundColor: const Color.fromRGBO(22, 25, 21, 1),
    foregroundColor: const Color.fromRGBO(251, 251, 251, 1),
  ),


  //
  // Bottom Nav Bar Theme
  // 
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: const Color.fromRGBO(0, 180, 92, 1),
    backgroundColor: const Color.fromRGBO(22, 25, 21, 1),
  ),


  //
  // Input Decoration Theme
  //
  inputDecorationTheme: InputDecorationTheme(
    fillColor: const Color.fromRGBO(251, 251, 251, 1),
    filled: true,
    focusColor: Colors.blueAccent,
    // text style for input label
    labelStyle: TextStyle(
      color: const Color.fromRGBO(22, 25, 21, 1),
    ),
    // text style for floating label
    floatingLabelStyle: TextStyle(
      color: const Color.fromRGBO(0, 180, 92, 1),
    ),

  ),
  
  //
  // Floating Action Button Theme
  //
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Color.fromRGBO(0, 128, 128, 1),
    foregroundColor: const Color.fromRGBO(251, 251, 251, 1),
    splashColor: const Color.fromRGBO(251, 251, 251, 1),
  ),

  //
  // Drawer Theme
  //
  drawerTheme: DrawerThemeData(
  backgroundColor: const Color.fromRGBO(22, 25, 21, 1),

  ),

  //
  // Divider Theme
  //
  dividerTheme: DividerThemeData(
    color: const Color.fromRGBO(208, 206, 204, 1),
  ),

);
