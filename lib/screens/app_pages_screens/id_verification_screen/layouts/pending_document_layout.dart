import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../../config.dart';

class PendingDocumentLayout extends StatelessWidget {
  final DocumentModel? data;
  final GestureTapCallback? onTap;

  const PendingDocumentLayout({super.key, this.data, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Expanded(
        child: Row(children: [
          DottedBorder(
              color: appColor(context).appTheme.lightText,
              borderType: BorderType.RRect,
              radius: const Radius.circular(AppRadius.r40),
              child: ClipRRect(
                  borderRadius:
                      const BorderRadius.all(Radius.circular(AppRadius.r40)),
                  child: Container(
                      alignment: Alignment.center,
                      color: appColor(context).appTheme.fieldCardBg,
                      child: SvgPicture.asset(
                        eSvgAssets.add,
                        colorFilter: ColorFilter.mode(
                            appColor(context).appTheme.lightText,
                            BlendMode.srcIn),
                      ).paddingAll(Insets.i8)))),
          const HSpace(Sizes.s12),
          Expanded(
              child: Text(language(context, data!.title!),
                  style: appCss.dmDenseMedium14
                      .textColor(appColor(context).appTheme.darkText)))
        ]),
      ),
      SvgPicture.asset(
          rtl(context) ? eSvgAssets.arrowLeft : eSvgAssets.arrowRight,
          colorFilter: ColorFilter.mode(
              appColor(context).appTheme.darkText, BlendMode.srcIn))
    ])
        .paddingSymmetric(vertical: Insets.i12, horizontal: Insets.i15)
        .boxBorderExtension(context, radius: AppRadius.r12, isShadow: true)
        .inkWell(onTap: onTap)
        .paddingOnly(bottom: Insets.i15);
  }
}
