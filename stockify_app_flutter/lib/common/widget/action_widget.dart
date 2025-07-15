import 'package:flutter/material.dart';
import 'package:stockify_app_flutter/common/theme/colors.dart';

class ActionWidget extends StatelessWidget {
  final IconData icon;
  final Function() onTap;
  final message;

  const ActionWidget(
      {super.key,
      required this.icon,
      required this.onTap,
      this.message = 'Tap to perform action'});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Icon(icon, color: AppColors.colorAccent),
      ),
    );
  }
}
