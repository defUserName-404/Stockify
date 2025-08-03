part of 'app_layout.dart';

class AppLayoutSmall extends StatelessWidget {
  final int selectedIndex;
  final void Function(int,
      {ItemFilterParams? itemFilterParams, bool openAddItemPanel}) updateSelectedScreen;
  final Widget Function(int) getSelectedScreen;

  const AppLayoutSmall({
    super.key,
    required this.selectedIndex,
    required this.updateSelectedScreen,
    required this.getSelectedScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: getSelectedScreen(selectedIndex),
          ),
        ),
        BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: updateSelectedScreen,
          items: [
            BottomNavigationBarItem(
              icon: Icon(selectedIndex == 0
                  ? Icons.dashboard
                  : Icons.dashboard_outlined),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(selectedIndex == 1
                  ? Icons.inventory_2
                  : Icons.inventory_2_outlined),
              label: 'Items',
            ),
            BottomNavigationBarItem(
              icon: Icon(selectedIndex == 2
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
                          Icon(selectedIndex == 3
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
              icon: Icon(selectedIndex == 4
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
}