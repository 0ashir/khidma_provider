import 'dart:convert';
import 'dart:developer';

import '../../config.dart';

class ForgetPasswordProvider with ChangeNotifier {
  TextEditingController forgetController = TextEditingController();
  GlobalKey<FormState> forgetKey = GlobalKey<FormState>();
  final FocusNode emailFocus = FocusNode();

  //on tap send otp to give api with validation
  onTapSendOtp(context) {
    FocusManager.instance.primaryFocus?.unfocus();
    if (forgetKey.currentState!.validate()) {
      forgetPassword(context);
    }
  }

  //forget password api
  forgetPassword(context) async {
    showLoading(context);
    var body = {
      "email": forgetController.text,
    };

    log("body::${jsonEncode(body)}");
    try {
      await apiServices.postApi(api.forgotPassword, jsonEncode(body)).then((value) {
      //  log("value.data:::${value.data}");
        hideLoading(context);
        notifyListeners();
        if (value.isSuccess!) {
          log("dfdxf : $value");

          route.pushNamed(context, routeName.verifyOtp,arg: forgetController.text);

          forgetController.text ="";
          notifyListeners();
        } else {
          log("dfdxf : $value");
          snackBarMessengers(context,
              message: value.message, color: appColor(context).appTheme.red);
        }
      });
    } catch (e) {
      hideLoading(context);
      notifyListeners();
      log("EEEE forgetPassword : $e");
    }
  }


}
