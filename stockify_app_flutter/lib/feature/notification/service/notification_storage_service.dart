import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stockify_app_flutter/feature/notification/model/app_notification.dart';

class NotificationStorageService extends ChangeNotifier {
  static const String _notificationsKey = 'notifications';

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
    notifications.removeWhere((notification) => notification.id == id);
    final updatedJsonList = notifications
        .map((notification) => json.encode(notification.toJson()))
        .toList();
    await prefs.setStringList(_notificationsKey, updatedJsonList);
    notifyListeners();
  }

  Future<void> clearNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_notificationsKey);
    notifyListeners();
  }
}
