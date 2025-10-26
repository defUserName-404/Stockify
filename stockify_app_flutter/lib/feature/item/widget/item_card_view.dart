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

class ItemCardView extends StatelessWidget {
  final Function(Item) onView;
  final Function(Item) onEdit;
  final Function(Item) onDelete;

  const ItemCardView({
    super.key,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ItemProvider>();
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 400,
        childAspectRatio: 1.4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: provider.filteredItems.length,
      itemBuilder: (context, index) {
        final item = provider.filteredItems[index];
        return ItemContextMenu(
          item: item,
          onView: onView,
          onEdit: onEdit,
          onDelete: onDelete,
          child: _ItemCard(
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

class _ItemCard extends StatefulWidget {
  final Item item;
  final Function(Item) onView;
  final Function(Item) onEdit;
  final Function(Item) onDelete;

  const _ItemCard({
    required this.item,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<_ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<_ItemCard> {
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
              color: theme.shadowColor.withAlpha(_isHovered ? 15 : 8),
              blurRadius: _isHovered ? 12 : 4,
              offset: Offset(0, _isHovered ? 6 : 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => widget.onView(widget.item),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _CardHeader(
                    item: widget.item,
                    provider: provider,
                  ),
                  const SizedBox(height: 12),
                  _CardBody(item: widget.item),
                  const Spacer(),
                  _CardFooter(
                    item: widget.item,
                    provider: provider,
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

class _CardHeader extends StatelessWidget {
  final Item item;
  final ItemProvider provider;

  const _CardHeader({
    required this.item,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        _DeviceTypeChip(
          deviceType: item.deviceType,
          onTap: () => provider.filterByDeviceType(item.deviceType),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withAlpha(30),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            item.assetNo,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _DeviceTypeChip extends StatelessWidget {
  final DeviceType deviceType;
  final VoidCallback onTap;

  const _DeviceTypeChip({
    required this.deviceType,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getDeviceTypeColor(deviceType);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withAlpha(10),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withAlpha(80)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getDeviceTypeIcon(deviceType),
              size: 16,
              color: color,
            ),
            const SizedBox(width: 6),
            Text(
              deviceType.name,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
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

class _CardBody extends StatelessWidget {
  final Item item;

  const _CardBody({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.modelNo,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: -0.3,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          item.serialNo,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withAlpha(160),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        _InfoRow(
          icon: Icons.calendar_today_outlined,
          label: DateFormatter.extractDateFromDateTime(item.warrantyDate),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoRow({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: theme.colorScheme.onSurface.withAlpha(120),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withAlpha(140),
          ),
        ),
      ],
    );
  }
}

class _CardFooter extends StatelessWidget {
  final Item item;
  final ItemProvider provider;
  final bool isHovered;
  final Function(Item) onView;
  final Function(Item) onEdit;
  final Function(Item) onDelete;

  const _CardFooter({
    required this.item,
    required this.provider,
    required this.isHovered,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () => provider.filterByAssetStatus(item.assetStatus),
          borderRadius: BorderRadius.circular(6),
          child: ItemStatus(assetStatus: item.assetStatus),
        ),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: isHovered ? 1.0 : 0.7,
          child: HoverActionsCell(
            isSelected: isHovered,
            actions: [
              ActionWidget(
                icon: Icons.remove_red_eye_outlined,
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