import 'package:flutter/material.dart';

import '../theme.dart';

class ThemeController extends ChangeNotifier {
  ThemeData _themeData = AppTheme.light;

  ThemeData get themeData => _themeData;

  void setThemeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }
}
