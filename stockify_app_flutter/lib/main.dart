import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockify_app_flutter/common/shared-preference/shared_preferences_service.dart';
import 'package:stockify_app_flutter/common/widget/app_layout/provider/app_layout_provider.dart';
import 'package:stockify_app_flutter/feature/dashboard/provider/dashboard_provider.dart';
import 'package:stockify_app_flutter/feature/item/provider/item_provider.dart';
import 'package:stockify_app_flutter/feature/item/provider/view_type_provider.dart';
import 'package:stockify_app_flutter/feature/notification/service/notification_service.dart';
import 'package:stockify_app_flutter/feature/notification/service/notification_storage_service.dart';

import 'app.dart';
import 'common/theme/provider/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final notificationStorageService = NotificationStorageService();
  await NotificationService().init();
  NotificationService().flutterLocalNotificationsPlugin.cancelAll();
  final sharedPreferencesService = SharedPreferencesService.instance;
  await sharedPreferencesService.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: notificationStorageService),
        ChangeNotifierProvider(create: (_) => ItemProvider()),
        ChangeNotifierProvider(
            create: (_) => ThemeProvider(sharedPreferencesService)),
        ChangeNotifierProvider(
            create: (_) => AppLayoutProvider(sharedPreferencesService)),
        ChangeNotifierProvider(
            create: (_) => ViewTypeProvider(sharedPreferencesService)),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
      ],
      child: const StockifyApp(),
    ),
  );
}
