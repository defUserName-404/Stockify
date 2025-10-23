import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockify_app_flutter/common/helpers/date_formatter.dart';
import 'package:stockify_app_flutter/common/shortcuts/app_shortcuts.dart';
import 'package:stockify_app_flutter/common/theme/colors.dart';
import 'package:stockify_app_flutter/common/widget/animations/screen_transition.dart';
import 'package:stockify_app_flutter/common/widget/app_dialogs.dart';
import 'package:stockify_app_flutter/common/widget/custom_snackbar.dart';
import 'package:stockify_app_flutter/common/widget/page_header.dart';
import 'package:stockify_app_flutter/feature/item/provider/item_provider.dart';
import 'package:stockify_app_flutter/feature/item/service/item_service.dart';
import 'package:stockify_app_flutter/feature/item/service/item_service_implementation.dart';
import 'package:stockify_app_flutter/feature/item/widget/item_form.dart';
import 'package:stockify_app_flutter/feature/item/widget/item_status.dart';
import 'package:stockify_app_flutter/feature/user/service/user_service.dart';
import 'package:stockify_app_flutter/feature/user/service/user_service_implementation.dart';

import '../../../common/widget/action_widget.dart';
import '../../../common/widget/filter_chips_bar.dart';
import '../../user/model/user.dart';
import '../model/device_type.dart';
import '../model/item.dart';
import '../model/item_filter_param.dart';

part '../widget/item_datatable.dart';

class ItemScreen extends StatefulWidget {
  final ItemFilterParams? filterParams;
  final int? itemId;
  final bool openAddItemPanel;

  const ItemScreen({
    super.key,
    this.filterParams,
    this.itemId,
    this.openAddItemPanel = false,
  });

  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  late final ItemService _itemService;
  late final UserService _userService;
  late ItemData _itemDataSource;
  final FocusNode _searchFocusNode = FocusNode();
  late final TextEditingController _searchInputController;
  List<User> _usersList = [];
  final GlobalKey<PaginatedDataTableState> _paginatedDataTableKey =
      GlobalKey<PaginatedDataTableState>();

  @override
  void initState() {
    super.initState();
    _itemService = ItemServiceImplementation.instance;
    _userService = UserServiceImplementation.instance;
    _searchInputController = TextEditingController();
    _fetchUsers();
    _initializeItemDataSource();
    // Initialize provider after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ItemProvider>();
      provider.initialize(widget.filterParams);
      if (widget.itemId != null) {
        final item = _itemService.getItem(widget.itemId!);
        _showViewDetailsDialog(item);
      } else if (widget.openAddItemPanel) {
        _openItemFormDialog();
      }
    });
  }

  void _fetchUsers() {
    setState(() {
      _usersList = _userService.getAllUsers();
    });
  }

  void _initializeItemDataSource() {
    final provider = context.read<ItemProvider>();
    _itemDataSource = ItemData(
      context: context,
      provider: provider,
      onEdit: (item) => _openItemFormDialog(item: item),
      onView: (item) => _showViewDetailsDialog(item),
      onDelete: (item) => _showDeleteConfirmationDialog(item),
    );
  }

  void _onSearchChanged(String query) {
    context.read<ItemProvider>().search(query);
  }

  void _showFilterDialog() {
    final provider = context.read<ItemProvider>();
    AppDialogs.showItemFilterDialog(
      context: context,
      currentParams: provider.filterParams,
      onApplyFilter: (params) {
        provider.updateFilterParams(params);
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
    final provider = context.read<ItemProvider>();
    if (item.id != null) {
      provider.updateItem(item);
      CustomSnackBar.show(
        context: context,
        message: 'Item updated successfully',
        type: SnackBarType.success,
      );
    } else {
      provider.addItem(item);
      CustomSnackBar.show(
        context: context,
        message: 'Item added successfully',
        type: SnackBarType.success,
      );
    }
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
      context.read<ItemProvider>().deleteItem(item.id!);
      CustomSnackBar.show(
        context: context,
        message: 'Item deleted successfully',
        type: SnackBarType.success,
      );
    }
  }

  void _onSort(String sortBy) {
    context.read<ItemProvider>().sort(sortBy);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Items'),
        surfaceTintColor: AppColors.colorTransparent,
      ),
      body: ScreenTransition(
        child: Consumer<ItemProvider>(
          builder: (context, provider, child) {
            return Shortcuts(
              shortcuts: {
                AppShortcuts.openSearch:
                    VoidCallbackIntent(() => _searchFocusNode.requestFocus()),
                AppShortcuts.openFilter:
                    VoidCallbackIntent(() => _showFilterDialog()),
                AppShortcuts.addNew:
                    VoidCallbackIntent(() => _openItemFormDialog()),
                AppShortcuts.arrowDown: VoidCallbackIntent(() {
                  provider.selectNextRow();
                  _paginatedDataTableKey.currentState
                      ?.pageTo(provider.firstRowIndex);
                }),
                AppShortcuts.arrowUp: VoidCallbackIntent(() {
                  provider.selectPreviousRow();
                  _paginatedDataTableKey.currentState
                      ?.pageTo(provider.firstRowIndex);
                }),
                AppShortcuts.viewDetails: VoidCallbackIntent(() {
                  final item = provider.getSelectedItem();
                  if (item != null) {
                    _showViewDetailsDialog(item);
                  }
                }),
                AppShortcuts.editItem: VoidCallbackIntent(() {
                  final item = provider.getSelectedItem();
                  if (item != null) {
                    _openItemFormDialog(item: item);
                  }
                }),
                AppShortcuts.deleteItem: VoidCallbackIntent(() {
                  final item = provider.getSelectedItem();
                  if (item != null) {
                    _showDeleteConfirmationDialog(item);
                  }
                }),
                AppShortcuts.nextPage: VoidCallbackIntent(() {
                  provider.nextPage();
                  _paginatedDataTableKey.currentState
                      ?.pageTo(provider.firstRowIndex);
                }),
                AppShortcuts.previousPage: VoidCallbackIntent(() {
                  provider.previousPage();
                  _paginatedDataTableKey.currentState
                      ?.pageTo(provider.firstRowIndex);
                }),
                AppShortcuts.sortAsc: VoidCallbackIntent(() {
                  provider.setSortOrder('ASC');
                }),
                AppShortcuts.sortDesc: VoidCallbackIntent(() {
                  provider.setSortOrder('DESC');
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
                        searchHint:
                            'Search by Asset No, Model, or Serial No...',
                      ),
                      FilterChipsBar(
                        chips: [
                          if (provider.filterParams.deviceType != null)
                            FilterChipData(
                              label:
                                  'Device: ${provider.filterParams.deviceType?.name}',
                              onDeleted: () => provider.clearDeviceTypeFilter(),
                            ),
                          if (provider.filterParams.assetStatus != null)
                            FilterChipData(
                              label:
                                  'Asset Status: ${provider.filterParams.assetStatus?.name}',
                              onDeleted: () =>
                                  provider.clearAssetStatusFilter(),
                            ),
                          if (provider.filterParams.warrantyDate != null)
                            FilterChipData(
                              label:
                                  'Warranty Date: ${DateFormatter.extractDateFromDateTime(provider.filterParams.warrantyDate!)} (${provider.filterParams.warrantyDateFilterType!.name})',
                              onDeleted: () =>
                                  provider.clearWarrantyDateFilter(),
                            ),
                          if (provider.filterParams.assignedTo != null)
                            FilterChipData(
                              label:
                                  'Assigned to: ${provider.filterParams.assignedTo?.userName}',
                              onDeleted: () => provider.clearAssignedToFilter(),
                            ),
                          if (provider.filterParams.isExpiring)
                            FilterChipData(
                              label: 'Expiring in 30 days',
                              onDeleted: () => provider.clearIsExpiringFilter(),
                            ),
                        ],
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: SizedBox(
                            width: double.infinity,
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                _itemDataSource.screenWidth =
                                    constraints.maxWidth;
                                return PaginatedDataTable(
                                  key: _paginatedDataTableKey,
                                  initialFirstRowIndex: provider.firstRowIndex,
                                  onPageChanged: (rowIndex) {
                                    provider.onPageChanged(rowIndex);
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
                                    if (value != null) {
                                      provider.setRowsPerPage(value);
                                    }
                                  },
                                  rowsPerPage: provider.rowsPerPage,
                                  columns: _getColumns(
                                      constraints.maxWidth, provider),
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
            onSort: (columnIndex, ascending) => _onSort('asset_no')),
        DataColumn(
            label: _buildSortableHeader('Device Type', 'device_type', provider),
            onSort: (columnIndex, ascending) => _onSort('device_type')),
        const DataColumn(label: Text('Actions')),
      ];
    } else if (maxWidth < 900) {
      columns = [
        DataColumn(
            label: _buildSortableHeader('Asset No', 'asset_no', provider),
            onSort: (columnIndex, ascending) => _onSort('asset_no')),
        DataColumn(
            label: _buildSortableHeader('Model No', 'model_no', provider),
            onSort: (columnIndex, ascending) => _onSort('model_no')),
        DataColumn(
            label: _buildSortableHeader('Device Type', 'device_type', provider),
            onSort: (columnIndex, ascending) => _onSort('device_type')),
        DataColumn(
            label:
                _buildSortableHeader('Asset Status', 'asset_status', provider),
            onSort: (columnIndex, ascending) => _onSort('asset_status')),
        const DataColumn(label: Text('Actions')),
      ];
    } else {
      columns = [
        DataColumn(
            label: _buildSortableHeader('Asset No', 'asset_no', provider),
            onSort: (columnIndex, ascending) => _onSort('asset_no')),
        DataColumn(
            label: _buildSortableHeader('Model No', 'model_no', provider),
            onSort: (columnIndex, ascending) => _onSort('model_no')),
        DataColumn(
            label: _buildSortableHeader('Serial No', 'serial_no', provider),
            onSort: (columnIndex, ascending) => _onSort('serial_no')),
        const DataColumn(label: Text('Device Type')),
        DataColumn(
            label: _buildSortableHeader(
                'Warranty Date', 'warranty_date', provider),
            onSort: (columnIndex, ascending) => _onSort('warranty_date')),
        const DataColumn(label: Text('Asset Status')),
        const DataColumn(label: Text('Actions')),
      ];
    }
    return columns;
  }

  Widget _buildSortableHeader(
      String title, String sortKey, ItemProvider provider) {
    return InkWell(
      onTap: () => _onSort(sortKey),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          if (provider.filterParams.sortBy == sortKey)
            Icon(
              provider.filterParams.sortOrder == 'ASC'
                  ? Icons.arrow_upward
                  : Icons.arrow_downward,
              size: 16,
            )
        ],
      ),
    );
  }
}