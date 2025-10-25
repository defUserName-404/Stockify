import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockify_app_flutter/common/widget/action_widget.dart';
import 'package:stockify_app_flutter/common/widget/hover_actions_cell.dart';
import 'package:stockify_app_flutter/feature/item/model/item.dart';
import 'package:stockify_app_flutter/feature/item/provider/item_provider.dart';
import 'package:stockify_app_flutter/feature/item/widget/item_context_menu.dart';
import 'package:stockify_app_flutter/feature/item/widget/item_status.dart';

class ItemCardView extends StatelessWidget {
  final Function(Item) onView;
  final Function(Item) onEdit;
  final Function(Item) onDelete;
  const ItemCardView({super.key, required this.onView, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ItemProvider>();
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 400,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemCount: provider.filteredItems.length,
      itemBuilder: (context, index) {
        final item = provider.filteredItems[index];
        return ItemContextMenu(
          item: item,
          onView: onView,
          onEdit: onEdit,
          onDelete: onDelete,
          child: _ItemCardItem(
            item: item,
            onTap: () => onView(item),
            onEdit: () => onEdit(item),
            onDelete: () => onDelete(item),
          ),
        );
      },
    );
  }
}

class _ItemCardItem extends StatelessWidget {
  final Item item;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ItemCardItem({required this.item, required this.onTap, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.modelNo,
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(item.assetNo),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ItemStatus(assetStatus: item.assetStatus),
                  HoverActionsCell(
                    actions: [
                      ActionWidget(icon: Icons.remove_red_eye, onTap: onTap, message: 'View'),
                      const SizedBox(width: 10),
                      ActionWidget(icon: Icons.edit, onTap: onEdit, message: 'Edit'),
                      const SizedBox(width: 10),
                      ActionWidget(icon: Icons.delete, onTap: onDelete, message: 'Delete'),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
