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
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        children: [
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Dark Mode'),
            subtitle: const Text('Toggle dark mode'),
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
            title: const Text('Import Data'),
            subtitle: Text(
                'This will not overwrite existing data. Select the file format you want to import.'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  child: const Text('CSV'),
                  onPressed: () async {
                    await dataService.importItemsFromCsv();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Items imported successfully!')),
                    );
                  },
                ),
                TextButton(
                  child: const Text('Excel'),
                  onPressed: () async {
                    await dataService.importItemsFromExcel();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text('Items imported successfully from Excel!')),
                    );
                  },
                ),
              ],
            ),
            onTap: () async {
              try {
                await dataService.importItemsFromCsv();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Items imported successfully!')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error importing CSV: $e')),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.download_for_offline),
            title: const Text('Export Data'),
            subtitle: Text('Select the file format you want to export.'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  child: const Text('CSV'),
                  onPressed: () async {
                    await dataService.exportItemsToCsv();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Items exported successfully to CSV!')),
                    );
                  },
                ),
                TextButton(
                  child: const Text('Excel'),
                  onPressed: () async {
                    await dataService.exportItemsToExcel();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text('Items exported successfully to Excel!')),
                    );
                  },
                ),
              ],
            ),
            onTap: () async {
              try {
                await dataService.exportItemsToCsv();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Items exported successfully to CSV!')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error exporting CSV: $e')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
