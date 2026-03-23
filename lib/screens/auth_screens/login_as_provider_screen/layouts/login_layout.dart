import 'package:flutter/gestures.dart';
import '../../../../config.dart';

class LoginLayout extends StatelessWidget {
  final bool? isProvider;
  final GestureTapCallback? onForget;
  final GestureRecognizer? recognizer;

  const LoginLayout(
      {super.key, this.isProvider = false, this.onForget, this.recognizer});

  @override
  Widget build(BuildContext context) {
    return Consumer2<LoginAsProvider, LoginAsServicemanProvider>(
        builder: (context1, value, value2, child) {
      return Stack(children: [
        const FieldsBackground(),
        Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonWidgetLayout()
                  .commonTitleWithSmallContainer(context, translations!.email),
              TextFieldCommon(
                      validator: (email) =>
                          Validation().emailValidation(context, email),
                      controller: isProvider == true
                          ? value.emailController
                          : value2.emailController,
                      hintText: language(context, translations!.enterEmail),
                      keyboardType: TextInputType.emailAddress,
                      focusNode: value.emailFocus,
                      onFieldSubmitted: (val) => validation.fieldFocusChange(
                          context,
                          isProvider == true
                              ? value.emailFocus
                              : value2.emailFocus,
                          isProvider == true
                              ? value.passwordFocus
                              : value2.passwordFocus),
                      prefixIcon: eSvgAssets.email)
                  .paddingSymmetric(horizontal: Insets.i20),
              const VSpace(Sizes.s15),
              CommonWidgetLayout().commonTitleWithSmallContainer(
                  context, translations!.password),
              TextFieldCommon(
                      suffixIcon: SvgPicture.asset(
                              value.isPassword
                                  ? eSvgAssets.hide
                                  : eSvgAssets.eye,
                              fit: BoxFit.scaleDown)
                          .inkWell(onTap: () => value.passwordSeenTap()),
                      obscureText: value.isPassword,
                      validator: (pass) => Validation().dynamicTextValidation(
                          context, pass, translations!.pleaseEnterPassword),
                      controller: isProvider == true
                          ? value.passwordController
                          : value2.passwordController,
                      hintText: language(context, translations!.enterPassword),
                      focusNode: isProvider == true
                          ? value.passwordFocus
                          : value2.passwordFocus,
                      prefixIcon: eSvgAssets.lock)
                  .paddingSymmetric(horizontal: Insets.i20),
              const VSpace(Sizes.s10),
              Text(language(context, translations!.forgotPassword),
                      style: appCss.dmDenseSemiBold14
                          .textColor(appColor(context).appTheme.primary))
                  .inkWell(onTap: onForget)
                  .alignment(Alignment.bottomRight)
                  .paddingSymmetric(horizontal: Insets.i20),
              const VSpace(Sizes.s35),
              ButtonCommon(
                      title: translations!.loginNow,
                      onTap: () => isProvider == true
                          ? value.login(context)
                          : value2.login(context))
                  .paddingSymmetric(horizontal: Insets.i20),
              if (isProvider == true)
                RichText(
                        text: TextSpan(
                            text: language(context, translations!.notMember),
                            style: appCss.dmDenseMedium14
                                .textColor(appColor(context).appTheme.darkText),
                            children: [
                      TextSpan(
                          recognizer: recognizer,
                          text: language(context, translations!.signUp),
                          style: appCss.dmDenseMedium14
                              .textColor(appColor(context).appTheme.primary))
                    ]))
                    .paddingOnly(top: Insets.i12)
                    .alignment(Alignment.center),
              if (appSettingModel != null &&
                  appSettingModel!.activation!.defaultCredentials == "1")
                const VSpace(Sizes.s12),
              if (appSettingModel != null &&
                  appSettingModel!.activation!.defaultCredentials == "1")
                ButtonCommon(
                        title: isProvider == true
                            ? "Provider Demo"
                            : "Serviceman Demo",
                        style: appCss.dmDenseRegular16
                            .textColor(appColor(context).appTheme.primary),
                        borderColor: appColor(context).appTheme.primary,
                        fontColor: appColor(context).appTheme.primary,
                        color: appColor(context).appTheme.trans,
                        onTap: () => isProvider == true
                            ? value.demoCreds()
                            : value2.demoCreds())
                    .paddingSymmetric(horizontal: Insets.i20),
            ]).paddingSymmetric(vertical: Insets.i20)
      ]);
    });
  }
}
