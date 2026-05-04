import 'dart:developer';

import 'package:flutter/cupertino.dart';
import '../../config.dart';

class ChangePasswordProvider extends ChangeNotifier {
  TextEditingController txtOldPassword = TextEditingController();
  TextEditingController txtNewPassword = TextEditingController();
  TextEditingController txtConfirmPassword = TextEditingController();
  GlobalKey<FormState> resetFormKey = GlobalKey<FormState>();
  bool isNewPassword = true, isConfirmPassword = true, isOldPassword = true;

  final FocusNode oldPasswordFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  final FocusNode confirmPasswordFocus = FocusNode();

  double slider = 4.0;

  //old password see tap
  oldPasswordSeenTap() {
    isOldPassword = !isOldPassword;
    notifyListeners();
  }

  //new password see tap
  newPasswordSeenTap() {
    isNewPassword = !isNewPassword;
    notifyListeners();
  }

  //confirm password see tap
  confirmPasswordSeenTap() {
    isConfirmPassword = !isConfirmPassword;
    notifyListeners();
  }

  updatePassword(context) {
    FocusManager.instance.primaryFocus?.unfocus();
    if (resetFormKey.currentState!.validate()) {
      resetPassword(context);
    }
  }

  //reset password api
  bool isResetPassword = false;
  resetPassword(context) async {
    isResetPassword = true;
    notifyListeners();
    showLoading(context);
    notifyListeners();

    var body = {
      "current_password": txtOldPassword.text,
      "password": txtNewPassword.text,
      "password_confirmation": txtConfirmPassword.text,
    };

    try {
      await apiServices
          .putApi(api.updatePassword, body, isToken: true)
          .then((value) {
        hideLoading(context);
        notifyListeners();
        if (value.isSuccess!) {
          isResetPassword = false;
          notifyListeners();
          showCupertinoDialog(
            barrierDismissible: true,
            context: context,
            builder: (context1) {
              return AlertDialogCommon(
                title: translations!.successfullyChanged,
                height: Sizes.s140,
                image: eGifAssets.successGif,
                subtext: language(context, translations!.thankYou),
                bText1: language(context, translations!.loginAgain),
                b1OnTap: () async {
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();

                  txtNewPassword.text = "";
                  txtOldPassword.text = "";
                  txtConfirmPassword.text = "";

                  userModel = null;
                  servicemanList = [];

                  notifyListeners();
                  pref.remove(session.user);
                  pref.remove(session.accessToken);
                  pref.remove(session.token);
                  notifyListeners();
                  route.pushNamedAndRemoveUntil(
                      context, routeName.loginServiceman);
                },
              );
            },
          );
        } else {
          isResetPassword = false;
          notifyListeners();
          snackBarMessengers(context,
              message: value.message, color: appColor(context).appTheme.red);
        }
      });
    } catch (e) {
      isResetPassword = false;
      hideLoading(context);
      notifyListeners();
    }
  }
}
