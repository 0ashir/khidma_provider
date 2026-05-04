import 'package:fixit_provider/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class ServicemanShimmer extends StatelessWidget {
  const ServicemanShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDark(context) ? Colors.black : Colors.white,
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: Sizes.s20),
        children: [
          const VSpace(Sizes.s25),
          /*   const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommonSkeleton(
                    height: Sizes.s40, width: Sizes.s40, isCircle: true),
                CommonSkeleton(
                    height: Sizes.s23, width: Sizes.s138, radius: 12),
                CommonSkeleton(
                    height: Sizes.s40, width: Sizes.s40, isCircle: true),
              ]),
          const VSpace(Sizes.s25), */
          Container(
            padding: const EdgeInsets.all(Sizes.s15),
            decoration: ShapeDecoration(
                color: isDark(context)
                    ? Colors.black26
                    : appColor(context).appTheme.whiteBg,
                shadows: isDark(context)
                    ? []
                    : [
                        BoxShadow(
                            color: appColor(context)
                                .appTheme
                                .darkText
                                .withOpacity(0.06),
                            blurRadius: 5,
                            spreadRadius: 0,
                            offset: const Offset(0, 2))
                      ],
                shape: SmoothRectangleBorder(
                    side: BorderSide(
                        color: isDark(context)
                            ? Colors.black26
                            : appColor(context).appTheme.stroke),
                    borderRadius: SmoothBorderRadius(
                        cornerRadius: Sizes.s12, cornerSmoothing: 1))),
            child: Column(children: [
              Stack(
                children: [
                  Container(
                    height: Sizes.s68,
                    padding: const EdgeInsets.all(Sizes.s15),
                    decoration: ShapeDecoration(
                        color:
                            appColor(context).appTheme.stroke.withOpacity(.5),
                        shadows: isDark(context) ? [] : [],
                        shape: SmoothRectangleBorder(
                            borderRadius: SmoothBorderRadius(
                                cornerRadius: Sizes.s12, cornerSmoothing: 1))),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                            height: Sizes.s94,
                            width: Sizes.s94,
                            decoration: BoxDecoration(
                                color: appColor(context).appTheme.whiteBg,
                                shape: BoxShape.circle)),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            CommonSkeleton(
                                height: Sizes.s90,
                                width: Sizes.s90,
                                isCircle: true),
                            /* Positioned(
                              right: 0,
                              bottom: 10,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                      height: Sizes.s32,
                                      width: Sizes.s32,
                                      decoration: BoxDecoration(
                                          color: appColor(context)
                                              .appTheme
                                              .whiteBg,
                                          shape: BoxShape.circle)),
                                  Container(
                                      height: Sizes.s28,
                                      width: Sizes.s28,
                                      decoration: BoxDecoration(
                                          color: appColor(context)
                                              .appTheme
                                              .fieldCardBg,
                                          shape: BoxShape.circle)),
                                ],
                              ),
                            ), */
                          ],
                        ).width(Sizes.s100)
                      ],
                    ),
                  ),
                ],
              ).height(Sizes.s100),
              const VSpace(Sizes.s12),
              const CommonSkeleton(
                  height: Sizes.s22, width: Sizes.s150, radius: 12),
              const VSpace(Sizes.s8),
              const CommonSkeleton(
                  height: Sizes.s22, width: Sizes.s115, radius: 12),
              const VSpace(Sizes.s8),
              const CommonSkeleton(
                  height: Sizes.s22, width: Sizes.s116, radius: 12),
              const VSpace(Sizes.s14),
              Image.asset(eImageAssets.bulletDotted)
                  .paddingSymmetric(vertical: Insets.i12),
              Stack(
                alignment: Alignment.center,
                children: [
                  const CommonSkeleton(height: Sizes.s42, radius: 10),
                  const Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CommonWhiteShimmer(
                                  height: Sizes.s17, width: Sizes.s78),
                              CommonWhiteShimmer(
                                  height: Sizes.s17, width: Sizes.s58)
                            ])
                      ]).paddingSymmetric(horizontal: Sizes.s15)
                ],
              ),
              const VSpace(Sizes.s20),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const CommonSkeleton(
                    height: Sizes.s22, width: Sizes.s85, radius: 12),
                const VSpace(Sizes.s11),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    const CommonSkeleton(height: Sizes.s62, radius: 10),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IntrinsicHeight(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CommonWhiteShimmer(
                                          height: Sizes.s17, width: Sizes.s66),
                                      const VSpace(Sizes.s5),
                                      CommonWhiteShimmer(
                                          height: Sizes.s17, width: Sizes.s105)
                                    ]),
                                VerticalDivider(
                                  color: appColor(context).appTheme.stroke,
                                ),
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CommonWhiteShimmer(
                                          height: Sizes.s17, width: Sizes.s66),
                                      const VSpace(Sizes.s5),
                                      CommonWhiteShimmer(
                                          height: Sizes.s17, width: Sizes.s105)
                                    ])
                              ],
                            ),
                          )
                        ]).paddingSymmetric(horizontal: Sizes.s15)
                  ],
                ),
                const VSpace(Sizes.s20),
                const CommonSkeleton(height: Sizes.s14, width: Sizes.s125),
                const VSpace(Sizes.s15),
                Row(
                  children: List.generate(
                      3,
                      (index) => const CommonSkeleton(
                              height: Sizes.s32, width: Sizes.s78)
                          .padding(right: Sizes.s10)),
                ),
                const VSpace(Sizes.s20),
                const CommonSkeleton(height: Sizes.s14, width: Sizes.s84),
                const VSpace(Sizes.s9),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    const CommonSkeleton(height: Sizes.s40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                          3,
                          (index) => IntrinsicHeight(
                                child: Row(
                                  children: [
                                    const CommonWhiteShimmer(
                                        height: Sizes.s17, width: Sizes.s66),
                                    if (index != 2)
                                      VerticalDivider().paddingSymmetric(
                                          horizontal: Sizes.s10)
                                  ],
                                ),
                              )),
                    ),
                  ],
                ),
                const VSpace(Sizes.s20),
                const CommonSkeleton(height: Sizes.s14, width: Sizes.s84),
                const VSpace(Sizes.s9),
                const CommonSkeleton(height: Sizes.s14),
                const VSpace(Sizes.s7),
                const CommonSkeleton(height: Sizes.s14),
                const VSpace(Sizes.s7),
                const CommonSkeleton(height: Sizes.s14, width: Sizes.s185)
              ]).width(MediaQuery.of(context).size.width)
            ]),
          ),
        ],
      ),
    );
  }
}
