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

class AppPlaceholder extends StatefulWidget {
  const AppPlaceholder({super.key});

  static final GlobalKey<_AppPlaceholderState> navigatorKey =
      GlobalKey<_AppPlaceholderState>();

  @override
  State<AppPlaceholder> createState() => _AppPlaceholderState();
}

class _AppPlaceholderState extends State<AppPlaceholder> {
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
            body: Row(
              children: <Widget>[
                Container(
                  width: _railWidth,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    border: Border(
                      right: BorderSide(
                        color:
                            Theme.of(context).colorScheme.outline.withAlpha(20),
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
                                  _updateRailWidth(_isExtended
                                      ? _minRailWidth
                                      : _maxRailWidth);
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
                                  future:
                                      notificationService.getNotifications(),
                                  builder: (context, snapshot) {
                                    final hasNotifications = snapshot.hasData &&
                                        snapshot.data!.isNotEmpty;
                                    return _CustomNavButton(
                                      icon: _selectedIndex == 3
                                          ? (hasNotifications
                                              ? Icons.notifications_active
                                              : Icons.notifications_none)
                                          : (hasNotifications
                                              ? Icons
                                                  .notifications_active_outlined
                                              : Icons
                                                  .notifications_none_outlined),
                                      label: 'Notifications',
                                      onPressed: () => updateSelectedScreen(3),
                                      isSelected: _selectedIndex == 3,
                                      showLabel: _showLabels,
                                      tooltip: 'Notifications',
                                      badge: hasNotifications
                                          ? snapshot.data!.length
                                          : null,
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
                    child: Container(
                      width: 4,
                      height: double.infinity,
                      color: Colors.transparent,
                      child: Center(
                        child: Container(
                          width: 2,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .outline
                                .withOpacity(0.2),
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Main content area
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 32.0),
                    child: _getSelectedScreen(_selectedIndex),
                  ),
                ),
              ],
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

class _CustomNavButton extends StatefulWidget {
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
  State<_CustomNavButton> createState() => _CustomNavButtonState();
}

class _CustomNavButtonState extends State<_CustomNavButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Tooltip(
      message: widget.tooltip,
      waitDuration: const Duration(milliseconds: 500),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: widget.isSelected
                ? colorScheme.primaryContainer
                : _isHovered
                    ? colorScheme.surfaceContainerHighest
                    : Colors.transparent,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: widget.onPressed,
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Icon(
                          widget.icon,
                          size: 24,
                          color: widget.isSelected
                              ? AppColors.colorAccent
                              : _isHovered
                                  ? colorScheme.onSurface
                                  : colorScheme.onSurfaceVariant,
                        ),
                        if (widget.badge != null)
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
                                widget.badge! > 99
                                    ? '99+'
                                    : widget.badge.toString(),
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
                    if (widget.showLabel && widget.label != null) ...[
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.label!,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: widget.isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: widget.isSelected
                                ? AppColors.colorAccent
                                : _isHovered
                                    ? colorScheme.onSurface
                                    : colorScheme.onSurfaceVariant,
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