import 'package:flutter/material.dart';

import '../model/asset_status.dart';
import '../model/device_type.dart';
import '../model/item.dart';

class FilterDialog extends StatefulWidget {
  final ItemFilterParams currentParams;
  final Function(ItemFilterParams) onApplyFilter;

  const FilterDialog({
    Key? key,
    required this.currentParams,
    required this.onApplyFilter,
  }) : super(key: key);

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  late ItemFilterParams _params;

  @override
  void initState() {
    super.initState();
    _params = widget.currentParams;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Sort & Filter'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Sort By',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _params.sortBy,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: const [
                DropdownMenuItem(value: 'assetNo', child: Text('Asset No')),
                DropdownMenuItem(value: 'modelNo', child: Text('Model No')),
                DropdownMenuItem(value: 'serialNo', child: Text('Serial No')),
                DropdownMenuItem(
                    value: 'receivedDate', child: Text('Received Date')),
                DropdownMenuItem(
                    value: 'warrantyDate', child: Text('Warranty Date')),
              ],
              onChanged: (value) {
                setState(() {
                  final newParams = _params.copyWith(sortBy: value);
                  widget.onApplyFilter(newParams);
                });
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Ascending'),
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
                    title: const Text('Descending'),
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
            const Text('Filter By',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<DeviceType>(
              value: _params.deviceType,
              decoration: const InputDecoration(
                labelText: 'Device Type',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
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
            DropdownButtonFormField<AssetStatus>(
              value: _params.assetStatus,
              decoration: const InputDecoration(
                labelText: 'Asset Status',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
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
          child: const Text('Reset'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onApplyFilter(_params);
            Navigator.of(context).pop();
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }
}
