import 'dart:developer';
import '../../../../config.dart';

class ZoneDropDown extends StatelessWidget {
  final bool isAddLocation;

  const ZoneDropDown({
    super.key,
    this.isAddLocation = false,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<SignUpCompanyProvider, CompanyDetailProvider>(
        builder: (context2, signup, company, child) {
      log("ZONES :${signup.zonesList.length}");
      return Container(
        margin:
            EdgeInsets.symmetric(horizontal: !isAddLocation ? Sizes.s20 : 0),
        padding: const EdgeInsets.symmetric(
            horizontal: Sizes.s15, vertical: Sizes.s10),
        decoration: ShapeDecoration(
            color: !isAddLocation
                ? appColor(context).appTheme.whiteBg
                : appColor(context).appTheme.fieldCardBg,
            shape: SmoothRectangleBorder(
                borderRadius:
                    SmoothBorderRadius(cornerRadius: 8, cornerSmoothing: 1))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  SvgPicture.asset(eSvgAssets.locationOut,
                          colorFilter: ColorFilter.mode(
                              !isAddLocation
                                  ? signup.zoneSelect.isNotEmpty
                                      ? appColor(context).appTheme.darkText
                                      : appColor(context).appTheme.lightText
                                  : company.zoneSelect.isNotEmpty
                                      ? appColor(context).appTheme.darkText
                                      : appColor(context).appTheme.lightText,
                              BlendMode.srcIn))
                      .padding(
                          left: 0,
                          right: rtl(context) ? Insets.i5 : 0,
                          top: Sizes.s5,
                          vertical: Sizes.s5),
                  const HSpace(Sizes.s12),
                  if (!isAddLocation)
                    if (signup.zoneSelect.isNotEmpty)
                      Expanded(
                        child: Wrap(
                            direction: Axis.horizontal,
                            children: signup.zoneSelect
                                .asMap()
                                .entries
                                .map((e) => Container(
                                        margin: EdgeInsets.only(
                                            right: Sizes.s10,
                                            top: signup.zoneSelect.isNotEmpty
                                                ? Sizes.s8
                                                : 0,
                                            bottom: signup.zoneSelect.length -
                                                        1 !=
                                                    e.key
                                                ? Sizes.s8
                                                : 0),
                                        padding: const EdgeInsets
                                            .symmetric(
                                            horizontal: Sizes.s9,
                                            vertical: Sizes.s5),
                                        decoration: ShapeDecoration(
                                            shape: SmoothRectangleBorder(
                                              borderRadius: SmoothBorderRadius(
                                                  cornerRadius: 8,
                                                  cornerSmoothing: 1),
                                            ),
                                            color:
                                                const Color
                                                    .fromRGBO(84, 101, 255, 0.1)),
                                        child:
                                            Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                              /* Icon(
                                          Cup,
                                          size: 18,
                                          color: appColor(context).appTheme.darkText
                                        ),*/
                                              SvgPicture.asset(
                                                eSvgAssets.cross,
                                                height: 16,
                                                colorFilter: ColorFilter.mode(
                                                    appColor(context)
                                                        .appTheme
                                                        .primary,
                                                    BlendMode.srcIn),
                                              ),
                                              const HSpace(Sizes.s2),
                                              Text(e.value.name!,
                                                  style: appCss.dmDenseLight14
                                                      .textColor(
                                                          appColor(context)
                                                              .appTheme
                                                              .primary))
                                            ]))
                                    .inkWell(
                                        onTap: () =>
                                            signup.onZoneSelect(e.value)))
                                .toList()),
                      ),
                  if (!isAddLocation)
                    if (signup.zoneSelect.isEmpty)
                      Text(language(context, translations!.selectZone),
                          style: appCss.dmDenseMedium14
                              .textColor(appColor(context).appTheme.lightText)),
                  if (isAddLocation)
                    if (company.zoneSelect.isNotEmpty)
                      Expanded(
                        child: Wrap(
                            direction: Axis.horizontal,
                            children: company.zoneSelect
                                .asMap()
                                .entries
                                .map((e) => Container(
                                        margin: EdgeInsets.only(
                                            right: Sizes.s10,
                                            top: company.zoneSelect.isNotEmpty
                                                ? Sizes.s8
                                                : 0,
                                            bottom: company.zoneSelect.length - 1 !=
                                                    e.key
                                                ? Sizes.s8
                                                : 0),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: Sizes.s9,
                                            vertical: Sizes.s5),
                                        decoration: ShapeDecoration(
                                            shape: SmoothRectangleBorder(
                                              borderRadius: SmoothBorderRadius(
                                                  cornerRadius: 8,
                                                  cornerSmoothing: 1),
                                            ),
                                            color: const Color.fromRGBO(
                                                84, 101, 255, 0.1)),
                                        child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SvgPicture.asset(
                                                eSvgAssets.cross,
                                                height: 16,
                                                colorFilter: ColorFilter.mode(
                                                    appColor(context)
                                                        .appTheme
                                                        .primary,
                                                    BlendMode.srcIn),
                                              ),
                                              const HSpace(Sizes.s2),
                                              Text(e.value.name!,
                                                  style: appCss.dmDenseLight14
                                                      .textColor(
                                                          appColor(context)
                                                              .appTheme
                                                              .primary))
                                            ]))
                                    .inkWell(
                                        onTap: () => !isAddLocation
                                            ? signup.onZoneSelect(e.value)
                                            : company.onZoneSelect(e.value)))
                                .toList()),
                      ),
                  if (isAddLocation)
                    if (company.zoneSelect.isEmpty)
                      Text(language(context, translations!.selectZone),
                          style: appCss.dmDenseMedium14
                              .textColor(appColor(context).appTheme.lightText))
                ],
              ),
            ),
            SvgPicture.asset(eSvgAssets.dropDown,
                colorFilter: ColorFilter.mode(
                    !isAddLocation
                        ? signup.zoneSelect.isNotEmpty
                            ? appColor(context).appTheme.darkText
                            : appColor(context).appTheme.lightText
                        : company.zoneSelect.isNotEmpty
                            ? appColor(context).appTheme.darkText
                            : appColor(context).appTheme.lightText,
                    BlendMode.srcIn))
          ],
        ),
      ).inkWell(
          onTap: () => !isAddLocation
              ? signup.onBottomSheet(context)
              : company.onBottomSheet(context));
    });
  }
}
