import 'package:flutter/material.dart';

import '../app/generalImports.dart';

extension TextThemeExtension on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;

  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  double get screenWidth => MediaQuery.sizeOf(this).width;

  double get screenHeight => MediaQuery.sizeOf(this).height;

  /// Decimals for amounts the provider enters: the country's
  /// `currency_decimal_places` (`get_country_settings`), else the system
  /// decimal setting.
  int get providerDecimalPlaces =>
      read<FetchCountrySettingsCubit>().currencyDecimalPlaces ??
      int.tryParse(read<FetchSystemSettingsCubit>().SystemDecimalPoint) ??
      2;

  /// Whether the "pay later" (pay on service) option is available: the
  /// country's `cod_setting` when known, else the admin's system setting.
  /// Call it while building: it rebuilds when the country settings load.
  bool get isPayLaterAvailable =>
      watch<FetchCountrySettingsCubit>().isCodEnabled ??
      read<FetchSystemSettingsCubit>().isPayLaterAllowedByAdmin;

  /// Currency symbol of the provider's country (`get_country_settings`); the
  /// system symbol until that loads.
  String get providerCurrencySymbol =>
      read<FetchCountrySettingsCubit>().currencySymbol ??
      read<FetchSystemSettingsCubit>().SystemCurrency;
}
