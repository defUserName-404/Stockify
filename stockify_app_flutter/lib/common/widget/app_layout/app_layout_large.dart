part of 'app_layout.dart';

class _AppLayoutLarge extends StatelessWidget {
  final int selectedIndex;
  final double railWidth;
  final bool isExtended;
  final bool showLabels;
  final double minRailWidth;
  final double maxRailWidth;
  final void Function(double) updateRailWidth;
  final void Function(int,
      {ItemFilterParams? itemFilterParams,
      bool openAddItemPanel}) updateSelectedScreen;
  final Widget Function(int) getSelectedScreen;

  const _AppLayoutLarge({
    super.key,
    required this.selectedIndex,
    required this.railWidth,
    required this.isExtended,
    required this.showLabels,
    required this.minRailWidth,
    required this.maxRailWidth,
    required this.updateRailWidth,
    required this.updateSelectedScreen,
    required this.getSelectedScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: railWidth,
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
              SizedBox(
                height: 64,
                child: Row(
                  children: [
                    Expanded(
                      child: _CustomNavButton(
                        icon: Icons.menu,
                        onPressed: () {
                          updateRailWidth(
                              isExtended ? minRailWidth : maxRailWidth);
                        },
                        isSelected: false,
                        showLabel: false,
                        tooltip: isExtended ? 'Collapse' : 'Expand',
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
                        icon: selectedIndex == 0
                            ? Icons.dashboard
                            : Icons.dashboard_outlined,
                        label: 'Dashboard',
                        onPressed: () => updateSelectedScreen(0),
                        isSelected: selectedIndex == 0,
                        showLabel: showLabels,
                        tooltip: 'Dashboard',
                      ),
                      const SizedBox(height: 4),
                      _CustomNavButton(
                        icon: selectedIndex == 1
                            ? Icons.inventory_2
                            : Icons.inventory_2_outlined,
                        label: 'Items',
                        onPressed: () => updateSelectedScreen(1),
                        isSelected: selectedIndex == 1,
                        showLabel: showLabels,
                        tooltip: 'Items',
                      ),
                      const SizedBox(height: 4),
                      _CustomNavButton(
                        icon: selectedIndex == 2
                            ? Icons.account_circle
                            : Icons.account_circle_outlined,
                        label: 'Users',
                        onPressed: () => updateSelectedScreen(2),
                        isSelected: selectedIndex == 2,
                        showLabel: showLabels,
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
                              icon: selectedIndex == 3
                                  ? (hasNotifications
                                      ? Icons.notifications_active
                                      : Icons.notifications_none)
                                  : (hasNotifications
                                      ? Icons.notifications_active_outlined
                                      : Icons.notifications_none_outlined),
                              label: 'Notifications',
                              onPressed: () => updateSelectedScreen(3),
                              isSelected: selectedIndex == 3,
                              showLabel: showLabels,
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
                      icon: selectedIndex == 4
                          ? Icons.settings
                          : Icons.settings_outlined,
                      label: 'Settings',
                      onPressed: () => updateSelectedScreen(4),
                      isSelected: selectedIndex == 4,
                      showLabel: showLabels,
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
            updateRailWidth(railWidth + details.primaryDelta!);
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
            child: getSelectedScreen(selectedIndex),
          ),
        ),
      ],
    );
  }
}
