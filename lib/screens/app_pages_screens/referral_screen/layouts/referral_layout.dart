import 'package:flutter/services.dart';
import '../../../../config.dart';
import '../../../../utils/toast_utils.dart';
import 'terms_condition_bottom_sheet.dart';

class ReferralLayout extends StatelessWidget {
  const ReferralLayout({super.key});

  @override
  Widget build(BuildContext context) {
    String code = userModel?.referralCode ?? "";
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Banner
          Stack(
            children: [
              Image.asset(eImageAssets.referralBg,
                  width: double.infinity, fit: BoxFit.fill),
              Positioned.fill(
                child: Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _bannerRichText(
                                  context,
                                  translations!.earnCoin.toString(),
                                  translations!.noCoins.toString())
                              .paddingOnly(bottom: Insets.i15),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Insets.i12, vertical: Insets.i8),
                            decoration: BoxDecoration(
                              color: appColor(context).appTheme.whiteBg,
                              borderRadius: BorderRadius.circular(AppRadius.r8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(eSvgAssets.copy,
                                    height: Sizes.s14,
                                    colorFilter: ColorFilter.mode(
                                        appColor(context).appTheme.primary,
                                        BlendMode.srcIn)),
                                const HSpace(Sizes.s8),
                                Text(
                                  code,
                                  style: appCss.dmDenseBold14.textColor(
                                      appColor(context).appTheme.primary),
                                ),
                              ],
                            ),
                          ).inkWell(onTap: () {
                            Clipboard.setData(ClipboardData(text: code));
                            showSuccessToast(context,
                                translations!.copiedToClipboard.toString());
                          }),
                        ],
                      ).paddingSymmetric(horizontal: Insets.i20),
                    ),
                    Expanded(
                      flex: 4,
                      child: Image.asset(eImageAssets.megaPhone,
                          fit: BoxFit.contain),
                    ),
                  ],
                ),
              ),
            ],
          ).paddingSymmetric(horizontal: Insets.i15, vertical: Insets.i20),

          // How it works section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(Insets.i15),
            decoration: BoxDecoration(
              color: appColor(context).appTheme.whiteBg,
              borderRadius: BorderRadius.circular(AppRadius.r12),
              border: Border.all(color: appColor(context).appTheme.fieldCardBg),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(translations!.howWork!,
                        style: appCss.dmDenseBold16
                            .textColor(appColor(context).appTheme.primary)),
                    Text(translations!.termsCs!,
                            style: appCss.dmDenseMedium14
                                .textColor(appColor(context).appTheme.lightText)
                                .textDecoration(TextDecoration.underline))
                        .inkWell(onTap: () {
                      showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          builder: (context) =>
                              const TermsConditionBottomSheet());
                    }),
                  ],
                ).paddingOnly(bottom: Insets.i15),
                _stepRow(context, "1. ", translations!.refer1!),
                const VSpace(Sizes.s10),
                _stepRow(context, "2. ", translations!.refer2!,
                    boldText: "50 coins"),
                const VSpace(Sizes.s10),
                _stepRow(context, "3. ", translations!.customerUsedCoins!),
              ],
            ),
          ).paddingSymmetric(horizontal: Insets.i15),

          // Note text
          Text(
            translations!.referNote!,
            style: appCss.dmDenseMedium12
                .textColor(appColor(context).appTheme.lightText),
          ).paddingAll(Insets.i15),

          // See Your Referrals Banner
          Stack(
            children: [
              Image.asset(
                  isDark(context)
                      ? eImageAssets.seeReferralDarkBg
                      : eImageAssets.seeReferralBg,
                  width: double.infinity,
                  fit: BoxFit.fill),
              Positioned.fill(
                child: Row(
                  children: [
                    Expanded(
                      flex: 7,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(translations!.seeReferral!,
                              style: appCss.dmDenseBold16.textColor(
                                  appColor(context).appTheme.primary)),
                          const VSpace(Sizes.s5),
                          Text(translations!.referralTrack!,
                              style: appCss.dmDenseMedium12.textColor(
                                  appColor(context).appTheme.lightText)),
                          const VSpace(Sizes.s15),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Insets.i20, vertical: Insets.i8),
                            decoration: BoxDecoration(
                              color: appColor(context).appTheme.primary,
                              borderRadius: BorderRadius.circular(AppRadius.r8),
                            ),
                            child: Text(translations!.viewAll!,
                                style: appCss.dmDenseMedium14.textColor(
                                    appColor(context).appTheme.whiteBg)),
                          ).inkWell(onTap: () {
                            route.pushNamed(context, routeName.referralList);
                          }),
                        ],
                      ).paddingSymmetric(horizontal: Insets.i20),
                    ),
                    Expanded(
                      flex: 4,
                      child: Image.asset(eImageAssets.fixitGirl,
                          fit: BoxFit.contain),
                    ),
                  ],
                ),
              ),
            ],
          ).paddingSymmetric(horizontal: Insets.i15),

          const VSpace(Sizes.s30),

          const VSpace(Sizes.s20),
        ],
      ),
    );
  }

  Widget _bannerRichText(BuildContext context, String text, String boldText) {
    List<String> parts = text.split(boldText);
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: parts[0],
            style: appCss.dmDenseMedium16
                .textColor(appColor(context).appTheme.whiteBg),
          ),
          TextSpan(
            text: boldText,
            style: appCss.dmDenseBold18
                .textColor(appColor(context).appTheme.whiteBg),
          ),
          TextSpan(
            text: parts[1],
            style: appCss.dmDenseMedium16
                .textColor(appColor(context).appTheme.whiteBg),
          ),
        ],
      ),
    );
  }

  Widget _stepRow(BuildContext context, String number, String text,
      {String? boldText}) {
    if (boldText != null && text.contains(boldText)) {
      List<String> parts = text.split(boldText);
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(number,
              style: appCss.dmDenseMedium14
                  .textColor(appColor(context).appTheme.darkText)),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                      text: parts[0],
                      style: appCss.dmDenseMedium14
                          .textColor(appColor(context).appTheme.darkText)),
                  TextSpan(
                      text: boldText,
                      style: appCss.dmDenseBold14
                          .textColor(appColor(context).appTheme.darkText)),
                  TextSpan(
                      text: parts[1],
                      style: appCss.dmDenseMedium14
                          .textColor(appColor(context).appTheme.darkText)),
                ],
              ),
            ),
          ),
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(number,
            style: appCss.dmDenseMedium14
                .textColor(appColor(context).appTheme.darkText)),
        Expanded(
            child: Text(text,
                style: appCss.dmDenseMedium14
                    .textColor(appColor(context).appTheme.darkText))),
      ],
    );
  }
}
