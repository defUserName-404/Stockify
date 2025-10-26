part of '../widgets/app_layout.dart';

class _BottomNavigationSection extends StatelessWidget {
  const _BottomNavigationSection();

  @override
  Widget build(BuildContext context) {
    final appLayoutProvider = Provider.of<AppLayoutProvider>(context);
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
              if (appLayoutProvider.showLabels) ...[
                const _SectionLabel(label: 'SYSTEM'),
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
                        onPressed: () =>
                            appLayoutProvider.updateSelectedScreen(3),
                        isSelected: appLayoutProvider.selectedIndex == 3,
                        showLabel: appLayoutProvider.showLabels,
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
                onPressed: () => appLayoutProvider.updateSelectedScreen(4),
                isSelected: appLayoutProvider.selectedIndex == 4,
                showLabel: appLayoutProvider.showLabels,
              ),
            ],
          ),
        ),
      ],
    );
  }
}