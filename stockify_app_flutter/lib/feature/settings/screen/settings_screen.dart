import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockify_app_flutter/common/shortcuts/app_shortcuts.dart';
import 'package:stockify_app_flutter/common/widget/animations/screen_transition.dart';
import 'package:stockify_app_flutter/common/widget/custom_snackbar.dart';

import '../../../common/data/service/data_service.dart';
import '../../../common/theme/colors.dart';
import '../../../common/theme/provider/theme_provider.dart';
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
    final themeProvider = Provider.of<ThemeProvider>(context);
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
                value: themeProvider.themeData == AppTheme.dark,
                onChanged: (isDarkMode) {
                  themeProvider.toggleTheme();
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
                    CustomSnackBar.show(
                      context: context,
                      message: 'Report generated successfully!',
                      type: SnackBarType.success,
                    );
                  } else {
                    CustomSnackBar.show(
                      context: context,
                      message: 'Report generation cancelled.',
                      type: SnackBarType.error,
                    );
                  }
                } catch (e) {
                  CustomSnackBar.show(
                    context: context,
                    message: 'Error generating report: $e',
                    type: SnackBarType.error,
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
                  _buildImportExportButtons(
                      text: 'CSV',
                      onPressed: () async {
                        try {
                          await dataService.importItemsFromCsv();
                          CustomSnackBar.show(
                            context: context,
                            message: 'Items imported successfully from CSV!',
                            type: SnackBarType.success,
                          );
                        } catch (e) {
                          CustomSnackBar.show(
                            context: context,
                            message: 'Error importing CSV: $e',
                            type: SnackBarType.error,
                          );
                        }
                      },
                      imageAsset: 'assets/icons/csv-icon.png'),
                  const SizedBox(width: 16),
                  _buildImportExportButtons(
                      text: 'Excel',
                      onPressed: () async {
                        try {
                          await dataService.importItemsFromExcel();
                          CustomSnackBar.show(
                            context: context,
                            message: 'Items imported successfully from Excel!',
                            type: SnackBarType.success,
                          );
                        } catch (e) {
                          CustomSnackBar.show(
                            context: context,
                            message: 'Error importing Excel: $e',
                            type: SnackBarType.error,
                          );
                        }
                      },
                      imageAsset: 'assets/icons/microsoft-excel-icon-logo.png'),
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
                  _buildImportExportButtons(
                      text: 'CSV',
                      onPressed: () async {
                        try {
                          await dataService.exportItemsToCsv();
                          CustomSnackBar.show(
                            context: context,
                            message: 'Items exported successfully to CSV!',
                            type: SnackBarType.success,
                          );
                        } catch (e) {
                          CustomSnackBar.show(
                            context: context,
                            message: 'Error exporting CSV: $e',
                            type: SnackBarType.error,
                          );
                        }
                      },
                      imageAsset: 'assets/icons/csv-icon.png'),
                  const SizedBox(width: 16),
                  _buildImportExportButtons(
                    text: 'Excel',
                    onPressed: () async {
                      try {
                        await dataService.exportItemsToExcel();
                        CustomSnackBar.show(
                          context: context,
                          message: 'Items exported successfully to Excel!',
                          type: SnackBarType.success,
                        );
                      } catch (e) {
                        CustomSnackBar.show(
                          context: context,
                          message: 'Error exporting Excel: $e',
                          type: SnackBarType.error,
                        );
                      }
                    },
                    imageAsset: 'assets/icons/microsoft-excel-icon-logo.png',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImportExportButtons(
      {required String text,
      required VoidCallback onPressed,
      required String imageAsset}) {
    return TextButton(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            imageAsset,
            width: 24,
            height: 24,
            color: AppColors.colorAccent,
          ),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontSize: 16)),
        ],
      ),
      onPressed: onPressed,
    );
  }
}
