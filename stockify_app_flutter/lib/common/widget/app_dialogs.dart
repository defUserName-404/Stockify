import 'package:flutter/material.dart';
import 'package:stockify_app_flutter/common/theme/colors.dart';
import 'package:stockify_app_flutter/feature/item/model/item_filter_param.dart';
import 'package:stockify_app_flutter/feature/user/model/user.dart';
import 'package:stockify_app_flutter/feature/user/model/user_filter_param.dart';

import '../../feature/item/widget/item_filter_dialog.dart';
import '../../feature/user/widget/user_filter_dialog.dart';

class AppDialogs {
  AppDialogs._();

  static Future<void> showDetailsDialog({
    required BuildContext context,
    required String title,
    required Widget content,
    required IconData icon,
  }) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Row(
          children: [
            Icon(
              icon,
              color: AppColors.colorAccent,
            ),
            const SizedBox(width: 8.0),
            Text(title),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        content: content,
        actions: [
          TextButton(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.close),
                const SizedBox(width: 8),
                const Text('Close'),
              ],
            ),
            style: Theme.of(context).textButtonTheme.style!.copyWith(
                  foregroundColor:
                      WidgetStateProperty.all<Color>(AppColors.colorTextDark),
                  backgroundColor: WidgetStateProperty.all<Color>(
                      AppColors.colorTextSemiLight),
                ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  static Future<bool?> showDeleteConfirmationDialog({
    required BuildContext context,
    required String itemName,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        title: Row(
          children: [
            const Icon(
              Icons.dangerous_rounded,
              color: AppColors.colorAccent,
            ),
            const SizedBox(width: 8),
            const Text('Confirm Deletion'),
          ],
        ),
        content: Text('Are you sure you want to delete this $itemName?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            style: Theme.of(context).textButtonTheme.style!.copyWith(
                  foregroundColor:
                      WidgetStateProperty.all<Color>(AppColors.colorTextDark),
                  backgroundColor: WidgetStateProperty.all<Color>(
                      AppColors.colorTextSemiLight),
                ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.cancel_outlined),
                const SizedBox(width: 8),
                const Text('Cancel'),
              ],
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: Theme.of(context).textButtonTheme.style!.copyWith(
                  foregroundColor:
                      WidgetStateProperty.all<Color>(AppColors.colorText),
                  backgroundColor:
                      WidgetStateProperty.all<Color>(AppColors.colorPink),
                ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.delete),
                const SizedBox(width: 8),
                const Text('Yes'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Future<void> showItemFilterDialog({
    required BuildContext context,
    required ItemFilterParams currentParams,
    required Function(ItemFilterParams) onApplyFilter,
    required List<User> usersList,
  }) {
    return showDialog(
      context: context,
      builder: (context) => ItemFilterDialog(
        currentParams: currentParams,
        onApplyFilter: onApplyFilter,
        usersList: usersList,
      ),
    );
  }

  static Future<void> showUserFilterDialog({
    required BuildContext context,
    required UserFilterParams currentParams,
    required Function(UserFilterParams) onApplyFilter,
  }) {
    return showDialog(
      context: context,
      builder: (context) => UserFilterDialog(
        currentParams: currentParams,
        onApplyFilter: onApplyFilter,
      ),
    );
  }
}
