import '../../../../config.dart';

class CommonOtpLayout extends StatelessWidget {
  const CommonOtpLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<VerifyOtpProvider>(
      builder: (context1,value,child) {
        return OtpLayout(
                controller: value.otpController,
                validator: (value) => Validation().otpValidation(context,value),
                onSubmitted: (val) {
                  value.otpController.text = val;
                },
                defaultPinTheme: value.defaultTheme(context),
                errorPinTheme: value.defaultTheme(context).copyWith(
                    decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppRadius.r8))),
                focusedPinTheme: value.defaultTheme(context).copyWith(
                    height: Sizes.s48,
                    width: Sizes.s55,
                    decoration: value.defaultTheme(context).decoration!.copyWith(
                        color: appColor(context).appTheme.whiteBg,
                        border:
                            Border.all(color: appColor(context).appTheme.primary))))
            .paddingSymmetric(horizontal: Insets.i20);
      }
    );
  }
}
