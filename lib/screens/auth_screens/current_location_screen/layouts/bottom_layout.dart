import 'dart:developer';

import '../../../../config.dart';

class BottomLocationLayout extends StatelessWidget {
  const BottomLocationLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationProvider>(builder: (context1, value, child) {
      log("value.currentAddress::${value.currentAddress}///${value.street}");
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommonArrow(
                        svgColor: appColor(context).appTheme.whiteBg,
                        color: appColor(context).appTheme.primary,
                        arrow: rtl(context)
                            ? eSvgAssets.arrowRight
                            : eSvgAssets.arrowLeft)
                    .inkWell(onTap: () => route.pop(context)),
                CommonArrow(
                        svgColor: appColor(context).appTheme.whiteBg,
                        color: appColor(context).appTheme.primary,
                        arrow: eSvgAssets.search)
                    .inkWell(onTap: () => value.searchLocation(context))
              ],
            ).paddingSymmetric(vertical: Insets.i50, horizontal: Insets.i20),
            Column(children: [
              Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                          height: Sizes.s40,
                          width: Sizes.s40,
                          margin: const EdgeInsets.symmetric(
                              horizontal: Insets.i20),
                          decoration: ShapeDecoration(
                              color: appColor(context).appTheme.primary,
                              shape: SmoothRectangleBorder(
                                  borderRadius: SmoothBorderRadius(
                                      cornerRadius: 8, cornerSmoothing: 1))),
                          child: SvgPicture.asset(eSvgAssets.zipcode,
                              fit: BoxFit.scaleDown,
                              colorFilter: ColorFilter.mode(
                                  appColor(context).appTheme.whiteBg,
                                  BlendMode.srcIn)))
                      .inkWell(onTap: () => value.fetchCurrent(context))),
              const VSpace(Sizes.s20),
              Container(
                      child: Column(children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(language(context, translations!.selectService),
                          style: appCss.dmDenseRegular14
                              .textColor(appColor(context).appTheme.lightText))
                    ]),
                const VSpace(Sizes.s15),
                CurrentAddressTextLayout(
                    currentAddress: value.currentAddress, street: value.street),
                ButtonCommon(
                    title: translations!.confirmLocation,
                    onTap: () => value.onEdit(context))
              ]).paddingAll(Insets.i20))
                  .bottomSheetExtension(context)
            ])
          ]);
    });
  }
}
