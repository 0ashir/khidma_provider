import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import '../../config.dart';

class VerifyOtpProvider with ChangeNotifier {
  TextEditingController otpController = TextEditingController();
  GlobalKey<FormState> otpKey = GlobalKey<FormState>();

  String? phone, dialCode, verificationCode, min, sec, email;
  bool isCodeSent = false, isCountDown = false, isEmail = false;
  Timer? countdownTimer;
  final FocusNode phoneFocus = FocusNode();
  Duration myDuration = const Duration(seconds: 60);


  //pin put default theme
  defaultTheme(context) {
    final defaultPinTheme = PinTheme(
        textStyle: appCss.dmDenseSemiBold18
            .textColor(appColor(context).appTheme.darkText),
        width: Sizes.s55,
        height: Sizes.s48,
        decoration: BoxDecoration(
            color: appColor(context).appTheme.whiteBg,
            borderRadius: BorderRadius.circular(AppRadius.r8),
            border: Border.all(color: appColor(context).appTheme.whiteBg)));
    return defaultPinTheme;
  }

  onTapVerify(context) {
    if (otpKey.currentState!.validate()) {

        verifyOtp(context);

    }
  }

  //verify otp
  verifyOtp(context) async {
    showLoading(context);
    notifyListeners();

    var body = {"otp": otpController.text, "email": email};
    log("body : $body");

    try {
      await apiServices.postApi(api.verifyOtp, jsonEncode(body)).then((value) {
        hideLoading(context);
        log("SSSS : ${value.isSuccess}");
        notifyListeners();
        if (value.isSuccess!) {
          route.pushNamed(context, routeName.resetPass,
              arg: {"otp": otpController.text, "email": email});
        } else {
          snackBarMessengers(context,
              message: value.message, color: appColor(context).appTheme.red);
        }
      });
    } catch (e) {
      hideLoading(context);
      notifyListeners();
      log("CATCH verifyOtp: $e");
    }
  }
  // on page init data fetch
  getArgument(context) {
    dynamic data = ModalRoute.of(context)!.settings.arguments;
    email = data;
    log("ARG : $data");
    notifyListeners();
  }

}
