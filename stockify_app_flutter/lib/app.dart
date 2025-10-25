import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'common/theme/controller/theme_controller.dart';
import 'common/widget/app_layout/widgets/app_layout.dart';

class StockifyApp extends StatelessWidget {
  const StockifyApp({super.key});

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
