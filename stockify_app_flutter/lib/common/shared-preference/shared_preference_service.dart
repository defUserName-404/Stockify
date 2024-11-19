import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService extends ChangeNotifier {
  late SharedPreferences _prefs;
  bool _isDarkMode = false;
  double _railWidth = 72.0;

  bool get isDarkMode => _isDarkMode;

  double get railWidth => _railWidth;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _isDarkMode = _prefs.getBool('isDarkMode') ?? false;
    _railWidth = _prefs.getDouble('railWidth') ?? 72.0;
    notifyListeners();
  }

  void toggleDarkMode(bool value) async {
    _isDarkMode = value;
    await _prefs.setBool('isDarkMode', value);
    notifyListeners();
  }

  void setRailWidth(double value) async {
    _railWidth = value;
    await _prefs.setDouble('railWidth', value);
    notifyListeners();
  }
}
