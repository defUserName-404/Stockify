import '../model/item.dart';
import '../repository/item_repository.dart';

class ItemService {
  ItemService._privateConstructor();

  static final ItemService _instance = ItemService._privateConstructor();

  static ItemService get instance => _instance;

  final ItemRepository _itemRepository = ItemRepository.instance;

  void addItem(Item item) {
    _itemRepository.addItem(item);
  }

  void updateItem(Item item) {
    _itemRepository.updateItem(item);
  }

  void deleteItem(String id) {
    _itemRepository.deleteItem(id);
  }

  List<Item> getAllItems() {
    return _itemRepository.getAllItems();
  }
}
