part of '../screen/item_screen.dart';

class ItemData extends DataTableSource {
  final ItemService _itemService = ItemServiceImplementation.instance;
  List<Item> _filteredItems = [];
  final BuildContext context;
  final void Function(Item)? onEdit;
  final void Function(Item)? onView;
  final void Function(Item)? onDelete;
  ItemFilterParams _filterParams;
  final int Function() getSelectedRowIndex;
  final Function(int) setSelectedRowIndex;
  final int rowsPerPage;

  ItemData({
    required this.context,
    this.onEdit,
    this.onView,
    this.onDelete,
    required this.getSelectedRowIndex,
    required this.setSelectedRowIndex,
    required ItemFilterParams filterParams,
    required this.rowsPerPage,
  }) : _filterParams = filterParams {
    refreshData();
  }

  void updateFilterParams(ItemFilterParams params) {
    _filterParams = params;
    refreshData();
  }

  void refreshData() {
    _filteredItems = _itemService.getFilteredItems(_filterParams);
    notifyListeners();
  }

  void notifySelectionChanged() {
    notifyListeners();
  }

  Item getRowData(int index) {
    return _filteredItems[index];
  }

  @override
  DataRow getRow(int index) {
    final item = _filteredItems[index];
    final isSelected = getSelectedRowIndex() == index;
    final isEven = index.isEven;
    final theme = Theme.of(context);
    return DataRow.byIndex(
      index: index,
      selected: isSelected,
      color: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          return theme.colorScheme.primary.withAlpha(40);
        }
        return isEven
            ? Colors.transparent
            : theme.colorScheme.onSurface.withAlpha(2);
      }),
      onSelectChanged: (_) {
        if (index >= 0 && index < _filteredItems.length) {
          setSelectedRowIndex(index);
        }
        notifyListeners();
      },
      cells: [
        DataCell(Text(item.id?.toString() ?? '')),
        DataCell(Text(item.assetNo)),
        DataCell(Text(item.modelNo)),
        DataCell(Text(item.serialNo)),
        DataCell(Chip(
          avatar: Icon(_getDeviceTypeIcon(item.deviceType),
              size: 16, color: _getDeviceTypeColor(item.deviceType)),
          label: Text(item.deviceType.name),
          backgroundColor: _getDeviceTypeColor(item.deviceType).withAlpha(10),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: _getDeviceTypeColor(item.deviceType))),
        )),
        DataCell(
            Text(DateFormatter.extractDateFromDateTime(item.warrantyDate))),
        DataCell(ItemStatus(assetStatus: item.assetStatus)),
        DataCell(Row(
          children: [
            ActionWidget(
              icon: Icons.remove_red_eye_rounded,
              onTap: () => onView!(item),
              message: 'View Item Details',
            ),
            const SizedBox(width: 10.0),
            ActionWidget(
              icon: Icons.edit,
              onTap: () => onEdit!(item),
              message: 'Edit Item',
            ),
            const SizedBox(width: 10.0),
            ActionWidget(
              icon: Icons.delete,
              onTap: () => onDelete!(item),
              message: 'Delete Item',
            )
          ],
        ))
      ],
    );
  }

  @override
  int get rowCount => _filteredItems.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;

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
      default:
        return Icons.device_unknown;
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
