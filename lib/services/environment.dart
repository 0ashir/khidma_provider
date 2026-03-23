//FOR DATA ENTRY
import 'dart:developer';
import 'dart:io';
import '../config.dart';

// FOR USER
String apiUrl = "https://admin.khidmaplus.com/api";
String paymentUrl = "https://admin.khidmaplus.com/api";
String providerAppUrl = "https://play.google.com/store/apps/details?id=com.provider.khadamat&pcampaignid=web_share";
String userAppPlayStoreUrl = "https://apps.apple.com/us/app/khidma-plus-home-services/id6755617892";
String googleMapKey = "AIzaSyDNbeNlSQb8NyHK-z-JlVQWicssGnzyJms";

// Global SharedPreferences and Locale
late SharedPreferences sharedPreferences;
String local = appSettingModel!.general!.defaultLanguage!.locale!;

// Initialize SharedPreferences and Locale
Future<void> initializeAppSettings() async {
  sharedPreferences = await SharedPreferences.getInstance();
  local = sharedPreferences.getString('selectedLocale') ?? "en";
  log("set language:: $local");
}

Map<String, String>? headersToken(
  String? token, {
  bool isLang = false,
  String? localLang,
}) =>
    {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      "Accept-Lang": isLang ? "$localLang" : 'en',
      "Authorization": "Bearer $token",
    };

Map<String, String>? get headers => {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      "Accept-Lang": local,
    };
