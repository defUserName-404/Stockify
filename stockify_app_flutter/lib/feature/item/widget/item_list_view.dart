import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockify_app_flutter/common/widget/action_widget.dart';
import 'package:stockify_app_flutter/feature/item/model/item.dart';
import 'package:stockify_app_flutter/feature/item/provider/item_provider.dart';
import 'package:stockify_app_flutter/feature/item/widget/item_status.dart';

class ItemListView extends StatelessWidget {
  final Function(Item) onView;
  final Function(Item) onEdit;
  final Function(Item) onDelete;
  const ItemListView({super.key, required this.onView, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ItemProvider>();
    return ListView.builder(
      itemCount: provider.filteredItems.length,
      itemBuilder: (context, index) {
        final item = provider.filteredItems[index];
        return _ItemListItem(
          item: item,
          onTap: () => onView(item),
          onEdit: () => onEdit(item),
          onDelete: () => onDelete(item),
        );
      },
    );
  }
}

class _ItemListItem extends StatelessWidget {
  final Item item;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ItemListItem({required this.item, required this.onTap, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.modelNo),
      subtitle: Text(item.assetNo),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ItemStatus(assetStatus: item.assetStatus),
          const SizedBox(width: 10),
          ActionWidget(icon: Icons.remove_red_eye, onTap: onTap, message: 'View'),
          const SizedBox(width: 10),
          ActionWidget(icon: Icons.edit, onTap: onEdit, message: 'Edit'),
          const SizedBox(width: 10),
          ActionWidget(icon: Icons.delete, onTap: onDelete, message: 'Delete'),
        ],
      ),
      onTap: onTap,
    );
  }
}
