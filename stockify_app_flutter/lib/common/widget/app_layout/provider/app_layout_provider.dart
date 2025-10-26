import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stockify_app_flutter/common/shared-preference/shared_preferences_service.dart';
import 'package:stockify_app_flutter/feature/dashboard/screen/dashboard_screen.dart';
import 'package:stockify_app_flutter/feature/item/model/item_filter_param.dart';
import 'package:stockify_app_flutter/feature/item/screen/item_screen.dart';
import 'package:stockify_app_flutter/feature/notification/screen/notification_screen.dart';
import 'package:stockify_app_flutter/feature/settings/screen/settings_screen.dart';
import 'package:stockify_app_flutter/feature/user/screen/user_screen.dart';

class AppLayoutProvider extends ChangeNotifier {
  int _selectedIndex = 0;
  ItemFilterParams? _currentFilterParams;
  bool _openAddItemPanel = false;
  late double _railWidth;
  bool _isExtended = false;
  bool _showLabels = false;

  final double _minRailWidth = 80;
  final double _maxRailWidth = 250;
  final double _minRailLabelThreshold = 150;
  final SharedPreferences _prefs;

  int get selectedIndex => _selectedIndex;

  ItemFilterParams? get currentFilterParams => _currentFilterParams;

  bool get openAddItemPanel => _openAddItemPanel;

  double get railWidth => _railWidth;

  bool get isExtended => _isExtended;

  bool get showLabels => _showLabels;

  double get minRailWidth => _minRailWidth;

  double get maxRailWidth => _maxRailWidth;

  AppLayoutProvider(SharedPreferencesService sharedPreferencesService)
      : _prefs = sharedPreferencesService.prefs {
    _railWidth = _prefs.getDouble('railWidth') ?? _minRailWidth;
    _isExtended = _railWidth > _minRailWidth;
    _showLabels = _railWidth > _minRailLabelThreshold;
  }

  void updateSelectedScreen(int index,
      {ItemFilterParams? itemFilterParams, bool openAddItemPanel = false}) {
    _selectedIndex = index;
    _currentFilterParams = index == 1 ? itemFilterParams : null;
    _openAddItemPanel = openAddItemPanel;
    notifyListeners();
  }

  void updateRailWidth(double newWidth) {
    _railWidth = newWidth.clamp(_minRailWidth, _maxRailWidth);
    _showLabels = _railWidth > _minRailLabelThreshold;
    _isExtended = _railWidth > _minRailWidth;
    _prefs.setDouble('railWidth', _railWidth);
    notifyListeners();
  }

  Widget getSelectedScreen() {
    switch (_selectedIndex) {
      case 0:
        return const DashboardScreen();
      case 1:
        return ItemScreen(
          filterParams: _currentFilterParams,
          openAddItemPanel: _openAddItemPanel,
        );
      case 2:
        return UserScreen();
      case 3:
        return const NotificationScreen();
      case 4:
        return const SettingsScreen();
      default:
        return const Center(child: Text('Page not found'));
    }
  }
}
