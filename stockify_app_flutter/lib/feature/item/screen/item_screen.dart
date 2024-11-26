import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockify_app_flutter/common/helpers/date_formatter.dart';
import 'package:stockify_app_flutter/common/theme/colors.dart';
import 'package:stockify_app_flutter/common/theme/controller/theme_controller.dart';
import 'package:stockify_app_flutter/common/widget/action_widget.dart';
import 'package:stockify_app_flutter/common/widget/app_button.dart';
import 'package:stockify_app_flutter/feature/item/model/asset_status.dart';
import 'package:stockify_app_flutter/feature/item/service/item_service.dart';
import 'package:stockify_app_flutter/feature/item/service/item_service_implementation.dart';
import 'package:stockify_app_flutter/feature/item/util/item_validator.dart';
import 'package:stockify_app_flutter/feature/item/widget/item_status.dart';

import '../../user/model/user.dart';
import '../model/device_type.dart';
import '../model/item.dart';
import '../widget/item_details_text.dart';

class ItemScreen extends StatefulWidget {
  ItemScreen({super.key});

  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  late final ItemService _itemService;
  int _rowsPerPage = 10;
  bool _isPanelOpen = false;
  Item? _editingItem;
  late final TextEditingController _assetInputController,
      _modelInputController,
      _serialInputController,
      _hostNameInputController,
      _ipPortInputController,
      _macAddressInputController,
      _osVersionInputController,
      _facePlateNameInputController,
      _switchPortInputController,
      _switchIpAddressInputController;
  DeviceType? _selectedDeviceType;
  AssetStatus? _selectedAssetStatus;
  DateTime? _selectedWarrantyDate;
  DateTime? _selectedReceivedDate;
  bool? _isPasswordProtected;
  User? _assignedUser;

  @override
  void initState() {
    _itemService = ItemServiceImplementation.instance;
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
    _selectedDeviceType = _editingItem?.deviceType;
    _selectedAssetStatus = _editingItem?.assetStatus;
    _selectedWarrantyDate = _editingItem?.warrantyDate;
    _selectedReceivedDate = _editingItem?.receivedDate;
    _isPasswordProtected = _editingItem?.isPasswordProtected;
    _assignedUser = _editingItem?.assignedTo;
    super.initState();
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
      id: _editingItem == null
          ? (int.parse(_itemService.getAllItems().last.id) + 1).toString()
          : _editingItem!.id,
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
    log(item.toString());
    if (_editingItem != null) {
      _itemService.updateItem(item);
    } else {
      _itemService.addItem(item);
    }
    _clearFields();
    _togglePanel();
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

  @override
  Widget build(BuildContext context) {
    final screenWidthHalf = MediaQuery.of(context).size.width / 2;
    final currentTheme =
        Provider.of<ThemeController>(context).themeData.brightness;
    List<User> usersList = List.generate(
        10,
        (index) => User(
              id: index.toString(),
              userName: "User ${index + 1}",
            ));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Items'),
        surfaceTintColor: AppColors.colorTransparent,
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 16.0),
                Container(
                  width: double.infinity,
                  child: PaginatedDataTable(
                    headingRowColor: WidgetStateProperty.all<Color>(
                        AppColors.colorAccent.withValues(alpha: 0.25)),
                    actions: [
                      AppButton(
                          onPressed: _togglePanel,
                          icon: Icons.add,
                          iconColor: AppColors.colorAccent,
                          text: 'Add New Item'),
                    ],
                    header: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 9,
                          child: SearchBar(
                            padding:
                                WidgetStateProperty.all<EdgeInsetsGeometry>(
                              const EdgeInsets.symmetric(horizontal: 16.0),
                            ),
                            leading: Icon(Icons.search,
                                color: AppColors.colorTextDark),
                            hintText:
                                'Search for items by their ID, Asset No, Model No or Serial No',
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        AppButton(
                          onPressed: () {},
                          icon: Icons.filter_list_rounded,
                          iconColor: AppColors.colorTextDark,
                          text: 'Sort & Filter',
                          backgroundColor: AppColors.colorTextSemiLight,
                          foregroundColor: AppColors.colorTextDark,
                        ),
                      ],
                    ),
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
                    source: ItemData(
                        context: context,
                        onEdit: (item) => _togglePanel(item: item)),
                  ),
                ),
              ],
            ),
          ),
          // Side Panel (Sliding in/out)
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _assetInputController,
                          validator: ItemInputValidator.validateAssetNo,
                          autovalidateMode: AutovalidateMode.onUnfocus,
                          decoration: InputDecoration(labelText: 'Asset No'),
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: TextFormField(
                          controller: _modelInputController,
                          validator: ItemInputValidator.validateModelNo,
                          autovalidateMode: AutovalidateMode.onUnfocus,
                          decoration: InputDecoration(labelText: 'Model No'),
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
                          autovalidateMode: AutovalidateMode.onUnfocus,
                          decoration: InputDecoration(labelText: 'Serial No'),
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Expanded(
                        child: DropdownButtonFormField<DeviceType>(
                          value: _selectedDeviceType,
                          decoration: InputDecoration(labelText: 'Device Type'),
                          validator: ItemInputValidator.validateDeviceType,
                          autovalidateMode: AutovalidateMode.onUnfocus,
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
                          validator: ItemInputValidator.validateWarrantyDate,
                          autovalidateMode: AutovalidateMode.onUnfocus,
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
                          validator: ItemInputValidator.validateAssetStatus,
                          autovalidateMode: AutovalidateMode.onUnfocus,
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
                          decoration: InputDecoration(labelText: 'Host Name'),
                          controller: _hostNameInputController,
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(labelText: 'IP Port'),
                          controller: _ipPortInputController,
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(labelText: 'MAC Address'),
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
                          decoration: InputDecoration(labelText: 'OS Version'),
                          controller: _osVersionInputController,
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: TextFormField(
                          decoration:
                              InputDecoration(labelText: 'Face Plate Name'),
                          controller: _facePlateNameInputController,
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(labelText: 'Switch Port'),
                          controller: _switchPortInputController,
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: TextFormField(
                          decoration:
                              InputDecoration(labelText: 'Switch IP Address'),
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
                                decoration:
                                    InputDecoration(labelText: 'Assigned User'),
                                items: usersList.map((user) {
                                  return DropdownMenuItem(
                                      value: user, child: Text(user.userName));
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
    );
  }
}

class ItemData extends DataTableSource {
  final ItemService _itemService = ItemServiceImplementation.instance;
  late final List<Item> _items;
  late final BuildContext _context;
  final void Function(Item)? onEdit;

  final Set<int> _selectedRows = {};

  ItemData({required BuildContext context, this.onEdit}) {
    _items = _itemService.getAllItems();
    _context = context;
  }

  @override
  DataRow getRow(int index) {
    final item = _items[index];
    final selectedRowId = int.parse(item.id);
    return DataRow.byIndex(
      index: index,
      selected: _selectedRows.contains(selectedRowId),
      onSelectChanged: (selected) {
        if (selected == true) {
          _selectedRows.add(selectedRowId);
        } else {
          _selectedRows.remove(selectedRowId);
        }
        notifyListeners();
      },
      cells: [
        DataCell(Text(item.id.toString())),
        DataCell(Text(item.assetNo)),
        DataCell(Text(item.modelNo)),
        DataCell(Text(item.serialNo)),
        DataCell(Text(item.deviceType.name)),
        DataCell(
            Text(DateFormatter.extractDateFromDateTime(item.warrantyDate))),
        DataCell(ItemStatus(assetStatus: item.assetStatus)),
        DataCell(Row(
          children: [
            ActionWidget(
                icon: Icons.remove_red_eye_rounded,
                onTap: () {
                  showDialog(
                    context: _context,
                    builder: (_) => AlertDialog(
                      title: Text('Item Details'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ItemDetailsText(
                              label: 'Asset No', itemText: '${item.assetNo}'),
                          ItemDetailsText(
                              label: 'Model No', itemText: '${item.modelNo}'),
                          ItemDetailsText(
                              label: 'Serial No', itemText: '${item.serialNo}'),
                          ItemDetailsText(
                              label: 'Device Type',
                              itemText: '${item.deviceType.name}'),
                          if (item.receivedDate != null)
                            ItemDetailsText(
                                label: 'Warranty Date',
                                itemText:
                                    '${DateFormatter.extractDateFromDateTime(item.receivedDate!)}'),
                          ItemDetailsText(
                              label: 'Warranty Date',
                              itemText:
                                  '${DateFormatter.extractDateFromDateTime(item.warrantyDate)}'),
                          ItemDetailsText(
                              label: 'Status',
                              itemText: '${item.assetStatus.name}'),
                          if (item.hostName != null)
                            ItemDetailsText(
                                label: 'Host Name',
                                itemText: '${item.hostName}'),
                          if (item.ipPort != null)
                            ItemDetailsText(
                                label: 'IP Address',
                                itemText: '${item.ipPort}'),
                          if (item.macAddress != null)
                            ItemDetailsText(
                                label: 'MAC Address',
                                itemText: '${item.macAddress}'),
                          if (item.osVersion != null)
                            ItemDetailsText(
                                label: 'OS Version',
                                itemText: '${item.osVersion}'),
                          if (item.facePlateName != null)
                            ItemDetailsText(
                                label: 'Face Plate Name',
                                itemText: '${item.facePlateName}'),
                          if (item.switchPort != null)
                            ItemDetailsText(
                                label: 'Switch Port',
                                itemText: '${item.switchPort}'),
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
                          onPressed: () => Navigator.of(_context).pop(),
                        ),
                      ],
                    ),
                  );
                }),
            const SizedBox(width: 10.0),
            ActionWidget(
                icon: Icons.edit,
                onTap: () {
                  onEdit!(item);
                }),
            const SizedBox(width: 10.0),
            ActionWidget(
                icon: Icons.delete,
                onTap: () async {
                  final confirmDelete = await showDialog<bool>(
                    context: _context,
                    builder: (context) => AlertDialog(
                      title: const Text('Confirm Deletion'),
                      content: (_selectedRows.length == 0 ||
                              _selectedRows.length == 1)
                          ? const Text(
                              'Are you sure you want to delete this item?')
                          : Text(
                              'Are you sure you want to delete these ${_selectedRows.length} items?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Yes',
                              style: TextStyle(color: AppColors.colorPink)),
                        ),
                      ],
                    ),
                  );
                  if (confirmDelete == true) {
                    if (selectedRowCount == 0) {
                      _itemService.deleteItem(item.id);
                      notifyListeners();
                    } else {}
                    final selectedItems = _items
                        .where((element) =>
                            _selectedRows.contains(int.parse(element.id)))
                        .toList();
                    for (final currentlySelectedItem in selectedItems) {
                      _itemService.deleteItem(currentlySelectedItem.id);
                      _selectedRows.remove(int.parse(currentlySelectedItem.id));
                      notifyListeners();
                    }
                  }
                })
          ],
        ))
      ],
    );
  }

  @override
  int get rowCount => _items.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedRows.length;
}
