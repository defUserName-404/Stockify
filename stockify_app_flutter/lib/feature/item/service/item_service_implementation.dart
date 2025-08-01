import 'package:stockify_app_flutter/feature/item/model/item.dart';
import 'package:stockify_app_flutter/feature/item/model/item_filter_param.dart';
import 'package:stockify_app_flutter/feature/item/service/item_service.dart';

import '../repository/item_repository.dart';

class ItemServiceImplementation implements ItemService {
  ItemServiceImplementation._privateConstructor();

  static final ItemServiceImplementation _instance =
      ItemServiceImplementation._privateConstructor();

  static ItemService get instance => _instance;

  final ItemRepository _itemRepository = ItemRepository.instance;

  @override
  void addItem(Item item) {
    _itemRepository.addItem(item);
  }

  @override
  void deleteItem(int id) {
    _itemRepository.deleteItem(id);
  }

  @override
  List<Item> getAllItems() {
    return _itemRepository.getAllItems();
  }

  @override
  Item getItem(int id) {
    return _itemRepository.getItemById(id);
  }

  @override
  void updateItem(Item item) {
    _itemRepository.updateItem(item);
  }

  @override
  List<Item> getFilteredItems(ItemFilterParams params) {
    return _itemRepository.getFilteredItems(params);
  }
}
