// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:fixit_provider/providers/app_pages_provider/ads_detail_provider.dart';

import '../../../config.dart';
import '../../../providers/app_pages_provider/ads_provider.dart';
import 'common_adslist_layout.dart';

class AdvertisingScreens extends StatelessWidget {
  const AdvertisingScreens({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AdsProvider, AdsDetailProvider>(
        builder: (context1, value, value2, child) {

      return StatefulWrapper(
        onInit: () => Future.delayed(const Duration(milliseconds: 150))
            .then((_) => value.onReady(context)),
        child: PopScope(
          onPopInvokedWithResult: (didPop, result) {
            value.onBack(context);
            if (didPop) return;
          },
          child: LoadingComponent(
            child: Scaffold(
              appBar: AppBar(
                  leadingWidth: 80,
                  title: Text(language(context, translations!.advertisement),
                      style: appCss.dmDenseSemiBold18
                          .textColor(appColor(context).appTheme.darkText)),
                  centerTitle: true,
                  leading: CommonArrow(
                          arrow: rtl(context)
                              ? eSvgAssets.arrowRight
                              : eSvgAssets.arrowLeft,
                          onTap: () => value.onBack(context, isBack: true))
                      .paddingDirectional(all: Sizes.s10)),
              body: Column(
                children: [
                  VSpace(Sizes.s20),
                  SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children:
                            appArray.adsStatusList.asMap().entries.map((e) {
                              log("e.value ${e.value}");
                          return IntrinsicWidth(
                            child: Column(children: [
                              Text(language(context, e.value),
                                      style: value.tabIndex == e.key
                                          ? appCss.dmDenseSemiBold14.textColor(
                                              appColor(context)
                                                  .appTheme
                                                  .whiteColor)
                                          : appCss.dmDenseRegular14.textColor(
                                              appColor(context)
                                                  .appTheme
                                                  .lightText),
                                      textAlign: TextAlign.center)
                                  .inkWell(onTap: () {
                                    log("SSS ");
                                    value.onTapTab(context, e.key, e.value);
                                  })
                                  .padding(
                                      vertical: Insets.i10,
                                      horizontal: Insets.i20)
                                  .decorated(
                                      color: value.tabIndex == e.key
                                          ? appColor(context).appTheme.primary
                                          : appColor(context).appTheme.trans,
                                      borderRadius:
                                          BorderRadius.circular(Sizes.s4),
                                      border: Border.all(
                                          color: appColor(context)
                                              .appTheme
                                              .stroke))
                                  .padding(right: Sizes.s12),
                            ]),
                          );
                        }).toList(),
                      ).paddingSymmetric(horizontal: Insets.i20)),
                  VSpace(Sizes.s20),
                  // Dynamic List Section

                  value.isLoading == true
                      ? Image.asset(eGifAssets.loaderGif, height: Sizes.s100)
                          .center()
                      : advertisementList.isEmpty
                          ? const CommonEmpty().padding(top: Sizes.s50)
                          : Expanded(
                              child: ListView(
                                children: [
                                  ...advertisementList.asMap().entries.map(
                                    (e) {
                                      return CommonAdsListLayout(
                                          data: e.value,
                                          onTap: () async {
                                            await value2.getAdvertisementList(
                                                context, e.value.id);
                                            if (e.value.type == "service") {
                                              print(
                                                  "Service List : ${e.value.id}");
                                              route.pushNamed(
                                                context,
                                                routeName.adsServiceList,
                                              );
                                            } else {
                                              if (e.value.bannerType ==
                                                  "image") {
                                                value2.onHomeImageChange(
                                                    0,
                                                    e.value.media.first
                                                        .originalUrl);
                                              }
                                              route.pushNamed(context,
                                                  routeName.adsDetailsScreen,
                                                  arg: e.value);
                                            }
                                          });
                                    },
                                  )
                                ],
                              ),
                            ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
