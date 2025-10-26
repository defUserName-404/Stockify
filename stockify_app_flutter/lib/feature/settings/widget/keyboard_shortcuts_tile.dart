import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockify_app_flutter/common/shortcuts/app_shortcuts.dart';
import 'package:stockify_app_flutter/common/theme/colors.dart';
import 'package:stockify_app_flutter/feature/settings/provider/settings_provider.dart';

class KeyboardShortcutsTile extends StatelessWidget {
  const KeyboardShortcutsTile({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.keyboard_sharp),
          title: const Text('Keyboard Shortcuts'),
          subtitle: const Text('View all available keyboard shortcuts'),
          trailing: Icon(
            settingsProvider.showShortcuts
                ? Icons.expand_less
                : Icons.expand_more,
          ),
          onTap: () {
            settingsProvider.toggleShortcuts();
          },
        ),
        if (settingsProvider.showShortcuts)
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: shortcutList.length,
              itemBuilder: (context, index) {
                final shortcut = shortcutList[index];
                return ListTile(
                  title: Text(shortcut.description),
                  trailing: Text(
                    shortcut.combination,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.colorAccent,
                        ),
                  ),
                  leading: Icon(shortcut.icon),
                );
              },
            ),
          ),
      ],
    );
  }
}
