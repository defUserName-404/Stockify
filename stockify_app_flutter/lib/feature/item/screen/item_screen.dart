import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockify_app_flutter/common/helpers/date_formatter.dart';
import 'package:stockify_app_flutter/common/shortcuts/app_shortcuts.dart';
import 'package:stockify_app_flutter/common/theme/colors.dart';
import 'package:stockify_app_flutter/common/theme/controller/theme_controller.dart';
import 'package:stockify_app_flutter/common/widget/action_widget.dart';
import 'package:stockify_app_flutter/common/widget/animations/screen_transition.dart';
import 'package:stockify_app_flutter/common/widget/responsive/page_header.dart';
import 'package:stockify_app_flutter/common/widget/side_panel.dart';
import 'package:stockify_app_flutter/feature/item/service/item_service.dart';
import 'package:stockify_app_flutter/feature/item/service/item_service_implementation.dart';
import 'package:stockify_app_flutter/feature/item/widget/item_form.dart';
import 'package:stockify_app_flutter/feature/item/widget/item_status.dart';
import 'package:stockify_app_flutter/feature/user/service/user_service.dart';
import 'package:stockify_app_flutter/feature/user/service/user_service_implementation.dart';

import '../../user/model/user.dart';
import '../model/device_type.dart';
import '../model/item.dart';
import '../model/item_filter_param.dart';
import '../widget/item_details_text.dart';
import '../widget/item_filter_dialog.dart';

class ItemScreen extends StatefulWidget {
  final ItemFilterParams? filterParams;
  final int? itemId;

  ItemScreen({super.key, this.filterParams, this.itemId});

  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  late final ItemService _itemService;
  late final UserService _userService;
  int _rowsPerPage = 10;
  bool _isPanelOpen = false;
  Item? _editingItem;
  late ItemData _itemDataSource;
  ItemFilterParams _filterParams = ItemFilterParams();
  final FocusNode _searchFocusNode = FocusNode();
  int _selectedRowIndex = -1;
  late final TextEditingController _searchInputController;
  List<User> _usersList = [];
  final GlobalKey<ItemFormState> _formKey = GlobalKey<ItemFormState>();
  final GlobalKey<PaginatedDataTableState> _paginatedDataTableKey =
      GlobalKey<PaginatedDataTableState>();
  int _firstRowIndex = 0;

  @override
  void initState() {
    _itemService = ItemServiceImplementation.instance;
    _userService = UserServiceImplementation.instance;
    _filterParams = widget.filterParams ?? ItemFilterParams();
    _searchInputController = TextEditingController();
    _initializeItemDataSource();
    _fetchUsers();
    if (widget.itemId != null) {
      final item = _itemService.getItem(widget.itemId!);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showViewDetailsDialog(item);
      });
    }
    super.initState();
  }

  void _fetchUsers() {
    setState(() {
      _usersList = _userService.getAllUsers();
    });
  }

  void _initializeItemDataSource() {
    _itemDataSource = ItemData(
      context: context,
      onEdit: (item) => _togglePanel(item: item),
      filterParams: _filterParams,
      rowsPerPage: _rowsPerPage,
      onView: (item) => _showViewDetailsDialog(item),
      onDelete: (item) => _showDeleteConfirmationDialog(item),
      getSelectedRowIndex: () => _selectedRowIndex,
      setSelectedRowIndex: (index) {
        setState(() {
          _selectedRowIndex = index;
        });
      },
    );
  }

  void _refreshData() {
    setState(() {
      _itemDataSource.updateFilterParams(_filterParams);
      _itemDataSource.refreshData();
      _selectedRowIndex = -1; // Reset selected row index on data refresh
    });
  }

  void _onSearchChanged(String query) {
    _filterParams = _filterParams.copyWith(search: query);
    _refreshData();
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => FilterDialog(
        currentParams: _filterParams,
        onApplyFilter: (params) {
          setState(() {
            _filterParams = params;
          });
          _refreshData();
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchInputController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _togglePanel({Item? item}) {
    setState(() {
      _editingItem = item;
      _isPanelOpen = !_isPanelOpen;
    });
  }

  void _saveItem(Item item) {
    if (item.id != null) {
      _itemService.updateItem(item);
    } else {
      _itemService.addItem(item);
    }
    _togglePanel();
    _refreshData();
  }

  void _showViewDetailsDialog(Item item) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Item Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ItemDetailsText(label: 'Asset No', itemText: '${item.assetNo}'),
            ItemDetailsText(label: 'Model No', itemText: '${item.modelNo}'),
            ItemDetailsText(label: 'Serial No', itemText: '${item.serialNo}'),
            ItemDetailsText(
                label: 'Device Type', itemText: '${item.deviceType.name}'),
            if (item.receivedDate != null)
              ItemDetailsText(
                  label: 'Received Date',
                  itemText:
                      '${DateFormatter.extractDateFromDateTime(item.receivedDate!)}'),
            ItemDetailsText(
                label: 'Warranty Date',
                itemText:
                    '${DateFormatter.extractDateFromDateTime(item.warrantyDate)}'),
            ItemDetailsText(
                label: 'Status', itemText: '${item.assetStatus.name}'),
            if (item.hostName != null)
              ItemDetailsText(label: 'Host Name', itemText: '${item.hostName}'),
            if (item.ipPort != null)
              ItemDetailsText(label: 'IP Address', itemText: '${item.ipPort}'),
            if (item.macAddress != null)
              ItemDetailsText(
                  label: 'MAC Address', itemText: '${item.macAddress}'),
            if (item.osVersion != null)
              ItemDetailsText(
                  label: 'OS Version', itemText: '${item.osVersion}'),
            if (item.facePlateName != null)
              ItemDetailsText(
                  label: 'Face Plate Name', itemText: '${item.facePlateName}'),
            if (item.switchPort != null)
              ItemDetailsText(
                  label: 'Switch Port', itemText: '${item.switchPort}'),
            if (item.switchIpAddress != null)
              ItemDetailsText(
                  label: 'Switch IP Address',
                  itemText: '${item.switchIpAddress}'),
            if (item.assignedTo != null)
              ItemDetailsText(
                  label: 'Assigned User',
                  itemText: '${item.assignedTo!.userName}'),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Close'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(Item item) async {
    final confirmDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child:
                const Text('Yes', style: TextStyle(color: AppColors.colorPink)),
          ),
        ],
      ),
    );
    if (confirmDelete == true) {
      _itemService.deleteItem(item.id!);
      _refreshData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidthHalf = MediaQuery.of(context).size.width / 2;
    final currentTheme =
        Provider.of<ThemeController>(context).themeData.brightness;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Items'),
        surfaceTintColor: AppColors.colorTransparent,
      ),
      body: ScreenTransition(
        child: Shortcuts(
          shortcuts: {
            AppShortcuts.openSearch:
                VoidCallbackIntent(() => _searchFocusNode.requestFocus()),
            AppShortcuts.openFilter:
                VoidCallbackIntent(() => _showFilterDialog()),
            AppShortcuts.addNew: VoidCallbackIntent(() => _togglePanel()),
            AppShortcuts.arrowDown: VoidCallbackIntent(() {
              int newIndex = _selectedRowIndex;
              if (newIndex < _itemDataSource.rowCount - 1) {
                newIndex++;
                setState(() {
                  _selectedRowIndex = newIndex;
                  if (newIndex >= _firstRowIndex + _rowsPerPage) {
                    _firstRowIndex = (newIndex ~/ _rowsPerPage) * _rowsPerPage;
                    _paginatedDataTableKey.currentState?.pageTo(_firstRowIndex);
                  }
                });
                _itemDataSource.notifySelectionChanged();
              }
            }),
            AppShortcuts.arrowUp: VoidCallbackIntent(() {
              int newIndex = _selectedRowIndex;
              if (newIndex > 0) {
                newIndex--;
                setState(() {
                  _selectedRowIndex = newIndex;
                  if (newIndex < _firstRowIndex) {
                    _firstRowIndex = (newIndex ~/ _rowsPerPage) * _rowsPerPage;
                    _paginatedDataTableKey.currentState?.pageTo(_firstRowIndex);
                  }
                });
                _itemDataSource.notifySelectionChanged();
              }
            }),
            AppShortcuts.viewDetails: VoidCallbackIntent(() {
              if (_selectedRowIndex != -1) {
                _showViewDetailsDialog(
                    _itemDataSource.getRowData(_selectedRowIndex));
              }
            }),
            AppShortcuts.editItem: VoidCallbackIntent(() {
              if (_selectedRowIndex != -1) {
                _togglePanel(
                    item: _itemDataSource.getRowData(_selectedRowIndex));
              }
            }),
            AppShortcuts.deleteItem: VoidCallbackIntent(() {
              if (_selectedRowIndex != -1) {
                _showDeleteConfirmationDialog(
                    _itemDataSource.getRowData(_selectedRowIndex));
              }
            }),
            AppShortcuts.cancel: VoidCallbackIntent(() => _togglePanel()),
            AppShortcuts.submit: VoidCallbackIntent(() {
              if (_isPanelOpen) {
                _formKey.currentState?.saveItem();
              }
            }),
            AppShortcuts.nextPage: VoidCallbackIntent(() {
              final newFirstRowIndex = _firstRowIndex + _rowsPerPage;
              if (newFirstRowIndex < _itemDataSource.rowCount) {
                setState(() {
                  _firstRowIndex = newFirstRowIndex;
                  _selectedRowIndex = newFirstRowIndex;
                });
                _paginatedDataTableKey.currentState?.pageTo(newFirstRowIndex);
              }
            }),
            AppShortcuts.previousPage: VoidCallbackIntent(() {
              final newFirstRowIndex = _firstRowIndex - _rowsPerPage;
              if (newFirstRowIndex >= 0) {
                setState(() {
                  _firstRowIndex = newFirstRowIndex;
                  _selectedRowIndex = newFirstRowIndex;
                });
                _paginatedDataTableKey.currentState?.pageTo(newFirstRowIndex);
              }
            }),
          },
          child: Actions(
            actions: {
              VoidCallbackIntent: CallbackAction<VoidCallbackIntent>(
                onInvoke: (intent) => intent.callback(),
              ),
            },
            child: FocusScope(
              autofocus: true,
              child: Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      PageHeader(
                        onAddNew: () => _togglePanel(),
                        onFilter: _showFilterDialog,
                        onSearch: _onSearchChanged,
                        searchController: _searchInputController,
                        searchFocusNode: _searchFocusNode,
                        searchHint:
                            'Search by Asset No, Model, or Serial No...',
                      ),
                      if (_filterParams.deviceType != null ||
                          _filterParams.assetStatus != null)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Wrap(
                            spacing: 8.0,
                            children: [
                              if (_filterParams.deviceType != null)
                                Chip(
                                  label: Text(
                                      'Device: ${_filterParams.deviceType!.name}'),
                                  onDeleted: () {
                                    setState(() {
                                      _filterParams = _filterParams.copyWith(
                                          deviceType: null);
                                    });
                                    _refreshData();
                                  },
                                ),
                              if (_filterParams.assetStatus != null)
                                Chip(
                                  label: Text(
                                      'Status: ${_filterParams.assetStatus!.name}'),
                                  onDeleted: () {
                                    setState(() {
                                      _filterParams = _filterParams.copyWith(
                                          assetStatus: null);
                                    });
                                    _refreshData();
                                  },
                                ),
                            ],
                          ),
                        ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Container(
                            width: double.infinity,
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                List<DataColumn> getColumns(double maxWidth) {
                                  if (maxWidth < 600) {
                                    return [
                                      DataColumn(label: Text('ID')),
                                      DataColumn(label: Text('Asset No')),
                                      DataColumn(label: Text('Device Type')),
                                      DataColumn(label: Text('Actions')),
                                    ];
                                  } else if (maxWidth < 900) {
                                    return [
                                      DataColumn(label: Text('ID')),
                                      DataColumn(label: Text('Asset No')),
                                      DataColumn(label: Text('Model No')),
                                      DataColumn(label: Text('Device Type')),
                                      DataColumn(label: Text('Asset Status')),
                                      DataColumn(label: Text('Actions')),
                                    ];
                                  } else {
                                    return [
                                      DataColumn(label: Text('ID')),
                                      DataColumn(label: Text('Asset No')),
                                      DataColumn(label: Text('Model No')),
                                      DataColumn(label: Text('Serial No')),
                                      DataColumn(label: Text('Device Type')),
                                      DataColumn(label: Text('Warranty Date')),
                                      DataColumn(label: Text('Asset Status')),
                                      DataColumn(label: Text('Actions')),
                                    ];
                                  }
                                }

                                return PaginatedDataTable(
                                  key: _paginatedDataTableKey,
                                  initialFirstRowIndex: _firstRowIndex,
                                  onPageChanged: (rowIndex) {
                                    setState(() {
                                      _firstRowIndex = rowIndex;
                                      _selectedRowIndex = rowIndex;
                                    });
                                  },
                                  headingRowColor:
                                      WidgetStateProperty.all<Color>(
                                          Theme.of(context)
                                              .colorScheme
                                              .primaryContainer
                                              .withAlpha(10)),
                                  showCheckboxColumn: false,
                                  showEmptyRows: false,
                                  availableRowsPerPage: const [10, 20, 50],
                                  onRowsPerPageChanged: (int? value) {
                                    setState(() {
                                      _rowsPerPage = value!;
                                    });
                                  },
                                  rowsPerPage: _rowsPerPage,
                                  columns: getColumns(constraints.maxWidth),
                                  source: _itemDataSource,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SidePanel(
                    isOpen: _isPanelOpen,
                    panelWidth: screenWidthHalf,
                    currentTheme: currentTheme,
                    child: ItemForm(
                      key: _formKey,
                      editingItem: _editingItem,
                      onSave: _saveItem,
                      onCancel: () => _togglePanel(),
                      usersList: _usersList,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

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
