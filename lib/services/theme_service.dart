import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService extends ChangeNotifier {
  final SharedPreferences sharedPreferences;
  bool _darkTheme = true;

  bool get darkTheme {
    return sharedPreferences.getBool('darkTheme') ?? _darkTheme;
  }

  set darkTheme(bool value) {
    _darkTheme = value;
    sharedPreferences.setBool(darkThemeKey, value);
    notifyListeners();
  }

  ThemeService(this.sharedPreferences);

  static const darkThemeKey = 'dark_theme';
}
