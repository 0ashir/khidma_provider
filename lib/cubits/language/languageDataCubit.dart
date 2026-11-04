import 'package:edemand_partner/app/generalImports.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'dart:convert';

abstract class LanguageDataState {}

class LanguageDataInitial extends LanguageDataState {}

class GetLanguageDataInProgress extends LanguageDataState {}

class GetLanguageDataSuccess extends LanguageDataState {
  final dynamic jsonData;
  final AppLanguage currentLanguage;

  GetLanguageDataSuccess({
    required this.jsonData,
    required this.currentLanguage,
  });
}

class GetLanguageDataError extends LanguageDataState {
  final dynamic error;

  GetLanguageDataError(this.error);
}

class LanguageDataCubit extends Cubit<LanguageDataState> {
  LanguageDataCubit() : super(LanguageDataInitial());

  /// Load English language data from local assets as fallback
  Future<Map<String, dynamic>> _loadFallbackEnglishData() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/languages/en.json',
      );
      return json.decode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      // Return empty map if even local file fails to load
      return {};
    }
  }

  /// Creates fallback English language object
  AppLanguage _createFallbackEnglishLanguage() {
    return const AppLanguage(
      id: 'en_fallback',
      languageCode: 'en',
      languageName: 'English',
      imageURL: 'assets/images/flags/aus.png',
      isRtl: '0',
      isDefault: true,
    );
  }

  Future<void> getLanguageData({required AppLanguage languageData}) async {
    try {
      emit(GetLanguageDataInProgress());

      // Quick check: Get stored data once
      final storedLanguage = HiveRepository.getCurrentLanguage();
      final storedJsonData = HiveRepository.getLanguageJsonData();

      // Single condition check: Use cached data if language matches and updated_at is same
      final canUseCachedData =
          storedLanguage != null &&
          storedJsonData != null &&
          storedLanguage.languageCode == languageData.languageCode &&
          (languageData.updatedAt == null && storedLanguage.updatedAt == null ||
              (languageData.updatedAt != null &&
                  storedLanguage.updatedAt != null &&
                  languageData.updatedAt == storedLanguage.updatedAt));

      if (canUseCachedData) {
        // Use stored data - no API call needed
        _setTimeagoLocale(
          storedLanguage.languageCode,
          Map<String, dynamic>.from(storedJsonData),
        );
        ClarityService.logAction(ClarityActions.languageChanged, {
          'language_code': languageData.languageCode,
          'fallback': 'false',
          'source': 'cached',
        });
        ClarityService.setTag('language', languageData.languageCode);
        emit(
          GetLanguageDataSuccess(
            jsonData: storedJsonData,
            currentLanguage: storedLanguage,
          ),
        );
        return;
      }

      // Fetch from API only when needed
      final jsonData = await SettingsRepository().getLanguageJsonData(
        languageData.languageCode,
      );

      // Check if data is empty
      if (jsonData.isEmpty) {
        // Use fallback English from local assets
        final fallbackData = await _loadFallbackEnglishData();
        final fallbackLanguage = _createFallbackEnglishLanguage();
        _setTimeagoLocale(fallbackLanguage.languageCode, fallbackData);
        ClarityService.logAction(ClarityActions.languageChanged, {
          'language_code': fallbackLanguage.languageCode,
          'fallback': 'true',
        });
        ClarityService.setTag('language', fallbackLanguage.languageCode);
        emit(
          GetLanguageDataSuccess(
            jsonData: fallbackData,
            currentLanguage: fallbackLanguage,
          ),
        );
      } else {
        // Store the fetched data in Hive
        await HiveRepository.storeLanguage(data: jsonData, lang: languageData);
        _setTimeagoLocale(
          languageData.languageCode,
          Map<String, dynamic>.from(jsonData),
        );
        ClarityService.logAction(ClarityActions.languageChanged, {
          'language_code': languageData.languageCode,
          'fallback': 'false',
          'source': 'api',
        });
        ClarityService.setTag('language', languageData.languageCode);
        emit(
          GetLanguageDataSuccess(
            jsonData: jsonData,
            currentLanguage: languageData,
          ),
        );
      }
    } catch (e) {
      // On error, try to use stored data if available and language matches
      final storedLanguage = HiveRepository.getCurrentLanguage();
      final storedJsonData = HiveRepository.getLanguageJsonData();

      if (storedLanguage != null &&
          storedJsonData != null &&
          storedLanguage.languageCode == languageData.languageCode) {
        _setTimeagoLocale(
          languageData.languageCode,
          Map<String, dynamic>.from(storedJsonData),
        );
        ClarityService.logAction(ClarityActions.languageChanged, {
          'language_code': storedLanguage.languageCode,
          'fallback': 'false',
          'source': 'cached_on_error',
          'error': e.toString(),
        });
        ClarityService.setTag('language', storedLanguage.languageCode);
        emit(
          GetLanguageDataSuccess(
            jsonData: storedJsonData,
            currentLanguage: storedLanguage,
          ),
        );
        return;
      }

      // Last resort: Load English from local assets
      final fallbackData = await _loadFallbackEnglishData();
      final fallbackLanguage = _createFallbackEnglishLanguage();
      _setTimeagoLocale(
        languageData.languageCode,
        Map<String, dynamic>.from(fallbackData),
      );
      ClarityService.logAction(ClarityActions.languageChanged, {
        'language_code': fallbackLanguage.languageCode,
        'fallback': 'true',
        'error': e.toString(),
      });
      ClarityService.setTag('language', fallbackLanguage.languageCode);
      emit(
        GetLanguageDataSuccess(
          jsonData: fallbackData,
          currentLanguage: fallbackLanguage,
        ),
      );
    }
  }

  Future<void> setLanguageData({
    required AppLanguage languageData,
    required dynamic jsonData,
  }) async {
    _setTimeagoLocale(
      languageData.languageCode,
      Map<String, dynamic>.from(jsonData),
    );
    emit(
      GetLanguageDataSuccess(jsonData: jsonData, currentLanguage: languageData),
    );
  }

  /// Sets timeago locale messages based on the language data
  void _setTimeagoLocale(String languageCode, Map<String, dynamic> jsonData) {
    try {
      timeago.setLocaleMessages(languageCode, _CustomTimeagoMessages(jsonData));
      // Set as default locale for timeago
      timeago.setDefaultLocale(languageCode);
    } catch (e) {
      // Fallback to English messages if translation setup fails
      timeago.setLocaleMessages(languageCode, timeago.EnMessages());
      timeago.setDefaultLocale('en');
    }
  }
}

/// Custom Messages from JSON for timeago
class _CustomTimeagoMessages implements timeago.LookupMessages {
  final Map<String, dynamic> translations;

  _CustomTimeagoMessages(this.translations);

  @override
  String prefixAgo() => translations['timeagoPrefixAgo'] ?? '';
  @override
  String prefixFromNow() => translations['timeagoPrefixFromNow'] ?? '';
  @override
  String suffixAgo() => translations['timeagoSuffixAgo'] ?? 'ago';
  @override
  String suffixFromNow() => translations['timeagoSuffixFromNow'] ?? 'from now';
  @override
  String lessThanOneMinute(int seconds) =>
      translations['timeagoLessThanOneMinute'] ?? 'a moment';
  @override
  String aboutAMinute(int minutes) =>
      translations['timeagoAboutAMinute'] ?? 'a minute';
  @override
  String minutes(int minutes) =>
      '$minutes ${translations['timeagoMinutes'] ?? 'minutes'}';
  @override
  String aboutAnHour(int minutes) =>
      translations['timeagoAboutAnHour'] ?? 'about an hour';
  @override
  String hours(int hours) =>
      '$hours ${translations['timeagoHours'] ?? 'hours'}';
  @override
  String aDay(int hours) => translations['timeagoADay'] ?? 'a day';
  @override
  String days(int days) => '$days ${translations['timeagoDays'] ?? 'days'}';
  @override
  String aboutAMonth(int days) =>
      translations['timeagoAboutAMonth'] ?? 'about a month';
  @override
  String months(int months) =>
      '$months ${translations['timeagoMonths'] ?? 'months'}';
  @override
  String aboutAYear(int year) =>
      translations['timeagoAboutAYear'] ?? 'about a year';
  @override
  String years(int years) =>
      '$years ${translations['timeagoYears'] ?? 'years'}';
  @override
  String wordSeparator() => translations['timeagoWordSeparator'] ?? ' ';
}
