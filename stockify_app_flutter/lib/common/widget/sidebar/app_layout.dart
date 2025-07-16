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
import '../../theme/colors.dart';

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
  late double _railWidth;
  bool _isExtended = false;
  bool _showLabels = false;
  final double _minRailWidth = 80;
  final double _maxRailWidth = 250;
  final double _minRailLabelThreshold = 100;

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
                  return _buildSmallScreenLayout();
                } else {
                  return _buildLargeScreenLayout();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSmallScreenLayout() {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: _getSelectedScreen(_selectedIndex),
          ),
        ),
        BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: updateSelectedScreen,
          items: [
            BottomNavigationBarItem(
              icon: Icon(_selectedIndex == 0
                  ? Icons.dashboard
                  : Icons.dashboard_outlined),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(_selectedIndex == 1
                  ? Icons.inventory_2
                  : Icons.inventory_2_outlined),
              label: 'Items',
            ),
            BottomNavigationBarItem(
              icon: Icon(_selectedIndex == 2
                  ? Icons.account_circle
                  : Icons.account_circle_outlined),
              label: 'Users',
            ),
            BottomNavigationBarItem(
              icon: Consumer<NotificationStorageService>(
                builder: (context, notificationService, child) {
                  return FutureBuilder<List<AppNotification>>(
                    future: notificationService.getNotifications(),
                    builder: (context, snapshot) {
                      final hasNotifications =
                          snapshot.hasData && snapshot.data!.isNotEmpty;
                      return Stack(
                        children: [
                          Icon(_selectedIndex == 3
                              ? (hasNotifications
                                  ? Icons.notifications_active
                                  : Icons.notifications_none)
                              : (hasNotifications
                                  ? Icons.notifications_active_outlined
                                  : Icons.notifications_none_outlined)),
                          if (hasNotifications)
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                padding: const EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.error,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 12,
                                  minHeight: 12,
                                ),
                                child: Text(
                                  snapshot.data!.length > 9
                                      ? '9+'
                                      : snapshot.data!.length.toString(),
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onError,
                                    fontSize: 8,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  );
                },
              ),
              label: 'Notifications',
            ),
            BottomNavigationBarItem(
              icon: Icon(_selectedIndex == 4
                  ? Icons.settings
                  : Icons.settings_outlined),
              label: 'Settings',
            ),
          ],
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Theme.of(context).colorScheme.onSurface,
        ),
      ],
    );
  }

  Widget _buildLargeScreenLayout() {
    return Row(
      children: <Widget>[
        Container(
          width: _railWidth,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(
              right: BorderSide(
                color: Theme.of(context).colorScheme.outline.withAlpha(20),
                width: 1,
              ),
            ),
          ),
          child: Column(
            children: [
              // Header with toggle button
              Container(
                height: 64,
                child: Row(
                  children: [
                    Expanded(
                      child: _CustomNavButton(
                        icon: Icons.menu,
                        onPressed: () {
                          _updateRailWidth(
                              _isExtended ? _minRailWidth : _maxRailWidth);
                        },
                        isSelected: false,
                        showLabel: false,
                        tooltip: _isExtended ? 'Collapse' : 'Expand',
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // Main navigation items
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    children: [
                      _CustomNavButton(
                        icon: _selectedIndex == 0
                            ? Icons.dashboard
                            : Icons.dashboard_outlined,
                        label: 'Dashboard',
                        onPressed: () => updateSelectedScreen(0),
                        isSelected: _selectedIndex == 0,
                        showLabel: _showLabels,
                        tooltip: 'Dashboard',
                      ),
                      const SizedBox(height: 4),
                      _CustomNavButton(
                        icon: _selectedIndex == 1
                            ? Icons.inventory_2
                            : Icons.inventory_2_outlined,
                        label: 'Items',
                        onPressed: () => updateSelectedScreen(1),
                        isSelected: _selectedIndex == 1,
                        showLabel: _showLabels,
                        tooltip: 'Items',
                      ),
                      const SizedBox(height: 4),
                      _CustomNavButton(
                        icon: _selectedIndex == 2
                            ? Icons.account_circle
                            : Icons.account_circle_outlined,
                        label: 'Users',
                        onPressed: () => updateSelectedScreen(2),
                        isSelected: _selectedIndex == 2,
                        showLabel: _showLabels,
                        tooltip: 'Users',
                      ),
                    ],
                  ),
                ),
              ),
              // Bottom section with notifications and settings
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: [
                    const Divider(height: 1),
                    const SizedBox(height: 8),
                    Consumer<NotificationStorageService>(
                      builder: (context, notificationService, child) {
                        return FutureBuilder<List<AppNotification>>(
                          future: notificationService.getNotifications(),
                          builder: (context, snapshot) {
                            final hasNotifications =
                                snapshot.hasData && snapshot.data!.isNotEmpty;
                            return _CustomNavButton(
                              icon: _selectedIndex == 3
                                  ? (hasNotifications
                                      ? Icons.notifications_active
                                      : Icons.notifications_none)
                                  : (hasNotifications
                                      ? Icons.notifications_active_outlined
                                      : Icons.notifications_none_outlined),
                              label: 'Notifications',
                              onPressed: () => updateSelectedScreen(3),
                              isSelected: _selectedIndex == 3,
                              showLabel: _showLabels,
                              tooltip: 'Notifications',
                              badge:
                                  hasNotifications ? snapshot.data!.length : null,
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 4),
                    _CustomNavButton(
                      icon: _selectedIndex == 4
                          ? Icons.settings
                          : Icons.settings_outlined,
                      label: 'Settings',
                      onPressed: () => updateSelectedScreen(4),
                      isSelected: _selectedIndex == 4,
                      showLabel: _showLabels,
                      tooltip: 'Settings',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Resize handle
        GestureDetector(
          onHorizontalDragUpdate: (details) {
            _updateRailWidth(_railWidth + details.primaryDelta!);
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.resizeLeftRight,
            child: Center(
              child: Container(
                width: 2,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outline.withAlpha(20),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ),
          ),
        ),
        // Main content area
        Expanded(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
            child: _getSelectedScreen(_selectedIndex),
          ),
        ),
      ],
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
        return ItemScreen(filterParams: _currentFilterParams);
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

  void updateSelectedScreen(int index, {ItemFilterParams? itemFilterParams}) {
    setState(() {
      _selectedIndex = index;
      _currentFilterParams = itemFilterParams;
    });
  }
}

class _CustomNavButton extends StatelessWidget {
  final IconData icon;
  final String? label;
  final VoidCallback onPressed;
  final bool isSelected;
  final bool showLabel;
  final String tooltip;
  final int? badge;

  const _CustomNavButton({
    required this.icon,
    this.label,
    required this.onPressed,
    required this.isSelected,
    required this.showLabel,
    required this.tooltip,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Tooltip(
      message: tooltip,
      waitDuration: const Duration(milliseconds: 500),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color:
                isSelected ? colorScheme.primaryContainer : colorScheme.surface,
          ),
          child: Material(
            color: AppColors.colorTransparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: onPressed,
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Icon(
                          icon,
                          size: 24,
                          color: isSelected
                              ? AppColors.colorAccent
                              : colorScheme.onSurface,
                        ),
                        if (badge != null)
                          Positioned(
                            right: -6,
                            top: -6,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: colorScheme.error,
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 16,
                                minHeight: 16,
                              ),
                              child: Text(
                                badge! > 99 ? '99+' : badge.toString(),
                                style: TextStyle(
                                  color: colorScheme.onError,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (showLabel && label != null) ...[
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          label!,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w400,
                            color: isSelected
                                ? AppColors.colorAccent
                                : colorScheme.onSurface,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}