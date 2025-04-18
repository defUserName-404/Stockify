import 'package:flutter/material.dart';
import 'package:stockify_app_flutter/common/theme/colors.dart';

class ActionWidget extends StatelessWidget {
  final IconData icon;
  final Function() onTap;

  const ActionWidget({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, color: AppColors.colorAccent),
    );
  }
}
