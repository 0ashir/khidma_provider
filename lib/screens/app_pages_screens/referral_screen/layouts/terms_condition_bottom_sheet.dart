import 'package:flutter/cupertino.dart';
import '../../../../config.dart';

class TermsConditionBottomSheet extends StatelessWidget {
  const TermsConditionBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.4,
        width: MediaQuery.of(context).size.width,
        decoration: ShapeDecoration(
            shape: const SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius.only(
                    topLeft: SmoothRadius(
                        cornerRadius: AppRadius.r20, cornerSmoothing: 1),
                    topRight: SmoothRadius(
                        cornerRadius: AppRadius.r20, cornerSmoothing: 1))),
            color: appColor(context).appTheme.whiteBg),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Text("Terms & Conditions",
                style: appCss.dmDenseBold18
                    .textColor(appColor(context).appTheme.primary)),
          ]).paddingAll(Insets.i20),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSection(
                    context, "Earn 50 coins after completing your first ride.",
                    boldText: "50 coins"),
                _buildSection(
                  context,
                  "1 coin = ₹1, redeemable for ride discounts.",
                ),
                _buildSection(context,
                    "Coins are non-transferable and cannot be exchanged for cash."),
                _buildSection(context, "Valid for new users only."),
                _buildSection(
                    context, "Misuse may result in cancellation of coins."),
                _buildSection(context,
                    "Offer subject to change or withdrawal at any time."),
              ],
            ).paddingSymmetric(horizontal: Insets.i20),
          )),
        ]));
  }

  Widget _buildSection(BuildContext context, String content,
      {String? boldText}) {
    List<String> parts = boldText != null && content.contains(boldText)
        ? content.split(boldText)
        : [content];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.circle,
                size: Sizes.s5, color: appColor(context).appTheme.darkText)
            .paddingOnly(top: Insets.i4),
        const HSpace(Sizes.s8),
        Expanded(
          child: boldText != null && content.contains(boldText)
              ? RichText(
                  text: TextSpan(children: [
                  TextSpan(
                      text: parts[0],
                      style: appCss.dmDenseRegular12
                          .textColor(appColor(context).appTheme.darkText)),
                  TextSpan(
                      text: boldText,
                      style: appCss.dmDenseBold12
                          .textColor(appColor(context).appTheme.darkText)),
                  if (parts.length > 1)
                    TextSpan(
                        text: parts[1],
                        style: appCss.dmDenseRegular12
                            .textColor(appColor(context).appTheme.darkText)),
                ]))
              : Text(content,
                  style: appCss.dmDenseRegular12
                      .textColor(appColor(context).appTheme.darkText)),
        ),
      ],
    ).paddingSymmetric(vertical: Sizes.s4);
  }
}
