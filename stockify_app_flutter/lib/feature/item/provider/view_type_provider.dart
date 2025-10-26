import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stockify_app_flutter/common/shared-preference/shared_preferences_service.dart';
import 'package:stockify_app_flutter/feature/item/model/item_view_type.dart';

class ViewTypeProvider extends ChangeNotifier {
  late ItemViewType _viewType;
  final SharedPreferences _prefs;

  ViewTypeProvider(SharedPreferencesService sharedPreferencesService)
      : _prefs = sharedPreferencesService.prefs {
    _viewType = ItemViewType.values.firstWhere(
      (e) => e.toString() == _prefs.getString('itemViewType'),
      orElse: () => ItemViewType.table,
    );
  }

  ItemViewType get viewType => _viewType;

  void setViewType(ItemViewType viewType) {
    if (_viewType != viewType) {
      _viewType = viewType;
      _prefs.setString('itemViewType', viewType.toString());
      notifyListeners();
    }
  }
}
