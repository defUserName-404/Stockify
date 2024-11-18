import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockify_app_flutter/common/theme/controller/theme_controller.dart';

import '../../../common/theme/theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeController>(context);
    final currentTheme = themeProvider.themeData.brightness;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(children: [
        ListTile(
          leading: Icon(Icons.dark_mode),
          title: Text('Dark Mode'),
          trailing: Switch(
              value: currentTheme == Brightness.dark,
              onChanged: (isDarkMode) {
                if (isDarkMode) {
                  themeProvider.setThemeData(AppTheme.dark);
                } else {
                  themeProvider.setThemeData(AppTheme.light);
                }
              }),
          dense: true,
        )
      ]),
    );
  }
}
