import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockify_app_flutter/common/shortcuts/app_shortcuts.dart';
import 'package:stockify_app_flutter/feature/item/screen/item_screen.dart';
import 'package:stockify_app_flutter/feature/notification/screen/notification_screen.dart';
import 'package:stockify_app_flutter/feature/user/screen/user_screen.dart';

import '../../../feature/dashboard/screen/dashboard_screen.dart';
import '../../../feature/item/model/item_filter_param.dart';
import '../../../feature/notification/model/app_notification.dart';
import '../../../feature/notification/service/notification_storage_service.dart';
import '../../../feature/settings/screen/settings_screen.dart';
import '../../shared-preference/shared_preference_service.dart';

part 'app_layout_large.dart';
part 'app_layout_small.dart';

part 'nav_button.dart';

part 'sidebar/bottom_navigation_section.dart';

part 'sidebar/header_toggle_button.dart';

part 'sidebar/notification_badge.dart';

part 'sidebar/sidebar.dart';

part 'sidebar/sidebar_header.dart';

part 'sidebar/resize_handle.dart';

part 'sidebar/section_label.dart';

class AppLayout extends StatefulWidget {
  const AppLayout({super.key});

  static final GlobalKey<_AppLayoutState> navigatorKey =
      GlobalKey<_AppLayoutState>();

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  int _selectedIndex = 0;
  ItemFilterParams? _currentFilterParams = null;
  bool _openAddItemPanel = false;
  late double _railWidth;
  bool _isExtended = false;
  bool _showLabels = false;
  final double _minRailWidth = 80;
  final double _maxRailWidth = 250;
  final double _minRailLabelThreshold = 150;

  @override
  void initState() {
    super.initState();
    final sharedPrefs = Provider.of<SharedPrefsService>(context, listen: false);
    _railWidth = sharedPrefs.railWidth;
    _isExtended = _railWidth > _minRailWidth;
    _showLabels = _railWidth > _minRailLabelThreshold;
  }

  void _updateRailWidth(double newWidth) {
    final sharedPrefs = Provider.of<SharedPrefsService>(context, listen: false);
    setState(() {
      _railWidth = newWidth.clamp(_minRailWidth, _maxRailWidth);
      _showLabels = _railWidth > _minRailLabelThreshold;
      _isExtended = _railWidth > _minRailWidth;
      sharedPrefs.setRailWidth(_railWidth);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {
        AppShortcuts.goToDashboard:
            VoidCallbackIntent(() => updateSelectedScreen(0)),
        AppShortcuts.goToItems:
            VoidCallbackIntent(() => updateSelectedScreen(1)),
        AppShortcuts.goToUsers:
            VoidCallbackIntent(() => updateSelectedScreen(2)),
        AppShortcuts.goToNotifications:
            VoidCallbackIntent(() => updateSelectedScreen(3)),
        AppShortcuts.goToSettings:
            VoidCallbackIntent(() => updateSelectedScreen(4)),
      },
      child: Actions(
        actions: {
          VoidCallbackIntent: CallbackAction<VoidCallbackIntent>(
            onInvoke: (intent) => intent.callback(),
          ),
        },
        child: FocusScope(
          autofocus: true,
          child: Scaffold(
            body: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 600) {
                  return _AppLayoutSmall(
                    selectedIndex: _selectedIndex,
                    updateSelectedScreen: updateSelectedScreen,
                    getSelectedScreen: _getSelectedScreen,
                  );
                } else {
                  return _AppLayoutLarge(
                    selectedIndex: _selectedIndex,
                    railWidth: _railWidth,
                    isExtended: _isExtended,
                    showLabels: _showLabels,
                    minRailWidth: _minRailWidth,
                    maxRailWidth: _maxRailWidth,
                    updateRailWidth: _updateRailWidth,
                    updateSelectedScreen: updateSelectedScreen,
                    getSelectedScreen: _getSelectedScreen,
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _getSelectedScreen(int index) {
    if (index != 1) {
      _currentFilterParams = null;
    }
    switch (index) {
      case 0:
        return const DashboardScreen();
      case 1:
        return ItemScreen(
            filterParams: _currentFilterParams,
            openAddItemPanel: _openAddItemPanel);
      case 2:
        return UserScreen();
      case 3:
        return const NotificationScreen();
      case 4:
        return const SettingsScreen();
      default:
        return const Center(child: Text("Page not found"));
    }
  }

  void updateSelectedScreen(int index,
      {ItemFilterParams? itemFilterParams, bool openAddItemPanel = false}) {
    setState(() {
      _selectedIndex = index;
      _currentFilterParams = itemFilterParams;
      _openAddItemPanel = openAddItemPanel;
    });
  }
}
