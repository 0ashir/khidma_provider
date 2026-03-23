

import '../../../../config.dart';

class ServicePackageShimmer extends StatelessWidget {
  const ServicePackageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDark(context)? Colors.black:Colors.white,
      body: Stack(alignment: Alignment.bottomCenter,
        children: [
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.s20),
            children: [
              Column(
                children: [
                  const VSpace(Sizes.s50),
                  const Row(children: [
                    CommonSkeleton(
                        height: Sizes.s40, width: Sizes.s40, isCircle: true),
                    HSpace(Sizes.s48),
                    CommonSkeleton(height: Sizes.s23, width: Sizes.s138, radius: 12)
                  ]),
                  const VSpace(Sizes.s34),
                  Container(
                    padding: const EdgeInsets.all(Sizes.s15),
                    decoration: ShapeDecoration(
                        color: isDark(context)?Colors.black26: appColor(context).appTheme.whiteBg,shadows:isDark(context) ?[]: [
                      BoxShadow(
                          color: appColor(context).appTheme.darkText.withOpacity(0.06),
                          blurRadius: 5,
                          spreadRadius: 0,
                          offset: const Offset(0,2)
                      )
                    ],
                        shape: SmoothRectangleBorder(
                            side: BorderSide(color: isDark(context)?Colors.black26: appColor(context).appTheme.stroke),
                            borderRadius: SmoothBorderRadius(
                                cornerRadius: Sizes.s12, cornerSmoothing: 1))),
                    child: Column(children: [
                      const CommonSkeleton(height: Sizes.s78, radius: 12),
                      const VSpace(Sizes.s12),
                      const CommonSkeleton(
                          height: Sizes.s22, width: Sizes.s190, radius: 12),
                      const VSpace(Sizes.s8),
                      const CommonSkeleton(
                          height: Sizes.s22, width: Sizes.s106, radius: 12),
                      const VSpace(Sizes.s20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CommonSkeleton(
                              height: Sizes.s22, width: Sizes.s106, radius: 12),
                          const VSpace(Sizes.s11),
                          const CommonSkeleton(height: Sizes.s14),
                          const VSpace(Sizes.s7),
                          const CommonSkeleton(height: Sizes.s14),
                          const VSpace(Sizes.s5),
                          const CommonSkeleton(height: Sizes.s14),
                          const VSpace(Sizes.s6),
                          const CommonSkeleton(height: Sizes.s14, width: Sizes.s60),
                          const VSpace(Sizes.s15),
                          Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              const CommonSkeleton(height: Sizes.s115, radius: 10),
                              const Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CommonWhiteShimmer(
                                              height: Sizes.s14, width: Sizes.s78),
                                          CommonWhiteShimmer(
                                              height: Sizes.s14, width: Sizes.s58)
                                        ]),
                                    VSpace(Sizes.s30),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                CommonWhiteShimmer(
                                                    height: Sizes.s38,
                                                    width: Sizes.s38,
                                                    isCircle: true),
                                                HSpace(Sizes.s12),
                                                CommonWhiteShimmer(
                                                    height: Sizes.s14,
                                                    width: Sizes.s78)
                                              ]),
                                          CommonWhiteShimmer(
                                              height: Sizes.s14, width: Sizes.s78)
                                        ])
                                  ]).paddingSymmetric(
                                  horizontal: Sizes.s15, vertical: Sizes.s16)
                            ],
                          ),
                          const VSpace(Sizes.s15),
                          const CommonSkeleton(height: Sizes.s14, width: Sizes.s115),
                          const VSpace(Sizes.s15),
                          Container(
                            padding: const EdgeInsets.all(Sizes.s15),
                            decoration: ShapeDecoration(
                                color: isDark(context)?Colors.black26: appColor(context).appTheme
                                    .skeletonColor
                                    .withOpacity(.8),
                                shape: SmoothRectangleBorder(
                                    borderRadius: SmoothBorderRadius(
                                        cornerRadius: 10, cornerSmoothing: 1))),
                            child: Column(
                              children: List.generate(
                                  2,
                                  (index) => const Column(
                                    crossAxisAlignment:   CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              CommonWhiteShimmer(
                                                height: Sizes.s70,
                                                width: Sizes.s70,
                                                radius: 8
                                              ),
                                              HSpace(Sizes.s10),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                children: [
                                                  CommonWhiteShimmer(
                                                      height: Sizes.s14,
                                                      width: Sizes.s115),
                                                  VSpace(Sizes.s7),
                                                  CommonWhiteShimmer(
                                                      height: Sizes.s16,
                                                      width: Sizes.s115),
                                                  VSpace(Sizes.s7),
                                                  CommonWhiteShimmer(
                                                      height: Sizes.s16,
                                                      width: Sizes.s50)
                                                ]
                                              )
                                            ]
                                          ),
                                          VSpace(Sizes.s30),
                                          CommonWhiteShimmer(
                                              height: Sizes.s14,
                                              width: Sizes.s238),
                                          VSpace(Sizes.s8),
                                          CommonWhiteShimmer(
                                              height: Sizes.s14,
                                              width: Sizes.s62)
                                        ],
                                      ).marginOnly(
                                          bottom: index != 1 ? Sizes.s40 : 0)),
                            ),
                          ),
                          const VSpace(Sizes.s32),
                          const CommonSkeleton(height: Sizes.s14, width: Sizes.s128),
                          const VSpace(Sizes.s9),
                          const CommonSkeleton(height: Sizes.s14),
                          const VSpace(Sizes.s7),
                          const CommonSkeleton(height: Sizes.s14)
                        ]
                      ).width(MediaQuery.of(context).size.width)
                    ]),
                  ),
                  const VSpace(Sizes.s100),
                ],
              )
            ],
          ),
          const Stack(alignment: Alignment.center, children: [
            CommonSkeleton(height: Sizes.s50),
            CommonWhiteShimmer(height: Sizes.s15, width: Sizes.s88)
          ])
              .marginSymmetric(horizontal: Sizes.s15)
              .paddingOnly(bottom: Sizes.s15)
              .backgroundColor(isDark(context)?Colors.black26: appColor(context).appTheme.whiteBg)
        ],
      ),
    );
  }
}
