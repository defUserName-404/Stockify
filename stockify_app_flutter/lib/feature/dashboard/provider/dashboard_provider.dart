import 'package:flutter/material.dart';
import 'package:stockify_app_flutter/feature/item/model/asset_status.dart';
import 'package:stockify_app_flutter/feature/item/model/device_type.dart';
import 'package:stockify_app_flutter/feature/item/model/item.dart';
import 'package:stockify_app_flutter/feature/item/model/item_filter_param.dart';
import 'package:stockify_app_flutter/feature/item/service/item_service.dart';
import 'package:stockify_app_flutter/feature/item/service/item_service_implementation.dart';
import 'package:stockify_app_flutter/feature/user/service/user_service.dart';
import 'package:stockify_app_flutter/feature/user/service/user_service_implementation.dart';

class DashboardProvider with ChangeNotifier {
  late final ItemService _itemService;
  late final UserService _userService;

  int _totalItems = 0;
  int _totalUsers = 0;
  int _expiringItems = 0;
  int _disposedItems = 0;
  Map<DeviceType, int> _deviceTypeCounts = {};
  Map<AssetStatus, int> _assetStatusCounts = {};
  List<Item> _expiringItemsList = [];
  List<Item> _expiredItemsList = [];

  DashboardProvider() {
    _itemService = ItemServiceImplementation.instance;
    _userService = UserServiceImplementation.instance;
    fetchData();
  }

  void fetchData() async {
    await _fetchFilteredItems();
    _totalUsers = _userService.getAllUsers().length;
    notifyListeners();
  }

  Future<void> _fetchFilteredItems() async {
    final allItems = _itemService.getAllItems();
    _totalItems = allItems.length;
    final expiringItemsResult =
        _itemService.getFilteredItems(ItemFilterParams(isExpiring: true));
    _expiringItems = expiringItemsResult.length;
    _expiringItemsList = expiringItemsResult;
    final expiredItemsResult =
        _itemService.getFilteredItems(ItemFilterParams(isExpired: true));
    _expiredItemsList = expiredItemsResult;
    final disposedItemsResult = _itemService
        .getFilteredItems(ItemFilterParams(assetStatus: AssetStatus.Disposed));
    _disposedItems = disposedItemsResult.length;
    final deviceTypeCountsResult = <DeviceType, int>{};
    final assetStatusCountsResult = <AssetStatus, int>{};
    for (final item in allItems) {
      deviceTypeCountsResult[item.deviceType] =
          (deviceTypeCountsResult[item.deviceType] ?? 0) + 1;
      assetStatusCountsResult[item.assetStatus] =
          (assetStatusCountsResult[item.assetStatus] ?? 0) + 1;
    }
    _deviceTypeCounts = deviceTypeCountsResult;
    _assetStatusCounts = assetStatusCountsResult;
  }

  int get totalItems => _totalItems;

  int get totalUsers => _totalUsers;

  int get expiringItems => _expiringItems;

  int get disposedItems => _disposedItems;

  Map<DeviceType, int> get deviceTypeCounts => _deviceTypeCounts;

  Map<AssetStatus, int> get assetStatusCounts => _assetStatusCounts;

  List<Item> get expiringItemsList => _expiringItemsList;

  List<Item> get expiredItemsList => _expiredItemsList;
}
