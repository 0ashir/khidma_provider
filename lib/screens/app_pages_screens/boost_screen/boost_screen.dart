import 'dart:developer';
import 'dart:io';

import 'package:fixit_provider/screens/app_pages_screens/add_new_service_screen/layouts/service_selection.dart';
import 'package:fixit_provider/screens/app_pages_screens/boost_screen/text_filed_layout.dart';
import 'package:fixit_provider/screens/app_pages_screens/boost_screen/zone_list.dart';
import 'package:intl/intl.dart';

import '../../../config.dart';
import '../../../providers/app_pages_provider/boost_provider.dart';
import '../../../widgets/wallet_drop_down.dart';
import '../../auth_screens/sign_up_company_screen/layouts/zone_list.dart';
import '../add_new_service_screen/layouts/category_selection.dart';
import 'boost_bill_summary.dart';
import 'boost_category_selection.dart';

class BoostScreen extends StatelessWidget {
  const BoostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<SignUpCompanyProvider, CompanyDetailProvider,
        BoostProvider>(builder: (context1, signup, company, value, child) {
      log("value.bannerImage.length${value.bannerImage.length}");
      return PopScope(
        canPop: true,
        onPopInvoked: (didPop) {
          value.categories = [];
          value.zoneSelect = [];
          value.bannerImage.clear();
          value.startDateCtrl.clear();
          value.differenceInDays = 0;
        },
        child: StatefulWrapper(
          onInit: () =>
              Future.delayed(const Duration(milliseconds: 150)).then((_) {
            value.onReady();
            value.onInit(context);
            final commonApi =
                Provider.of<CommonApiProvider>(context, listen: false);
            commonApi.getZoneList();
            final homePvr = Provider.of<HomeProvider>(context, listen: false);
            homePvr.getAppSettingList(context);
            log("dfadjh $allServiceList");
          }),
          child: Scaffold(
              appBar: AppBar(
                  leadingWidth: 80,
                  centerTitle: true,
                  title: Text(language(context, "Increase Reach"),
                      style: appCss.dmDenseSemiBold18
                          .textColor(appColor(context).appTheme.darkText)),
                  leading: CommonArrow(
                          arrow: rtl(context)
                              ? eSvgAssets.arrowRight
                              : eSvgAssets.arrowLeft,
                          onTap: () => value.onBack(context, isBack: true))
                      .padding(all: Sizes.s7)),
              body: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  ListView(children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const VSpace(Sizes.s18),
                          Text(
                                  language(context,
                                      "Please note: The total amount will be deducted from the selected provider's wallet. If you update the advertisement and the amount increases due to an extension of the dates, the additional amount will also be debited from the wallet."),
                                  style: appCss.dmDenseMedium12.textColor(
                                      appColor(context).appTheme.lightText))
                              .padding(
                                  vertical: Sizes.s14, horizontal: Sizes.s17)
                              .decorated(
                                  color: appColor(context).appTheme.fieldCardBg,
                                  borderRadius:
                                      BorderRadius.circular(Sizes.s10)),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    const FieldsBackground(),
                                    Column(children: [
                                      const ContainerWithTextLayout(
                                              title: "Advertisement Type")
                                          .padding(
                                              bottom: Sizes.s8, top: Sizes.s16),
                                      DarkDropDownLayout(
                                          svgColor: appColor(context)
                                              .appTheme
                                              .lightText,
                                          border: CommonWidgetLayout()
                                              .noneDecoration(
                                                  radius: 0,
                                                  color: appColor(context)
                                                      .appTheme
                                                      .trans),
                                          val: value.serviceBanner,
                                          hintText:
                                              language(context, "Ads Type"),
                                          isIcon: true,
                                          icon: eSvgAssets.adsType,
                                          categoryList: appArray.serviceBanner,
                                          onChanged: (val) => value
                                              .serviceBannerValue(val)).padding(
                                          horizontal: Sizes.s20),
                                      const ContainerWithTextLayout(
                                              title: "App Screen")
                                          .padding(
                                              bottom: Sizes.s8, top: Sizes.s16),
                                      DarkDropDownLayout(
                                          svgColor: appColor(context)
                                              .appTheme
                                              .lightText,
                                          border: CommonWidgetLayout()
                                              .noneDecoration(
                                                  radius: 0,
                                                  color: appColor(context)
                                                      .appTheme
                                                      .trans),
                                          val: value.selectPage,
                                          hintText:
                                              language(context, "App Screen"),
                                          isIcon: true,
                                          icon: eSvgAssets.appScreen,
                                          categoryList: appArray.selectHomeCat,
                                          onChanged: (val) =>
                                              value.onSelectPage(val)).padding(
                                          horizontal: Sizes.s20),
                                      value.serviceBanner == "Banner"
                                          ? Column(children: [
                                              const ContainerWithTextLayout(
                                                      title: "Select Banner")
                                                  .padding(
                                                      bottom: Sizes.s8,
                                                      top: Sizes.s16),
                                              DarkDropDownLayout(
                                                  svgColor: appColor(context)
                                                      .appTheme
                                                      .lightText,
                                                  border: CommonWidgetLayout()
                                                      .noneDecoration(
                                                          radius: 0,
                                                          color:
                                                              appColor(context)
                                                                  .appTheme
                                                                  .trans),
                                                  val: value.choseValue,
                                                  hintText: language(
                                                      context, "Select Banner"),
                                                  isIcon: true,
                                                  icon: eSvgAssets.box,
                                                  categoryList:
                                                      appArray.bannerType,
                                                  onChanged: (val) => value
                                                      .selectImageOrTextValue(
                                                          val)).padding(
                                                  horizontal: Sizes.s20)
                                            ])
                                          : Column(
                                              children: [
                                                const ContainerWithTextLayout(
                                                        title: "Service")
                                                    .padding(
                                                        bottom: Sizes.s8,
                                                        top: Sizes.s16),
                                                const OfferServiceSelectionLayout()
                                                    .padding(
                                                        horizontal: Sizes.s20),
                                              ],
                                            ),
                                      if (value.serviceBanner == "Banner" &&
                                          value.choseValue == "Image")
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ContainerWithTextLayout(
                                                      title: appFonts
                                                          .uploadLogoImage)
                                                  .padding(
                                                      top: Sizes.s16,
                                                      bottom: Sizes.s8),
                                              if (value.imageFile != null)
                                                value.bannerImage.length <= 1
                                                    ? ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            child: Image.file(
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    File(value
                                                                        .imageFile!
                                                                        .path),
                                                                    width: MediaQuery.sizeOf(context)
                                                                        .width,
                                                                    height: Sizes
                                                                        .s145)
                                                                .inkWell(
                                                                    onTap: () {
                                                              /*  value.onImagePick(
                                                                  context); */
                                                            }))
                                                        .padding(
                                                            horizontal:
                                                                Sizes.s20,
                                                            bottom: Sizes.s30)
                                                    : GridView.builder(
                                                        shrinkWrap: true,
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        gridDelegate:
                                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                          crossAxisCount: 2,
                                                          // Adjust based on your requirement
                                                          crossAxisSpacing: 10,
                                                          mainAxisSpacing: 10,
                                                          childAspectRatio:
                                                              1, // Make it square
                                                        ),
                                                        itemCount: value
                                                            .bannerImage.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            child: Image.file(
                                                              File(value
                                                                  .bannerImage[
                                                                      index]
                                                                  .path),
                                                              fit: BoxFit.cover,
                                                              width: double
                                                                  .infinity,
                                                              height: double
                                                                  .infinity,
                                                            ).inkWell(
                                                              onTap: () => value
                                                                  .onImagePick(
                                                                      context),
                                                            ),
                                                          );
                                                        },
                                                      ).paddingDirectional(
                                                        horizontal: Sizes.s20,
                                                        bottom: Sizes.s30),
                                              if (value.bannerImage.length <
                                                  int.parse(
                                                      settingAdvertisementModel[
                                                          'max_image_uploads']))
                                                AddNewBoxLayout(
                                                        height: Sizes.s100,
                                                        width: double.infinity,
                                                        title: appFonts.addNew,
                                                        onAdd: () {
                                                          if (value.bannerImage
                                                                  .length <
                                                              int.parse(
                                                                  settingAdvertisementModel[
                                                                      'max_image_uploads']))
                                                            value.onImagePick(
                                                                context);
                                                        })
                                                    .padding(
                                                        horizontal: Sizes.s20)
                                            ]),
                                      if (value.serviceBanner == "Banner" &&
                                          value.choseValue == "Video")
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const ContainerWithTextLayout(
                                                      title:
                                                          "Upload Video Link")
                                                  .padding(
                                                      top: Sizes.s16,
                                                      bottom: Sizes.s8),
                                              TextFieldCommon(
                                                      // isEnable: false,
                                                      focusNode:
                                                          value.videoFocus,
                                                      controller:
                                                          value.videoCtrl,
                                                      hintText: "Video Link",
                                                      style: appCss
                                                          .dmDenseMedium13
                                                          .textColor(
                                                              appColor(context)
                                                                  .appTheme
                                                                  .darkText),
                                                      validator: (value) => validation
                                                          .dynamicTextValidation(
                                                              context,
                                                              value,
                                                              "Please Enter Video Link"),
                                                      prefixIcon:
                                                          eSvgAssets.video)
                                                  .padding(
                                                      horizontal: Sizes.s20)
                                            ]),
                                      const ContainerWithTextLayout(
                                              title: "Select Date")
                                          .padding(
                                              bottom: Sizes.s8, top: Sizes.s16),
                                      TextFieldCommon(
                                              isEnable: false,
                                              focusNode: value.startDateFocus,
                                              controller: value.startDateCtrl,
                                              hintText:
                                                  translations!.selectDate!,
                                              style: appCss.dmDenseMedium13
                                                  .textColor(appColor(context)
                                                      .appTheme
                                                      .darkText),
                                              validator: (value) => validation
                                                  .dynamicTextValidation(
                                                      context,
                                                      value,
                                                      translations!
                                                          .pleaseSelectEndDate),
                                              prefixIcon: eSvgAssets.calender)
                                          .inkWell(
                                              onTap: () =>
                                                  value.onDateSelect(context))
                                          .padding(horizontal: Sizes.s20),
                                      const ContainerWithTextLayout(
                                              title: "Zones")
                                          .padding(
                                              bottom: Sizes.s8, top: Sizes.s16),
                                      const BoostZoneDropDown(),
                                    ]).paddingSymmetric(vertical: Insets.i20),
                                  ],
                                ).padding(top: Sizes.s20, bottom: Sizes.s16),
                                    Text(
                                        language(
                                            context, translations!.billSummary),
                                        style: appCss.dmDenseMedium14.textColor(
                                            appColor(context)
                                                .appTheme
                                                .darkText))
                                    .padding(
                                        top: Insets.i16, bottom: Insets.i10),
                     const CommonBillSummary()
                                    .padding(bottom: Sizes.s110)
                              ])
                        ]).padding(horizontal: Sizes.s20)
                  ]),
                  ButtonCommon(
                          title: language(context, translations!.payment),
                          onTap: () {
                            userModel?.providerWallet?.balance == 0.0
                                ? snackBarMessengers(context,
                                    message: "Please Check Your Wallet Balance")
                                : value.createPromotionPlan(context);
                          })
                      .paddingDirectional(
                          top: Sizes.s20,
                          bottom: Sizes.s20,
                          horizontal: Sizes.s20)
                      .backgroundColor(appColor(context).appTheme.whiteBg)
                ],
              )),
        ),
      );
    });
  }
}
