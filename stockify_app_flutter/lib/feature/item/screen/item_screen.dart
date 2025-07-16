import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockify_app_flutter/common/helpers/date_formatter.dart';
import 'package:stockify_app_flutter/common/shortcuts/app_shortcuts.dart';
import 'package:stockify_app_flutter/common/theme/colors.dart';
import 'package:stockify_app_flutter/common/theme/controller/theme_controller.dart';
import 'package:stockify_app_flutter/common/widget/action_widget.dart';
import 'package:stockify_app_flutter/common/widget/app_button.dart';
import 'package:stockify_app_flutter/feature/item/model/asset_status.dart';
import 'package:stockify_app_flutter/feature/item/service/item_service.dart';
import 'package:stockify_app_flutter/feature/item/service/item_service_implementation.dart';
import 'package:stockify_app_flutter/feature/item/widget/item_header.dart';
import 'package:stockify_app_flutter/feature/item/widget/item_status.dart';
import 'package:stockify_app_flutter/feature/user/service/user_service.dart';
import 'package:stockify_app_flutter/feature/user/service/user_service_implementation.dart';

import '../../user/model/user.dart';
import '../model/device_type.dart';
import '../model/item.dart';
import '../model/item_filter_param.dart';
import '../util/item_validator.dart';
import '../widget/item_details_text.dart';
import '../widget/item_filter_dialog.dart';

class ItemScreen extends StatefulWidget {
  final ItemFilterParams? filterParams;

  ItemScreen({super.key, this.filterParams});

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

  late final TextEditingController _assetInputController,
      _modelInputController,
      _serialInputController,
      _hostNameInputController,
      _ipPortInputController,
      _macAddressInputController,
      _osVersionInputController,
      _facePlateNameInputController,
      _switchPortInputController,
      _switchIpAddressInputController,
      _searchInputController;
  DeviceType? _selectedDeviceType;
  AssetStatus? _selectedAssetStatus;
  DateTime? _selectedWarrantyDate;
  DateTime? _selectedReceivedDate;
  bool? _isPasswordProtected;
  User? _assignedUser;
  List<User> _usersList = [];

  @override
  void initState() {
    _itemService = ItemServiceImplementation.instance;
    _userService = UserServiceImplementation.instance;
    _filterParams = widget.filterParams ?? ItemFilterParams();
    _initializeControllers();
    _initializeItemDataSource();
    _fetchUsers();
    super.initState();
  }

  void _fetchUsers() {
    setState(() {
      _usersList = _userService.getAllUsers();
    });
  }

  void _initializeControllers() {
    _assetInputController = TextEditingController();
    _modelInputController = TextEditingController();
    _serialInputController = TextEditingController();
    _hostNameInputController = TextEditingController();
    _ipPortInputController = TextEditingController();
    _macAddressInputController = TextEditingController();
    _osVersionInputController = TextEditingController();
    _facePlateNameInputController = TextEditingController();
    _switchPortInputController = TextEditingController();
    _switchIpAddressInputController = TextEditingController();
    _searchInputController = TextEditingController();
    _selectedDeviceType = _editingItem?.deviceType;
    _selectedAssetStatus = _editingItem?.assetStatus;
    _selectedWarrantyDate = _editingItem?.warrantyDate;
    _selectedReceivedDate = _editingItem?.receivedDate;
    _isPasswordProtected = _editingItem?.isPasswordProtected;
    _assignedUser = _editingItem?.assignedTo;
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
        });
  }

  void _refreshData() {
    setState(() {
      _itemDataSource.updateFilterParams(_filterParams);
      _itemDataSource.refreshData();
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
    _assetInputController.dispose();
    _modelInputController.dispose();
    _serialInputController.dispose();
    _hostNameInputController.dispose();
    _ipPortInputController.dispose();
    _macAddressInputController.dispose();
    _osVersionInputController.dispose();
    _facePlateNameInputController.dispose();
    _switchPortInputController.dispose();
    _switchIpAddressInputController.dispose();
    _searchInputController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _togglePanel({Item? item}) {
    setState(() {
      if (item != null) {
        _editingItem = item;
        _assetInputController.text = item.assetNo;
        _modelInputController.text = item.modelNo;
        _serialInputController.text = item.serialNo;
        _selectedDeviceType = item.deviceType;
        _selectedReceivedDate = item.receivedDate;
        _selectedWarrantyDate = item.warrantyDate;
        _selectedAssetStatus = item.assetStatus;
        _hostNameInputController.text = item.hostName ?? '';
        _ipPortInputController.text = item.ipPort ?? '';
        _macAddressInputController.text = item.macAddress ?? '';
        _osVersionInputController.text = item.osVersion ?? '';
        _facePlateNameInputController.text = item.facePlateName ?? '';
        _switchPortInputController.text = item.switchPort ?? '';
        _switchIpAddressInputController.text = item.switchIpAddress ?? '';
        _isPasswordProtected = item.isPasswordProtected;
        _assignedUser = item.assignedTo;
      } else {
        _editingItem = null;
        _assetInputController.clear();
        _modelInputController.clear();
        _serialInputController.clear();
        _selectedDeviceType = null;
        _selectedReceivedDate = null;
        _selectedWarrantyDate = null;
        _selectedAssetStatus = null;
        _hostNameInputController.clear();
        _ipPortInputController.clear();
        _macAddressInputController.clear();
        _osVersionInputController.clear();
        _facePlateNameInputController.clear();
        _switchPortInputController.clear();
        _switchIpAddressInputController.clear();
        _isPasswordProtected = null;
        _assignedUser = null;
      }
      _isPanelOpen = !_isPanelOpen;
    });
  }

  void _saveItem() {
    final assetNo = _assetInputController.text;
    final modelNo = _modelInputController.text;
    final serialNo = _serialInputController.text;
    final deviceType = _selectedDeviceType;
    final assetStatus = _selectedAssetStatus;
    final receivedDate = _selectedReceivedDate;
    final warrantyDate = _selectedWarrantyDate;
    final hostName = _hostNameInputController.text;
    final ipPort = _ipPortInputController.text;
    final macAddress = _macAddressInputController.text;
    final osVersion = _osVersionInputController.text;
    final facePlateName = _facePlateNameInputController.text;
    final switchPort = _switchPortInputController.text;
    final switchIpAddress = _switchIpAddressInputController.text;
    final isPasswordProtected = _isPasswordProtected;
    final assignedTo = _assignedUser;
    final item = Item(
      id: _editingItem != null ? _editingItem!.id : null,
      assetNo: assetNo,
      modelNo: modelNo,
      serialNo: serialNo,
      deviceType: deviceType!,
      assetStatus: assetStatus!,
      receivedDate: receivedDate,
      warrantyDate: warrantyDate!,
      hostName: hostName,
      ipPort: ipPort,
      macAddress: macAddress,
      osVersion: osVersion,
      facePlateName: facePlateName,
      switchPort: switchPort,
      switchIpAddress: switchIpAddress,
      isPasswordProtected: isPasswordProtected,
      assignedTo: assignedTo,
    );
    if (_editingItem != null) {
      _itemService.updateItem(item);
    } else {
      _itemService.addItem(item);
    }
    _clearFields();
    _togglePanel();
    _refreshData();
  }

  void _clearFields() {
    _assetInputController.clear();
    _modelInputController.clear();
    _serialInputController.clear();
    _hostNameInputController.clear();
    _ipPortInputController.clear();
    _macAddressInputController.clear();
    _osVersionInputController.clear();
    _facePlateNameInputController.clear();
    _switchPortInputController.clear();
    _switchIpAddressInputController.clear();
    _selectedDeviceType = null;
    _selectedAssetStatus = null;
    _selectedWarrantyDate = null;
    _selectedReceivedDate = null;
    _isPasswordProtected = null;
    _assignedUser = null;
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
      body: Shortcuts(
        shortcuts: {
          AppShortcuts.openSearch:
              VoidCallbackIntent(() => _searchFocusNode.requestFocus()),
          AppShortcuts.openFilter:
              VoidCallbackIntent(() => _showFilterDialog()),
          AppShortcuts.addNew: VoidCallbackIntent(() => _togglePanel()),
          AppShortcuts.arrowDown: VoidCallbackIntent(() {
            _selectedRowIndex = _itemDataSource.getSelectedRowIndex();
            setState(() {
              if (_selectedRowIndex <
                  _itemDataSource._filteredItems.length - 1) {
                _itemDataSource.setSelectedRowIndex(_selectedRowIndex + 1);
              }
            });
            _refreshData();
          }),
          AppShortcuts.arrowUp: VoidCallbackIntent(() {
            _selectedRowIndex = _itemDataSource.getSelectedRowIndex();
            setState(() {
              if (_selectedRowIndex > 0) {
                _itemDataSource.setSelectedRowIndex(_selectedRowIndex - 1);
              }
            });
            _refreshData();
          }),
          AppShortcuts.viewDetails: VoidCallbackIntent(() {
            if (_selectedRowIndex != -1) {
              _showViewDetailsDialog(
                  _itemDataSource.getRowData(_selectedRowIndex));
            }
          }),
          AppShortcuts.editItem: VoidCallbackIntent(() {
            if (_selectedRowIndex != -1) {
              _togglePanel(item: _itemDataSource.getRowData(_selectedRowIndex));
            }
          }),
          AppShortcuts.deleteItem: VoidCallbackIntent(() {
            if (_selectedRowIndex != -1) {
              _showDeleteConfirmationDialog(
                  _itemDataSource.getRowData(_selectedRowIndex));
            }
          }),
        },
        child: Actions(
          actions: {
            VoidCallbackIntent: CallbackAction<VoidCallbackIntent>(
              onInvoke: (intent) => intent.callback(),
            ),
          },
          child: Focus(
            autofocus: true,
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    ItemHeader(
                      onAddNew: _togglePanel,
                      onFilter: _showFilterDialog,
                      onSearch: _onSearchChanged,
                      searchController: _searchInputController,
                      searchFocusNode: _searchFocusNode,
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
                          child: PaginatedDataTable(
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
                            columns: [
                              DataColumn(label: Text('ID')),
                              DataColumn(label: Text('Asset No')),
                              DataColumn(label: Text('Model No')),
                              DataColumn(label: Text('Serial No')),
                              DataColumn(label: Text('Device Type')),
                              DataColumn(label: Text('Warranty Date')),
                              DataColumn(label: Text('Asset Status')),
                              DataColumn(label: Text('Actions'))
                            ],
                            source: _itemDataSource,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                AnimatedPositioned(
                  duration: Duration(milliseconds: 300),
                  right: _isPanelOpen ? 0 : -screenWidthHalf,
                  top: 0,
                  bottom: 0,
                  width: screenWidthHalf,
                  child: Container(
                    color: currentTheme == Brightness.light
                        ? AppColors.colorBackground
                        : AppColors.colorBackgroundDark,
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _editingItem == null ? 'Add Item' : 'Edit Item',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _assetInputController,
                                validator: ItemInputValidator.validateAssetNo,
                                autovalidateMode: AutovalidateMode.always,
                                decoration:
                                    InputDecoration(labelText: 'Asset No'),
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Expanded(
                              child: TextFormField(
                                controller: _modelInputController,
                                validator: ItemInputValidator.validateModelNo,
                                autovalidateMode: AutovalidateMode.always,
                                decoration:
                                    InputDecoration(labelText: 'Model No'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _serialInputController,
                                validator: ItemInputValidator.validateSerialNo,
                                autovalidateMode: AutovalidateMode.always,
                                decoration:
                                    InputDecoration(labelText: 'Serial No'),
                              ),
                            ),
                            SizedBox(width: 10.0),
                            Expanded(
                              child: DropdownButtonFormField<DeviceType>(
                                value: _selectedDeviceType,
                                decoration:
                                    InputDecoration(labelText: 'Device Type'),
                                validator:
                                    ItemInputValidator.validateDeviceType,
                                autovalidateMode: AutovalidateMode.always,
                                items: DeviceType.values.map((type) {
                                  return DropdownMenuItem(
                                      value: type, child: Text(type.name));
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedDeviceType = newValue;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  labelText: 'Received Date',
                                  suffixIcon: Icon(Icons.calendar_today),
                                ),
                                controller: TextEditingController(
                                  text: _selectedReceivedDate != null
                                      ? DateFormatter.extractDateFromDateTime(
                                          _selectedReceivedDate!)
                                      : "",
                                ),
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate:
                                        _selectedReceivedDate ?? DateTime.now(),
                                    firstDate: DateTime(1970),
                                    lastDate: DateTime(2038),
                                  );
                                  if (pickedDate != null) {
                                    setState(() {
                                      _selectedReceivedDate = pickedDate;
                                    });
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Expanded(
                              child: TextFormField(
                                readOnly: true,
                                validator:
                                    ItemInputValidator.validateWarrantyDate,
                                autovalidateMode: AutovalidateMode.always,
                                decoration: InputDecoration(
                                  labelText: 'Warranty Date',
                                  suffixIcon: Icon(Icons.calendar_today),
                                ),
                                controller: TextEditingController(
                                  text: _selectedWarrantyDate != null
                                      ? DateFormatter.extractDateFromDateTime(
                                          _selectedWarrantyDate!)
                                      : "",
                                ),
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate:
                                        _selectedWarrantyDate ?? DateTime.now(),
                                    firstDate: DateTime(1970),
                                    lastDate: DateTime(2038),
                                  );
                                  if (pickedDate != null) {
                                    setState(() {
                                      _selectedWarrantyDate = pickedDate;
                                    });
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Expanded(
                              child: DropdownButtonFormField<AssetStatus>(
                                value: _selectedAssetStatus,
                                validator:
                                    ItemInputValidator.validateAssetStatus,
                                autovalidateMode: AutovalidateMode.always,
                                decoration:
                                    InputDecoration(labelText: 'Asset Status'),
                                items: AssetStatus.values.map((type) {
                                  return DropdownMenuItem(
                                      value: type, child: Text(type.name));
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedAssetStatus = newValue;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                decoration:
                                    InputDecoration(labelText: 'Host Name'),
                                controller: _hostNameInputController,
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Expanded(
                              child: TextFormField(
                                decoration:
                                    InputDecoration(labelText: 'IP Port'),
                                controller: _ipPortInputController,
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Expanded(
                              child: TextFormField(
                                decoration:
                                    InputDecoration(labelText: 'MAC Address'),
                                controller: _macAddressInputController,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                decoration:
                                    InputDecoration(labelText: 'OS Version'),
                                controller: _osVersionInputController,
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(
                                    labelText: 'Face Plate Name'),
                                controller: _facePlateNameInputController,
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Expanded(
                              child: TextFormField(
                                decoration:
                                    InputDecoration(labelText: 'Switch Port'),
                                controller: _switchPortInputController,
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(
                                    labelText: 'Switch IP Address'),
                                controller: _switchIpAddressInputController,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          children: [
                            const Text('Is Password Protected?'),
                            const SizedBox(width: 10.0),
                            Expanded(
                              child: Row(
                                children: [
                                  Radio<bool>(
                                    value: true,
                                    groupValue: _isPasswordProtected,
                                    onChanged: (value) {
                                      setState(() {
                                        _isPasswordProtected = value;
                                      });
                                    },
                                  ),
                                  const Text('Yes'),
                                  const SizedBox(width: 10),
                                  Radio<bool>(
                                    value: false,
                                    groupValue: _isPasswordProtected,
                                    onChanged: (value) {
                                      setState(() {
                                        _isPasswordProtected = value;
                                      });
                                    },
                                  ),
                                  const Text('No'),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: DropdownButtonFormField<User>(
                                      value: _assignedUser,
                                      decoration: InputDecoration(
                                          labelText: 'Assigned User'),
                                      items: _usersList.map((user) {
                                        return DropdownMenuItem(
                                            value: user,
                                            child: Text(user.userName));
                                      }).toList(),
                                      onChanged: (newValue) {
                                        setState(() {
                                          _assignedUser = newValue;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppButton(
                                onPressed: _saveItem,
                                icon: Icons.add,
                                iconColor: AppColors.colorAccent,
                                text: _editingItem == null
                                    ? 'Add Item'
                                    : 'Save Changes'),
                            const SizedBox(width: 10.0),
                            AppButton(
                              onPressed: _togglePanel,
                              icon: Icons.cancel,
                              iconColor: AppColors.colorTextDark,
                              text: 'Cancel',
                              backgroundColor: AppColors.colorTextSemiLight,
                              foregroundColor: AppColors.colorTextDark,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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

  ItemData({
    required this.context,
    this.onEdit,
    this.onView,
    this.onDelete,
    required this.getSelectedRowIndex,
    required this.setSelectedRowIndex,
    required ItemFilterParams filterParams,
    required int rowsPerPage,
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
          return theme.colorScheme.primary.withOpacity(0.2);
        }
        return isEven
            ? Colors.transparent
            : theme.colorScheme.onSurface.withOpacity(0.02);
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
