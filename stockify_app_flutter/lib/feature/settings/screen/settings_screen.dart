import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockify_app_flutter/feature/settings/screen/shortcut_list_screen.dart';

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
            leading: const Icon(Icons.keyboard_sharp),
            title: const Text('Keyboard Shortcuts'),
            subtitle: const Text('View all available keyboard shortcuts'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ShortcutListScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.upload_file),
            title: const Text('Import Data'),
            subtitle: const Text(
                'Select the file format of your imported data. Please note that this will not overwrite any existing data.'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  child: const Text('CSV'),
                  onPressed: () async {
                    try {
                      await dataService.importItemsFromCsv();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Items imported successfully from CSV!')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error importing CSV: $e')),
                      );
                    }
                  },
                ),
                const SizedBox(width: 16),
                TextButton(
                  child: const Text('Excel'),
                  onPressed: () async {
                    try {
                      await dataService.importItemsFromExcel();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Items imported successfully from Excel!')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error importing Excel: $e')),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.download_for_offline),
            title: const Text('Export Data'),
            subtitle:
                const Text('Select the file format of your exported data.'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  child: const Text('CSV'),
                  onPressed: () async {
                    try {
                      await dataService.exportItemsToCsv();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Items exported successfully to CSV!')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error exporting CSV: $e')),
                      );
                    }
                  },
                ),
                const SizedBox(width: 16),
                TextButton(
                  child: const Text('Excel'),
                  onPressed: () async {
                    try {
                      await dataService.exportItemsToExcel();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Items exported successfully to Excel!')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error exporting Excel: $e')),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
