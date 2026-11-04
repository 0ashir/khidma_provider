import '../../app/generalImports.dart';

class HiveRepository {
  //box-keys
  static const String userDetailBoxKey = 'userDetailsBox';

  static const String authStatusBoxKey = 'authBox';
  static String languageBoxKey = 'language';
  static String themeBoxKey = 'themeBox';

  //value-keys
  static const String tokenIdKey = 'token';
  static const String handymanDetailsKey = 'handymanDetails';
  static const String loggedInUserTypeKey = 'loggedInUserType';
  static const String handymanLoginTypeKey = 'handymanLoginType';
  static const String isAuthenticatedKey = 'isAuthenticated';
  static const String isUserFirstTimeKey = 'isUserFirstTime';
  static String lastSkippedMaintenanceScheduleWarningKey =
      "lastSkippedMaintenanceScheduleWarning";

  static String currentThemeKey = 'currentTheme';
  static String resendTokenKey = 'resendToken';

  static String currentLanguageKey = "currentLanguageKey";
  static String languageJsonDataKey = "languageJsonData";
  static String languageUpdatedAtKey = "languageUpdatedAtKey";

  static Future<void> init() async {
    await Hive.openBox(languageBoxKey);
    await Hive.openBox(authStatusBoxKey);
    await Hive.openBox(themeBoxKey);
    await Hive.openBox(userDetailBoxKey);
    await Hive.openBox(placesBoxKey);
  }

  static AppTheme getCurrentTheme() {
    final current = Hive.box(themeBoxKey).get(currentThemeKey);

    if (current == null) {
      return AppTheme.light;
    }
    if (current == 'light') {
      return AppTheme.light;
    }
    if (current == 'dark') {
      return AppTheme.dark;
    }
    return AppTheme.light;
  }

  static void setCurrentTheme(AppTheme theme) {
    String newTheme;
    if (theme == AppTheme.light) {
      newTheme = 'light';
    } else {
      newTheme = 'dark';
    }
    Hive.box(themeBoxKey).put(HiveRepository.currentThemeKey, newTheme);
  }

  static Future<bool> storeLanguage({
    required dynamic data,
    required AppLanguage lang,
  }) async {
    final box = Hive.box(languageBoxKey);

    await box.put(languageJsonDataKey, data);
    await box.put(currentLanguageKey, lang.toJson()); // storing as JSON
    // Store updated_at separately for easy comparison
    if (lang.updatedAt != null) {
      await box.put(languageUpdatedAtKey, lang.updatedAt);
    }

    return true;
  }

  static dynamic getLanguageJsonData() {
    return Hive.box(languageBoxKey).get(languageJsonDataKey);
  }

  static AppLanguage? getCurrentLanguage() {
    final data = Hive.box(languageBoxKey).get(currentLanguageKey);

    if (data == null) {
      return null;
    }

    // Convert Map<dynamic, dynamic> → Map<String, dynamic>
    final language = AppLanguage.fromJson(
      Map<String, dynamic>.from(data as Map),
    );

    return language;
  }

  /// Get stored updated_at for the current language
  static String? getStoredLanguageUpdatedAt() {
    return Hive.box(languageBoxKey).get(languageUpdatedAtKey)?.toString();
  }

  static String get getUserToken =>
      Hive.box(userDetailBoxKey).get(tokenIdKey) ?? '';

  static set setUserToken(value) =>
      Hive.box(userDetailBoxKey).put(tokenIdKey, value);

  static Future<void> setUserData(Map data) async {
    await Hive.box(userDetailBoxKey).put("userDetails", data);
  }

  /// Stores the flat handyman login payload for the active handyman session.
  static Future<void> setHandymanData(Map data) async {
    await Hive.box(userDetailBoxKey).put(handymanDetailsKey, data);
  }

  static HandymanLoginModel? getHandymanData() {
    final data = Hive.box(userDetailBoxKey).get(handymanDetailsKey);
    if (data == null) return null;
    try {
      return HandymanLoginModel.fromJson(Map<String, dynamic>.from(data));
    } catch (_) {}
    return null;
  }

  /// How the active handyman signed in (phone or email). Null for sessions
  /// created before this was stored.
  static LoginType? get getHandymanLoginType {
    final value = Hive.box(userDetailBoxKey).get(handymanLoginTypeKey);
    return value == null ? null : LoginType.fromAPIValue(value.toString());
  }

  static set setHandymanLoginType(LoginType value) =>
      Hive.box(userDetailBoxKey).put(handymanLoginTypeKey, value.value);

  /// Which kind of user owns the active session.
  static UserType get getLoggedInUserType => UserType.fromValue(
    Hive.box(userDetailBoxKey).get(loggedInUserTypeKey)?.toString(),
  );

  static set setLoggedInUserType(UserType value) =>
      Hive.box(userDetailBoxKey).put(loggedInUserTypeKey, value.value);

  static bool get isHandymanSession => getLoggedInUserType.isHandyman;

  static ProviderDetails getProviderDetails() {
    try {
      return ProviderDetails.fromJson(
        Map.from(Hive.box(userDetailBoxKey).get("userDetails") ?? {}),
      );
    } catch (_) {}
    return ProviderDetails();
  }

  ///--------------------------------- placeBox methods

  static String placesBoxKey = 'places';
  static String getStoredPlacesKey = 'getStoredPlaces';

  static List<Map> get getStoredPlaces {
    return ((Hive.box(placesBoxKey).get(getStoredPlacesKey) ?? []) as List)
        .map((e) => Map.from(e))
        .toList();
  }

  static set setPlaces(List<Map> enable) {
    Hive.box(placesBoxKey).put(getStoredPlacesKey, enable);
  }

  static Future<void> storePlaceInHive({
    required String placeId,
    required String placeName,
    required String latitude,
    required String longitude,
  }) async {
    final List<Map> lists = HiveRepository.getStoredPlaces;

    lists.removeWhere((element) => element["placeId"] == placeId);
    lists.insert(0, {
      "name": placeName,
      "cityName": placeName,
      "placeId": placeId,
      "latitude": latitude,
      "longitude": longitude,
    });

    HiveRepository.setPlaces = lists;
  }

  ///--------------------------------- authStatusBoxKey
  static bool get isUserLoggedIn =>
      Hive.box(authStatusBoxKey).get(isAuthenticatedKey) ?? false;

  static set setUserLoggedIn(enable) =>
      Hive.box(authStatusBoxKey).put(isAuthenticatedKey, enable);

  static dynamic get getResendToken =>
      Hive.box(userDetailBoxKey).get(resendTokenKey);

  static set setResendToken(enable) =>
      Hive.box(userDetailBoxKey).put(resendTokenKey, enable);

  static bool get isUserFirstTimeInApp =>
      Hive.box(authStatusBoxKey).get(isUserFirstTimeKey) ?? true;

  static set setUserFirstTimeInApp(enable) =>
      Hive.box(authStatusBoxKey).put(isUserFirstTimeKey, enable);

  static Future<void> clearBoxValues({required String boxName}) async {
    await Hive.box(boxName).clear();
  }

  static String? get getLastSkippedMaintenanceScheduleWarning =>
      Hive.box(userDetailBoxKey).get(lastSkippedMaintenanceScheduleWarningKey);

  static set setLastSkippedMaintenanceScheduleWarning(data) => Hive.box(
    userDetailBoxKey,
  ).put(lastSkippedMaintenanceScheduleWarningKey, data);
}
