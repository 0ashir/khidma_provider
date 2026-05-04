import 'package:fixit_provider/model/location_model.dart';

import '../../../../config.dart';

class LocationLayout extends StatelessWidget {
  final LocationData? data;
  final GestureTapCallback? editOnTap, deleteOnTap;
  final bool isPrimaryAnTapLayout, selectedIndex;

  const LocationLayout(
      {super.key,
      this.data,
      this.deleteOnTap,
      this.editOnTap,
      this.isPrimaryAnTapLayout = true,
      this.selectedIndex = false});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(children: [
          /* data!.isPrimary == 1 || */ selectedIndex
              ? SvgPicture.asset(
                  eSvgAssets.tickCircle,
                  height: Sizes.s40,
                ).paddingAll(Insets.i5).decorated(
                  shape: BoxShape.circle,
                  border: Border.all(
                      width: 2, color: appColor(context).appTheme.fieldCardBg))
              : SvgPicture.asset(
                      data!.type == "home"
                          ? eSvgAssets.homeFill
                          : eSvgAssets.beg,
                      colorFilter: ColorFilter.mode(
                          appColor(context).appTheme.lightText,
                          BlendMode.srcIn))
                  .paddingAll(Insets.i9)
                  .decorated(
                      color: appColor(context).appTheme.stroke,
                      shape: BoxShape.circle,
                      border: Border.all(
                          width: 4,
                          color: appColor(context).appTheme.fieldCardBg)),
          const HSpace(Sizes.s10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(data!.alternativeName ?? "",
                style: appCss.dmDenseMedium14
                    .textColor(appColor(context).appTheme.darkText)),
            Text(
                data!.alternativePhone != null
                    ? "+${data!.code} ${data!.alternativePhone.toString()}"
                    : "",
                style: appCss.dmDenseMedium12
                    .textColor(appColor(context).appTheme.lightText))
          ])
        ]),
        data?.type == null
            ? const SizedBox.shrink()
            : Text("${data?.type /* .capitalizeFirst() */}",
                    style: appCss.dmDenseMedium12
                        .textColor(appColor(context).appTheme.primary))
                .paddingSymmetric(horizontal: Insets.i10, vertical: Insets.i5)
                .decorated(
                    borderRadius: BorderRadius.circular(AppRadius.r13),
                    color: appColor(context).appTheme.primary.withOpacity(0.1))
      ]).paddingAll(Insets.i12),
      Divider(height: 1, color: appColor(context).appTheme.stroke),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const VSpace(Sizes.s12),
        Text(language(context, translations!.address),
            style: appCss.dmDenseMedium12
                .textColor(appColor(context).appTheme.lightText)),
        const VSpace(Sizes.s5),
        Text(
            "${data?.address!}${"${data?.area != null ? "," : ""}${data?.area ?? ""}"},${" ${data?.city}"},${" ${data!.postalCode}"}",
            style: appCss.dmDenseMedium14
                .textColor(appColor(context).appTheme.darkText)),
        DottedLines(
                color: isPrimaryAnTapLayout
                    ? appColor(context).appTheme.stroke
                    : appColor(context).appTheme.whiteColor)
            .paddingSymmetric(vertical: isPrimaryAnTapLayout ? Insets.i10 : 0),
        if (isPrimaryAnTapLayout)
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            /* Text(
                "\u2022 ${data!.isPrimary == 1 ? translations!.setAsPrimary : translations!.notSetAsPrimary}",
                style: appCss.dmDenseMedium12
                    .textColor(appColor(context).appTheme.lightText)), */
            Row(children: [
              CommonArrow(
                  onTap: editOnTap,
                  arrow: eSvgAssets.edit,
                  svgColor: appColor(context).appTheme.darkText),
              const HSpace(Sizes.s12),
              CommonArrow(
                  onTap: deleteOnTap,
                  arrow: eSvgAssets.delete,
                  svgColor: appColor(context).appTheme.red,
                  color: appColor(context).appTheme.red.withOpacity(0.1))
            ])
          ])
      ]).paddingSymmetric(horizontal: Insets.i15)
    ])
        .paddingOnly(bottom: Insets.i15)
        .decorated(
            color: appColor(context).appTheme.whiteBg,
            borderRadius: BorderRadius.circular(AppRadius.r12),
            boxShadow: [
              BoxShadow(
                  color: appColor(context).appTheme.darkText.withOpacity(0.06),
                  blurRadius: 12,
                  spreadRadius: 0,
                  offset: const Offset(0, 2)),
            ],
            border: Border.all(color: appColor(context).appTheme.stroke))
        .paddingOnly(bottom: Insets.i15, left: 20, right: 20);
  }
}
