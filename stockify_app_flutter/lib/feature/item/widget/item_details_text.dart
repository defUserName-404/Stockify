import 'package:flutter/material.dart';
import 'package:stockify_app_flutter/common/theme/colors.dart';

class ItemDetailsText extends StatelessWidget {
  const ItemDetailsText(
      {super.key, required this.itemText, required this.label});

  final String itemText;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 8),
        Text(
          itemText,
          style: TextStyle(fontSize: 16, color: AppColors.colorAccent),
        ),
      ],
    );
  }
}
