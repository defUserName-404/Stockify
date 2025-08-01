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
        return Icons.check_circle;
      case SnackBarType.error:
        return Icons.error;
      case SnackBarType.info:
        return Icons.info;
    }
  }

  static void show({
    required BuildContext context,
    required String message,
    required SnackBarType type,
    IconData? icon,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width - 32,
            ),
            child: Material(
              elevation: 6,
              borderRadius: BorderRadius.circular(16),
              shadowColor: Colors.black26,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                decoration: BoxDecoration(
                  color: _getBackgroundColor(type, context),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(20),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IntrinsicWidth(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(30),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          _getIcon(type, icon: icon),
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      Flexible(
                        child: Text(
                          message,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        duration: const Duration(seconds: 3),
        dismissDirection: DismissDirection.horizontal,
        margin: const EdgeInsets.only(
          bottom: 16,
          left: 16,
          right: 16,
        ),
        padding: EdgeInsets.zero,
      ),
    );
  }
}