import 'package:flutter/material.dart';
import 'package:stockify_app_flutter/feature/item/model/item_view_type.dart';

class ViewTypeProvider extends ChangeNotifier {
  ItemViewType _viewType = ItemViewType.table;

  ItemViewType get viewType => _viewType;

  void setViewType(ItemViewType viewType) {
    if (_viewType != viewType) {
      _viewType = viewType;
      notifyListeners();
    }
  }
}
