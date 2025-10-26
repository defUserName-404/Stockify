import 'package:flutter/material.dart';

class DataManagementTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Widget> buttons;

  const DataManagementTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.buttons,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: buttons,
      ),
    );
  }
}
