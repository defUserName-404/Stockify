import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockify_app_flutter/common/helpers/date_formatter.dart';
import 'package:stockify_app_flutter/common/shortcuts/app_shortcuts.dart';
import 'package:stockify_app_flutter/common/theme/colors.dart';
import 'package:stockify_app_flutter/common/theme/controller/theme_controller.dart';
import 'package:stockify_app_flutter/common/widget/action_widget.dart';
import 'package:stockify_app_flutter/common/widget/animations/screen_transition.dart';
import 'package:stockify_app_flutter/common/widget/app_dialogs.dart';
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
    } else if (widget.openAddItemPanel) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _togglePanel();
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
    AppDialogs.showItemFilterDialog(
      context: context,
      currentParams: _filterParams,
      onApplyFilter: (params) {
        setState(() {
          _filterParams = params;
        });
        _refreshData();
      },
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
    AppDialogs.showDetailsDialog(
      context: context,
      title: 'Item Details',
      icon: Icons.inventory_2_outlined,
      content: SingleChildScrollView(
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
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
