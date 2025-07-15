import '../model/item.dart';
import '../model/item_filter_param.dart';

abstract class ItemService {
  void addItem(Item item);

  void updateItem(Item item);

  void deleteItem(int id);

  List<Item> getAllItems();

  List<Item> getFilteredItems(ItemFilterParams params);

  Item getItem(int id);
}
