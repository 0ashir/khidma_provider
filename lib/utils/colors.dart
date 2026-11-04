import 'package:flutter/material.dart';

extension AppColors on ColorScheme {
  static const Color greenColor = Colors.green;
  static const Color starRatingColor = Color(0xfff4be18);
  static const Color redColor = Colors.red;
  static const Color orangeColor = Colors.orange;
  static Color whiteColors = Colors.white;
  static const Color grey = Colors.grey;

  static Color lightPrimaryColor = const Color(0xffF5F6F7); //background color
  //card color
  static Color lightSecondaryColor = const Color(0xffFFFFFF);
  //main color
  static Color lightAccentColor = const Color(0xff5465FF);
  //text color
  static Color lightSubHeadingColor1 = const Color(0xff00162E);

  //dark theme colors
  //background color
  static Color darkPrimaryColor = const Color(0xff1A1C28);
  //card color
  static Color darkSecondaryColor = const Color(0xff262935);
  //main color
  static Color darkAccentColor = const Color(0xff5465FF);
  //text color
  static Color darkSubHeadingColor1 = const Color(0xffF1F1F1);

  Color get primaryColor =>
      brightness == Brightness.light ? lightPrimaryColor : darkPrimaryColor;
  Color get secondaryColor =>
      brightness == Brightness.light ? lightSecondaryColor : darkSecondaryColor;
  Color get accentColor =>
      brightness == Brightness.light ? lightAccentColor : darkAccentColor;
  Color get lightGreyColor => blackColor.withValues(alpha: 0.5);
  Color get blackColor => brightness == Brightness.light
      ? lightSubHeadingColor1
      : darkSubHeadingColor1;

  Color get shimmerBaseColor => brightness == Brightness.light
      ? const Color.fromARGB(255, 225, 225, 225)
      : const Color.fromARGB(255, 150, 150, 150);
  Color get shimmerHighlightColor => brightness == Brightness.light
      ? Colors.grey.shade100
      : Colors.grey.shade300;
  Color get shimmerContentColor => brightness == Brightness.light
      ? Colors.white.withValues(alpha: 0.85)
      : Colors.white.withValues(alpha: 0.7);

  //splashScreen GradientColor
  static Color splashScreenGradientTopColor = const Color(0xff5465FF);
  static Color splashScreenGradientBottomColor = const Color(0xff323D99);

  //screen GradientsColor
  static Color darkgradientBottomColor = const Color(0xff1E1E2C);
  static Color darkgradientTopColor = const Color(0xff2A2C3E);
  static Color lightgradientBottomColor = const Color(0xffF2F1F6);
  static Color lightgradientTopColor = const Color(0xffFFFFFF);
  Color get gradientBottomColor => brightness == Brightness.light
      ? lightgradientBottomColor
      : darkgradientBottomColor;
  Color get gradientTopColor => brightness == Brightness.light
      ? lightgradientTopColor
      : darkgradientTopColor;

  static Color get pendingPaymentStatusColor => const Color(0xffFF9900);

  static Color get failedPaymentStatusColor => const Color(0xffC60000);

  static Color get successPaymentStatusColor => const Color(0xff1E9400);

  static Color get yellowColor => Colors.yellow;

  static Color get awaitingOrderColor => Colors.black;

  static Color get confirmedOrderColor => const Color(0xff009EA8);

  static Color get startedOrderColor => const Color(0xff5465FF);

  static Color get rescheduledOrderColor => const Color(0xffFF9900);

  static Color get cancelledOrderColor => const Color(0xffC60000);

  static Color get completedOrderColor => const Color(0xff1E9400);
}
