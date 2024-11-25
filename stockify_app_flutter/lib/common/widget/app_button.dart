import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color? iconColor;
  final String text;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const AppButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.iconColor,
    required this.text,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor),
          SizedBox(width: 8.0),
          Text(text),
        ],
      ),
    );
  }
}
