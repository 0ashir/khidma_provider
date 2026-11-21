import 'package:edemand_partner/app/generalImports.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

/// A time the API sends with a zone, e.g. `09:10:00Z` or `09:10:00+05:30`.
final RegExp _timeWithZone = RegExp(r'(Z|[+-]\d{2}(:?\d{2})?)$');

/// [time] with a zone (`09:10:00Z`) on [date] (`2026-10-10`) as device-local
/// date and time. Null for a time without a zone, or one that does not parse.
/// A missing or odd [date] counts as today, which only matters at DST changes.
DateTime? _localDateTimeOf(final String? date, final String time) {
  if (!_timeWithZone.hasMatch(time.trim())) return null;
  String day = (date ?? '').trim().split(RegExp('[ T]')).first;
  if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(day)) {
    day = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }
  return DateTime.tryParse('${day}T${time.trim()}')?.toLocal();
}

extension StringExtension on String {
  String translate({required BuildContext context}) {
    return (AppLocalization.of(context)!.getTranslatedValues(this) ?? this)
        .trim();
  }

  /// Replace extra coma from String
  ///
  /// Drops empty parts (`a,,b` / `a, ,b`) and leading or trailing commas.
  /// Short parts such as block `A` are kept.
  String removeExtraComma() {
    return trim()
        .replaceAll(RegExp(r',\s*(?=,)'), '')
        .replaceAll(RegExp(r'^\s*,|,\s*$'), '')
        .trim();
  }

  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  /// At most 6 decimals.
  String trimLatLong() {
    final int dot = indexOf('.');
    if (dot == -1 || length - dot - 1 <= 6) return this;
    return substring(0, dot + 7);
  }

  /// Date in the country format. With [withTime] the zoned time of the booking
  /// (`09:10:00Z`), the date is the one at that moment in local time.
  String formatDate({final String? withTime}) {
    final DateTime? local = withTime == null
        ? null
        : _localDateTimeOf(this, withTime);
    if (local != null) return local.formatDate();

    try {
      late DateTime dateTime;
      bool dateTimeSet = false;

      // Try to parse the date string with common formats
      try {
        // Try ISO format first
        dateTime = DateTime.parse(this);
        dateTimeSet = true;
      } catch (_) {
        // Try common date formats
        final List<String> possibleFormats = [
          'dd-MM-yyyy',
          'dd/MM/yyyy',
          'MM-dd-yyyy',
          'MM/dd/yyyy',
          'yyyy-MM-dd',
          'yyyy/MM/dd',
          'dd-MM-yyyy HH:mm:ss.SSSZ',
          'dd/MM/yyyy HH:mm:ss.SSSZ',
          'MM-dd-yyyy HH:mm:ss.SSSZ',
          'MM/dd/yyyy HH:mm:ss.SSSZ',
          'yyyy-MM-dd HH:mm:ss.SSSZ',
          'yyyy/MM/dd HH:mm:ss.SSSZ',
          'dd-MM-yyyy HH:mm:ss',
          'dd/MM/yyyy HH:mm:ss',
          'MM-dd-yyyy HH:mm:ss',
          'MM/dd/yyyy HH:mm:ss',
          'yyyy-MM-dd HH:mm:ss',
          'yyyy/MM/dd HH:mm:ss',
        ];

        for (final format in possibleFormats) {
          try {
            dateTime = DateFormat(format).parse(this);
            dateTimeSet = true;
            break;
          } catch (_) {
            continue;
          }
        }

        if (!dateTimeSet) {
          // If all formats fail, try to parse with the system date format
          try {
            dateTime = DateFormat(dateAndTimeSetting["dateFormat"]).parse(this);
            dateTimeSet = true;
          } catch (_) {
            // If parsing fails, try appending time and using ISO format
            try {
              dateTime = DateTime.parse("$this 00:00:00.000Z");
              dateTimeSet = true;
            } catch (_) {
              // Return original string if all parsing fails
              return this;
            }
          }
        }
      }

      return DateFormat("${dateAndTimeSetting["dateFormat"]}").format(dateTime);
    } catch (e) {
      // Return the original string if formatting fails
      return this;
    }
  }

  /// Time in the country format. A time with a zone (`09:10:00Z`) is shown in
  /// local time, using [onDate] (`2026-10-10`) for the offset.
  String formatTime({final String? onDate}) {
    try {
      return DateFormat(
        dateAndTimeSetting["use24HourFormat"] ? 'HH:mm' : 'hh:mm a',
      ).format(
        _localDateTimeOf(onDate, this) ?? DateFormat('HH:mm').parse(this),
      );
    } catch (_) {
      return this;
    }
  }

  /// Date part only, in the country format; time is dropped.
  String formatDateAndTimeOnlyDate() => formatDate();

  String formatAccountNumber() {
    String accountNumber;

    // Format 1: structured HTML with "A/c No:" label
    final acMatch = RegExp(r'A/c No:<\/span>\s*([^|<]+)').firstMatch(this);
    if (acMatch != null) {
      accountNumber = acMatch.group(1)!.trim();
    } else if (contains('<')) {
      // No A/c No: label found in HTML — not a structured account number
      accountNumber = '-';
    } else {
      accountNumber = isNotEmpty ? this : '-';
    }

    if (accountNumber == '-') return '-';
    if (accountNumber.length > 5) {
      return '*' * (accountNumber.length - 4) +
          accountNumber.substring(accountNumber.length - 4);
    }
    return accountNumber;
  }

  String formatDateAndTime() {
    try {
      late DateTime dateTime;
      bool dateTimeSet = false;

      // Try to parse the date string with common formats
      try {
        // Try ISO format first
        dateTime = DateTime.parse(this);
        dateTimeSet = true;
      } catch (_) {
        // Try common date formats
        final List<String> possibleFormats = [
          'dd-MM-yyyy HH:mm',
          'dd/MM/yyyy HH:mm',
          'MM-dd-yyyy HH:mm',
          'MM/dd/yyyy HH:mm',
          'yyyy-MM-dd HH:mm',
          'yyyy/MM/dd HH:mm',
        ];

        for (final format in possibleFormats) {
          try {
            dateTime = DateFormat(format).parse(this);
            dateTimeSet = true;
            break;
          } catch (_) {
            continue;
          }
        }

        if (!dateTimeSet) {
          // If all formats fail, try to parse with the system date format
          final String datePart = split(" ").first;
          final String timePart = split(" ").length > 1
              ? split(" ")[1]
              : "00:00";
          try {
            dateTime = DateFormat(
              '${dateAndTimeSetting["dateFormat"]} HH:mm',
            ).parse("$datePart $timePart");
            dateTimeSet = true;
          } catch (_) {
            // Return original if parsing fails
            return this;
          }
        }
      }

      if (dateAndTimeSetting["use24HourFormat"]) {
        final String date = DateFormat(
          dateAndTimeSetting["dateFormat"],
        ).format(dateTime);
        final String time = DateFormat('HH:mm').format(dateTime);
        return "$date $time";
      }

      return DateFormat(
        '${dateAndTimeSetting["dateFormat"]} hh:mm a',
      ).format(dateTime);
    } catch (e) {
      // Return the original string if parsing fails
      return this;
    }
  }

  //price format
  ///
  /// [currencySymbol] / [decimalPlaces] / [currencyCode] override the system
  /// currency (a booking keeps the currency it was placed in).
  String priceFormat(
    BuildContext context, {
    String? currencySymbol,
    int? decimalPlaces,
    String? currencyCode,
  }) {
    final settings = context.read<FetchSystemSettingsCubit>();
    final formatter = NumberFormat.currency(
      // Device locales such as "ars_US" (Najdi Arabic) are unknown to intl and
      // throw "Invalid locale"; fall back to the base language, then English.
      locale: Intl.verifiedLocale(
        Platform.localeName,
        NumberFormat.localeExists,
        onFailure: (_) => 'en',
      ),
      name: (currencyCode ?? '').isNotEmpty
          ? currencyCode
          : settings.SystemCurrencyCountryCode,
      symbol: (currencySymbol ?? '').isNotEmpty
          ? currencySymbol
          : settings.SystemCurrency,
      decimalDigits: decimalPlaces ?? int.parse(settings.SystemDecimalPoint),
    );

    // Handle null or empty strings, and return formatted zero if parsing fails
    return formatter.format(double.tryParse(replaceAll(",", '')) ?? 0.0);
  }

  /// [priceFormat] in the logged-in provider's country currency
  /// (`get_country_settings`); the system currency until that loads.
  ///
  /// [currencySymbol] / [decimalPlaces] from the amount's own API row win over
  /// the provider's country.
  String providerPriceFormat(
    BuildContext context, {
    String? currencySymbol,
    int? decimalPlaces,
  }) {
    final country = context.read<FetchCountrySettingsCubit>();
    final bool hasOwnSymbol = (currencySymbol ?? '').isNotEmpty;
    return priceFormat(
      context,
      currencySymbol: hasOwnSymbol ? currencySymbol : country.currencySymbol,
      decimalPlaces: decimalPlaces ?? country.currencyDecimalPlaces,
      currencyCode: hasOwnSymbol ? null : country.currencyCode,
    );
  }

  String extractFileName() {
    try {
      return split('/').last;
    } catch (_) {
      return '';
    }
  }

  String formatPercentage() {
    return '${toString()} %';
  }

  void debugPrint() {
    if (kDebugMode) {}
  }

  bool isImage() => [
    'png',
    'jpg',
    'jpeg',
    'gif',
    'webp',
    'bmp',
    'wbmp',
    'pbm',
    'pgm',
    'ppm',
    'tga',
    'ico',
    'cur',
  ].contains(toLowerCase().split('.').lastOrNull ?? '');

  dynamic toInt() {
    if (isEmpty) return this;
    return int.tryParse(this);
  }
}

/// Locale and language helpers shared across the app
class LocaleUtils {
  /// Validates if language code is valid using DateFormat.localeExists
  /// Returns valid language code or null if invalid
  static String? getValidLanguageCode(String? languageCode) {
    if (languageCode == null || languageCode.isEmpty) {
      return null;
    }

    final String normalizedCode = languageCode.trim();

    // Check if locale exists (valid language code)
    if (DateFormat.localeExists(normalizedCode)) {
      return normalizedCode;
    }

    // Try lowercase version
    final String lowerCode = normalizedCode.toLowerCase();
    if (DateFormat.localeExists(lowerCode)) {
      return lowerCode;
    }

    // Try base language code (e.g., 'ar' from 'arb', 'en' from 'en_US')
    if (normalizedCode.contains('_')) {
      final String baseLanguage = normalizedCode.split('_').first.toLowerCase();
      if (DateFormat.localeExists(baseLanguage)) {
        return baseLanguage;
      }
    }

    // Try extracting 2-letter code (common pattern: "arb" -> "ar")
    if (normalizedCode.length > 2) {
      final String twoLetterCode = lowerCode.substring(0, 2);
      if (DateFormat.localeExists(twoLetterCode)) {
        return twoLetterCode;
      }
    }

    // Invalid language code
    return null;
  }

  /// Gets current locale with proper fallback chain
  /// Step 1: Try LanguageDataCubit
  /// Step 2: Try storedLanguage from HiveRepository
  /// Step 3: Try defaultLanguage from LanguageListCubit
  /// Step 4: Fallback to 'en'
  static Locale getCurrentLocale(BuildContext context) {
    String? validLanguageCode;

    // Step 1: Try to get from LanguageDataCubit
    try {
      final languageState = context.read<LanguageDataCubit>().state;
      if (languageState is GetLanguageDataSuccess) {
        validLanguageCode = getValidLanguageCode(
          languageState.currentLanguage.languageCode,
        );
      }
    } catch (_) {
      // LanguageDataCubit not available, continue to next step
    }

    // Step 2: If Step 1 failed, try stored language
    if (validLanguageCode == null) {
      final AppLanguage? storedLanguage = HiveRepository.getCurrentLanguage();
      if (storedLanguage != null) {
        validLanguageCode = getValidLanguageCode(storedLanguage.languageCode);
      }
    }

    // Step 3: If Step 2 failed, try default language from LanguageListCubit
    if (validLanguageCode == null) {
      try {
        final languageListState = context.read<LanguageListCubit>().state;
        if (languageListState is GetLanguageListSuccess &&
            languageListState.defaultLanguage != null) {
          validLanguageCode = getValidLanguageCode(
            languageListState.defaultLanguage!.languageCode,
          );
        }
      } catch (_) {
        // LanguageListCubit not available, continue to next step
      }
    }

    // Step 4: Final fallback to English (always valid)
    return Locale(validLanguageCode ?? 'en');
  }

  /// Validates and normalizes language code for DateFormat usage
  /// Returns a valid locale code, falling back to default language or "en"
  static String getValidLanguageCodeOrFallback(String? languageCode) {
    // Use the public method for validation
    final String? validCode = getValidLanguageCode(languageCode);

    // If validation succeeded, return the valid code
    if (validCode != null) {
      return validCode;
    }

    // If validation failed, fallback to default language code
    return _getDefaultLanguageCode();
  }

  /// Gets default language code, falling back to "en" if not available
  static String _getDefaultLanguageCode() {
    try {
      final AppLanguage? currentLanguage = HiveRepository.getCurrentLanguage();

      if (currentLanguage != null && currentLanguage.languageCode.isNotEmpty) {
        final String defaultCode = currentLanguage.languageCode.trim();

        // Check if default locale is supported (try both original and lowercase)
        if (DateFormat.localeExists(defaultCode)) {
          return defaultCode;
        }

        // Try lowercase version
        final String lowerDefaultCode = defaultCode.toLowerCase();
        if (DateFormat.localeExists(lowerDefaultCode)) {
          return lowerDefaultCode;
        }

        // Try base language code (e.g., 'ar' from 'arb', 'en' from 'en_US')
        if (defaultCode.contains('_')) {
          final String baseLanguage = defaultCode
              .split('_')
              .first
              .toLowerCase();
          if (DateFormat.localeExists(baseLanguage)) {
            return baseLanguage;
          }
        }

        // Try extracting 2-letter code
        if (defaultCode.length > 2) {
          final String twoLetterCode = lowerDefaultCode.substring(0, 2);
          if (DateFormat.localeExists(twoLetterCode)) {
            return twoLetterCode;
          }
        }
      }
    } catch (_) {
      // Error getting default language, use "en"
    }

    // Final fallback to "en"
    return Intl.defaultLocale?.split('_').first ?? 'en';
  }
}
