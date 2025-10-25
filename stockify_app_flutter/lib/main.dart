import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockify_app_flutter/common/widget/app_layout/provider/app_layout_provider.dart';
import 'package:stockify_app_flutter/common/widget/app_layout/widgets/app_layout.dart';
import 'package:stockify_app_flutter/feature/item/provider/item_provider.dart';
import 'package:stockify_app_flutter/feature/item/provider/view_type_provider.dart';
import 'package:stockify_app_flutter/feature/notification/service/notification_service.dart';
import 'package:stockify_app_flutter/feature/notification/service/notification_storage_service.dart';

import 'common/shared-preference/shared_preference_service.dart';
import 'common/theme/controller/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPrefsService = SharedPrefsService();
  final notificationStorageService = NotificationStorageService();
  await sharedPrefsService.init();
  await NotificationService().init();
  NotificationService().flutterLocalNotificationsPlugin.cancelAll();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => ThemeController()),
    ChangeNotifierProvider(create: (_) => sharedPrefsService),
    ChangeNotifierProvider(create: (_) => notificationStorageService),
    ChangeNotifierProvider(create: (_) => ItemProvider()),
    ChangeNotifierProvider(create: (_) => ViewTypeProvider()),
    ChangeNotifierProvider(
        create: (context) => AppLayoutProvider(
            Provider.of<SharedPrefsService>(context, listen: false)))
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeController>(context);
    return MaterialApp(
      title: 'Stockify',
      theme: themeProvider.themeData,
      home: const AppLayout(),
      debugShowCheckedModeBanner: false,
    );
  }
}
