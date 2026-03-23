import 'package:fixit_provider/config.dart';

class HomeShimmer extends StatelessWidget {
  const HomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: isDark(context) ? Colors.black : Colors.white,
        body: ListView(children: [
          const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  CommonSkeleton(
                      height: Sizes.s40, width: Sizes.s40, isCircle: true),
                  HSpace(Sizes.s10),
                  CommonSkeleton(height: Sizes.s15, width: Sizes.s90)
                ]),
                Row(children: [
                  CommonSkeleton(
                      height: Sizes.s40, width: Sizes.s40, isCircle: true),
                  HSpace(Sizes.s10),
                  CommonSkeleton(
                      height: Sizes.s40, width: Sizes.s40, isCircle: true)
                ])
              ]).padding(horizontal: Sizes.s20),
          const VSpace(Sizes.s25),
          Stack(alignment: Alignment.center, children: [
            const CommonSkeleton(height: Sizes.s72, radius: 35),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  CommonWhiteShimmer(
                      height: Sizes.s40, width: Sizes.s40, isCircle: true),
                  HSpace(Sizes.s8),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonWhiteShimmer(height: Sizes.s15, width: Sizes.s76),
                        VSpace(Sizes.s8),
                        CommonWhiteShimmer(height: Sizes.s15, width: Sizes.s98)
                      ])
                ]),
                CommonWhiteShimmer(
                    height: Sizes.s40, width: Sizes.s100, radius: 20),
              ],
            ).paddingSymmetric(horizontal: Sizes.s12)
          ]).padding(horizontal: Sizes.s20),
          const VSpace(Sizes.s16),
          StaggeredGrid.count(
                  crossAxisCount: 10,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  children: appArray.earningList
                      .getRange(0, 4)
                      .toList()
                      .asMap()
                      .entries
                      .map((e) => StaggeredGridTile.count(
                          crossAxisCellCount: e.key == 0
                              ? 6
                              : e.key == 1
                                  ? 4
                                  : e.key == 2
                                      ? 4
                                      : 6,
                          mainAxisCellCount: 3.4,
                          child:
                              Stack(alignment: Alignment.centerLeft, children: [
                            const CommonSkeleton(
                                height: Sizes.s105, radius: Sizes.s15),
                            const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CommonWhiteShimmer(
                                      height: Sizes.s32,
                                      width: Sizes.s32,
                                      radius: 6),
                                  VSpace(Sizes.s11),
                                  CommonWhiteShimmer(
                                      height: Sizes.s10, width: Sizes.s76),
                                  VSpace(Sizes.s10),
                                  CommonWhiteShimmer(
                                      height: Sizes.s10, width: Sizes.s98)
                                ]).paddingSymmetric(horizontal: Sizes.s14)
                          ])))
                      .toList())
              .padding(horizontal: Sizes.s20),
          const VSpace(Sizes.s25),
          Stack(children: [
            const CommonSkeleton(height: Sizes.s340, radius: 0),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const CommonWhiteShimmer(height: Sizes.s17, width: Sizes.s128),
              const VSpace(Sizes.s18),
              Image.asset(isDark(context)
                  ? eImageAssets.graphDark
                  : eImageAssets.grapghSkeleton)
            ]).padding(horizontal: Sizes.s20, vertical: Sizes.s28)
          ]),
          const VSpace(Sizes.s26),
          const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommonSkeleton(height: Sizes.s17, width: Sizes.s184),
                CommonSkeleton(height: Sizes.s17, width: Sizes.s48)
              ]).padding(horizontal: Sizes.s20),
          const VSpace(Sizes.s18),
          GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: 4,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 230,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15),
                  itemBuilder: (context, index) {
                    return Container(
                        width: Sizes.s257,
                        padding: const EdgeInsets.all(Sizes.s12),
                        decoration: ShapeDecoration(
                            color: isDark(context)
                                ? Colors.black26
                                : appColor(context).appTheme.whiteBg,
                            shape: SmoothRectangleBorder(
                                borderRadius: SmoothBorderRadius(
                                    cornerRadius: 8, cornerSmoothing: 1),
                                side: BorderSide(
                                    color: isDark(context)
                                        ? Colors.black26
                                        : appColor(context)
                                            .appTheme
                                            .skeletonColor))),
                        child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonSkeleton(height: Sizes.s106, radius: 6),
                              VSpace(Sizes.s14),
                              CommonSkeleton(
                                  height: Sizes.s10, width: Sizes.s76),
                              VSpace(Sizes.s9),
                              CommonSkeleton(
                                  height: Sizes.s10, width: Sizes.s98),
                              VSpace(Sizes.s14),
                              CommonSkeleton(height: Sizes.s36, radius: 8),
                            ]));
                  })
              .paddingOnly(
                  left: Insets.i20, right: Insets.i20, bottom: Insets.i25),
          Container(
              color: (isDark(context)
                  ? const Color(0xFF202020).withOpacity(.6)
                  : Colors.grey.withOpacity(0.2)),
              padding: const EdgeInsets.symmetric(
                  horizontal: Sizes.s20, vertical: Sizes.s28),
              child: Column(children: [
                const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonWhiteShimmer(height: Sizes.s17, width: Sizes.s184),
                      CommonWhiteShimmer(height: Sizes.s17, width: Sizes.s48)
                    ]),
                const VSpace(Sizes.s17),
                ...List.generate(
                    2,
                    (index) => Stack(children: [
                          const CommonWhiteShimmer(
                            height: Sizes.s435,
                            radius: 12,
                          ).marginOnly(bottom: index == 0 ? Sizes.s28 : 0),
                          Column(children: [
                            const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CommonSkeleton(
                                            height: Sizes.s10,
                                            width: Sizes.s52),
                                        VSpace(Sizes.s16),
                                        CommonSkeleton(
                                            height: Sizes.s10,
                                            width: Sizes.s160),
                                        VSpace(Sizes.s16),
                                        CommonSkeleton(
                                            height: Sizes.s10,
                                            width: Sizes.s160)
                                      ]),
                                  CommonSkeleton(
                                      height: Sizes.s84,
                                      width: Sizes.s84,
                                      radius: 10)
                                ]),
                            const VSpace(Sizes.s12),
                            Image.asset(eImageAssets.bulletDotted)
                                .padding(bottom: Insets.i18),
                            const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CommonSkeleton(
                                      height: Sizes.s10, width: Sizes.s52),
                                  CommonSkeleton(
                                      height: Sizes.s22,
                                      radius: 12,
                                      width: Sizes.s66)
                                ]),
                            const VSpace(Sizes.s15),
                            const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CommonSkeleton(
                                      height: Sizes.s10, width: Sizes.s116),
                                  CommonSkeleton(
                                      height: Sizes.s10, width: Sizes.s76)
                                ]),
                            const VSpace(Sizes.s18),
                            const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CommonSkeleton(
                                      height: Sizes.s10, width: Sizes.s67),
                                  CommonSkeleton(
                                      height: Sizes.s10, width: Sizes.s128)
                                ]),
                            const VSpace(Sizes.s18),
                            const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CommonSkeleton(
                                      height: Sizes.s10, width: Sizes.s52),
                                  CommonSkeleton(
                                      height: Sizes.s10, width: Sizes.s128)
                                ]),
                            const VSpace(Sizes.s18),
                            const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CommonSkeleton(
                                      height: Sizes.s10, width: Sizes.s55),
                                  CommonSkeleton(
                                      height: Sizes.s10, width: Sizes.s128)
                                ]),
                            const VSpace(Sizes.s18),
                            Stack(alignment: Alignment.centerLeft, children: [
                              const CommonSkeleton(
                                  height: Sizes.s60, radius: 10),
                              const Row(children: [
                                CommonWhiteShimmer(
                                    height: Sizes.s36,
                                    width: Sizes.s36,
                                    isCircle: true),
                                HSpace(Sizes.s8),
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CommonWhiteShimmer(
                                          height: Sizes.s10, width: Sizes.s55),
                                      VSpace(Sizes.s7),
                                      CommonWhiteShimmer(
                                          height: Sizes.s10, width: Sizes.s90)
                                    ])
                              ]).padding(horizontal: Sizes.s12)
                            ]),
                            const VSpace(Sizes.s10),
                            const CommonSkeleton(
                                    height: Sizes.s10, width: Sizes.s150)
                                .alignment(Alignment.centerLeft),
                            const VSpace(Sizes.s15),
                            const Row(children: [
                              Stack(children: [
                                CommonSkeleton(
                                    height: Sizes.s44, width: Sizes.s145),
                                CommonWhiteShimmer()
                              ])
                            ])
                          ]).padding(horizontal: Sizes.s15, top: Sizes.s25)
                        ]))
              ]))
        ]));
  }
}
