import 'dart:convert';

import 'package:edemand_partner/app/generalImports.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;

class AppLocalization {
  final Locale locale;

  late Map<String, String> _localizedValues;

  AppLocalization(this.locale);

  static AppLocalization? of(BuildContext context) {
    return Localizations.of(context, AppLocalization);
  }

  /// Bundled English strings, read once at startup by [preloadBundled] so
  /// [loadSync] never has to wait on the asset bundle.
  static Map<String, dynamic>? _bundledJson;

  /// Call during app bootstrap (behind the brand splash). Without it the first
  /// [Localizations] load is async and MaterialApp paints an empty (black)
  /// frame before the first route appears.
  static Future<void> preloadBundled() async {
    _bundledJson ??= json.decode(
      await rootBundle.loadString('assets/languages/en.json'),
    );
  }

  /// Loads strings without awaiting; returns false if nothing is available
  /// yet (no cached language in Hive and [preloadBundled] not done).
  bool loadSync() {
    final cached = HiveRepository.getLanguageJsonData();
    final Map<String, dynamic>? mappedJson = cached != null
        ? Map<String, dynamic>.from(cached)
        : _bundledJson;
    if (mappedJson == null) return false;
    _localizedValues = mappedJson.map(
      (key, value) => MapEntry(key, value.toString()),
    );
    return true;
  }

  Future loadJson() async {
    if (!loadSync()) {
      await preloadBundled();
      loadSync();
    }
  }

  String? getTranslatedValues(String? key) {
    return _localizedValues[key!];
  }

  static const LocalizationsDelegate<AppLocalization> delegate =
      _AppLocalizationDelegate();
}

class _AppLocalizationDelegate extends LocalizationsDelegate<AppLocalization> {
  const _AppLocalizationDelegate();

  @override
  bool isSupported(Locale locale) {
    return true;
  }

  @override
  Future<AppLocalization> load(Locale locale) {
    final AppLocalization localization = AppLocalization(locale);
    // Synchronous when possible so the first frame is never blank.
    if (localization.loadSync()) {
      return SynchronousFuture<AppLocalization>(localization);
    }
    return localization.loadJson().then((_) => localization);
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalization> old) {
    return true;
  }
}
