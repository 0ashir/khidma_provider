import 'package:flutter/gestures.dart';

import '../../../config.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<IntroProvider, LanguageProvider>(
        builder: (context, value, lang, child) {
      return PopScope(
          canPop: true,
          child: Scaffold(
              body: SafeArea(
            top: false,
            child: SingleChildScrollView(
              child: Column(children: [
                Stack(children: [
                  Image.asset(eImageAssets.introImage,
                      height: Sizes.s470,
                      fit: BoxFit.fill,
                      width: MediaQuery.of(context).size.width),
                  /* const LanguageDropDownLayout().paddingSymmetric(
                      vertical: Insets.i50, horizontal: Insets.i20) */
                ]),
                Column(children: [
                  const SizedBox(height: Sizes.s2, width: Sizes.s24).decorated(
                      color: appColor(context).appTheme.primary,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(AppRadius.r10))),
                  const VSpace(Sizes.s13),
                  Text(translations?.getPaidBy.toString().toUpperCase() ?? "",
                      style: appCss.dmDenseBold15
                          .textColor(appColor(context).appTheme.darkText)),
                  const VSpace(Sizes.s13),
                  Text(language(context, translations?.nowManageAll),
                      textAlign: TextAlign.center,
                      style: appCss.dmDenseMedium14
                          .textColor(appColor(context).appTheme.lightText)),
                  const VSpace(Sizes.s25),
                  ButtonCommon(
                      title: translations!.loginAsProvider,
                      onTap: () {
                        hideLoading(context);
                        route.pushNamed(context, routeName.loginProvider);
                      }),
                  const VSpace(Sizes.s18),
                  ButtonCommon(
                      title: translations!.loginAsServiceman ?? '',
                      onTap: () {
                        hideLoading(context);
                        route.pushNamed(context, routeName.loginServiceman);
                      }),
                ])
                    .paddingSymmetric(
                        vertical: Insets.i15, horizontal: Insets.i20)
                    .boxShapeExtension(
                        color: appColor(context).appTheme.fieldCardBg,
                        radius: AppRadius.r20)
                    .paddingSymmetric(horizontal: Insets.i20),
                const VSpace(Sizes.s15),
                Consumer<IntroProvider>(builder: (context, value, child) {
                  return RichText(
                      text: TextSpan(
                          text: language(context, translations!.donHaveAccount),
                          style: appCss.dmDenseMedium14
                              .textColor(appColor(context).appTheme.darkText),
                          children: [
                        TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => value.onSignUp(context),
                            text: language(context, translations!.signUp),
                            style: appCss.dmDenseMedium16
                                .textColor(appColor(context).appTheme.primary))
                      ])).center();
                }),
                                  const VSpace(Sizes.s13),

              ]),
            ),
          )));
    });
  }
}
