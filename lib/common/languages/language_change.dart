import 'dart:developer';

import 'package:fixit_provider/model/translation_model.dart';
import 'package:fixit_provider/services/environment.dart' as env;
import 'package:fixit_provider/services/google_translation_service.dart';

import '../../config.dart';
import '../../model/system_language_model.dart';

class LanguageProvider with ChangeNotifier {
  LanguageProvider(this.sharedPreferences, context) {
    var selectedLocale = sharedPreferences.getString("selectedLocale");

    if (selectedLocale != null) {
      locale = Locale(selectedLocale);
    } else {
      locale = Locale(
          appSettingModel?.general?.defaultLanguage?.locale ?? "en");
    }

    setVal(selectedLocale, context);
    getLanguage();
    getLanguageTranslate(context); // load translations immediately at app start
  }

  String currentLanguage = appFonts.english;
  Locale? locale;
  int? selectedIndex;
  List<SystemLanguage> languageList = [];
  final SharedPreferences sharedPreferences;
  String? apiLanguage;
  int addSelectedIndex = 0; // Store selected index
  var selectedLocaleService = "en";

  void setSelectedIndex(int index, String locale) async {
    addSelectedIndex = index;
    selectedLocaleService = locale;
    // log("Selected Language Updated: $selectedLocaleService");

    await sharedPreferences.setString("selectedLocaleService", locale);

    notifyListeners();
  }

  bool isLoading = false;
  getLanguage() async {
    // Fetches the list of available languages only — does NOT touch translations.
    try {
      final value = await apiServices.getApi(api.systemLanguage, [], isToken: false);
      if (value.isSuccess == true) {
        languageList.clear();
        for (var item in value.data) {
          SystemLanguage systemLanguage = SystemLanguage.fromJson(item);
          if (!languageList.contains(systemLanguage)) {
            languageList.add(systemLanguage);
          }
        }
        String? selectedLocaleCode =
            sharedPreferences.getString("selectedLocale") ?? "en";
        int index = languageList.indexWhere(
            (element) => element.appLocale?.split("_")[0] == selectedLocaleCode);
        selectedIndex = index != -1 ? index : 0;
        log("✅ Language list loaded. selectedIndex=$selectedIndex");
      }
      notifyListeners();
    } catch (e) {
      debugPrint("EEEE NOTI LANGUAGE $e");
    }
  }

  // Awaits the full translation fetch so screens rebuild exactly once with the
  // correct language — no English flash, no stale rebuild before data arrives.
  changeLocale(SystemLanguage newLocale, context) async {
    currentLanguage = newLocale.name!;
    locale = Locale(
        newLocale.appLocale!.split("_")[0], newLocale.appLocale!.split("_")[1]);
    final langCode = locale!.languageCode.toString();
    sharedPreferences.setString('selectedLocale', langCode);
    env.local = langCode;
    GoogleTranslationService.clearCache(); // discard stale translations
    log('🌐 [changeLocale] switching to $langCode');
    await getLanguageTranslate(context, languageCode: langCode);
    notifyListeners();
  }

  getLocal() {
    var selectedLocale = sharedPreferences.getString("selectedLocale");
    return selectedLocale;
  }

  //translateText api
  bool isTranslateLoader = false;
  getLanguageTranslate(context,
      {bool? isSelectLanguage = false, String? languageCode}) async {
    final resolvedCode = isSelectLanguage == true
        ? locale?.languageCode
        : languageCode;
    final endpoint = "${api.translate}/$resolvedCode";
    log('🌐 [Translation] START — lang=$resolvedCode  endpoint=$endpoint');
    isTranslateLoader = true;
    notifyListeners();
    try {
      // Do NOT reset translations before the await — keep whatever language
      // is currently shown so there is no English flash while data loads.
      final response = await apiServices.getApi(
          endpoint, [], isToken: false, isData: true);

      log('🌐 [Translation] RESPONSE — isSuccess=${response.isSuccess}  data=${response.data == null ? "null" : "received"}');

      if (response.isSuccess == true && response.data != null) {
        translations = Translation.fromJson(response.data, context);
        log('🌐 [Translation] DONE — loaded successfully for $resolvedCode');
      } else {
        log('🌐 [Translation] FAILED — keeping existing. message=${response.message}');
        translations ??= Translation.defaultTranslations();
      }
    } catch (e, s) {
      log('🌐 [Translation] ERROR — $e\n$s');
      translations ??= Translation.defaultTranslations();
    } finally {
      isTranslateLoader = false;
      notifyListeners();
    }
  }

  setVal(value, context) {
    notifyListeners();
    int index = languageList.indexWhere((element) => element.locale == value);
    if (index >= 0) {
      SystemLanguage systemLanguage = languageList[index];
      changeLocale(systemLanguage, context);
    }
  }

  setIndex(index) {
    selectedIndex = index;
    sharedPreferences.setInt("index", selectedIndex!);
    notifyListeners();
  }
}
