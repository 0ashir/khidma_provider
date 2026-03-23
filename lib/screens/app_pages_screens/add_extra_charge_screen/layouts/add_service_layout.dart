import 'package:flutter/cupertino.dart';

import '../../../../config.dart';

class AddServiceLayout extends StatelessWidget {
  final List<ExtraCharges>? extraCharge;

  const AddServiceLayout({super.key, this.extraCharge});

  @override
  Widget build(BuildContext context) {
    final value = Provider.of<AddExtraChargesProvider>(context);
    return Column(
        children: extraCharge!
            .asMap()
            .entries
            .map((e) => Column(children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(e.value.title!,
                                  style: appCss.dmDenseMedium14.textColor(
                                      appColor(context).appTheme.darkText)),
                              const VSpace(Sizes.s5),
                              Text(
                                  symbolPosition
                                      ? "${getSymbol(context)}${(currency(context).currencyVal * e.value.perServiceAmount!).toStringAsFixed(2)} per service"
                                      : "${(currency(context).currencyVal * e.value.perServiceAmount!).toStringAsFixed(2)}${getSymbol(context)} per service",
                                  style: appCss.dmDenseMedium14.textColor(
                                      appColor(context).appTheme.primary))
                            ]),
                        Image.asset(eImageAssets.serviceIcon,
                            height: Sizes.s46, width: Sizes.s46)
                      ]),
                  const DottedLines().paddingSymmetric(vertical: Insets.i12),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          Text(
                              "${language(context, translations!.noOfServiceDone)} :",
                              style: appCss.dmDenseMedium12.textColor(
                                  appColor(context).appTheme.darkText)),
                          const HSpace(Sizes.s10),
                          Text(
                              e.value.noServiceDone != null
                                  ? e.value.noServiceDone.toString()
                                  : "0",
                              style: appCss.dmDenseMedium12.textColor(
                                  appColor(context).appTheme.darkText))
                        ]),
                        CommonArrow(
                            svgColor: Colors.red,
                            color: Colors.red.withValues(alpha: 0.1),
                            arrow: eSvgAssets.delete,
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context1) => AlertDialog(
                                      insetPadding: const EdgeInsets.symmetric(
                                          horizontal: Insets.i20),
                                      contentPadding: EdgeInsets.zero,
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      shape: const SmoothRectangleBorder(
                                          borderRadius: SmoothBorderRadius.all(
                                              SmoothRadius(
                                                  cornerRadius: AppRadius.r10,
                                                  cornerSmoothing: 1))),
                                      backgroundColor:
                                          appColor(context).appTheme.whiteBg,
                                      content: Stack(
                                          alignment: Alignment.topRight,
                                          children: [
                                            Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  // Sub text
                                                  const VSpace(Sizes.s15),
                                                  BottomSheetButtonCommon(
                                                      clearTap: () {
                                                        route.pop(context);
                                                      },
                                                      applyTap: () {
                                                        value
                                                            .deleteExtraCharges(
                                                                context,
                                                                extraChargeId:
                                                                    e.value.id);
                                                        route.pop(context);
                                                      },
                                                      textTwo:
                                                          translations!.yes,
                                                      textOne: translations!.no)
                                                ]).padding(
                                                horizontal: Insets.i20,
                                                top: Insets.i60,
                                                bottom: Insets.i20),
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  // Title
                                                  Expanded(
                                                    child: Text(
                                                        language(context,
                                                            "Are you sure you want to delete?"),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: appCss
                                                            .dmDenseMedium15
                                                            .textColor(appColor(
                                                                    context)
                                                                .appTheme
                                                                .darkText)),
                                                  ),
                                                  Icon(CupertinoIcons.multiply,
                                                          size: Sizes.s20,
                                                          color:
                                                              appColor(context)
                                                                  .appTheme
                                                                  .darkText)
                                                      .inkWell(
                                                          onTap: () => route
                                                              .pop(context))
                                                ]).paddingAll(Insets.i20)
                                          ])));
                            })
                      ])
                ])
                    .paddingAll(Insets.i15)
                    .boxBorderExtension(context, isShadow: true)
                    .paddingOnly(bottom: Insets.i20))
            .toList());
  }
}
