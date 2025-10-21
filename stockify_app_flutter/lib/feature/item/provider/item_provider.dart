import 'package:flutter/material.dart';
import 'package:stockify_app_flutter/feature/item/model/item_filter_param.dart';
import 'package:stockify_app_flutter/feature/item/service/item_service.dart';
import 'package:stockify_app_flutter/feature/item/service/item_service_implementation.dart';

import '../model/item.dart';

class ItemProvider with ChangeNotifier {
  final ItemService _itemService = ItemServiceImplementation.instance;

  ItemFilterParams _filterParams = ItemFilterParams();
  List<Item> _items = [];
  bool _isLoading = false;

  ItemFilterParams get filterParams => _filterParams;

  List<Item> get items => _items;

  bool get isLoading => _isLoading;

  void search(String query) {
    _filterParams = _filterParams.copyWith(search: query);
    _fetchItems();
  }

  void sort(String sortBy) {
    String sortOrder = 'ASC';
    if (_filterParams.sortBy == sortBy) {
      sortOrder = _filterParams.sortOrder == 'ASC' ? 'DESC' : 'ASC';
    }
    _filterParams =
        _filterParams.copyWith(sortBy: sortBy, sortOrder: sortOrder);
    _fetchItems();
  }

  void applyFilter(ItemFilterParams params) {
    _filterParams = params;
    _fetchItems();
  }

  void _fetchItems() {
    _isLoading = true;
    notifyListeners();
    _items = _itemService.getFilteredItems(_filterParams);
    _isLoading = false;
    notifyListeners();
  }
}
