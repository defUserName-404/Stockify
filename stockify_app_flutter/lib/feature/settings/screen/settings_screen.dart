import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockify_app_flutter/common/shortcuts/app_shortcuts.dart';

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

class _SettingsScreenState extends State<SettingsScreen>
    with TickerProviderStateMixin {
  bool _showShortcuts = false;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
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
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
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
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
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
                            SnackBar(
                                content: Text('Error importing Excel: $e')),
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
                                content: Text(
                                    'Items exported successfully to CSV!')),
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
                            SnackBar(
                                content: Text('Error exporting Excel: $e')),
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
      ),
    );
  }
}
