import 'package:flutter/material.dart';

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
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(width: 8),
        Text(
          itemText,
          style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
