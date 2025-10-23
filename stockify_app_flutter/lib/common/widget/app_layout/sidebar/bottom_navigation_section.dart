part of '../app_layout.dart';

class _BottomNavigationSection extends StatelessWidget {
  final int selectedIndex;
  final bool showLabels;
  final void Function(int,
      {ItemFilterParams? itemFilterParams,
      bool openAddItemPanel}) updateSelectedScreen;

  const _BottomNavigationSection({
    required this.selectedIndex,
    required this.showLabels,
    required this.updateSelectedScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Divider(
          height: 1,
          color: Theme.of(context)
              .colorScheme
              .outlineVariant
              .withValues(alpha: 0.2),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (showLabels) ...[
                _SectionLabel(label: 'SYSTEM'),
                const SizedBox(height: 8),
              ],
              Consumer<NotificationStorageService>(
                builder: (context, notificationService, child) {
                  return FutureBuilder<List<AppNotification>>(
                    future: notificationService.getNotifications(),
                    builder: (context, snapshot) {
                      final hasNotifications =
                          snapshot.hasData && snapshot.data!.isNotEmpty;
                      final notificationCount =
                      hasNotifications ? snapshot.data!.length : 0;

                      return _NavButton(
                        icon: Icons.notifications_rounded,
                        label: 'Notifications',
                        onPressed: () => updateSelectedScreen(3),
                        isSelected: selectedIndex == 3,
                        showLabel: showLabels,
                        badge: notificationCount > 0 ? notificationCount : null,
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 4),
              _NavButton(
                icon: Icons.settings_rounded,
                label: 'Settings',
                onPressed: () => updateSelectedScreen(4),
                isSelected: selectedIndex == 4,
                showLabel: showLabels,
              ),
            ],
          ),
        ),
      ],
    );
  }
}