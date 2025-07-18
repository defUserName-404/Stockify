import 'package:flutter/material.dart';
import 'package:stockify_app_flutter/common/theme/colors.dart';

enum SnackBarType { success, error, info }

class CustomSnackBar {
  CustomSnackBar._();

  static Color _getBackgroundColor(SnackBarType type, BuildContext context) {
    switch (type) {
      case SnackBarType.success:
        return AppColors.colorGreen;
      case SnackBarType.error:
        return AppColors.colorPink;
      case SnackBarType.info:
        return Theme.of(context).colorScheme.primary;
    }
  }

  static IconData _getIcon(SnackBarType type, {IconData? icon}) {
    if (icon != null) return icon;
    switch (type) {
      case SnackBarType.success:
        return Icons.check_circle_outline;
      case SnackBarType.error:
        return Icons.error_outline;
      case SnackBarType.info:
        return Icons.info_outline;
    }
  }

  static void show(
      {required BuildContext context,
      required String message,
      required SnackBarType type,
      IconData? icon}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          decoration: BoxDecoration(
            color: _getBackgroundColor(type, context),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getIcon(type),
                color: Colors.white,
              ),
              const SizedBox(width: 12.0),
              Flexible(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        duration: const Duration(seconds: 2),
        dismissDirection: DismissDirection.horizontal,
      ),
    );
  }
}
