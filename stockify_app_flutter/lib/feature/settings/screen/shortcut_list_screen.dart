import 'package:flutter/material.dart';
import 'package:stockify_app_flutter/common/shortcuts/app_shortcuts.dart';

class ShortcutListScreen extends StatelessWidget {
  const ShortcutListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keyboard Shortcuts'),
      ),
      body: ListView.builder(
        itemCount: shortcutList.length,
        itemBuilder: (context, index) {
          final shortcut = shortcutList[index];
          return ListTile(
            title: Text(shortcut.description),
            trailing: Text(shortcut.combination),
          );
        },
      ),
    );
  }
}
