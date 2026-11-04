import 'package:flutter/material.dart';

import 'generalImports.dart';

enum AppTheme { dark, light }

final commonThemeData = ThemeData(useMaterial3: true, fontFamily: 'Outfit');

final Map<AppTheme, ThemeData> appThemeData = {
  AppTheme.light: commonThemeData.copyWith(
    textTheme: commonThemeData.textTheme.apply(
      bodyColor: AppColors.lightSubHeadingColor1,
      displayColor: AppColors.lightSubHeadingColor1,
    ),
    colorScheme:
        ColorScheme.fromSeed(
          seedColor: AppColors.lightAccentColor,
          brightness: Brightness.light,
        ).copyWith(
          primary: AppColors.lightAccentColor,
          secondary: AppColors.lightAccentColor,
          surface: AppColors.lightSecondaryColor,
          onSurface: AppColors.lightSubHeadingColor1,
        ),
    scaffoldBackgroundColor: AppColors.lightPrimaryColor,
    brightness: Brightness.light,
    primaryColor: AppColors.lightPrimaryColor,
    secondaryHeaderColor: AppColors.lightSubHeadingColor1,
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.lightAccentColor,
      selectionHandleColor: AppColors.lightAccentColor,
      selectionColor: AppColors.lightSecondaryColor,
    ),
    timePickerTheme: TimePickerThemeData(
      dialBackgroundColor: AppColors.lightAccentColor.withValues(alpha: 0.1),
      backgroundColor: AppColors.lightPrimaryColor,
      hourMinuteTextColor: AppColors.lightAccentColor,
      hourMinuteColor: AppColors.lightAccentColor.withValues(alpha: 0.1),
      cancelButtonStyle: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(AppColors.lightAccentColor),
      ),
      confirmButtonStyle: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(AppColors.lightAccentColor),
      ),
      dayPeriodColor: AppColors.lightAccentColor,
      dayPeriodTextColor: AppColors.lightSubHeadingColor1,
      dialHandColor: AppColors.lightAccentColor,
    ),
  ),
  AppTheme.dark: commonThemeData.copyWith(
    textTheme: commonThemeData.textTheme.apply(
      bodyColor: AppColors.darkSubHeadingColor1,
      displayColor: AppColors.darkSubHeadingColor1,
    ),
    iconTheme: commonThemeData.iconTheme.copyWith(
      color: AppColors.darkSubHeadingColor1,
    ),
    colorScheme:
        ColorScheme.fromSeed(
          seedColor: AppColors.darkAccentColor,
          brightness: Brightness.dark,
        ).copyWith(
          primary: AppColors.darkAccentColor,
          secondary: AppColors.darkAccentColor,
          surface: AppColors.darkSecondaryColor,
          onSurface: AppColors.darkSubHeadingColor1,
        ),
    brightness: Brightness.dark,
    primaryColor: AppColors.darkPrimaryColor,
    secondaryHeaderColor: AppColors.darkSubHeadingColor1,
    scaffoldBackgroundColor: AppColors.darkPrimaryColor,
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.darkAccentColor,
      selectionHandleColor: AppColors.darkAccentColor,
      selectionColor: AppColors.darkSecondaryColor,
    ),
    timePickerTheme: TimePickerThemeData(
      helpTextStyle: TextStyle(color: AppColors.darkSubHeadingColor1),
      dialBackgroundColor: AppColors.darkAccentColor.withValues(alpha: 0.5),
      backgroundColor: AppColors.darkPrimaryColor,
      hourMinuteTextColor: AppColors.darkAccentColor,
      hourMinuteColor: AppColors.darkPrimaryColor.withValues(alpha: 0.1),
      cancelButtonStyle: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(AppColors.darkAccentColor),
      ),
      confirmButtonStyle: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(AppColors.darkAccentColor),
      ),
      dayPeriodColor: AppColors.darkAccentColor,
      dayPeriodTextColor: AppColors.darkSubHeadingColor1,
      dialHandColor: AppColors.darkAccentColor,
    ),
  ),
};
