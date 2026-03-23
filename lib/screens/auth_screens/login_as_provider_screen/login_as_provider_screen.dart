import 'package:flutter/gestures.dart';

import '../../../config.dart';

class LoginAsProviderScreen extends StatelessWidget {
  const LoginAsProviderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final introPrv = Provider.of<IntroProvider>(context);
    return Consumer<LoginAsProvider>(builder: (loginContext, value, child) {
      return LoadingComponent(
        child: Scaffold(
            key: value.providerKey,
            resizeToAvoidBottomInset: false,
            appBar: const AuthAppBarCommon(),
            body: SafeArea(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                  Column(children: [
                    Form(
                        key: value.formKey,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const VSpace(Sizes.s35),
                              Text(
                                  language(context,
                                          translations!.loginAsProvider)
                                      .toUpperCase(),
                                  style: appCss.dmDenseBold20.textColor(
                                      appColor(context).appTheme.darkText)),
                              const VSpace(Sizes.s15),
                              LoginLayout(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => introPrv.onSignUp(context),
                                  isProvider: true,
                                  onForget: () => route.pushNamed(
                                      context, routeName.forgetPassword)),
                            ]).alignment(Alignment.centerLeft))
                  ]),
                  ButtonCommon(
                          onTap: () => route.popAndPushNamed(
                              context, routeName.loginServiceman),
                          title: translations!.loginAsServiceman,
                          borderColor: appColor(context).appTheme.primary,
                          color: appColor(context).appTheme.whiteBg,
                          style: appCss.dmDenseMedium16
                              .textColor(appColor(context).appTheme.primary))
                      .paddingOnly(bottom: Insets.i20)
                ]).paddingSymmetric(horizontal: Insets.i20))),
      );
    });
  }
}
