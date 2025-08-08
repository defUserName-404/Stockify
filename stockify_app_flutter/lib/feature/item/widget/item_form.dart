import 'package:flutter/material.dart';
import 'package:stockify_app_flutter/common/helpers/date_formatter.dart';
import 'package:stockify_app_flutter/common/widget/app_button.dart';
import 'package:stockify_app_flutter/feature/item/model/asset_status.dart';
import 'package:stockify_app_flutter/feature/item/model/device_type.dart';
import 'package:stockify_app_flutter/feature/item/model/item.dart';
import 'package:stockify_app_flutter/feature/item/util/item_validator.dart';
import 'package:stockify_app_flutter/feature/user/model/user.dart';

import '../../../common/shortcuts/app_shortcuts.dart';
import '../../../common/theme/colors.dart';

class ItemForm extends StatefulWidget {
  final Item? editingItem;
  final Function(Item) onSave;
  final VoidCallback onCancel;
  final List<User> usersList;
  final bool isViewOnly;

  const ItemForm({
    super.key,
    this.editingItem,
    required this.onSave,
    required this.onCancel,
    required this.usersList,
    this.isViewOnly = false,
  });

  @override
  ItemFormState createState() => ItemFormState();
}

class ItemFormState extends State<ItemForm> {
  final formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
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
  User? _assignedUser;
  final FocusNode _assetNoFocusNode = FocusNode();
  late bool _isViewOnly;

  @override
  void initState() {
    super.initState();
    _isViewOnly = widget.isViewOnly;
    _initializeControllers();
    if (!_isViewOnly) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _assetNoFocusNode.requestFocus();
      });
    }
  }

  @override
  void didUpdateWidget(ItemForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.editingItem != widget.editingItem) {
      _updateControllersWithNewItem();
    }
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
    _updateControllersWithNewItem();
  }

  void _updateControllersWithNewItem() {
    _assetInputController.text = widget.editingItem?.assetNo ?? '';
    _modelInputController.text = widget.editingItem?.modelNo ?? '';
    _serialInputController.text = widget.editingItem?.serialNo ?? '';
    _hostNameInputController.text = widget.editingItem?.hostName ?? '';
    _ipPortInputController.text = widget.editingItem?.ipPort ?? '';
    _macAddressInputController.text = widget.editingItem?.macAddress ?? '';
    _osVersionInputController.text = widget.editingItem?.osVersion ?? '';
    _facePlateNameInputController.text =
        widget.editingItem?.facePlateName ?? '';
    _switchPortInputController.text = widget.editingItem?.switchPort ?? '';
    _switchIpAddressInputController.text =
        widget.editingItem?.switchIpAddress ?? '';
    _selectedDeviceType = widget.editingItem?.deviceType;
    _selectedAssetStatus = widget.editingItem?.assetStatus;
    _selectedWarrantyDate = widget.editingItem?.warrantyDate;
    _selectedReceivedDate = widget.editingItem?.receivedDate;
    _assignedUser = widget.editingItem?.assignedTo;
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
    _scrollController.dispose();
    _assetNoFocusNode.dispose();
    super.dispose();
  }

  void _saveItem() {
    if (formKey.currentState?.validate() ?? false) {
      final item = Item(
        id: widget.editingItem?.id,
        assetNo: _assetInputController.text,
        modelNo: _modelInputController.text,
        serialNo: _serialInputController.text,
        deviceType: _selectedDeviceType!,
        assetStatus: _selectedAssetStatus!,
        receivedDate: _selectedReceivedDate,
        warrantyDate: _selectedWarrantyDate!,
        hostName: _hostNameInputController.text,
        ipPort: _ipPortInputController.text,
        macAddress: _macAddressInputController.text,
        osVersion: _osVersionInputController.text,
        facePlateName: _facePlateNameInputController.text,
        switchPort: _switchPortInputController.text,
        switchIpAddress: _switchIpAddressInputController.text,
        assignedTo: _assignedUser,
      );
      widget.onSave(item);
    }
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 12.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    String? Function(String?)? validator,
    Widget? suffixIcon,
    VoidCallback? onTap,
    bool readOnly = false,
    TextInputType? keyboardType,
    int? maxLines = 1,
    FocusNode? focusNode,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          validator: validator,
          onTap: _isViewOnly ? null : onTap,
          readOnly: readOnly || _isViewOnly,
          keyboardType: keyboardType,
          maxLines: maxLines,
          focusNode: focusNode,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline.withAlpha(30),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline.withAlpha(30),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            suffixIcon: suffixIcon,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField<T>({
    required String label,
    required T? value,
    required List<T> items,
    required String Function(T) getDisplayText,
    required void Function(T?) onChanged,
    String? Function(T?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<T>(
          value: value,
          validator: validator,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline.withAlpha(30),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline.withAlpha(30),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
          items: items.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(getDisplayText(item)),
            );
          }).toList(),
          onChanged: _isViewOnly ? null : onChanged,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {
        AppShortcuts.save: VoidCallbackIntent(() {
          if (!_isViewOnly) {
            _saveItem();
          }
        }),
        AppShortcuts.editItem: VoidCallbackIntent(() {
          if (_isViewOnly) {
            setState(() {
              _isViewOnly = false;
            });
          }
        })
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
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                  border: Border(
                    bottom: BorderSide(
                      color:
                          Theme.of(context).colorScheme.outline.withAlpha(20),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _isViewOnly
                          ? Icons.remove_red_eye_outlined
                          : (widget.editingItem == null
                              ? Icons.add_circle_outline
                              : Icons.edit_outlined),
                      color: AppColors.colorAccent,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _isViewOnly
                          ? 'Item Details'
                          : (widget.editingItem == null
                              ? 'Add New Item'
                              : 'Edit Item'),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const Spacer(),
                    if (_isViewOnly)
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            _isViewOnly = false;
                          });
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit'),
                      ),
                    const SizedBox(width: 16),
                    InkWell(
                      onTap: widget.onCancel,
                      child: const Icon(
                        Icons.close,
                      ),
                    ),
                  ],
                ),
              ),
              // Form Content
              Flexible(
                child: Form(
                  key: formKey,
                  child: Scrollbar(
                    controller: _scrollController,
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(20),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final isWide = constraints.maxWidth > 400;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Basic Information Section
                              _buildSectionTitle('Basic Information'),
                              if (isWide)
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildFormField(
                                        label: 'Asset Number',
                                        controller: _assetInputController,
                                        validator:
                                            ItemInputValidator.validateAssetNo,
                                        focusNode: _assetNoFocusNode,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _buildFormField(
                                        label: 'Model Number',
                                        controller: _modelInputController,
                                        validator:
                                            ItemInputValidator.validateModelNo,
                                      ),
                                    ),
                                  ],
                                )
                              else
                                Column(
                                  children: [
                                    _buildFormField(
                                      label: 'Asset Number',
                                      controller: _assetInputController,
                                      validator:
                                          ItemInputValidator.validateAssetNo,
                                      focusNode: _assetNoFocusNode,
                                    ),
                                    const SizedBox(height: 16),
                                    _buildFormField(
                                      label: 'Model Number',
                                      controller: _modelInputController,
                                      validator:
                                          ItemInputValidator.validateModelNo,
                                    ),
                                  ],
                                ),
                              const SizedBox(height: 16),
                              if (isWide)
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildFormField(
                                        label: 'Serial Number',
                                        controller: _serialInputController,
                                        validator:
                                            ItemInputValidator.validateSerialNo,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _buildDropdownField<DeviceType>(
                                        label: 'Device Type',
                                        value: _selectedDeviceType,
                                        items: DeviceType.values,
                                        getDisplayText: (type) => type.name,
                                        validator: ItemInputValidator
                                            .validateDeviceType,
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedDeviceType = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                )
                              else
                                Column(
                                  children: [
                                    _buildFormField(
                                      label: 'Serial Number',
                                      controller: _serialInputController,
                                      validator:
                                          ItemInputValidator.validateSerialNo,
                                    ),
                                    const SizedBox(height: 16),
                                    _buildDropdownField<DeviceType>(
                                      label: 'Device Type',
                                      value: _selectedDeviceType,
                                      items: DeviceType.values,
                                      getDisplayText: (type) => type.name,
                                      validator:
                                          ItemInputValidator.validateDeviceType,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedDeviceType = value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              const SizedBox(height: 16),
                              if (isWide)
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildFormField(
                                        label: 'Received Date',
                                        controller: TextEditingController(
                                          text: _selectedReceivedDate != null
                                              ? DateFormatter
                                                  .extractDateFromDateTime(
                                                      _selectedReceivedDate!)
                                              : "",
                                        ),
                                        readOnly: true,
                                        suffixIcon:
                                            const Icon(Icons.calendar_today),
                                        onTap: () async {
                                          DateTime? pickedDate =
                                              await showDatePicker(
                                            context: context,
                                            initialDate:
                                                _selectedReceivedDate ??
                                                    DateTime.now(),
                                            firstDate: DateTime(1970),
                                            lastDate: DateTime(2038),
                                          );
                                          if (pickedDate != null) {
                                            setState(() {
                                              _selectedReceivedDate =
                                                  pickedDate;
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _buildFormField(
                                        label: 'Warranty Date',
                                        controller: TextEditingController(
                                          text: _selectedWarrantyDate != null
                                              ? DateFormatter
                                                  .extractDateFromDateTime(
                                                      _selectedWarrantyDate!)
                                              : "",
                                        ),
                                        readOnly: true,
                                        validator: ItemInputValidator
                                            .validateWarrantyDate,
                                        suffixIcon:
                                            const Icon(Icons.calendar_today),
                                        onTap: () async {
                                          DateTime? pickedDate =
                                              await showDatePicker(
                                            context: context,
                                            initialDate:
                                                _selectedWarrantyDate ??
                                                    DateTime.now(),
                                            firstDate: DateTime(1970),
                                            lastDate: DateTime(2038),
                                          );
                                          if (pickedDate != null) {
                                            setState(() {
                                              _selectedWarrantyDate =
                                                  pickedDate;
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                )
                              else
                                Column(
                                  children: [
                                    _buildFormField(
                                      label: 'Received Date',
                                      controller: TextEditingController(
                                        text: _selectedReceivedDate != null
                                            ? DateFormatter
                                                .extractDateFromDateTime(
                                                    _selectedReceivedDate!)
                                            : "",
                                      ),
                                      readOnly: true,
                                      suffixIcon:
                                          const Icon(Icons.calendar_today),
                                      onTap: () async {
                                        DateTime? pickedDate =
                                            await showDatePicker(
                                          context: context,
                                          initialDate: _selectedReceivedDate ??
                                              DateTime.now(),
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
                                    const SizedBox(height: 16),
                                    _buildFormField(
                                      label: 'Warranty Date',
                                      controller: TextEditingController(
                                        text: _selectedWarrantyDate != null
                                            ? DateFormatter
                                                .extractDateFromDateTime(
                                                    _selectedWarrantyDate!)
                                            : "",
                                      ),
                                      readOnly: true,
                                      validator: ItemInputValidator
                                          .validateWarrantyDate,
                                      suffixIcon:
                                          const Icon(Icons.calendar_today),
                                      onTap: () async {
                                        DateTime? pickedDate =
                                            await showDatePicker(
                                          context: context,
                                          initialDate: _selectedWarrantyDate ??
                                              DateTime.now(),
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
                                  ],
                                ),
                              const SizedBox(height: 16),
                              _buildDropdownField<AssetStatus>(
                                label: 'Asset Status',
                                value: _selectedAssetStatus,
                                items: AssetStatus.values,
                                getDisplayText: (status) => status.name,
                                validator:
                                    ItemInputValidator.validateAssetStatus,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedAssetStatus = value;
                                  });
                                },
                              ),
                              // Network Configuration Section
                              _buildSectionTitle('Network Configuration'),
                              if (isWide)
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildFormField(
                                        label: 'Host Name',
                                        controller: _hostNameInputController,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _buildFormField(
                                        label: 'IP Address',
                                        controller: _ipPortInputController,
                                      ),
                                    ),
                                  ],
                                )
                              else
                                Column(
                                  children: [
                                    _buildFormField(
                                      label: 'Host Name',
                                      controller: _hostNameInputController,
                                    ),
                                    const SizedBox(height: 16),
                                    _buildFormField(
                                      label: 'IP Address',
                                      controller: _ipPortInputController,
                                    ),
                                  ],
                                ),
                              const SizedBox(height: 16),
                              _buildFormField(
                                label: 'MAC Address',
                                controller: _macAddressInputController,
                              ),
                              const SizedBox(height: 16),
                              if (isWide)
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildFormField(
                                        label: 'Switch Port',
                                        controller: _switchPortInputController,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _buildFormField(
                                        label: 'Switch IP Address',
                                        controller:
                                            _switchIpAddressInputController,
                                      ),
                                    ),
                                  ],
                                )
                              else
                                Column(
                                  children: [
                                    _buildFormField(
                                      label: 'Switch Port',
                                      controller: _switchPortInputController,
                                    ),
                                    const SizedBox(height: 16),
                                    _buildFormField(
                                      label: 'Switch IP Address',
                                      controller:
                                          _switchIpAddressInputController,
                                    ),
                                  ],
                                ),
                              // System Information Section
                              _buildSectionTitle('System Information'),
                              if (isWide)
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildFormField(
                                        label: 'OS Version',
                                        controller: _osVersionInputController,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _buildFormField(
                                        label: 'Face Plate Name',
                                        controller:
                                            _facePlateNameInputController,
                                      ),
                                    ),
                                  ],
                                )
                              else
                                Column(
                                  children: [
                                    _buildFormField(
                                      label: 'OS Version',
                                      controller: _osVersionInputController,
                                    ),
                                    const SizedBox(height: 16),
                                    _buildFormField(
                                      label: 'Face Plate Name',
                                      controller: _facePlateNameInputController,
                                    ),
                                  ],
                                ),
                              const SizedBox(height: 16),
                              _buildDropdownField<User>(
                                label: 'Assigned User',
                                value: _assignedUser,
                                items: widget.usersList,
                                getDisplayText: (user) => user.userName,
                                onChanged: (value) {
                                  setState(() {
                                    _assignedUser = value;
                                  });
                                },
                              ),
                              const SizedBox(height: 32),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              // Action Buttons
              if (!_isViewOnly)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                    border: Border(
                      top: BorderSide(
                        color:
                            Theme.of(context).colorScheme.outline.withAlpha(20),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AppButton(
                        onPressed: widget.onCancel,
                        icon: Icons.cancel,
                        iconColor: AppColors.colorTextDark,
                        text: 'Cancel',
                        backgroundColor: AppColors.colorTextSemiLight,
                        foregroundColor: AppColors.colorTextDark,
                      ),
                      const SizedBox(width: 16),
                      AppButton(
                        onPressed: _saveItem,
                        icon:
                            widget.editingItem == null ? Icons.add : Icons.save,
                        text: widget.editingItem == null
                            ? 'Add Item'
                            : 'Save Changes',
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}