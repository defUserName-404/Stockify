import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockify_app_flutter/common/data/service/data_service.dart';
import 'package:stockify_app_flutter/common/widget/animations/screen_transition.dart';
import 'package:stockify_app_flutter/common/widget/custom_snackbar.dart';
import 'package:stockify_app_flutter/feature/settings/provider/settings_provider.dart';
import 'package:stockify_app_flutter/feature/settings/widget/dark_mode_tile.dart';
import 'package:stockify_app_flutter/feature/settings/widget/data_management_tile.dart';
import 'package:stockify_app_flutter/feature/settings/widget/generate_report_tile.dart';
import 'package:stockify_app_flutter/feature/settings/widget/import_export_buttons.dart';
import 'package:stockify_app_flutter/feature/settings/widget/keyboard_shortcuts_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SettingsProvider(DataService.instance),
      child: const _SettingsScreenContent(),
    );
  }
}

class _SettingsScreenContent extends StatelessWidget {
  const _SettingsScreenContent();

  void _showImportResultDialog(BuildContext context, ImportResult result) {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Row(
              children: [
                Icon(
                  result.hasErrors && result.successCount == 0
                      ? Icons.error_outline
                      : result.hasErrors
                      ? Icons.warning_amber_rounded
                      : Icons.check_circle_outline,
                  color: result.hasErrors && result.successCount == 0
                      ? Colors.red
                      : result.hasErrors
                      ? Colors.orange
                      : Colors.green,
                ),
                const SizedBox(width: 8),
                Text(
                  result.hasErrors && result.successCount == 0
                      ? 'Import Failed'
                      : result.hasErrors
                      ? 'Import Completed with Errors'
                      : 'Import Successful',
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total Rows: ${result.totalRows}'),
                  Text('Successfully Imported: ${result.successCount}',
                      style: const TextStyle(color: Colors.green)),
                  if (result.updatedCount > 0)
                    Text('Updated: ${result.updatedCount}',
                        style: const TextStyle(color: Colors.blue)),
                  if (result.errorCount > 0)
                    Text('Errors: ${result.errorCount}',
                        style: const TextStyle(color: Colors.red)),
                  if (result.warnings.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const Text('Warnings:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    ...result.warnings.take(5).map((w) =>
                        Text('• $w',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.orange))),
                    if (result.warnings.length > 5)
                      Text('... and ${result.warnings.length - 5} more',
                          style: const TextStyle(fontSize: 12)),
                  ],
                  if (result.errors.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const Text('Errors:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    ...result.errors.take(5).map((e) =>
                        Text('• ${e.toString()}',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.red))),
                    if (result.errors.length > 5)
                      Text('... and ${result.errors.length - 5} more errors',
                          style: const TextStyle(fontSize: 12)),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SettingsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        titleSpacing: 0,
      ),
      body: ScreenTransition(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          children: [
            const DarkModeTile(),
            const KeyboardShortcutsTile(),
            const GenerateReportTile(),
            DataManagementTile(
              icon: Icons.upload_file,
              title: 'Import Data',
              subtitle:
              'Select the file format to import. Excel files must be in .xlsx format (not .xls).',
              buttons: [
                ImportExportButton(
                  text: 'CSV',
                  onPressed: () async {
                    try {
                      final result = await provider.importFromCsvWithOptions(
                        ImportOptions(skipErrors: true),
                      );

                      if (result.isSuccess) {
                        CustomSnackBar.show(
                          context: context,
                          message:
                          'Successfully imported ${result.successCount} items!',
                          type: SnackBarType.success,
                        );
                      }

                      if (result.hasErrors || result.warnings.isNotEmpty) {
                        _showImportResultDialog(context, result);
                      }
                    } catch (e) {
                      CustomSnackBar.show(
                        context: context,
                        message: 'Error importing CSV: $e',
                        type: SnackBarType.error,
                      );
                    }
                  },
                  imageAsset: 'assets/icons/csv-icon.png',
                ),
                const SizedBox(width: 16),
                ImportExportButton(
                  text: 'Excel',
                  onPressed: () async {
                    try {
                      final result = await provider.importFromExcelWithOptions(
                        ImportOptions(skipErrors: true),
                      );

                      if (result.isSuccess) {
                        CustomSnackBar.show(
                          context: context,
                          message:
                          'Successfully imported ${result.successCount} items!',
                          type: SnackBarType.success,
                        );
                      }

                      if (result.hasErrors || result.warnings.isNotEmpty) {
                        _showImportResultDialog(context, result);
                      }
                    } catch (e) {
                      CustomSnackBar.show(
                        context: context,
                        message: 'Error importing Excel: $e',
                        type: SnackBarType.error,
                      );
                    }
                  },
                  imageAsset: 'assets/icons/microsoft-excel-icon-logo.png',
                ),
              ],
            ),
            DataManagementTile(
              icon: Icons.download_for_offline,
              title: 'Export Data',
              subtitle: 'Select the file format of your exported data.',
              buttons: [
                ImportExportButton(
                  text: 'CSV',
                  onPressed: () async {
                    try {
                      await provider.exportToCsv();
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
                  imageAsset: 'assets/icons/csv-icon.png',
                ),
                const SizedBox(width: 16),
                ImportExportButton(
                  text: 'Excel',
                  onPressed: () async {
                    try {
                      await provider.exportToExcel();
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
          ],
        ),
      ),
    );
  }
}