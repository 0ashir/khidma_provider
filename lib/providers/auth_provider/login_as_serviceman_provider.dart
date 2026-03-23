import 'dart:convert';
import 'dart:developer';

import 'package:fixit_provider/config.dart';

import '../../firebase/firebase_api.dart';

class LoginAsServicemanProvider with ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormState> servicemenKey =
      GlobalKey<FormState>(debugLabel: 'servicemenKey');
  SharedPreferences? pref;
  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();

  demoCreds() {
    emailController.text = "servicemen@example.com";
    passwordController.text = "123456789";
    notifyListeners();
  }

  //login
  login(context) async {
    if (formKey.currentState!.validate()) {
      pref = await SharedPreferences.getInstance();
      String token = await getFcmToken();

      showLoading(context);

      var body = {
        "email": emailController.text,
        "password": passwordController.text,
        "fcm_token": token
      };

      try {
        await apiServices
            .postApi(api.login, jsonEncode(body))
            .then((value) async {
          notifyListeners();
          if (value.isSuccess!) {
            pref!.setBool(session.token, true);
            isServiceman = true;
            pref!.setBool(session.isServiceman, isServiceman);

            final commonApi =
                Provider.of<CommonApiProvider>(context, listen: false);
            await commonApi.selfApi(context);
            await commonApi.getDashBoardApi(context);
            dynamic userData = pref!.getString(session.user);
            if (userData != null) {
              final commonApi =
                  Provider.of<CommonApiProvider>(context, listen: false);
              await commonApi.selfApi(context);
              await commonApi.getDashBoardApi(context);
              final userApi =
                  Provider.of<UserDataApiProvider>(context, listen: false);
              // await userApi.homeStatisticApi();
              if (!isFreelancer) {
                await userApi.getServicemenByProviderId();
              }
              final locationCtrl =
                  Provider.of<LocationProvider>(context, listen: false);

              await Future.wait([
                Future(() {
                  locationCtrl.getUserCurrentLocation(context);
                  commonApi.getBlog();
                  userApi.getAddressList(context);
                  userApi.getDocumentDetails();
                  commonApi.getDocument();
                  userApi.getAllServiceList();
                  userApi.getBookingHistory(context);
                })
              ]);
              /*final locationCtrl =
                  Provider.of<LocationProvider>(context, listen: false);

              locationCtrl.getUserCurrentLocation(context);
              await userApi.getBankDetails();
              // await userApi.getDocumentDetails();
              await userApi.getDocumentDetails();
              await commonApi.getDocument();
              // await userApi.getJobRequest();
              await commonApi.getBlog();
              await userApi.getAddressList(context);
              await userApi.getAllServiceList();
              // await userApi.getPopularServiceList();
              // await userApi.getNotificationList();
              // await userApi.getServicePackageList();
              // userApi.statisticDetailChart();
              await userApi.getBookingHistory(context);*/
              FirebaseApi().onlineActiveStatusChange(false);
            }
            hideLoading(context);
            route.pushReplacementNamed(context, routeName.dashboard);
            emailController.text = "";
            passwordController.text = "";
            notifyListeners();
          } else {
            hideLoading(context);
            snackBarMessengers(context,
                message: value.message, color: appColor(context).appTheme.red);
          }
        });
      } catch (e) {
        hideLoading(context);
        notifyListeners();
        log("EEEE login1 : $e");
      }
    }
  }
}
