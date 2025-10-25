import 'package:flutter/material.dart';
import 'package:stockify_app_flutter/feature/item/model/item.dart';

class ItemContextMenu extends StatelessWidget {
  final Widget child;
  final Item item;
  final void Function(Item) onView;
  final void Function(Item) onEdit;
  final void Function(Item) onDelete;

  const ItemContextMenu({
    super.key,
    required this.child,
    required this.item,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onSecondaryTapUp: (details) {
        showMenu(
          context: context,
          position: RelativeRect.fromLTRB(
            details.globalPosition.dx,
            details.globalPosition.dy,
            details.globalPosition.dx,
            details.globalPosition.dy,
          ),
          items: [
            PopupMenuItem(
              onTap: () => onView(item),
              child: const ListTile(
                  leading: Icon(Icons.remove_red_eye), title: Text('View')),
            ),
            PopupMenuItem(
              onTap: () => onEdit(item),
              child: const ListTile(
                  leading: Icon(Icons.edit), title: Text('Edit')),
            ),
            PopupMenuItem(
              onTap: () => onDelete(item),
              child: const ListTile(
                  leading: Icon(Icons.delete), title: Text('Delete')),
            ),
          ],
        );
      },
      child: child,
    );
  }
}
