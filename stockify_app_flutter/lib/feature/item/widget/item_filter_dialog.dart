import 'package:flutter/material.dart';
import 'package:stockify_app_flutter/common/helpers/date_formatter.dart';
import 'package:stockify_app_flutter/feature/user/model/user.dart';

import '../../../common/theme/colors.dart';
import '../model/asset_status.dart';
import '../model/device_type.dart';
import '../model/item_filter_param.dart';

class ItemFilterDialog extends StatefulWidget {
  final ItemFilterParams currentParams;
  final Function(ItemFilterParams) onApplyFilter;
  final List<User> usersList;

  const ItemFilterDialog({
    Key? key,
    required this.currentParams,
    required this.onApplyFilter,
    required this.usersList,
  }) : super(key: key);

  @override
  State<ItemFilterDialog> createState() => _ItemFilterDialogState();
}

class _ItemFilterDialogState extends State<ItemFilterDialog> {
  late ItemFilterParams _params;
  late TextEditingController _warrantyDateController;

  @override
  void initState() {
    super.initState();
    _params = widget.currentParams;
    _warrantyDateController = TextEditingController(
        text: _params.warrantyDate != null
            ? DateFormatter.extractDateFromDateTime(_params.warrantyDate!)
            : '');
  }

  @override
  void dispose() {
    _warrantyDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Icon(
            Icons.filter_list_alt,
            color: AppColors.colorAccent,
          ),
          const SizedBox(width: 8),
          const Text('Sort & Filter'),
        ],
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Sort By',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String?>(
              value: _params.sortBy,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: const [
                DropdownMenuItem(value: null, child: Text('Default')),
                DropdownMenuItem(value: 'asset_no', child: Text('Asset No')),
                DropdownMenuItem(value: 'model_no', child: Text('Model No')),
                DropdownMenuItem(value: 'serial_no', child: Text('Serial No')),
                DropdownMenuItem(
                    value: 'received_date', child: Text('Received Date')),
                DropdownMenuItem(
                    value: 'warranty_date', child: Text('Warranty Date')),
              ],
              onChanged: (value) {
                setState(() {
                  _params = _params.copyWith(sortBy: value);
                });
              },
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: Row(
                      children: [
                        const Icon(Icons.arrow_upward),
                        const SizedBox(width: 8),
                        const Text('Ascending'),
                      ],
                    ),
                    value: 'ASC',
                    groupValue: _params.sortOrder,
                    onChanged: (value) {
                      setState(() {
                        _params = _params.copyWith(sortOrder: value);
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: Row(
                      children: [
                        const Icon(Icons.arrow_downward),
                        const SizedBox(width: 8),
                        const Text('Descending'),
                      ],
                    ),
                    value: 'DESC',
                    groupValue: _params.sortOrder,
                    onChanged: (value) {
                      setState(() {
                        _params = _params.copyWith(sortOrder: value);
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Device Type',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<DeviceType>(
              value: _params.deviceType,
              items: [
                const DropdownMenuItem(
                    value: null, child: Text('All Device Types')),
                ...DeviceType.values.map((type) =>
                    DropdownMenuItem(value: type, child: Text(type.name))),
              ],
              onChanged: (value) {
                setState(() {
                  _params = _params.copyWith(deviceType: value);
                });
              },
            ),
            const SizedBox(height: 12),
            const Text('Asset Status',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<AssetStatus>(
              value: _params.assetStatus,
              items: [
                const DropdownMenuItem(value: null, child: Text('All Status')),
                ...AssetStatus.values.map((status) =>
                    DropdownMenuItem(value: status, child: Text(status.name))),
              ],
              onChanged: (value) {
                setState(() {
                  _params = _params.copyWith(assetStatus: value);
                });
              },
            ),
            const SizedBox(height: 16),
            const Text('Assigned User',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<User>(
              value: _params.assignedTo,
              items: [
                const DropdownMenuItem(value: null, child: Text('All Users')),
                ...widget.usersList.map((user) =>
                    DropdownMenuItem(value: user, child: Text(user.userName))),
              ],
              onChanged: (value) {
                setState(() {
                  _params = _params.copyWith(assignedTo: value);
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            setState(() {
              _params = ItemFilterParams();
            });
          },
          style: Theme.of(context).textButtonTheme.style!.copyWith(
                foregroundColor:
                    WidgetStateProperty.all<Color>(AppColors.colorTextDark),
                backgroundColor: WidgetStateProperty.all<Color>(
                  AppColors.colorTextSemiLight,
                ),
              ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.refresh),
              const SizedBox(width: 8),
              const Text('Reset'),
            ],
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: Theme.of(context).textButtonTheme.style!.copyWith(
                foregroundColor:
                    WidgetStateProperty.all<Color>(AppColors.colorTextDark),
                backgroundColor: WidgetStateProperty.all<Color>(
                  AppColors.colorTextSemiLight,
                ),
              ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cancel),
              const SizedBox(width: 8),
              const Text('Cancel'),
            ],
          ),
        ),
        TextButton(
          onPressed: () {
            widget.onApplyFilter(_params);
            Navigator.of(context).pop();
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check),
              const SizedBox(width: 8),
              const Text('Apply'),
            ],
          ),
        ),
      ],
    );
  }
}
