import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stockify_app_flutter/common/shared-preference/shared_preferences_service.dart';

import '../theme.dart';

class ThemeController extends ChangeNotifier {
  ThemeData _themeData = AppTheme.light;
  SharedPreferences? _prefs;

  ThemeData get themeData => _themeData;

  ThemeController();

  void _loadTheme() {
    bool isDarkMode = _prefs?.getBool('isDarkMode') ?? false;
    _themeData = isDarkMode ? AppTheme.dark : AppTheme.light;
    notifyListeners();
  }

  void setThemeData(ThemeData themeData) {
    _themeData = themeData;
    _prefs?.setBool('isDarkMode', themeData == AppTheme.dark);
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == AppTheme.light) {
      setThemeData(AppTheme.dark);
    } else {
      setThemeData(AppTheme.light);
    }
  }

  void update(SharedPreferencesService sharedPreferencesService) {
    _prefs = sharedPreferencesService.prefs;
    _loadTheme();
  }
}
