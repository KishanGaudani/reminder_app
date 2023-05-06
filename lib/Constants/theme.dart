// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ModelTheme extends ChangeNotifier {
  late bool _isDark;
  late MyThemePreferences _preferences;
  bool get isDark => _isDark;

  ModelTheme() {
    _isDark = false;
    _preferences = MyThemePreferences();
    getPreferences();
  }
  set isDark(bool value) {
    _isDark = value;
    _preferences.setTheme(value);
    notifyListeners();
  }

  getPreferences() async {
    _isDark = await _preferences.getTheme();
    notifyListeners();
  }
}

class MyThemePreferences {
  static const THEME = 'theme';

  setTheme(bool value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(THEME, value) ?? false;
  }

  getTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(THEME) ?? false;
  }
}