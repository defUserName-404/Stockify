import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/data/service/data_service.dart';
import '../../../common/shared-preference/shared_preference_service.dart';
import '../../../common/theme/controller/theme_controller.dart';
import '../../../common/theme/theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sharedPrefs = Provider.of<SharedPrefsService>(context);
    final themeProvider = Provider.of<ThemeController>(context, listen: false);
    final dataService = DataService.instance;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        titleSpacing: 0,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Dark Mode'),
            trailing: Switch(
              value: sharedPrefs.isDarkMode,
              onChanged: (isDarkMode) {
                sharedPrefs.toggleDarkMode(isDarkMode);
                themeProvider
                    .setThemeData(isDarkMode ? AppTheme.dark : AppTheme.light);
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.upload_file),
            title: const Text('Import Data (CSV)'),
            onTap: () => dataService.importItemsFromCsv(context),
          ),
          ListTile(
            leading: const Icon(Icons.download_for_offline),
            title: const Text('Export Data (CSV)'),
            onTap: () => dataService.exportItemsToCsv(context),
          ),
          ListTile(
            leading: const Icon(Icons.upload_file),
            title: const Text('Import Data (Excel)'),
            onTap: () => dataService.importItemsFromExcel(context),
          ),
          ListTile(
            leading: const Icon(Icons.download_for_offline),
            title: const Text('Export Data (Excel)'),
            onTap: () => dataService.exportItemsToExcel(context),
          ),
        ],
      ),
    );
  }
}
