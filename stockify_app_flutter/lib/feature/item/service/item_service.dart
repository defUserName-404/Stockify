import '../model/item.dart';

abstract class ItemService {
  void addItem(Item item);

  void updateItem(Item item);

  void deleteItem(int id);

  List<Item> getAllItems();

  Item getItem(int id);
}
