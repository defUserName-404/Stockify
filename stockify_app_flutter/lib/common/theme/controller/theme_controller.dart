import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme.dart';

class ThemeController extends ChangeNotifier {
  ThemeData _themeData = AppTheme.light;

  ThemeData get themeData => _themeData;

  ThemeController() {
    _loadTheme();
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    bool isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _themeData = isDarkMode ? AppTheme.dark : AppTheme.light;
    notifyListeners();
  }

  void setThemeData(ThemeData themeData) async {
    _themeData = themeData;
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', themeData == AppTheme.dark);
    notifyListeners();
  }
}
