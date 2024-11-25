import '../model/item.dart';

abstract class ItemService {
  void addItem(Item item);

  void updateItem(Item item);

  void deleteItem(String id);

  List<Item> getAllItems();

  Item getItem(String id);
}
