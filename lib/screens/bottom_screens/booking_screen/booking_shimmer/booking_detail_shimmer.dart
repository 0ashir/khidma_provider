import 'package:flutter/material.dart';

import '../../../../config.dart';

class BookingDetailShimmer extends StatelessWidget {
  const BookingDetailShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDark(context) ? Colors.black : Colors.white,
      body: ListView(
        padding: EdgeInsets.only(
            left: Sizes.s20, right: Sizes.s20, bottom: Sizes.s50),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const CommonSkeleton(height: Sizes.s142, radius: 10),
              // const VSpace(Sizes.s20),
              // const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              //   CommonSkeleton(height: Sizes.s15, width: Sizes.s65),
              //   CommonSkeleton(height: Sizes.s32, width: Sizes.s106, radius: 4),
              // ]),
              // const VSpace(Sizes.s18),
              // const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              //   CommonSkeleton(height: Sizes.s15, width: Sizes.s185),
              //   CommonSkeleton(height: Sizes.s15, width: Sizes.s35),
              // ]),
              // const VSpace(Sizes.s11),
              const CommonSkeleton(height: Sizes.s11, width: Sizes.s92),
              /*  const VSpace(Sizes.s20), */
              const Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            CommonSkeleton(
                                height: Sizes.s20, width: Sizes.s20, radius: 0),
                            HSpace(Sizes.s18),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CommonSkeleton(
                                    height: Sizes.s11, width: Sizes.s76),
                                VSpace(Sizes.s8),
                                CommonSkeleton(
                                    height: Sizes.s9, width: Sizes.s25)
                              ],
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            CommonSkeleton(
                                height: Sizes.s20, width: Sizes.s20, radius: 0),
                            HSpace(Sizes.s18),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CommonSkeleton(
                                    height: Sizes.s11, width: Sizes.s76),
                                VSpace(Sizes.s8),
                                CommonSkeleton(
                                    height: Sizes.s9, width: Sizes.s25)
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  VSpace(Sizes.s38),
                  // Row(
                  //   children: [
                  //     CommonSkeleton(
                  //         height: Sizes.s20, width: Sizes.s20, radius: 0),
                  //     HSpace(Sizes.s18),
                  //     Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         CommonSkeleton(height: Sizes.s11, width: Sizes.s210),
                  //         VSpace(Sizes.s8),
                  //         CommonSkeleton(height: Sizes.s9, width: Sizes.s25)
                  //       ],
                  //     )
                  //   ],
                  // )
                ],
              )
                  .paddingSymmetric(horizontal: Sizes.s10, vertical: Sizes.s15)
                  .boxBorderExtension(context,
                      color: isDark(context) ? Colors.black : Colors.white,
                      isShadow: false,
                      bColor: isDark(context)
                          ? Colors.black26
                          : appColor(context).appTheme.skeletonColor),
              const VSpace(Sizes.s17),
              const CommonSkeleton(height: Sizes.s11, width: Sizes.s58),
              const VSpace(Sizes.s14),
              const CommonSkeleton(height: Sizes.s11, width: Sizes.s280),
              const VSpace(Sizes.s10),
              const CommonSkeleton(height: Sizes.s11, width: Sizes.s270),
              const VSpace(Sizes.s10),
              const CommonSkeleton(height: Sizes.s11, width: Sizes.s190),
              const VSpace(Sizes.s20),
              Stack(
                alignment: Alignment.centerLeft,
                children: [
                  const CommonSkeleton(height: Sizes.s46),
                  const Row(children: [
                    CommonWhiteShimmer(height: Sizes.s13, width: Sizes.s38),
                    HSpace(Sizes.s4),
                    CommonWhiteShimmer(height: Sizes.s13, width: Sizes.s180)
                  ]).paddingSymmetric(horizontal: Sizes.s12)
                ],
              ),
              const VSpace(Sizes.s10),
              ...List.generate(
                  2,
                  (index) => Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          const CommonSkeleton(height: Sizes.s115),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CommonWhiteShimmer(
                                        height: Sizes.s13, width: Sizes.s86),
                                    CommonWhiteShimmer(
                                        height: Sizes.s13, width: Sizes.s44)
                                  ]),
                              VSpace(Sizes.s32),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(children: [
                                      CommonWhiteShimmer(
                                          height: Sizes.s38,
                                          width: Sizes.s38,
                                          isCircle: true),
                                      HSpace(Sizes.s13),
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CommonWhiteShimmer(
                                                height: Sizes.s11,
                                                width: Sizes.s68),
                                            VSpace(Sizes.s10),
                                            CommonWhiteShimmer(
                                                height: Sizes.s11,
                                                width: Sizes.s116)
                                          ])
                                    ]),
                                    CommonWhiteShimmer(
                                        height: Sizes.s11, width: Sizes.s60)
                                  ])
                            ],
                          ).paddingSymmetric(horizontal: Sizes.s12)
                        ],
                      ).marginOnly(bottom: index == 0 ? Sizes.s15 : 0)),
              const VSpace(Sizes.s28),
              const CommonSkeleton(height: Sizes.s11, width: Sizes.s82),
              const VSpace(Sizes.s14),
              // Stack(
              //   children: [
              //     Container(
              //       padding: const EdgeInsets.all(Sizes.s20),
              //       width: MediaQuery.of(context).size.width,
              //       decoration: BoxDecoration(color: isDark(context)?Colors.black:Colors.white,
              //           image: DecorationImage(
              //               image: AssetImage( eImageAssets.shimmerBg),
              //               fit: BoxFit.fill)),
              //       child: Column(
              //         children: [
              //           const Row(
              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //             children: [
              //               CommonWhiteShimmer(height: Sizes.s13,width: Sizes.s105),
              //               CommonWhiteShimmer(height: Sizes.s13,width: Sizes.s47),
              //             ],
              //           ).paddingOnly(bottom: Sizes.s24),
              //           const Row(
              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //             children: [
              //               CommonWhiteShimmer(height: Sizes.s13,width: Sizes.s165),
              //               CommonWhiteShimmer(height: Sizes.s13,width: Sizes.s52),
              //             ],
              //           ).paddingOnly(bottom: Sizes.s24),
              //           const Row(
              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //             children: [
              //               CommonWhiteShimmer(height: Sizes.s13,width: Sizes.s28),
              //               CommonWhiteShimmer(height: Sizes.s13,width: Sizes.s52),
              //             ],
              //           ).paddingOnly(bottom: Sizes.s24),
              //           const Row(
              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //             children: [
              //               CommonWhiteShimmer(height: Sizes.s13,width: Sizes.s105),
              //               CommonWhiteShimmer(height: Sizes.s13,width: Sizes.s47),
              //             ],
              //           ).paddingOnly(bottom: Sizes.s24),
              //           const VSpace(Sizes.s24),
              //           const Row(
              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //             children: [
              //               CommonWhiteShimmer(height: Sizes.s13,width: Sizes.s105),
              //               CommonWhiteShimmer(height: Sizes.s13,width: Sizes.s47),
              //             ],
              //           )
              //         ],
              //       ),
              //     )
              //   ],
              // )
            ],
          ).paddingAll(Sizes.s15).boxBorderExtension(context,
              color: isDark(context) ? Colors.black : Colors.white,
              bColor: appColor(context).appTheme.stroke,
              isShadow: true)
        ],
      ),
    );
  }
}
