import 'package:flutter/material.dart';
import 'package:stockify_app_flutter/common/theme/colors.dart';
import 'package:stockify_app_flutter/common/widget/animations/screen_transition.dart';
import 'package:stockify_app_flutter/feature/dashboard/widget/charts_section.dart';
import 'package:stockify_app_flutter/feature/dashboard/widget/info_cards_grid.dart';
import 'package:stockify_app_flutter/feature/dashboard/widget/quick_actions.dart';
import 'package:stockify_app_flutter/feature/dashboard/widget/welcome_section.dart';
import 'package:stockify_app_flutter/feature/item/model/asset_status.dart';
import 'package:stockify_app_flutter/feature/item/model/device_type.dart';
import 'package:stockify_app_flutter/feature/item/model/item.dart';
import 'package:stockify_app_flutter/feature/item/service/item_service.dart';
import 'package:stockify_app_flutter/feature/item/service/item_service_implementation.dart';
import 'package:stockify_app_flutter/feature/notification/model/app_notification.dart';
import 'package:stockify_app_flutter/feature/notification/service/notification_service.dart';
import 'package:stockify_app_flutter/feature/notification/service/notification_storage_service.dart';
import 'package:stockify_app_flutter/feature/user/model/user.dart';
import 'package:stockify_app_flutter/feature/user/service/user_service.dart';
import 'package:stockify_app_flutter/feature/user/service/user_service_implementation.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final ItemService _itemService;
  late final UserService _userService;
  late List<Item> _items;
  late List<User> _users;

  @override
  void initState() {
    super.initState();
    _itemService = ItemServiceImplementation.instance;
    _userService = UserServiceImplementation.instance;
    _items = _itemService.getAllItems();
    _users = _userService.getAllUsers();
    _scheduleWarrantyNotifications();
  }

  void dispose() {
    super.dispose();
  }

  void _scheduleWarrantyNotifications() async {
    final expiringItems = _getExpiringItems();
    final existingNotifications =
        await NotificationStorageService().getNotifications();
    for (var item in expiringItems) {
      if (!existingNotifications.any((n) => n.id == item.id)) {
        final notificationTitle = 'Warranty Expiring Soon!';
        final notificationBody =
            'The warranty for ${item.assetNo} (${item.modelNo}) is expiring on ${item.warrantyDate.toLocal().toString().split(' ')[0]}.';
        final notificationPayload = 'item_id_${item.id}';
        NotificationService().showNotification(
          id: item.id!,
          title: notificationTitle,
          body: notificationBody,
          payload: notificationPayload,
        );
        NotificationStorageService().addNotification(
          AppNotification(
            id: item.id!,
            title: notificationTitle,
            body: notificationBody,
            timestamp: DateTime.now(),
            payload: notificationPayload,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        surfaceTintColor: AppColors.colorTransparent,
      ),
      body: ScreenTransition(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const WelcomeSection(),
              const SizedBox(height: 32),
              InfoCardsGrid(
                totalItems: _items.length,
                totalUsers: _users.length,
                expiringItems: _getExpiringItems().length,
                disposedItems: _getDisposedItems().length,
              ),
              const SizedBox(height: 32),
              ChartsSection(
                deviceTypeCounts: _getDeviceTypeCounts(),
                assetStatusCounts: _getAssetStatusCounts(),
              ),
              const SizedBox(height: 32),
              const QuickActions(),
            ],
          ),
        ),
      ),
    );
  }

  List<Item> _getExpiringItems() {
    final now = DateTime.now();
    return _items.where((item) {
      return item.warrantyDate.isAfter(now) &&
          item.warrantyDate.difference(now).inDays <= 30;
    }).toList();
  }

  List<Item> _getDisposedItems() {
    return _items
        .where((item) => item.assetStatus == AssetStatus.Disposed)
        .toList();
  }

  Map<DeviceType, int> _getDeviceTypeCounts() {
    final counts = <DeviceType, int>{};
    for (final item in _items) {
      counts[item.deviceType] = (counts[item.deviceType] ?? 0) + 1;
    }
    return counts;
  }

  Map<AssetStatus, int> _getAssetStatusCounts() {
    final counts = <AssetStatus, int>{};
    for (final item in _items) {
      counts[item.assetStatus] = (counts[item.assetStatus] ?? 0) + 1;
    }
    return counts;
  }
}
