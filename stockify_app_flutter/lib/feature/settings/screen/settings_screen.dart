import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockify_app_flutter/common/data/service/data_service.dart';
import 'package:stockify_app_flutter/common/widget/animations/screen_transition.dart';
import 'package:stockify_app_flutter/common/widget/custom_snackbar.dart';
import 'package:stockify_app_flutter/feature/settings/provider/settings_provider.dart';

import '../../../common/shortcuts/app_shortcuts.dart';
import '../../../common/theme/provider/theme_provider.dart';
import '../../../common/theme/theme.dart';

part '../widget/about_content.dart';
part '../widget/action_button.dart';
part '../widget/button_content.dart';
part '../widget/card_header.dart';
part '../widget/dark_mode_card.dart';
part '../widget/data_management_card.dart';
part '../widget/expandable_card.dart';
part '../widget/generate_report_card.dart';
part '../widget/help_content.dart';
part '../widget/import_result_dialog.dart';
part '../widget/keyboard_shortcuts_card.dart';
part '../widget/keyboard_shortcuts_content.dart';
part '../widget/result_stat.dart';
part '../widget/settings_card.dart';
part '../widget/settings_section.dart';

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
      builder: (context) => _ImportResultDialog(result: result),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SettingsProvider>(context);
    final isDesktop = MediaQuery.of(context).size.width > 800;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        titleSpacing: 0,
        elevation: 0,
      ),
      body: ScreenTransition(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1200),
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 40.0 : 16.0,
              vertical: 24.0,
            ),
            child: ListView(
              children: [
                const _SettingsSection(
                  title: 'Appearance',
                  children: [
                    _DarkModeCard(),
                  ],
                ),
                const SizedBox(height: 24),
                const _SettingsSection(
                  title: 'Productivity',
                  children: [
                    _KeyboardShortcutsCard(),
                    SizedBox(height: 16),
                    _GenerateReportCard(),
                  ],
                ),
                const SizedBox(height: 24),
                _SettingsSection(
                  title: 'Data Management',
                  children: [
                    _DataManagementCard(
                      icon: Icons.upload_file_outlined,
                      title: 'Import Data',
                      subtitle:
                          'Select the file format to import. Excel files must be in .xlsx format (not .xls).',
                      actions: [
                        _ActionButton(
                          label: 'Import CSV',
                          imageAsset: 'assets/icons/csv-icon.png',
                          isPrimary: false,
                          onPressed: () => _handleImport(
                            context,
                            provider.importFromCsvWithOptions,
                          ),
                        ),
                        _ActionButton(
                          label: 'Import Excel',
                          imageAsset:
                              'assets/icons/microsoft-excel-icon-logo.png',
                          isPrimary: false,
                          onPressed: () => _handleImport(
                            context,
                            provider.importFromExcelWithOptions,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _DataManagementCard(
                      icon: Icons.download_for_offline_outlined,
                      title: 'Export Data',
                      subtitle: 'Select the file format of your exported data.',
                      actions: [
                        _ActionButton(
                          label: 'Export CSV',
                          imageAsset: 'assets/icons/csv-icon.png',
                          isPrimary: true,
                          onPressed: () => _handleExport(
                            context,
                            provider.exportToCsv,
                            'CSV',
                          ),
                        ),
                        _ActionButton(
                          label: 'Export Excel',
                          imageAsset:
                              'assets/icons/microsoft-excel-icon-logo.png',
                          isPrimary: true,
                          onPressed: () => _handleExport(
                            context,
                            provider.exportToExcel,
                            'Excel',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const _SettingsSection(
                  title: 'Information',
                  children: [
                    _ExpandableCard(
                      icon: Icons.info_outline,
                      title: 'About',
                      subtitle: 'Learn more about the Stockify app',
                      child: _AboutContent(),
                    ),
                    SizedBox(height: 16),
                    _ExpandableCard(
                      icon: Icons.help_outline,
                      title: 'Help',
                      subtitle:
                          'Get help and answers to frequently asked questions',
                      child: _HelpContent(),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleImport(
    BuildContext context,
    Future<ImportResult> Function(ImportOptions) importFunction,
  ) async {
    try {
      final result = await importFunction(ImportOptions(skipErrors: true));
      if (result.isSuccess) {
        CustomSnackBar.show(
          context: context,
          message: 'Successfully imported ${result.successCount} items!',
          type: SnackBarType.success,
        );
      }
      if (result.hasErrors || result.warnings.isNotEmpty) {
        _showImportResultDialog(context, result);
      }
    } catch (e) {
      CustomSnackBar.show(
        context: context,
        message: 'Error importing: $e',
        type: SnackBarType.error,
      );
    }
  }

  Future<void> _handleExport(
    BuildContext context,
    Future<void> Function() exportFunction,
    String format,
  ) async {
    try {
      await exportFunction();
      CustomSnackBar.show(
        context: context,
        message: 'Items exported successfully to $format!',
        type: SnackBarType.success,
      );
    } catch (e) {
      CustomSnackBar.show(
        context: context,
        message: 'Error exporting $format: $e',
        type: SnackBarType.error,
      );
    }
  }
}