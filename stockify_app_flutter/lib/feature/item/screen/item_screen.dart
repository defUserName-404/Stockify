import 'package:flutter/material.dart';
import 'package:stockify_app_flutter/common/helpers/date_formatter.dart';
import 'package:stockify_app_flutter/common/shortcuts/app_shortcuts.dart';
import 'package:stockify_app_flutter/common/theme/colors.dart';
import 'package:stockify_app_flutter/common/widget/action_widget.dart';
import 'package:stockify_app_flutter/common/widget/animations/screen_transition.dart';
import 'package:stockify_app_flutter/common/widget/app_dialogs.dart';
import 'package:stockify_app_flutter/common/widget/custom_snackbar.dart';
import 'package:stockify_app_flutter/common/widget/responsive/page_header.dart';
import 'package:stockify_app_flutter/feature/item/service/item_service.dart';
import 'package:stockify_app_flutter/feature/item/service/item_service_implementation.dart';
import 'package:stockify_app_flutter/feature/item/widget/item_form.dart';
import 'package:stockify_app_flutter/feature/item/widget/item_status.dart';
import 'package:stockify_app_flutter/feature/user/service/user_service.dart';
import 'package:stockify_app_flutter/feature/user/service/user_service_implementation.dart';

import '../../user/model/user.dart';
import '../model/asset_status.dart';
import '../model/device_type.dart';
import '../model/item.dart';
import '../model/item_filter_param.dart';

part '../widget/item_datatable.dart';

class ItemScreen extends StatefulWidget {
  final ItemFilterParams? filterParams;
  final int? itemId;
  final bool openAddItemPanel;

  ItemScreen(
      {super.key,
      this.filterParams,
      this.itemId,
      this.openAddItemPanel = false});

  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  late final ItemService _itemService;
  late final UserService _userService;
  int _rowsPerPage = 10;
  late ItemData _itemDataSource;
  ItemFilterParams _filterParams = ItemFilterParams();
  final FocusNode _searchFocusNode = FocusNode();
  int _selectedRowIndex = -1;
  late final TextEditingController _searchInputController;
  List<User> _usersList = [];
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
    } else if (widget.openAddItemPanel) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _openItemFormDialog();
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
      onEdit: (item) => _openItemFormDialog(item: item),
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
      onFilterByDeviceType: (type) => _filterByDeviceType(type),
      onFilterByAssetStatus: (status) => _filterByAssetStatus(status),
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
    AppDialogs.showItemFilterDialog(
      context: context,
      currentParams: _filterParams,
      onApplyFilter: (params) {
        setState(() {
          _filterParams = params;
        });
        _refreshData();
      },
      usersList: _usersList,
    );
  }

  @override
  void dispose() {
    _searchInputController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _openItemFormDialog({Item? item}) async {
    final savedItem = await showDialog<Item>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width > 800
              ? MediaQuery.of(context).size.width / 2
              : MediaQuery.of(context).size.width * 0.9,
          child: ItemForm(
            editingItem: item,
            onSave: (newItem) {
              Navigator.of(context).pop(newItem);
            },
            onCancel: () {
              Navigator.of(context).pop();
            },
            usersList: _usersList,
          ),
        ),
      ),
    );
    if (savedItem != null) {
      _saveItem(savedItem);
    }
  }

  void _saveItem(Item item) {
    if (item.id != null) {
      _itemService.updateItem(item);
      CustomSnackBar.show(
        context: context,
        message: 'Item updated successfully',
        type: SnackBarType.success,
      );
    } else {
      _itemService.addItem(item);
      CustomSnackBar.show(
        context: context,
        message: 'Item added successfully',
        type: SnackBarType.success,
      );
    }
    _refreshData();
  }

  void _showViewDetailsDialog(Item item) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width > 800
              ? MediaQuery.of(context).size.width / 2
              : MediaQuery.of(context).size.width * 0.9,
          child: ItemForm(
            editingItem: item,
            onSave: (_) {},
            onCancel: () {
              Navigator.of(context).pop();
            },
            usersList: _usersList,
            isViewOnly: true,
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(Item item) async {
    final confirmDelete = await AppDialogs.showDeleteConfirmationDialog(
      context: context,
      itemName: 'item',
    );
    if (confirmDelete == true) {
      _itemService.deleteItem(item.id!);
      CustomSnackBar.show(
        context: context,
        message: 'Item deleted successfully',
        type: SnackBarType.success,
      );
      _refreshData();
    }
  }

  void _onSort(String sortBy) {
    String sortOrder = 'ASC';
    if (_filterParams.sortBy == sortBy) {
      sortOrder = _filterParams.sortOrder == 'ASC' ? 'DESC' : 'ASC';
    }
    setState(() {
      _filterParams =
          _filterParams.copyWith(sortBy: sortBy, sortOrder: sortOrder);
    });
    _refreshData();
  }

  void _filterByDeviceType(DeviceType type) {
    setState(() {
      _filterParams = _filterParams.copyWith(deviceType: type);
    });
    _refreshData();
  }

  void _filterByAssetStatus(AssetStatus status) {
    setState(() {
      _filterParams = _filterParams.copyWith(assetStatus: status);
    });
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
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
            AppShortcuts.addNew:
                VoidCallbackIntent(() => _openItemFormDialog()),
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
                _openItemFormDialog(
                    item: _itemDataSource.getRowData(_selectedRowIndex));
              }
            }),
            AppShortcuts.deleteItem: VoidCallbackIntent(() {
              if (_selectedRowIndex != -1) {
                _showDeleteConfirmationDialog(
                    _itemDataSource.getRowData(_selectedRowIndex));
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
            AppShortcuts.sortAsc: VoidCallbackIntent(() {
              if (_filterParams.sortBy != null) {
                setState(() {
                  _filterParams = _filterParams.copyWith(sortOrder: 'ASC');
                });
                _refreshData();
              }
            }),
            AppShortcuts.sortDesc: VoidCallbackIntent(() {
              if (_filterParams.sortBy != null) {
                setState(() {
                  _filterParams = _filterParams.copyWith(sortOrder: 'DESC');
                });
                _refreshData();
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
              child: Column(
                children: <Widget>[
                  PageHeader(
                    onAddNew: () => _openItemFormDialog(),
                    onFilter: _showFilterDialog,
                    onSearch: _onSearchChanged,
                    searchController: _searchInputController,
                    searchFocusNode: _searchFocusNode,
                    searchHint: 'Search by Asset No, Model, or Serial No...',
                  ),
                  if (_filterParams.deviceType != null ||
                      _filterParams.assetStatus != null ||
                      _filterParams.warrantyDate != null ||
                      _filterParams.assignedTo != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: [
                          if (_filterParams.deviceType != null)
                            Chip(
                              label: Text(
                                  'Device: ${_filterParams.deviceType!.name}'),
                              onDeleted: () {
                                setState(() {
                                  _filterParams =
                                      _filterParams.copyWith(deviceType: null);
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
                                  _filterParams =
                                      _filterParams.copyWith(assetStatus: null);
                                });
                                _refreshData();
                              },
                            ),
                          if (_filterParams.warrantyDate != null)
                            Chip(
                              label: Text(
                                  'Warranty Date: ${DateFormatter.extractDateFromDateTime(_filterParams.warrantyDate!)} (${_filterParams.warrantyDateFilterType!.name})'),
                              onDeleted: () {
                                setState(() {
                                  _filterParams = _filterParams.copyWith(
                                      warrantyDate: null,
                                      warrantyDateFilterType: null);
                                });
                                _refreshData();
                              },
                            ),
                          if (_filterParams.assignedTo != null)
                            Chip(
                              label: Text(
                                  'Assigned To: ${_filterParams.assignedTo!.userName}'),
                              onDeleted: () {
                                setState(() {
                                  _filterParams =
                                      _filterParams.copyWith(assignedTo: null);
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
                            _itemDataSource.screenWidth = constraints.maxWidth;
                            return PaginatedDataTable(
                              key: _paginatedDataTableKey,
                              initialFirstRowIndex: _firstRowIndex,
                              onPageChanged: (rowIndex) {
                                setState(() {
                                  _firstRowIndex = rowIndex;
                                  _selectedRowIndex = rowIndex;
                                });
                              },
                              headingRowColor: WidgetStateProperty.all<Color>(
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
                              columns: _getColumns(constraints.maxWidth),
                              source: _itemDataSource,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<DataColumn> _getColumns(double maxWidth) {
    List<DataColumn> columns = [];
    if (maxWidth < 600) {
      columns = [
        DataColumn(
            label: _buildSortableHeader('Asset No', 'asset_no'),
            onSort: (columnIndex, ascending) => _onSort('asset_no')),
        DataColumn(
            label: _buildSortableHeader('Device Type', 'device_type'),
            onSort: (columnIndex, ascending) => _onSort('device_type')),
        const DataColumn(label: Text('Actions')),
      ];
    } else if (maxWidth < 900) {
      columns = [
        DataColumn(
            label: _buildSortableHeader('Asset No', 'asset_no'),
            onSort: (columnIndex, ascending) => _onSort('asset_no')),
        DataColumn(
            label: _buildSortableHeader('Model No', 'model_no'),
            onSort: (columnIndex, ascending) => _onSort('model_no')),
        DataColumn(
            label: _buildSortableHeader('Device Type', 'device_type'),
            onSort: (columnIndex, ascending) => _onSort('device_type')),
        DataColumn(
            label: _buildSortableHeader('Asset Status', 'asset_status'),
            onSort: (columnIndex, ascending) => _onSort('asset_status')),
        const DataColumn(label: Text('Actions')),
      ];
    } else {
      columns = [
        DataColumn(
            label: _buildSortableHeader('Asset No', 'asset_no'),
            onSort: (columnIndex, ascending) => _onSort('asset_no')),
        DataColumn(
            label: _buildSortableHeader('Model No', 'model_no'),
            onSort: (columnIndex, ascending) => _onSort('model_no')),
        DataColumn(
            label: _buildSortableHeader('Serial No', 'serial_no'),
            onSort: (columnIndex, ascending) => _onSort('serial_no')),
        DataColumn(label: Text('Device Type')),
        DataColumn(
            label: _buildSortableHeader('Warranty Date', 'warranty_date'),
            onSort: (columnIndex, ascending) => _onSort('warranty_date')),
        DataColumn(label: Text('Asset Status')),
        const DataColumn(label: Text('Actions')),
      ];
    }
    return columns;
  }

  Widget _buildSortableHeader(String title, String sortKey) {
    return InkWell(
      onTap: () => _onSort(sortKey),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          if (_filterParams.sortBy == sortKey)
            Icon(
              _filterParams.sortOrder == 'ASC'
                  ? Icons.arrow_upward
                  : Icons.arrow_downward,
              size: 16,
            )
        ],
      ),
    );
  }
}
