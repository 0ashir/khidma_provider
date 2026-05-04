import 'dart:developer';

import 'package:fixit_provider/screens/auth_screens/sign_up_company_screen/layouts/zone_list.dart';

import '../../../config.dart';

class CompanyDetailsScreen extends StatefulWidget {
  const CompanyDetailsScreen({super.key});

  @override
  State<CompanyDetailsScreen> createState() => _CompanyDetailsScreenState();
}

class _CompanyDetailsScreenState extends State<CompanyDetailsScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Consumer3<CompanyDetailProvider, NewLocationProvider,
            UserDataApiProvider>(
        builder: (context2, value, locationVal, api, child) {
      return StatefulWrapper(
        onInit: () => Future.delayed(const Duration(milliseconds: 150), () {
          final commonApi =
              Provider.of<CommonApiProvider>(context, listen: false);
          commonApi.getZoneList();
          value.onReady();
        }),
        child: Scaffold(
            appBar: AppBar(
                leadingWidth: 80,
                title: Text(
                    language(
                        context,
                        isFreelancer
                            ? translations!.serviceLocation
                            : translations!.companyDetails),
                    style: appCss.dmDenseBold18
                        .textColor(appColor(context).appTheme.darkText)),
                centerTitle: true,
                actions: [
                  if (!isServiceman && !isFreelancer)
                    CommonArrow(
                            arrow: eSvgAssets.edit,
                            onTap: () => route.pushNamed(
                                context, routeName.companyDetailUpdate))
                        .paddingSymmetric(horizontal: Sizes.s20)
                ],
                leading: CommonArrow(
                    arrow: rtl(context)
                        ? eSvgAssets.arrowRight
                        : eSvgAssets.arrowLeft,
                    onTap: () /* => */ {
                      value.isSelectedZone = false;
                      route.pop(context);
                    }).padding(vertical: Insets.i8)),
            body: SingleChildScrollView(
                child: Column(children: [
              if (isFreelancer != true) const CompanyTopLayout(),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                if (!isServiceman)
                  Text(language(context, translations!.serviceAvailability),
                    overflow: TextOverflow.ellipsis,
                    style: appCss.dmDenseMedium16
                        .textColor(appColor(context).appTheme.darkText)),
                if (!isServiceman)
                  Text(
                          language(context,
                              "+ ${language(context, translations!.add)}"),
                          style: appCss.dmDenseBold16
                              .textColor(appColor(context).appTheme.primary))
                      .inkWell(onTap: () => value.zoneAddHideShow())
              ]).paddingOnly(top: Insets.i25, bottom: Insets.i15),
              if (value.isSelectedZone)
                Column(
                  children: [
                    const ZoneDropDown(isAddLocation: true),
                    const VSpace(Sizes.s20),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: ShapeDecoration(
                          color: appColor(context).appTheme.primary,
                          shape: SmoothRectangleBorder(
                              borderRadius: SmoothBorderRadius(
                                  cornerRadius: AppRadius.r8,
                                  cornerSmoothing: 1))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          value.isZoneUpdate
                              ? const CircularProgressIndicator(
                                      color: Colors.white)
                                  .center()
                                  .padding(vertical: Sizes.s5)
                              : Text(language(context, translations!.add),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: appCss.dmDenseRegular16.textColor(
                                      appColor(context).appTheme.whiteColor)),
                        ],
                      ),
                    ).inkWell(onTap: () => value.zoneUpdateAddress(context))
                    /* ButtonCommon(
                      title: language(context, translations!.add),
                      onTap: () => value.zoneUpdateAddress(context),
                    ) */
                  ],
                ),
              if (!isServiceman)
                if (!value.isSelectedZone)
                  if (userModel!.zones!.isNotEmpty)
                    Column(children: [
                      if (userModel!.zones!.isNotEmpty) const VSpace(Sizes.s15),
                      if (userModel!.zones!.isNotEmpty)
                        ...userModel!.zones!.asMap().entries.map((e) =>
                            Column(children: [
                              ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                  leading: SvgPicture.asset(eSvgAssets.location,
                                          colorFilter: ColorFilter.mode(
                                              appColor(context)
                                                  .appTheme
                                                  .primary,
                                              BlendMode.srcIn))
                                      .paddingAll(Insets.i7)
                                      .decorated(
                                          shape: BoxShape.circle,
                                          color: appColor(context)
                                              .appTheme
                                              .primary
                                              .withOpacity(0.1)),
                                  title: Text(e.value.name!,
                                          overflow: TextOverflow.ellipsis,
                                          style: appCss.dmDenseMedium12
                                              .textColor(appColor(context)
                                                  .appTheme
                                                  .darkText))
                                      .width(Sizes.s110),
                                  trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CommonArrow(
                                            arrow: eSvgAssets.delete,
                                            color: appColor(context)
                                                .appTheme
                                                .red
                                                .withOpacity(0.1),
                                            svgColor:
                                                appColor(context).appTheme.red,
                                            onTap: () => value.deleteZone(
                                                context, e.value.id),
                                            isThirteen: true)
                                      ])).padding(vertical: Insets.i10)
                            ])
                                .paddingSymmetric(horizontal: Insets.i15)
                                .boxShapeExtension(
                                    color:
                                        appColor(context).appTheme.fieldCardBg)
                                .marginOnly(
                                    bottom:
                                        e.key != userModel!.zones!.length - 1
                                            ? Insets.i15
                                            : 0))
                    ])
                        .paddingAll(Insets.i15)
                        .boxBorderExtension(context, isShadow: true),
              // if (isServiceman)
              //   if (!value.isSelectedZone)
              //     if (provider!.zones!.isNotEmpty)
              //       Column(children: [
              //         if (provider!.zones!.isNotEmpty) const VSpace(Sizes.s15),
              //         if (provider!.zones!.isNotEmpty)
              //           ...provider!.zones!.asMap().entries.map((e) =>
              //               Column(children: [
              //                 ListTile(
              //                   contentPadding: EdgeInsets.zero,
              //                   dense: true,
              //                   leading: SvgPicture.asset(eSvgAssets.location,
              //                           colorFilter: ColorFilter.mode(
              //                               appColor(context).appTheme.primary,
              //                               BlendMode.srcIn))
              //                       .paddingAll(Insets.i7)
              //                       .decorated(
              //                           shape: BoxShape.circle,
              //                           color: appColor(context)
              //                               .appTheme
              //                               .primary
              //                               .withOpacity(0.1)),
              //                   title: Text(e.value.name!,
              //                           overflow: TextOverflow.ellipsis,
              //                           style: appCss.dmDenseMedium12.textColor(
              //                               appColor(context)
              //                                   .appTheme
              //                                   .darkText))
              //                       .width(Sizes.s110),
              //                 ).padding(vertical: Insets.i10)
              //               ])
              //                   .paddingSymmetric(horizontal: Insets.i15)
              //                   .boxShapeExtension(
              //                       color:
              //                           appColor(context).appTheme.fieldCardBg)
              //                   .marginOnly(
              //                       bottom: e.key != provider!.zones!.length - 1
              //                           ? Insets.i15
              //                           : 0))
              //       ])
              //           .paddingAll(Insets.i15)
              //           .boxBorderExtension(context, isShadow: true)
            ]).padding(horizontal: Insets.i20, bottom: Insets.i20))),
      );
    });
  }
}
