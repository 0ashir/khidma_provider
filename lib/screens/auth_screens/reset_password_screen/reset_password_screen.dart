import '../../../config.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ResetPasswordProvider>(
        builder: (context1, resetPass, child) {
      return LoadingComponent(
          child: StatefulWrapper(
              onInit: () => Future.delayed(DurationsDelay.ms150)
                  .then((value) => resetPass.getArg(context)),
              child: Scaffold(
                  appBar: const AuthAppBarCommon(),
                  body: SingleChildScrollView(
                      child: Form(
                              key: resetPass.resetFormKey,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        language(context,
                                                translations!.resetPassword)
                                            .toUpperCase(),
                                        style: appCss.dmDenseBold20.textColor(
                                            appColor(context)
                                                .appTheme
                                                .darkText)),
                                    const VSpace(Sizes.s25),
                                    const ResetPasswordLayout()
                                  ]).alignment(Alignment.centerLeft))
                          .paddingSymmetric(
                              horizontal: Insets.i20, vertical: Insets.i50)))));
    });
  }
}
