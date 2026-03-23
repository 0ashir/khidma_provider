import 'dart:convert';
import 'dart:developer';
import 'package:fixit_provider/config.dart';
import 'package:fixit_provider/providers/app_pages_provider/app_details_provider.dart';
import '../../firebase/firebase_api.dart';

class LoginAsProvider with ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormState> providerKey =
      GlobalKey<FormState>(debugLabel: 'providerKey');
  SharedPreferences? pref;
  bool isPassword = true;
  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();

  // password see tap
  passwordSeenTap() {
    isPassword = !isPassword;
    notifyListeners();
  }

  demoCreds() {
    emailController.text = "provider@example.com";
    passwordController.text = "123456789";
    notifyListeners();
  }

/*  Future<void> stePro() async {
    Purchases.addCustomerInfoUpdateListener((customerInfo) async {
      Map<String, EntitlementInfo>? entitlementInfo =
          customerInfo.entitlements.all;

      log("customerInfo :2$entitlementInfo");
      log("customerInfo :2${emailController.text}");
      if (emailController.text != '') {
        if (emailController.text != "provider@example.com") {
          if (entitlementInfo["one_month_sub"]?.isActive == false) {
            // appCtrl.storage.remove(session.managementURL);
            sharedPreferences.remove(session.isPlanActive);
            session.isPlanActiveBool = false;
          } else if (entitlementInfo["three_month_sub"]?.isActive == false) {
            // appCtrl.storage.remove(session.managementURL);
            sharedPreferences.remove(session.isPlanActive);
            session.isPlanActiveBool = false;
          } else if (entitlementInfo["one_year_sub"]?.isActive == false) {
            // appCtrl.storage.remove(session.managementURL);
            sharedPreferences.remove(session.isPlanActive);
            session.isPlanActiveBool = false;
            log("HHHHHHHH");
          }
          notifyListeners();
          // await FirebaseFirestore.instance
          //     .collection(collectionName.subscribeUser)
          //     .doc(appCtrl.user['id'])
          //     .update({"status": appCtrl.isPlanActive});
        } else {
          log("adsdsadasdasdasdasdsaaAAAAAAAA");
          sharedPreferences.setBool(
              session.isPlanActive, session.isPlanActiveBool);
          session.isPlanActiveBool = true;
        }
      } else {
        if (entitlementInfo.isEmpty) {
          log("END L${entitlementInfo.isEmpty}");
          // appCtrl.storage.remove(session.managementURL);
          sharedPreferences.remove(session.isPlanActive);
          session.isPlanActiveBool = false;
        } else {
          if (entitlementInfo["one_month_sub"]?.isActive == false) {
            log("HGHGHJ :${entitlementInfo["one_month_sub"]}");
            // appCtrl.storage.remove(session.managementURL);
            sharedPreferences.remove(session.isPlanActive);
            session.isPlanActiveBool = false;
          } else if (entitlementInfo["three_month_sub"]?.isActive == false) {
            log("HGHGHJ :${entitlementInfo["three_month_sub"]?.isActive}");
            // appCtrl.storage.remove(session.managementURL);
            sharedPreferences.remove(session.isPlanActive);
            session.isPlanActiveBool = false;
          } else if (entitlementInfo["one_year_sub"]?.isActive == false) {
            // appCtrl.storage.remove(session.managementURL);
            sharedPreferences.remove(session.isPlanActive);
            session.isPlanActiveBool = false;
            log("HHHHHHHH");
          } else {
            log("JJJJJJJJJ");
            sharedPreferences.setBool(
                session.isPlanActive, session.isPlanActiveBool);
            session.isPlanActiveBool = true;
          }
        }
      }
    });
  }*/

  //login
  login(context) async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (formKey.currentState!.validate()) {
      await FirebaseMessaging.instance.requestPermission();
      pref = await SharedPreferences.getInstance();
      String token = await getFcmToken();

      showLoading(context);
      notifyListeners();

      var body = {
        "email": emailController.text,
        "password": passwordController.text,
        "fcm_token": token ?? ""
      };

      try {
        await apiServices
            .postApi(api.login, jsonEncode(body))
            .then((value) async {
          notifyListeners();
          if (value.isSuccess!) {
            pref!.setBool(session.token, true);
            final appDetails =
                Provider.of<AppDetailsProvider>(context, listen: false);
            appDetails.getAppPages();
            final commonApi =
                Provider.of<CommonApiProvider>(context, listen: false);
            final userApi =
                Provider.of<UserDataApiProvider>(context, listen: false);
            await commonApi.selfApi(context);
            await commonApi.getDashBoardApi(context);
            userApi.getBookingHistory(context);
            userApi.getWalletList(context);

            dynamic userData = pref!.getString(session.user);
            if (userModel!.role != "user") {
              if (userData != null) {
                final commonApi =
                    Provider.of<CommonApiProvider>(context, listen: false);

                final userApi =
                    Provider.of<UserDataApiProvider>(context, listen: false);

                if (!isFreelancer) {
                  await userApi.getServicemenByProviderId();
                }
                final locationCtrl =
                    Provider.of<LocationProvider>(context, listen: false);

                locationCtrl.getUserCurrentLocation(context);
                commonApi.selfApi(context);
                await commonApi.getDashBoardApi(context);
                // await Future.wait([
                //   userApi.getBookingHistory(context),
                //   userApi.getAddressList(context),
                //   userApi.getDocumentDetails(),
                //   commonApi.getDocument(),
                //   userApi.getServicePackageList(),
                //   userApi.getServiceAddOnsList(),
                //
                // ]);
                FirebaseApi().onlineActiveStatusChange(false);
              }
              hideLoading(context);
              // stePro();
              route.pushReplacementNamed(context, routeName.dashboard);
              emailController.text = "";
              passwordController.text = "";
              notifyListeners();
            } else {
              hideLoading(context);
              snackBarMessengers(context,
                  message: "This action is unauthorized for users.",
                  color: appColor(context).appTheme.red);
            }
          } else {
            hideLoading(context);
            snackBarMessengers(context,
                message: value.message, color: appColor(context).appTheme.red);
          }
        });
      } catch (e, s) {
        hideLoading(context);
        notifyListeners();
        log("EEEE login : $e====> $s");
      }
    }
  }
}
