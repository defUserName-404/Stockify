import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stockify_app_flutter/feature/notification/model/app_notification.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationStorageService extends ChangeNotifier {
  static const String _notificationsKey = 'notifications';
  static const String _dismissedExpiringKey = 'dismissed_expiring_notifications';
  static const String _dismissedExpiredKey = 'dismissed_expired_notifications';

  Future<List<AppNotification>> getNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final notificationsJson = prefs.getStringList(_notificationsKey) ?? [];
    return notificationsJson
        .map((jsonString) => AppNotification.fromJson(json.decode(jsonString)))
        .toList();
  }

  Future<void> addNotification(AppNotification notification) async {
    final prefs = await SharedPreferences.getInstance();
    final notifications = await getNotifications();
    if (notifications.any((n) => n.id == notification.id)) return;
    notifications.add(notification);
    final updatedJsonList = notifications
        .map((notification) => json.encode(notification.toJson()))
        .toList();
    await prefs.setStringList(_notificationsKey, updatedJsonList);
    notifyListeners();
  }

  Future<void> removeNotification(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final notifications = await getNotifications();

    AppNotification? notificationToRemove;
    try {
      notificationToRemove = notifications.firstWhere((n) => n.id == id);
    } catch (e) {
      notificationToRemove = null;
    }

    if (notificationToRemove != null && notificationToRemove.itemId != null) {
      if (notificationToRemove.type == NotificationType.warrantyExpiring) {
        await _addDismissedExpiringNotification(notificationToRemove.itemId!);
      } else if (notificationToRemove.type == NotificationType.warrantyExpired) {
        await _addDismissedExpiredNotification(notificationToRemove.itemId!);
      }
    }

    notifications.removeWhere((notification) => notification.id == id);
    final updatedJsonList = notifications
        .map((notification) => json.encode(notification.toJson()))
        .toList();
    await prefs.setStringList(_notificationsKey, updatedJsonList);
    FlutterLocalNotificationsPlugin().cancel(id);
    notifyListeners();
  }

  Future<void> clearNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_notificationsKey);
    notifyListeners();
  }

  Future<void> _addDismissedExpiringNotification(int itemId) async {
    final prefs = await SharedPreferences.getInstance();
    final dismissedIds = prefs.getStringList(_dismissedExpiringKey) ?? [];
    if (!dismissedIds.contains(itemId.toString())) {
      dismissedIds.add(itemId.toString());
      await prefs.setStringList(_dismissedExpiringKey, dismissedIds);
    }
  }

  Future<void> _addDismissedExpiredNotification(int itemId) async {
    final prefs = await SharedPreferences.getInstance();
    final dismissedIds = prefs.getStringList(_dismissedExpiredKey) ?? [];
    if (!dismissedIds.contains(itemId.toString())) {
      dismissedIds.add(itemId.toString());
      await prefs.setStringList(_dismissedExpiredKey, dismissedIds);
    }
  }

  Future<Set<int>> getDismissedExpiringNotificationItemIds() async {
    final prefs = await SharedPreferences.getInstance();
    final dismissedIds = prefs.getStringList(_dismissedExpiringKey) ?? [];
    return dismissedIds
        .map((id) => int.tryParse(id) ?? -1)
        .where((id) => id != -1)
        .toSet();
  }

  Future<Set<int>> getDismissedExpiredNotificationItemIds() async {
    final prefs = await SharedPreferences.getInstance();
    final dismissedIds = prefs.getStringList(_dismissedExpiredKey) ?? [];
    return dismissedIds
        .map((id) => int.tryParse(id) ?? -1)
        .where((id) => id != -1)
        .toSet();
  }
}
