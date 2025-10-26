import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockify_app_flutter/common/theme/provider/theme_provider.dart';

import '../../../common/theme/theme.dart';

class DarkModeTile extends StatelessWidget {
  const DarkModeTile({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return ListTile(
      leading: const Icon(Icons.dark_mode),
      title: const Text('Dark Mode'),
      subtitle: const Text('Toggle dark mode'),
      trailing: Switch(
        value: themeProvider.themeData == AppTheme.dark,
        onChanged: (isDarkMode) {
          themeProvider.toggleTheme();
        },
      ),
    );
  }
}
