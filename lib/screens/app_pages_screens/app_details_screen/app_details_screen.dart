import 'package:fixit_provider/providers/app_pages_provider/app_details_provider.dart';
import 'package:fixit_provider/screens/app_pages_screens/app_details_screen/layout/details_layout.dart';

import '../../../config.dart';

class AppDetailsScreen extends StatelessWidget {
  const AppDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppDetailsProvider>(builder: (context, value, child) {
      return StatefulWrapper(
          onInit: () => Future.delayed(DurationsDelay.ms150)
              .then((_) => value.getAppPages()),
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
            body: ListView.builder(
              shrinkWrap: true, // Ensures it doesn't take infinite height
              physics:
                  const NeverScrollableScrollPhysics(), // Prevents extra scrolling if inside another scrollable widget
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
                .paddingAll(Insets.i20),
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
