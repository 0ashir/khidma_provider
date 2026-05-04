import '../../../config.dart';

class LoginAsServicemanScreen extends StatelessWidget {
  const LoginAsServicemanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginAsServicemanProvider>(
        builder: (loginContext, value, child) {
      return LoadingComponent(
        child: Scaffold(
            key: value.servicemenKey,
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
                                          translations!.loginAsServiceman)
                                      .toUpperCase(),
                                  style: appCss.dmDenseBold20.textColor(
                                      appColor(context).appTheme.darkText)),
                              const VSpace(Sizes.s15),
                              const LoginLayout()
                            ]).alignment(Alignment.centerLeft))
                  ]),
                  ButtonCommon(
                          onTap: () => route.popAndPushNamed(
                              context, routeName.loginProvider),
                          title: translations!.loginAsProvider,
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
