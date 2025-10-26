import 'package:flutter/material.dart';
import 'package:stockify_app_flutter/common/theme/colors.dart';

class ImportExportButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final String imageAsset;

  const ImportExportButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.imageAsset,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            imageAsset,
            width: 24,
            height: 24,
            color: AppColors.colorAccent,
          ),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
