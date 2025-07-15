import 'package:flutter/material.dart';
import 'package:stockify_app_flutter/feature/user/model/user_filter_param.dart';

class UserFilterDialog extends StatefulWidget {
  final UserFilterParams currentParams;
  final Function(UserFilterParams) onApplyFilter;

  const UserFilterDialog({
    Key? key,
    required this.currentParams,
    required this.onApplyFilter,
  }) : super(key: key);

  @override
  State<UserFilterDialog> createState() => _UserFilterDialogState();
}

class _UserFilterDialogState extends State<UserFilterDialog> {
  late UserFilterParams _params;

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
            DropdownButtonFormField<String?>(
              value: _params.sortBy,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: const [
                DropdownMenuItem(value: null, child: Text('Default')),
                DropdownMenuItem(value: 'user_name', child: Text('User Name')),
                DropdownMenuItem(
                    value: 'designation', child: Text('Designation')),
                DropdownMenuItem(value: 'sap_id', child: Text('SAP ID')),
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
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            setState(() {
              _params = UserFilterParams();
            });
          },
          child: const Text('Reset'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
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
