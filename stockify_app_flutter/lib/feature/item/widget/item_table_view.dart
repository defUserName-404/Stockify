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

class ItemTableView extends StatefulWidget {
  final Function(Item) onEdit;
  final Function(Item) onView;
  final Function(Item) onDelete;
  final Function(String) onSort;

  const ItemTableView({
    super.key,
    required this.onEdit,
    required this.onView,
    required this.onDelete,
    required this.onSort,
  });

  @override
  State<ItemTableView> createState() => _ItemTableViewState();
}

class _ItemTableViewState extends State<ItemTableView> {
  late ItemData _itemDataSource;
  final GlobalKey<PaginatedDataTableState> _paginatedDataTableKey =
      GlobalKey<PaginatedDataTableState>();

  @override
  void initState() {
    super.initState();
    final provider = context.read<ItemProvider>();
    _itemDataSource = ItemData(
      context: context,
      provider: provider,
      onEdit: widget.onEdit,
      onView: widget.onView,
      onDelete: widget.onDelete,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ItemProvider>();
    return SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
        child: LayoutBuilder(
          builder: (context, constraints) {
            _itemDataSource.screenWidth = constraints.maxWidth;
            return PaginatedDataTable(
              key: _paginatedDataTableKey,
              initialFirstRowIndex: provider.firstRowIndex,
              onPageChanged: (rowIndex) {
                provider.onPageChanged(rowIndex);
              },
              headingRowColor: WidgetStateProperty.all<Color>(
                  Theme.of(context).colorScheme.primaryContainer.withAlpha(10)),
              showCheckboxColumn: false,
              showEmptyRows: false,
              availableRowsPerPage: const [10, 20, 50],
              onRowsPerPageChanged: (int? value) {
                if (value != null) {
                  provider.setRowsPerPage(value);
                }
              },
              rowsPerPage: provider.rowsPerPage,
              columns: _getColumns(constraints.maxWidth, provider),
              source: _itemDataSource,
            );
          },
        ),
      ),
    );
  }

  List<DataColumn> _getColumns(double maxWidth, ItemProvider provider) {
    List<DataColumn> columns = [];
    if (maxWidth < 600) {
      columns = [
        DataColumn(
            label: _buildSortableHeader('Asset No', 'asset_no', provider),
            onSort: (columnIndex, ascending) => widget.onSort('asset_no')),
        DataColumn(
            label: _buildSortableHeader('Device Type', 'device_type', provider),
            onSort: (columnIndex, ascending) => widget.onSort('device_type')),
        const DataColumn(label: Text('Actions')),
      ];
    } else if (maxWidth < 900) {
      columns = [
        DataColumn(
            label: _buildSortableHeader('Asset No', 'asset_no', provider),
            onSort: (columnIndex, ascending) => widget.onSort('asset_no')),
        DataColumn(
            label: _buildSortableHeader('Model No', 'model_no', provider),
            onSort: (columnIndex, ascending) => widget.onSort('model_no')),
        DataColumn(
            label: _buildSortableHeader('Device Type', 'device_type', provider),
            onSort: (columnIndex, ascending) => widget.onSort('device_type')),
        DataColumn(
            label:
                _buildSortableHeader('Asset Status', 'asset_status', provider),
            onSort: (columnIndex, ascending) => widget.onSort('asset_status')),
        const DataColumn(label: Text('Actions')),
      ];
    } else {
      columns = [
        DataColumn(
            label: _buildSortableHeader('Asset No', 'asset_no', provider),
            onSort: (columnIndex, ascending) => widget.onSort('asset_no')),
        DataColumn(
            label: _buildSortableHeader('Model No', 'model_no', provider),
            onSort: (columnIndex, ascending) => widget.onSort('model_no')),
        DataColumn(
            label: _buildSortableHeader('Serial No', 'serial_no', provider),
            onSort: (columnIndex, ascending) => widget.onSort('serial_no')),
        const DataColumn(label: Text('Device Type')),
        DataColumn(
            label: _buildSortableHeader(
                'Warranty Date', 'warranty_date', provider),
            onSort: (columnIndex, ascending) => widget.onSort('warranty_date')),
        const DataColumn(label: Text('Asset Status')),
        const DataColumn(label: Text('Actions')),
      ];
    }
    return columns;
  }

  Widget _buildSortableHeader(
      String title, String sortKey, ItemProvider provider) {
    return InkWell(
      onTap: () => widget.onSort(sortKey),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title),
          if (provider.filterParams.sortBy == sortKey)
            Icon(
              provider.filterParams.sortOrder == 'ASC'
                  ? Icons.arrow_upward
                  : Icons.arrow_downward,
              size: 12,
            )
        ],
      ),
    );
  }
}

class ItemData extends DataTableSource {
  final BuildContext context;
  final ItemProvider provider;
  final void Function(Item) onEdit;
  final void Function(Item) onView;
  final void Function(Item) onDelete;
  double screenWidth;

  ItemData({
    required this.context,
    required this.provider,
    required this.onEdit,
    required this.onView,
    required this.onDelete,
    this.screenWidth = 600,
  }) {
    // Listen to provider changes
    provider.addListener(_onProviderChanged);
  }

  void _onProviderChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    provider.removeListener(_onProviderChanged);
    super.dispose();
  }

  @override
  DataRow getRow(int index) {
    if (index >= provider.filteredItems.length) {
      return DataRow(cells: []);
    }
    final item = provider.filteredItems[index];
    final isSelected = provider.selectedRowIndex == index;
    final isEven = index.isEven;
    final theme = Theme.of(context);
    final cells = _getCells(item, isSelected);
    final wrappedCells = cells.map((cell) {
      if (cell.child is HoverActionsCell) return cell; // Don't wrap the actions
      return DataCell(
        ItemContextMenu(
          item: item,
          onView: onView,
          onEdit: onEdit,
          onDelete: onDelete,
          child: cell.child,
        ),
        onTap: cell.onTap,
        placeholder: cell.placeholder,
        showEditIcon: cell.showEditIcon,
      );
    }).toList();
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
        provider.setSelectedRowIndex(index);
      },
      cells: wrappedCells,
    );
  }

  List<DataCell> _getCells(Item item, bool isSelected) {
    if (screenWidth < 600) {
      return [
        DataCell(Text(item.assetNo)),
        DataCell(
          InkWell(
            onTap: () => provider.filterByDeviceType(item.deviceType),
            child: Chip(
              avatar: Icon(_getDeviceTypeIcon(item.deviceType),
                  size: 16, color: _getDeviceTypeColor(item.deviceType)),
              label: Text(item.deviceType.name),
              backgroundColor:
                  _getDeviceTypeColor(item.deviceType).withAlpha(10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side:
                      BorderSide(color: _getDeviceTypeColor(item.deviceType))),
            ),
          ),
        ),
        _buildActionsCell(item, isSelected),
      ];
    } else if (screenWidth < 900) {
      return [
        DataCell(Text(item.assetNo)),
        DataCell(Text(item.modelNo)),
        DataCell(
          InkWell(
            onTap: () => provider.filterByDeviceType(item.deviceType),
            child: Chip(
              avatar: Icon(_getDeviceTypeIcon(item.deviceType),
                  size: 16, color: _getDeviceTypeColor(item.deviceType)),
              label: Text(item.deviceType.name),
              backgroundColor:
                  _getDeviceTypeColor(item.deviceType).withAlpha(10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side:
                      BorderSide(color: _getDeviceTypeColor(item.deviceType))),
            ),
          ),
        ),
        DataCell(
          InkWell(
            onTap: () => provider.filterByAssetStatus(item.assetStatus),
            child: ItemStatus(assetStatus: item.assetStatus),
          ),
        ),
        _buildActionsCell(item, isSelected),
      ];
    } else {
      return [
        DataCell(Text(item.assetNo)),
        DataCell(Text(item.modelNo)),
        DataCell(Text(item.serialNo)),
        DataCell(
          InkWell(
            onTap: () => provider.filterByDeviceType(item.deviceType),
            child: Chip(
              avatar: Icon(_getDeviceTypeIcon(item.deviceType),
                  size: 16, color: _getDeviceTypeColor(item.deviceType)),
              label: Text(item.deviceType.name),
              backgroundColor:
                  _getDeviceTypeColor(item.deviceType).withAlpha(10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side:
                      BorderSide(color: _getDeviceTypeColor(item.deviceType))),
            ),
          ),
        ),
        DataCell(
            Text(DateFormatter.extractDateFromDateTime(item.warrantyDate))),
        DataCell(
          InkWell(
            onTap: () => provider.filterByAssetStatus(item.assetStatus),
            child: ItemStatus(assetStatus: item.assetStatus),
          ),
        ),
        _buildActionsCell(item, isSelected),
      ];
    }
  }

  DataCell _buildActionsCell(Item item, bool isSelected) {
    return DataCell(HoverActionsCell(
      isSelected: isSelected,
      actions: [
        ActionWidget(
          icon: Icons.remove_red_eye_rounded,
          onTap: () => onView(item),
          message: 'View Item Details',
        ),
        const SizedBox(width: 10.0),
        ActionWidget(
          icon: Icons.edit,
          onTap: () => onEdit(item),
          message: 'Edit Item',
        ),
        const SizedBox(width: 10.0),
        ActionWidget(
          icon: Icons.delete,
          onTap: () => onDelete(item),
          message: 'Delete Item',
        )
      ],
    ));
  }

  @override
  int get rowCount => provider.filteredItems.length;

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

