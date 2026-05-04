import 'package:flutter/cupertino.dart';

import '../../../../config.dart';

class LogoutAlert extends StatelessWidget {
  final GestureTapCallback? onTap;
  const LogoutAlert({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: Insets.i20),
      contentPadding: EdgeInsets.zero,
      shape: const SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius.all(
              SmoothRadius(cornerRadius: AppRadius.r14, cornerSmoothing: 1))),
      backgroundColor: appColor(context).appTheme.whiteBg,
      content: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(language(context, appFonts.areYouSure),
                  style: appCss.dmDenseMedium16
                      .textColor(appColor(context).appTheme.darkText)),
              const VSpace(Sizes.s20),
              Row(children: [
                Expanded(
                    child: ButtonCommon(
                        onTap: () => route.pop(context),
                        title: translations!.cancel,
                        borderColor: appColor(context).appTheme.red,
                        color: appColor(context).appTheme.whiteBg,
                        style: appCss.dmDenseSemiBold16
                            .textColor(appColor(context).appTheme.red))),
                const HSpace(Sizes.s15),
                Expanded(
                    child: ButtonCommon(
                        color: appColor(context).appTheme.red,
                        onTap: onTap,
                        title: translations!.yes))
              ])
            ],
          ).padding(
              horizontal: Insets.i20, top: Insets.i60, bottom: Insets.i20),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            // Title
            Text(language(context, translations!.logOut),
                style: appCss.dmDenseExtraBold18
                    .textColor(appColor(context).appTheme.darkText)),
            Icon(CupertinoIcons.multiply,
                    size: Sizes.s20, color: appColor(context).appTheme.darkText)
                .inkWell(onTap: () => route.pop(context))
          ]).paddingAll(Insets.i20)
        ],
      ),
    );
  }
}
