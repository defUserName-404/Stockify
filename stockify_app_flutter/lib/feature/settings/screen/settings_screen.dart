import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockify_app_flutter/common/shortcuts/app_shortcuts.dart';
import 'package:stockify_app_flutter/common/widget/animations/screen_transition.dart';

import '../../../common/data/service/data_service.dart';
import '../../../common/shared-preference/shared_preference_service.dart';
import '../../../common/theme/colors.dart';
import '../../../common/theme/controller/theme_controller.dart';
import '../../../common/theme/theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _showShortcuts = false;

  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
      body: ScreenTransition(
        child: ListView(
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
                  themeProvider.setThemeData(
                      isDarkMode ? AppTheme.dark : AppTheme.light);
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.keyboard_sharp),
              title: const Text('Keyboard Shortcuts'),
              subtitle: const Text('View all available keyboard shortcuts'),
              trailing: Icon(
                _showShortcuts ? Icons.expand_less : Icons.expand_more,
              ),
              onTap: () {
                setState(() {
                  _showShortcuts = !_showShortcuts;
                });
              },
            ),
            if (_showShortcuts)
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
            ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              title: const Text('Generate Report'),
              subtitle: const Text('Generate a PDF report of the inventory.'),
              onTap: () async {
                try {
                  String? outputFile = await FilePicker.platform.saveFile(
                    dialogTitle: 'Save Report',
                    fileName: 'inventory_report.pdf',
                    type: FileType.custom,
                    allowedExtensions: ['pdf'],
                  );
                  if (outputFile != null) {
                    await dataService.generatePdfReport(filePath: outputFile);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Report generated successfully!')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Report generation cancelled.')),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error generating report: $e')),
                  );
                }
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
                              content: Text(
                                  'Items imported successfully from CSV!')),
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
                              content: Text(
                                  'Items exported successfully to Excel!')),
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
      ),
    );
  }
}
