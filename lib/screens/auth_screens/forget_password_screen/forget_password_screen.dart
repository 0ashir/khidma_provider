import '../../../config.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ForgetPasswordProvider>(
        builder: (forgotCtrl, value, child) {
      return LoadingComponent(
          child: Scaffold(
              appBar: const AppBarCommon(title: ""),
              body: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AuthTopLayout(
                          image: eImageAssets.forget,
                          title: translations!.forgetPass,
                          subTitle: translations!.enterYourRegisterMail,
                          isNumber: false),
                      Stack(children: [
                        const FieldsBackground(),
                        Form(
                            key: value.forgetKey,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(children: [
                                    const SmallContainer(),
                                    const HSpace(Sizes.s20),
                                    Text(
                                        language(
                                            context, translations!.emailPhone),
                                        style: appCss.dmDenseSemiBold14
                                            .textColor(appColor(context)
                                                .appTheme
                                                .darkText))
                                  ]),
                                  const VSpace(Sizes.s8),
                                  TextFieldCommon(
                                          validator: (pass) => Validation()
                                              .emailValidation(context, pass),
                                          controller: value.forgetController,
                                          hintText: language(context,
                                              translations!.enterEmailPhone),
                                          focusNode: value.emailFocus,
                                          prefixIcon: eSvgAssets.lock)
                                      .paddingSymmetric(horizontal: Insets.i20),
                                  const VSpace(Sizes.s40),
                                  ButtonCommon(
                                      title: translations!.sendOtp,
                                      margin: Insets.i20,
                                      onTap: () => value.onTapSendOtp(context))
                                ]).paddingSymmetric(vertical: Insets.i20))
                      ]).paddingSymmetric(horizontal: Insets.i20)
                    ]),
              )));
    });
  }
}
