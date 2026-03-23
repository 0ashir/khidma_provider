import 'package:flutter/material.dart';

import '../config.dart';

class ReviewBottomLayout extends StatelessWidget {
  final String? serviceName, servicemanName, providerName;
  final GestureTapCallback? onTap;
  const ReviewBottomLayout(
      {super.key,
      this.serviceName,
      this.onTap,
      this.servicemanName,
      this.providerName});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Expanded(
        child: RichText(
            text: TextSpan(
                style: appCss.dmDenseRegular12
                    .textColor(appColor(context).appTheme.lightText),
                text:
                    "${language(context, serviceName != null ? translations!.serviceName : servicemanName != null ? translations!.serviceman : "Provider Name")} : ",
                children: [
              TextSpan(
                  text: serviceName != null
                      ? serviceName!
                      : servicemanName != null
                          ? servicemanName!
                          : providerName,
                  style: appCss.dmDenseRegular12
                      .textColor(appColor(context).appTheme.darkText))
            ])),
      ),
      SvgPicture.asset(eSvgAssets.anchorArrowRight,
          colorFilter: ColorFilter.mode(
              appColor(context).appTheme.lightText, BlendMode.srcIn))
    ])
        .paddingAll(Insets.i12)
        .boxShapeExtension(color: appColor(context).appTheme.fieldCardBg)
        .inkWell(onTap: onTap)
        .paddingOnly(bottom: Insets.i15);
  }
}
