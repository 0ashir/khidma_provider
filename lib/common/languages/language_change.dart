import 'dart:developer';

import 'package:fixit_provider/common/languages/ar.dart';
import 'package:fixit_provider/common/languages/language_helper.dart';
import 'package:fixit_provider/model/translation_model.dart';

import '../../config.dart';
import '../../model/system_language_model.dart';

class LanguageProvider with ChangeNotifier {
  LanguageProvider(this.sharedPreferences, context) {
    // getLanguageTranslate();
    var selectedLocale = sharedPreferences.getString("selectedLocale");

    if (selectedLocale != null) {
      locale = Locale(selectedLocale);
    } else {
      // selectedLocale = "english";
      // locale = const Locale("en");
    }

    setVal(selectedLocale, context);
    getLanguage();
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
    try {
      translations = Translation.defaultTranslations();
      await apiServices
          .getApi(api.systemLanguage, [], isToken: false)
          .then((value) {
        if (value.isSuccess!) {
          languageList.clear(); // Clear before adding
          for (var item in value.data) {
            SystemLanguage systemLanguage = SystemLanguage.fromJson(item);
            if (!languageList.contains(systemLanguage)) {
              languageList.add(systemLanguage);
            }
          }

// ✅ Compare with saved locale and set selected index
          String? selectedLocaleCode =
              sharedPreferences.getString("selectedLocale") ?? "en";
          int index = languageList.indexWhere((element) =>
          element.appLocale?.split("_")[0] == selectedLocaleCode);
          if (index != -1) {
            selectedIndex = index;
            log("✅ Selected index set to $selectedIndex for locale $selectedLocaleCode");
          } else {
            selectedIndex = 0; // fallback
          }
        }
        notifyListeners();
      });
    } catch (e) {
      debugPrint("EEEE NOTI LANGUAGE $e");
    }
  }

  // LanguageHelper languageHelper = LanguageHelper();

  changeLocale(SystemLanguage newLocale, context) {
    log("sharedPreferences a1: ${newLocale.locale}");
    Locale convertedLocale;

    currentLanguage = newLocale.name!;
    convertedLocale = Locale(
        newLocale.appLocale!.split("_")[0], newLocale.appLocale!.split("_")[1]);

    locale = convertedLocale;
    sharedPreferences.setString(
        'selectedLocale', locale!.languageCode.toString());

    getLanguageTranslate(context,
        languageCode: locale!.languageCode.toString());

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
    isTranslateLoader = true;
    notifyListeners();
    try {
      translations = Translation.defaultTranslations();
      final response = await apiServices.getApi(
          isSelectLanguage == true
              ? "${api.translate}/${locale!.languageCode}"
              : "${api.translate}/${languageCode}",
          [],
          isToken: false,
          isData: true);

      if (response.isSuccess!) {
        isTranslateLoader = false;
        translations = Translation.fromJson(
            response.data, context); // Directly pass the map
        // log("Loaded translations: ${response.data}");

        notifyListeners();
      } else {
        isTranslateLoader = false;
        log('Failed to load translations, using defaults');
        translations = Translation.defaultTranslations();
        notifyListeners();
      }
    } catch (e, s) {
      isTranslateLoader = false;
      log('Error Translation: $e==$s');
      translations = Translation.defaultTranslations();
      notifyListeners();
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
