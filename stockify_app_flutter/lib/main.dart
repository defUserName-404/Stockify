import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockify_app_flutter/common/shared-preference/shared_preferences_service.dart';
import 'package:stockify_app_flutter/common/theme/controller/theme_controller.dart';
import 'package:stockify_app_flutter/common/widget/app_layout/provider/app_layout_provider.dart';
import 'package:stockify_app_flutter/feature/item/provider/item_provider.dart';
import 'package:stockify_app_flutter/feature/item/provider/view_type_provider.dart';
import 'package:stockify_app_flutter/feature/notification/service/notification_service.dart';
import 'package:stockify_app_flutter/feature/notification/service/notification_storage_service.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferencesService = SharedPreferencesService();
  await sharedPreferencesService.init();

  final notificationStorageService = NotificationStorageService();
  await NotificationService().init();
  NotificationService().flutterLocalNotificationsPlugin.cancelAll();
  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: sharedPreferencesService),
        ChangeNotifierProvider.value(value: notificationStorageService),
        ChangeNotifierProvider(create: (_) => ItemProvider()),
        ChangeNotifierProxyProvider<SharedPreferencesService, ThemeController>(
          create: (context) => ThemeController(),
          update: (context, sharedPrefs, themeController) {
            themeController!.update(sharedPrefs);
            return themeController;
          },
        ),
        ChangeNotifierProxyProvider<SharedPreferencesService,
            AppLayoutProvider>(
          create: (context) => AppLayoutProvider(),
          update: (context, sharedPrefs, appLayoutProvider) {
            appLayoutProvider!.update(sharedPrefs);
            return appLayoutProvider;
          },
        ),
        ChangeNotifierProxyProvider<SharedPreferencesService, ViewTypeProvider>(
          create: (context) => ViewTypeProvider(),
          update: (context, sharedPrefs, viewTypeProvider) {
            viewTypeProvider!.update(sharedPrefs);
            return viewTypeProvider;
          },
        ),
      ],
      child: const StockifyApp(),
    ),
  );
}

