import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:fixit_provider/firebase/firebase_api.dart';
import 'package:fixit_provider/providers/common_providers/notification_provider.dart';

// import 'package:purchases_flutter/purchases_flutter.dart';
import '../../config.dart';
import '../../services/environment.dart';

class SplashProvider extends ChangeNotifier {
  double size = 10;
  double roundSize = 10;
  double roundSizeWidth = 10;
  AnimationController? controller;
  Animation<double>? animation;

  AnimationController? controller2;
  Animation<double>? animation2;

  AnimationController? controller3;
  Animation<double>? animation3;

  AnimationController? controllerSlide;
  Animation<Offset>? offsetAnimation;

  AnimationController? popUpAnimationController;

  onReady(TickerProvider sync, context) async {
    hideLoading(context);
    await getAppSettingList(context);
    bool isAvailable = await isNetworkConnection();
    final commonApi = Provider.of<CommonApiProvider>(context, listen: false);

    final userApi = Provider.of<UserDataApiProvider>(context, listen: false);
    final locationCtrl = Provider.of<LocationProvider>(context, listen: false);
    log("message123");
    await commonApi.selfApi(context);
    log("SELF:::${userModel?.id}");

    await commonApi.getDashBoardApi(context);
    commonApi.getAllCategory();
    userApi.getJobRequest(context);

    // userApi.getCategory();
    // userApi.getDocumentDetails();
    // commonApi.getCountryState();
    commonApi.getZoneList();
    commonApi.getKnownLanguage();
    // commonApi.getDocument();

    if (isAvailable) {
      // commonApi.selfApi(context);
      // commonApi.getDashBoardApi(context);
      userApi.getBookingHistory(context);
      commonApi.getCountryState();
      // commonApi.getKnownLanguage();
      // locationCtrl.getUserCurrentLocation(context);
      CustomNotificationController().initNotification(context);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var freelancer = prefs.getBool(session.isFreelancer) ?? false;
      var serviceman = prefs.getBool(session.isServiceman) ?? false;

      var login = prefs.getBool(session.isLogin) ?? false;
      bool notification = prefs.getBool(session.isNotification) ?? true;
      log("FREEELANCEERRR $freelancer");
      prefs.setBool(session.isNotification, notification);
      isLogin = login;
      isFreelancer = freelancer;
      isServiceman = serviceman;
      log("LOGGIINN $login");

      notifyListeners();
      dynamic userData = prefs.getString(session.user);

      notifyListeners();

      Provider.of<AppSettingProvider>(context, listen: false)
          .onNotification(notification, context);
      bool isAuthenticate = false;
      isLogin = login;

      if (userData != null) {
        isAuthenticate = prefs.getBool(session.token) ?? false;
        userApi.getWalletList(context);
        // if (!isFreelancer) {
        //   userApi.getServicemenByProviderId();
        // }

        // await commonApi.getProviderById(context, userData['provider_id']);
        if (isFreelancer || !isServiceman) {
          // userApi.getServicePackageList();
          // userApi.getServiceAddOnsList();
          // commonApi.selfApi(context);
          userApi.getBookingHistory(context);
          // userApi.getCategory();
          log("isServiceman:$isServiceman");
          notifyListeners();
        }

        FirebaseApi().onlineActiveStatusChange(false);
      }

      if (appSettingModel != null &&
          appSettingModel?.maintenance?.maintenanceMode == "1") {
        route.pushReplacementNamed(context, routeName.maintenance);
      } else {
        if (userData != null) {
          if (isAuthenticate) {
            route.pushReplacementNamed(context, routeName.dashboard);
            Provider.of<LocationProvider>(context, listen: false).getZoneId();
          } else {
            final dash = Provider.of<DashboardProvider>(context, listen: false);
            dash.selectIndex = 0;
            dash.notifyListeners();
            // commonApi.getDashBoardApi(context);
            // userApi.homeStatisticApi();
            prefs.remove(session.user);
            prefs.remove(session.accessToken);
            prefs.remove(session.token);
            prefs.remove(session.isLogin);
            prefs.remove(session.isFreelancer);
            prefs.remove(session.isServiceman);
            prefs.remove(session.isLogin);
            userModel = null;
            userPrimaryAddress = null;
            provider = null;
            position = null;
            statisticModel = null;
            bankDetailModel = null;
            popularServiceList = [];
            servicePackageList = [];
            providerDocumentList = [];
            notificationList = [];
            notUpdateDocumentList = [];
            addressList = [];

            route.pushReplacementNamed(context, routeName.intro);
          }
        } else {
          route.pushReplacementNamed(context, routeName.intro);
        }
      }
    } else {
      log("isAvailable is Available:::$isAvailable");
      route.pushReplacementNamed(context, routeName.noInternet);
    }
  }

  onChangeSize() {
    size = size == 10 ? 115 : 115;
    notifyListeners();
  }

  //setting list
  getAppSettingList(BuildContext context) async {
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    try {
      var value = await apiServices.getApi(api.settings, [], isData: true);

      if (value.isSuccess!) {
        log("message-=-=-=-=-=${value.data['values']}");
        appSettingModel = AppSettingModel.fromJson(value.data['values']);

        final currencyData =
            Provider.of<CurrencyProvider>(context, listen: false);
/*         Provider.of<CurrencyProvider>(context, listen: false); */
        log("string : ${appSettingModel!.general?.defaultCurrency?.symbol}");
        // log("currentZoneModel.first.data!.first::${currentZoneModel.first.currency?.code}");
        /*     onUpdate(currencyData, currentZoneModel.first.currency ?? "USD"); */
        onUpdate(currencyData, appSettingModel!.general!.defaultCurrency!);

        onUpdateLanguage(context, appSettingModel!.general!.defaultLanguage!);
        // SharedPreferences pref = await SharedPreferences.getInstance();
        // var selectedLocale = sharedPreferences.getString("selectedLocale");
        // languageProvider.changeLocale(
        //     selectedLocale != null
        //         ? selectedLocale.toString()
        //         : appSettingModel!.general!.defaultLanguage,
        //     context);
        notifyListeners();
        /* } */
      }
    } catch (e, s) {
      log("EEEEEEE:getAppSettingList::$e=====$s");
      notifyListeners();
    }
  }

  Future<void> onUpdate(
      CurrencyProvider currencyData, CurrencyModel data) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    double? currencyVal = pref.getDouble(session.currencyVal);
    if (currencyVal != null) {
      final prefCurrency = pref.getString(session.currency);
      currencyData.currencyVal = currencyVal;
      currencyData.currency = CurrencyModel.fromJson(jsonDecode(prefCurrency!));
      currencyData.priceSymbol = pref.getString(session.priceSymbol)!;
      currencyData.notifyListeners();
    } else {
      currencyData.priceSymbol = data.symbol.toString();
      currencyData.currency = data;
      currencyData.currencyVal = data.exchangeRate!;
      currencyData.notifyListeners();
    }

    await pref.setString(session.priceSymbol, currencyData.priceSymbol);
    Map<String, dynamic> cc = await currencyData.currency!.toJson();
    await pref.setString(session.currency, jsonEncode(cc));
    await pref.setDouble(session.currencyVal, currencyData.currencyVal);
  }

  Locale? locale;

  onUpdateLanguage(context, DefaultLanguage data) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final language = Provider.of<LanguageProvider>(context, listen: false);
    var selectedLocale = sharedPreferences.getString("selectedLocale");
    /*   log("messagedatadatadavdsfsdta::${data.locale}");
    log("messagedatadatadavdsfsdta::12${selectedLocale}"); */

    // Locale convertedLocale;
    // convertedLocale = Locale(selectedLocale.toString(), "AR");
    if (pref.getString("selectedLocale") == null) {
      await pref.setString('selectedLocale', data.locale!);

      language.getLocal();
      if (selectedLocale == null) {
        language.getLanguageTranslate(context, languageCode: data.locale);
      } else {
        language.getLanguageTranslate(context,
            languageCode: selectedLocale.toString());
      }
    } else {
      /*  log("messagedatadatadavdsfsdta::${data.locale}"); */
      language.getLocal();
      if (selectedLocale == null) {
        language.getLanguageTranslate(context, languageCode: data.locale);
      } else {
        language.getLanguageTranslate(context,
            languageCode: selectedLocale.toString());
      }
    }
  }
}
