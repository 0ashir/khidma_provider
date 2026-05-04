import 'package:share_plus/share_plus.dart';
import '../../../config.dart';
import 'layouts/referral_layout.dart';

class ReferralScreen extends StatelessWidget {
  const ReferralScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String code = userModel?.referralCode ?? "";
    return Consumer2<AppSettingProvider, ThemeService>(
        builder: (context1, settingCtrl, theme, child) {
      return StatefulWrapper(
        onInit: () => Future.delayed(const Duration(milliseconds: 150),
            () => settingCtrl.onReady(context)),
        child: Scaffold(
            appBar: AppBar(
                elevation: 0,
                centerTitle: true,
                leadingWidth: 80,
                leading: CommonArrow(
                    arrow: rtl(context)
                        ? eSvgAssets.arrowRight
                        : eSvgAssets.arrowLeft,
                    onTap: () => route.pop(context)).paddingAll(Insets.i8),
                title: Text(language(context, translations!.referralCode),
                    style: appCss.dmDenseBold18
                        .textColor(appColor(context).appTheme.darkText))),
            body: const ReferralLayout(),
            bottomNavigationBar: ButtonCommon(
              title: translations!.share,
              onTap: () {
                Share.share(
                    "${translations!.refDec1} $code ${translations!.refDec2}");
              },
            ).paddingOnly(
                left: Insets.i15, right: Insets.i15, bottom: Sizes.s30)),
      );
    });
  }
}
