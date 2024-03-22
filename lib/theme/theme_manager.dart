import 'package:flutter/material.dart';
import 'package:emission/theme/theme_data.dart';


class ThemeManager with ChangeNotifier{
  // class properties values
  ThemeData _themeData = lightMode;
  bool _isDarkMode = false;

  // getters for themeData and the current Theme
  ThemeData get themeData => _themeData;
  ThemeData get currentTheme => _isDarkMode ? darkMode : lightMode;

  bool get isDark => _isDarkMode;


  // A setter for the themeData variable
  set themeData(ThemeData themeData){
    _themeData = themeData;
    notifyListeners();
  }

  // void method that toggles the theme between light and dark
  void toggleTheme(){
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}