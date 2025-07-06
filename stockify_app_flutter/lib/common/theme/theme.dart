import 'package:flutter/material.dart';

import 'colors.dart';

class AppTheme {
  AppTheme._();

  static final _buttonStyleLight = ButtonStyle(
    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
    ),
    backgroundColor: WidgetStateProperty.all<Color>(AppColors.colorPrimary),
    foregroundColor: WidgetStateProperty.all<Color>(AppColors.colorAccent),
    minimumSize: WidgetStateProperty.all<Size>(Size(64, 64)),
    overlayColor:
        WidgetStateProperty.all<Color>(AppColors.colorBackground.withAlpha(10)),
  );

  static final _buttonStyleDark = _buttonStyleLight.copyWith(
    backgroundColor: WidgetStateProperty.all<Color>(AppColors.colorPrimaryDark),
    overlayColor: WidgetStateProperty.all<Color>(
        AppColors.colorBackgroundDark.withAlpha(10)),
  );

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
        fontSize: 22,
      ),
      titleLarge: TextStyle(
        fontFamily: 'Brand-Bold',
        color: AppColors.colorTextDark,
        fontWeight: FontWeight.bold,
        fontSize: 24,
      ),
      headlineLarge: TextStyle(
        fontFamily: 'Brand-Bold',
        color: AppColors.colorTextDark,
        fontWeight: FontWeight.bold,
        fontSize: 28,
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
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.colorAccent,
        backgroundColor: AppColors.colorPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
      ),
    ),
    listTileTheme: ListTileThemeData(
      iconColor: AppColors.colorTextDark,
      titleTextStyle: TextStyle(color: AppColors.colorTextDark, fontSize: 20),
      textColor: AppColors.colorTextDark,
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
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(style: _buttonStyleLight),
    iconButtonTheme: IconButtonThemeData(style: _buttonStyleLight),
    searchBarTheme: SearchBarThemeData(
      elevation: WidgetStateProperty.all<double>(2.0),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      ),
      backgroundColor:
          WidgetStateProperty.all<Color>(AppColors.colorTextSemiLight),
      textStyle: WidgetStateProperty.all<TextStyle>(
        TextStyle(color: AppColors.colorTextDark),
      ),
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
        color: AppColors.colorTextLight,
        fontWeight: FontWeight.bold,
        fontSize: 22,
      ),
      titleLarge: TextStyle(
        fontFamily: 'Brand-Bold',
        color: AppColors.colorTextLight,
        fontWeight: FontWeight.bold,
        fontSize: 24,
      ),
      headlineLarge: TextStyle(
        fontFamily: 'Brand-Bold',
        color: AppColors.colorTextLight,
        fontWeight: FontWeight.bold,
        fontSize: 28,
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
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.colorAccent,
        backgroundColor: AppColors.colorPrimaryDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
      ),
    ),
    listTileTheme: const ListTileThemeData(
      iconColor: AppColors.colorTextLight,
      textColor: AppColors.colorTextLight,
      titleTextStyle: TextStyle(color: AppColors.colorTextDark, fontSize: 20),
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
    elevatedButtonTheme: ElevatedButtonThemeData(style: _buttonStyleDark),
    iconButtonTheme: IconButtonThemeData(style: _buttonStyleDark),
    searchBarTheme: SearchBarThemeData(
      elevation: WidgetStateProperty.all<double>(2.0),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      ),
      backgroundColor:
          WidgetStateProperty.all<Color>(AppColors.colorTextSemiLight),
      textStyle: WidgetStateProperty.all<TextStyle>(
        TextStyle(color: AppColors.colorTextDark),
      ),
    ),
  );
}
