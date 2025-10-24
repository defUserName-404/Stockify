import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockify_app_flutter/common/helpers/date_formatter.dart';
import 'package:stockify_app_flutter/common/widget/animations/screen_transition.dart';
import 'package:stockify_app_flutter/feature/notification/model/app_notification.dart';
import 'package:stockify_app_flutter/feature/notification/service/notification_storage_service.dart';

import '../../../common/widget/app_layout/provider/app_layout_provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late NotificationStorageService _storageService;
  Future<List<AppNotification>> _notificationsFuture = Future.value([]);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _storageService =
          Provider.of<NotificationStorageService>(context, listen: false);
      _loadNotifications();
      _storageService.addListener(_onNotificationsChanged);
    });
  }

  @override
  void dispose() {
    _storageService.removeListener(_onNotificationsChanged);
    super.dispose();
  }

  void _onNotificationsChanged() {
    _loadNotifications();
  }

  void _loadNotifications() {
    setState(() {
      _notificationsFuture = _storageService.getNotifications();
    });
  }

  Future<void> _deleteNotification(int id) async {
    await _storageService.removeNotification(id);
    _loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        titleSpacing: 0,
      ),
      body: ScreenTransition(
        child: FutureBuilder<List<AppNotification>>(
          future: _notificationsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.notifications, size: 80, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No new notifications',
                      style: TextStyle(fontSize: 24, color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Notifications will appear here.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              );
            } else {
              final notifications = snapshot.data!;
              return ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(
                        notification.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (notification.assetName != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              'Asset: ${notification.assetName}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                          const SizedBox(height: 8),
                          Text(notification.body),
                          const SizedBox(height: 8),
                          Text(
                            DateFormatter.extractDateFromDateTime(
                                notification.timestamp),
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () => _deleteNotification(notification.id),
                      ),
                      onTap: () {
                        if (notification.itemId != null) {
                          final appLayoutProvider =
                              Provider.of<AppLayoutProvider>(context,
                                  listen: false);
                          appLayoutProvider.updateSelectedScreen(1);
                        }
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
