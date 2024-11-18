import 'package:flutter/material.dart';

import 'colors.dart';

class AppTheme {
  AppTheme._();

  static final light = ThemeData(
    useMaterial3: true,
    primaryColor: AppColors.colorPrimary,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.colorPrimary,
      onPrimary: AppColors.colorOnBackground,
      secondary: AppColors.colorSecondary,
      onSecondary: AppColors.colorOnBackground,
      error: AppColors.colorPink,
      onError: AppColors.colorText,
      surface: AppColors.colorBackground,
      onSurface: AppColors.colorOnBackground,
    ),
    fontFamily: 'Brand-Regular',
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: AppColors.colorTextDark),
      bodyLarge: TextStyle(color: AppColors.colorTextDark),
      titleMedium: TextStyle(color: AppColors.colorTextDark),
      headlineMedium: TextStyle(
        fontFamily: 'Brand-Bold',
        color: AppColors.colorTextDark,
        fontWeight: FontWeight.bold,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.0),
        borderSide: const BorderSide(color: AppColors.colorOnBackground),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.0),
        borderSide: const BorderSide(color: AppColors.colorOnBackground),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.0),
        borderSide: const BorderSide(color: AppColors.colorPrimary, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.0),
        borderSide: const BorderSide(color: AppColors.colorPink, width: 2.0),
      ),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: AppColors.colorAccent,
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
    ),
    listTileTheme: ListTileThemeData(
      iconColor: AppColors.colorTextDark,
      textColor: AppColors.colorTextDark,
      titleAlignment: ListTileTitleAlignment.top,
    ),
    switchTheme: const SwitchThemeData(
      thumbColor: WidgetStatePropertyAll<Color>(AppColors.colorAccent),
    ),
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: AppColors.colorPrimary,
      selectedIconTheme: const IconThemeData(color: AppColors.colorAccent),
      indicatorShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
      unselectedIconTheme:
          const IconThemeData(color: AppColors.colorBackground),
      unselectedLabelTextStyle: const TextStyle(
        color: AppColors.colorBackground,
      ),
      selectedLabelTextStyle: const TextStyle(
        color: AppColors.colorAccent,
      ),
      minExtendedWidth: 200,
      minWidth: 56,
    ),
  );

  static final dark = ThemeData(
    useMaterial3: true,
    primaryColor: AppColors.colorPrimaryDark,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.colorPrimaryDark,
      onPrimary: AppColors.colorOnBackgroundDark,
      secondary: AppColors.colorSecondary,
      onSecondary: AppColors.colorOnBackgroundDark,
      error: AppColors.colorPink,
      onError: AppColors.colorText,
      surface: AppColors.colorBackgroundDark,
      onSurface: AppColors.colorOnBackgroundDark,
    ),
    fontFamily: 'Brand-Regular',
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: AppColors.colorTextLight),
      bodyLarge: TextStyle(color: AppColors.colorTextLight),
      titleMedium: TextStyle(color: AppColors.colorTextLight),
      headlineMedium: TextStyle(
        fontFamily: 'Brand-Bold',
        color: AppColors.colorTextSemiLight,
        fontWeight: FontWeight.bold,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.0),
        borderSide: const BorderSide(color: AppColors.colorOnBackgroundDark),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.0),
        borderSide: const BorderSide(color: AppColors.colorOnBackgroundDark),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.0),
        borderSide: const BorderSide(
          color: AppColors.colorPrimaryDark,
          width: 2.0,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.0),
        borderSide: const BorderSide(color: AppColors.colorPink, width: 2.0),
      ),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: AppColors.colorAccent,
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
    ),
    listTileTheme: const ListTileThemeData(
      iconColor: AppColors.colorTextLight,
      textColor: AppColors.colorTextLight,
    ),
    switchTheme: const SwitchThemeData(
      thumbColor: WidgetStatePropertyAll(AppColors.colorAccent),
    ),
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: AppColors.colorPrimaryDark,
      selectedIconTheme: const IconThemeData(color: AppColors.colorAccent),
      indicatorShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
      unselectedIconTheme:
          const IconThemeData(color: AppColors.colorBackground),
      unselectedLabelTextStyle: const TextStyle(
        color: AppColors.colorBackground,
      ),
      selectedLabelTextStyle: const TextStyle(
        color: AppColors.colorAccent,
      ),
      minExtendedWidth: 200,
      minWidth: 56,
    ),
  );
}
