import 'package:fixit_provider/providers/app_pages_provider/app_details_provider.dart';
import 'package:fixit_provider/screens/app_pages_screens/app_details_screen/layout/details_layout.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../config.dart';

class AppDetailsScreen extends StatelessWidget {
  const AppDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppDetailsProvider>(builder: (context, value, child) {
      return StatefulWrapper(
          onInit: () => Future.delayed(DurationsDelay.ms150).then((_) {
            value.getAppPages();
            value.getAppInfo();
          }),
          child: Scaffold(
            appBar: AppBar(
                leadingWidth: 80,
                title: Text(
                    language(context,
                        translations!.appDetails ?? appFonts.appDetails),
                    textAlign: TextAlign.center,
                    style: appCss.dmDenseBold18
                        .textColor(appColor(context).appTheme.darkText)),
                centerTitle: true,
                leading: CommonArrow(
                        arrow: rtl(context)
                            ? eSvgAssets.arrowRight
                            : eSvgAssets.arrowLeft,
                        onTap: () => route.pop(context))
                    .paddingDirectional(vertical: Insets.i8)),
            body: SingleChildScrollView(
              child: Column(children: [
                // App info: logo, name, version and a short description so
                // the page isn't blank when the API returns no extra pages.
                Column(children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.r20),
                      child: Image.asset(eImageAssets.appLogo,
                          height: Sizes.s80, width: Sizes.s80, fit: BoxFit.cover)),
                  const VSpace(Sizes.s12),
                  Text("Khidma Provider",
                      style: appCss.dmDenseBold18
                          .textColor(appColor(context).appTheme.darkText)),
                  if (value.appVersion.isNotEmpty) ...[
                    const VSpace(Sizes.s4),
                    Text("Version ${value.appVersion}",
                        style: appCss.dmDenseRegular13
                            .textColor(appColor(context).appTheme.lightText))
                  ],
                  const VSpace(Sizes.s12),
                  Text(
                      "Manage your bookings, track earnings and grow your business — all from one place.",
                      textAlign: TextAlign.center,
                      style: appCss.dmDenseRegular13
                          .textColor(appColor(context).appTheme.lightText)),
                  const VSpace(Sizes.s16),
                  // WhatsApp contact button — opens a chat with our support number
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const FaIcon(FontAwesomeIcons.whatsapp,
                            color: Color(0xFF25D366), size: Sizes.s20),
                        const HSpace(Sizes.s8),
                        Text("Chat with us on WhatsApp",
                            style: appCss.dmDenseMedium14
                                .textColor(appColor(context).appTheme.primary))
                      ])
                      .paddingSymmetric(horizontal: Insets.i18, vertical: Insets.i10)
                      .decorated(
                          color: appColor(context).appTheme.fieldCardBg,
                          borderRadius: BorderRadius.circular(AppRadius.r30))
                      .inkWell(onTap: () => value.onTapWhatsapp(context)),
                  const VSpace(Sizes.s12),
                  // Website link — opens khidmaplus.com in the browser
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.language,
                            color: appColor(context).appTheme.primary,
                            size: Sizes.s20),
                        const HSpace(Sizes.s8),
                        Text("Visit our website",
                            style: appCss.dmDenseMedium14
                                .textColor(appColor(context).appTheme.primary))
                      ])
                      .paddingSymmetric(horizontal: Insets.i18, vertical: Insets.i10)
                      .decorated(
                          color: appColor(context).appTheme.fieldCardBg,
                          borderRadius: BorderRadius.circular(AppRadius.r30))
                      .inkWell(onTap: () => value.onTapWebsite(context))
                ])
                    .paddingAll(Insets.i20)
                    .boxBorderExtension(context, isShadow: true)
                    .paddingSymmetric(horizontal: Insets.i20),
                const VSpace(Sizes.s20),
                if (value.pageList.isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: value.pageList.length,
                    itemBuilder: (context, index) {
                      final page = value.pageList[index];

                      return Column(
                        children: [
                          AppDetailsLayout(
                            data: page,
                            list: value.pageList,
                            index: index,
                            onTap: () => value.onTapOption(page, context),
                          ),
                        ],
                      );
                    },
                  )
                      .paddingAll(Insets.i15)
                      .boxBorderExtension(context, isShadow: true)
                      .paddingSymmetric(horizontal: Insets.i20)
              ]).paddingOnly(bottom: Insets.i20),
            ),
          )
          /* Column(children: [
              /*   value.isLoading
                  ? Stack(children: [
                      CommonSkeleton(
                          height: Sizes.s280,
                          width: MediaQuery.of(context).size.width),
                      const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CommonWhiteShimmer(
                                    height: Sizes.s32,
                                    width: Sizes.s32,
                                    radius: 6),
                                HSpace(Sizes.s14),
                                CommonWhiteShimmer(
                                    height: Sizes.s14, width: Sizes.s90),
                              ],
                            ),
                            VSpace(Sizes.s30),
                            Row(
                              children: [
                                CommonWhiteShimmer(
                                    height: Sizes.s32,
                                    width: Sizes.s32,
                                    radius: 6),
                                HSpace(Sizes.s14),
                                CommonWhiteShimmer(
                                    height: Sizes.s14, width: Sizes.s90),
                              ],
                            ),
                            VSpace(Sizes.s30),
                            Row(
                              children: [
                                CommonWhiteShimmer(
                                    height: Sizes.s32,
                                    width: Sizes.s32,
                                    radius: 6),
                                HSpace(Sizes.s14),
                                CommonWhiteShimmer(
                                    height: Sizes.s14, width: Sizes.s90),
                              ],
                            ),
                            VSpace(Sizes.s30),
                            Row(
                              children: [
                                CommonWhiteShimmer(
                                    height: Sizes.s32,
                                    width: Sizes.s32,
                                    radius: 6),
                                HSpace(Sizes.s14),
                                CommonWhiteShimmer(
                                    height: Sizes.s14, width: Sizes.s90),
                              ],
                            ),
                            VSpace(Sizes.s30),
                          ]).marginSymmetric(
                          horizontal: Sizes.s10, vertical: Sizes.s15)
                    ]).marginSymmetric(horizontal: Sizes.s10)
                  : value.pageList.isEmpty
                      ? Container()
                      :  */
              Column(
                      children: value.pageList
                          .asMap()
                          .entries
                          .map((e) => AppDetailsLayout(
                              data: e.value,
                              list: value.pageList,
                              index: e.key,
                              onTap: () => value.onTapOption(e.value, context)))
                          .toList())
                  .paddingAll(Insets.i15)
                  .boxBorderExtension(context, isShadow: true)
            ]).paddingAll(Insets.i20)), */
          );
    });
  }
}
