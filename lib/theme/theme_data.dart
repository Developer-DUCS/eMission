//
import 'dart:ui';
import 'package:flutter/material.dart';


ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
    primary: const Color.fromRGBO(122, 194, 0, 1), // Light Green
    secondary: const Color.fromRGBO(199, 113, 53, 1), // Orangish Red
    tertiary: const Color.fromRGBO(244, 248, 6, 1), // Yellow
    background: const Color.fromRGBO(251, 251, 251, 1), // White background
    onBackground: const Color.fromRGBO(28, 28, 28, 1), // Black text on white background
  ),
  /**-------------------------------Input Text From Theme --------------------------------------*/
  inputDecorationTheme: InputDecorationTheme(
    fillColor: Colors.white,
    filled: true,
    focusColor: Colors.blueAccent,
    labelStyle: TextStyle(
      color: Colors.black,
    ),
    floatingLabelStyle: TextStyle(
      color: Colors.green
    ), 
  ),
);

ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme.dark(
    primary: const Color.fromRGBO(53, 102, 0, 1), // Dark Green
    secondary: const Color.fromRGBO(0, 102, 204, 1), // Blue
    tertiary: const Color.fromRGBO(207, 166, 42, 1), // Muted Yellow
    background: const Color.fromRGBO(28, 28, 28, 11), // Dark background  Color.fromRGBO(34, 42, 27, 1)
    onBackground: const Color.fromRGBO(251, 251, 251, 1), // White text on dark background
  ),
  /**-------------------------------Input Text From Theme --------------------------------------*/
  inputDecorationTheme: InputDecorationTheme(
    fillColor: Colors.white,
    filled: true,
    focusColor: Colors.blueAccent,
    labelStyle: TextStyle(
      color: Colors.black,
    ),
    floatingLabelStyle: TextStyle(
      color: Colors.green
    ),
  ),
);
