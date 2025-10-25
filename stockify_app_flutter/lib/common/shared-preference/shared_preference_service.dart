import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stockify_app_flutter/feature/item/model/item_view_type.dart';

class SharedPrefsService extends ChangeNotifier {
  late SharedPreferences _prefs;
  bool _isDarkMode = false;
  double _railWidth = 72.0;
  ItemViewType _itemViewType = ItemViewType.table;

  bool get isDarkMode => _isDarkMode;

  double get railWidth => _railWidth;

  ItemViewType get itemViewType => _itemViewType;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _isDarkMode = _prefs.getBool('isDarkMode') ?? false;
    _railWidth = _prefs.getDouble('railWidth') ?? 72.0;
    _itemViewType = ItemViewType.values.firstWhere(
      (e) => e.toString() == _prefs.getString('itemViewType'),
      orElse: () => ItemViewType.table,
    );
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

  void setItemViewType(ItemViewType value) async {
    _itemViewType = value;
    await _prefs.setString('itemViewType', value.toString());
    notifyListeners();
  }
}
