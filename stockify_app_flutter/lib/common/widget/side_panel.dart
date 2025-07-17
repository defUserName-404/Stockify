import 'package:flutter/material.dart';
import 'package:stockify_app_flutter/common/theme/colors.dart';

class SidePanel extends StatelessWidget {
  final bool isOpen;
  final double panelWidth;
  final Widget child;
  final Brightness currentTheme;

  const SidePanel({
    super.key,
    required this.isOpen,
    required this.panelWidth,
    required this.child,
    required this.currentTheme,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      right: isOpen ? 0 : -panelWidth,
      top: 0,
      bottom: 0,
      width: panelWidth,
      child: Material(
        elevation: 16,
        child: Container(
          color: currentTheme == Brightness.light
              ? AppColors.colorBackground
              : AppColors.colorBackgroundDark,
          child: child,
        ),
      ),
    );
  }
}
