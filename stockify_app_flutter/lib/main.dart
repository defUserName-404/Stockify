import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockify_app_flutter/common/widget/placeholder/placeholder_widget.dart';

import 'common/shared-preference/shared_preference_service.dart';
import 'common/theme/controller/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPrefsService = SharedPrefsService();
  await sharedPrefsService.init();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => ThemeController()),
    ChangeNotifierProvider(create: (_) => sharedPrefsService)
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
      home: const AppPlaceholder(),
      debugShowCheckedModeBanner: false,
    );
  }
}
