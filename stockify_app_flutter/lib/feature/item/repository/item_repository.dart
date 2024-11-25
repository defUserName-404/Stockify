import 'dart:math';

import 'package:stockify_app_flutter/feature/item/model/item.dart';

import '../model/asset_status.dart';
import '../model/device_type.dart';

class ItemRepository {
  ItemRepository._privateConstructor();

  static final ItemRepository _instance = ItemRepository._privateConstructor();

  static ItemRepository get instance => _instance;

  List<Item> _items = _generateRandomItems(200);

  static List<Item> _generateRandomItems(int itemCount) {
    final random = Random();
    return List.generate(itemCount, (index) {
      return Item(
        id: (index + 1).toString(),
        assetNo: 'A$index',
        modelNo: 'M$index',
        serialNo: 'S$index',
        deviceType: DeviceType.values[random.nextInt(DeviceType.values.length)],
        warrantyDate:
            DateTime.now().add(Duration(days: random.nextInt(3650) - 1825)),
        assetStatus:
            AssetStatus.values[random.nextInt(AssetStatus.values.length)],
      );
    });
  }

  List<Item> getAllItems() => _items;

  Item getItem(String id) => _items.firstWhere((element) => element.id == id);

  void addItem(Item item) {
    _items.add(item);
  }

  void updateItem(Item item) {
    final index = _items.indexWhere((element) => element.id == item.id);
    _items[index] = item;
  }

  void deleteItem(String id) {
    _items.removeWhere((element) => element.id == id);
  }
}
