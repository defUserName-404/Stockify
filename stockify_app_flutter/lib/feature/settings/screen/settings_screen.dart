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
                  'Select the file format of your imported data. Please note that this will not overwrite any existing data.',
              buttons: [
                ImportExportButton(
                  text: 'CSV',
                  onPressed: () async {
                    try {
                      await provider.importFromCsv();
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
                  imageAsset: 'assets/icons/csv-icon.png',
                ),
                const SizedBox(width: 16),
                ImportExportButton(
                  text: 'Excel',
                  onPressed: () async {
                    try {
                      await provider.importFromExcel();
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
