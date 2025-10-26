import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockify_app_flutter/common/helpers/date_formatter.dart';
import 'package:stockify_app_flutter/common/theme/colors.dart';
import 'package:stockify_app_flutter/common/widget/action_widget.dart';
import 'package:stockify_app_flutter/common/widget/hover_actions_cell.dart';
import 'package:stockify_app_flutter/feature/item/model/device_type.dart';
import 'package:stockify_app_flutter/feature/item/model/item.dart';
import 'package:stockify_app_flutter/feature/item/provider/item_provider.dart';
import 'package:stockify_app_flutter/feature/item/widget/item_context_menu.dart';
import 'package:stockify_app_flutter/feature/item/widget/item_status.dart';

class ItemListView extends StatelessWidget {
  final Function(Item) onView;
  final Function(Item) onEdit;
  final Function(Item) onDelete;

  const ItemListView({
    super.key,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ItemProvider>();
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: provider.filteredItems.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = provider.filteredItems[index];
        return ItemContextMenu(
          item: item,
          onView: onView,
          onEdit: onEdit,
          onDelete: onDelete,
          child: _ItemListTile(
            item: item,
            onView: onView,
            onEdit: onEdit,
            onDelete: onDelete,
          ),
        );
      },
    );
  }
}

class _ItemListTile extends StatefulWidget {
  final Item item;
  final Function(Item) onView;
  final Function(Item) onEdit;
  final Function(Item) onDelete;

  const _ItemListTile({
    required this.item,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<_ItemListTile> createState() => _ItemListTileState();
}

class _ItemListTileState extends State<_ItemListTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.watch<ItemProvider>();
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isHovered
                ? theme.colorScheme.primary.withAlpha(100)
                : theme.colorScheme.outlineVariant.withAlpha(30),
            width: _isHovered ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withAlpha(_isHovered ? 12 : 5),
              blurRadius: _isHovered ? 8 : 2,
              offset: Offset(0, _isHovered ? 4 : 1),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => widget.onView(widget.item),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  _LeadingSection(
                    item: widget.item,
                    provider: provider,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _ContentSection(
                      item: widget.item,
                      provider: provider,
                    ),
                  ),
                  const SizedBox(width: 16),
                  _TrailingSection(
                    item: widget.item,
                    isHovered: _isHovered,
                    onView: widget.onView,
                    onEdit: widget.onEdit,
                    onDelete: widget.onDelete,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LeadingSection extends StatelessWidget {
  final Item item;
  final ItemProvider provider;

  const _LeadingSection({
    required this.item,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getDeviceTypeColor(item.deviceType);
    return InkWell(
      onTap: () => provider.filterByDeviceType(item.deviceType),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: color.withAlpha(15),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withAlpha(60)),
        ),
        child: Icon(
          _getDeviceTypeIcon(item.deviceType),
          size: 28,
          color: color,
        ),
      ),
    );
  }

  IconData _getDeviceTypeIcon(DeviceType type) {
    switch (type) {
      case DeviceType.CPU:
        return Icons.memory;
      case DeviceType.Monitor:
        return Icons.desktop_windows;
      case DeviceType.UPS:
        return Icons.power;
      case DeviceType.RAM:
        return Icons.memory_outlined;
      case DeviceType.HDD:
        return Icons.storage;
      case DeviceType.SSD:
        return Icons.save;
      case DeviceType.Printer:
        return Icons.print;
      case DeviceType.Scanner:
        return Icons.scanner;
      case DeviceType.Projector:
        return Icons.videocam;
      case DeviceType.Router:
        return Icons.router;
      case DeviceType.Switch:
        return Icons.switch_camera;
      case DeviceType.Modem:
        return Icons.router_outlined;
      case DeviceType.Camera:
        return Icons.camera_alt;
      case DeviceType.Keyboard:
        return Icons.keyboard;
      case DeviceType.Mouse:
        return Icons.mouse;
      case DeviceType.Speaker:
        return Icons.speaker;
    }
  }

  Color _getDeviceTypeColor(DeviceType type) {
    switch (type) {
      case DeviceType.CPU:
        return AppColors.colorBlue;
      case DeviceType.Monitor:
        return AppColors.colorGreen;
      case DeviceType.UPS:
        return AppColors.colorOrange;
      case DeviceType.RAM:
        return AppColors.colorPurple;
      case DeviceType.HDD:
        return AppColors.colorPink;
      case DeviceType.SSD:
        return AppColors.colorPrimary;
      case DeviceType.Scanner:
        return AppColors.colorAccent;
      default:
        return AppColors.colorTextSemiLight;
    }
  }
}

class _ContentSection extends StatelessWidget {
  final Item item;
  final ItemProvider provider;

  const _ContentSection({
    required this.item,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                item.modelNo,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            _InfoChip(
              icon: Icons.tag,
              label: item.assetNo,
            ),
            const SizedBox(width: 8),
            _InfoChip(
              icon: Icons.numbers,
              label: item.serialNo,
            ),
            const SizedBox(width: 8),
            _InfoChip(
              icon: Icons.calendar_today_outlined,
              label: DateFormatter.extractDateFromDateTime(item.warrantyDate),
            ),
          ],
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withAlpha(80),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: theme.colorScheme.onSurface.withAlpha(140),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withAlpha(160),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrailingSection extends StatelessWidget {
  final Item item;
  final bool isHovered;
  final Function(Item) onView;
  final Function(Item) onEdit;
  final Function(Item) onDelete;

  const _TrailingSection({
    required this.item,
    required this.isHovered,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ItemProvider>();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () => provider.filterByAssetStatus(item.assetStatus),
          borderRadius: BorderRadius.circular(6),
          child: ItemStatus(assetStatus: item.assetStatus),
        ),
        const SizedBox(width: 12),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: isHovered ? 1.0 : 0.7,
          child: HoverActionsCell(
            isSelected: isHovered,
            actions: [
              ActionWidget(
                icon: Icons.remove_red_eye_rounded,
                onTap: () => onView(item),
                message: 'View',
              ),
              const SizedBox(width: 8),
              ActionWidget(
                icon: Icons.edit_outlined,
                onTap: () => onEdit(item),
                message: 'Edit',
              ),
              const SizedBox(width: 8),
              ActionWidget(
                icon: Icons.delete_outline,
                onTap: () => onDelete(item),
                message: 'Delete',
              ),
            ],
          ),
        ),
      ],
    );
  }
}