import 'package:fixit_provider/config.dart';

import '../../../../common_shimmer/service_shimmer.dart';

class ServiceShimmer extends StatelessWidget {
  const ServiceShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /*   const VSpace(Sizes.s200), */
        /* Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(children: [
                CommonSkeleton(height: Sizes.s40, width: Sizes.s40, isCircle: true),
                HSpace(Sizes.s48),
                CommonSkeleton(height: Sizes.s23, width: Sizes.s138, radius: 12)
              ]),
              Row(
                children: [
                  CommonSkeleton(height: Sizes.s40, width: Sizes.s40, isCircle: true),
                  const HSpace(Sizes.s10),
                  CommonSkeleton(height: Sizes.s40, width: Sizes.s40, isCircle: true)
                ],
              )
            ],
          ).padding(horizontal: Sizes.s20), */
        /*  const VSpace(Sizes.s25), */
        /* Stack(
              alignment: Alignment.centerLeft,
              children: [
                CommonSkeleton(height: Sizes.s148, radius: 0),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const VSpace(Sizes.s15),
                    const CommonWhiteShimmer(
                            height: Sizes.s16, width: Sizes.s96)
                        .alignment(Alignment.centerLeft),
                    const VSpace(Sizes.s20),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(8, (index) {
                          return const Column(children: [
                            CommonWhiteShimmer(
                                height: Sizes.s60,
                                width: Sizes.s60,
                                radius: 10),
                            VSpace(Sizes.s11),
                            CommonWhiteShimmer(
                                height: Sizes.s13, width: Sizes.s60, radius: 10)
                          ]).padding(
                              bottom: Sizes.s22,
                              left: rtl(context) ? Sizes.s15 : 0,
                              right: rtl(context) ? 0 : Sizes.s15);
                        }),
                      ),
                    ),
                  ],
                ).paddingSymmetric(horizontal: Sizes.s20)
              ],

            ), */
        /*  const VSpace(Sizes.s28), */
        /* Row(
          children: List.generate(
              3,
              (index) => Column(
                    children: [
                      CommonSkeleton(height: Sizes.s17, width: Sizes.s75),
                      const VSpace(Sizes.s7),
                      if (index == 0)
                        CommonSkeleton(height: Sizes.s2, width: Sizes.s88),
                    ],
                  ).padding(right: Sizes.s24)).toList(),
        ).paddingSymmetric(horizontal: Sizes.s20), */
        /*  CommonSkeleton(height: Sizes.s2, radius: 0), */
        const VSpace(Sizes.s15),
        const ServicesShimmer(count: 3).padding(horizontal: Sizes.s20),
      ],
    ).width(MediaQuery.of(context).size.width);
    /* Scaffold(
        backgroundColor: isDark(context) ? Colors.black : Colors.white,
        body: Column(
          children: [
            /*   const VSpace(Sizes.s200), */
            /* Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(children: [
                CommonSkeleton(height: Sizes.s40, width: Sizes.s40, isCircle: true),
                HSpace(Sizes.s48),
                CommonSkeleton(height: Sizes.s23, width: Sizes.s138, radius: 12)
              ]),
              Row(
                children: [
                  CommonSkeleton(height: Sizes.s40, width: Sizes.s40, isCircle: true),
                  const HSpace(Sizes.s10),
                  CommonSkeleton(height: Sizes.s40, width: Sizes.s40, isCircle: true)
                ],
              )
            ],
          ).padding(horizontal: Sizes.s20), */
            /*  const VSpace(Sizes.s25), */
            /* Stack(
              alignment: Alignment.centerLeft,
              children: [
                CommonSkeleton(height: Sizes.s148, radius: 0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const VSpace(Sizes.s15),
                    const CommonWhiteShimmer(
                            height: Sizes.s16, width: Sizes.s96)
                        .alignment(Alignment.centerLeft),
                    const VSpace(Sizes.s20),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(8, (index) {
                          return const Column(children: [
                            CommonWhiteShimmer(
                                height: Sizes.s60,
                                width: Sizes.s60,
                                radius: 10),
                            VSpace(Sizes.s11),
                            CommonWhiteShimmer(
                                height: Sizes.s13, width: Sizes.s60, radius: 10)
                          ]).padding(
                              bottom: Sizes.s22,
                              left: rtl(context) ? Sizes.s15 : 0,
                              right: rtl(context) ? 0 : Sizes.s15);
                        }),
                      ),
                    ),
                  ],
                ).paddingSymmetric(horizontal: Sizes.s20)
              ],
            ), */
            const VSpace(Sizes.s28),
            /*  Row(
              children: List.generate(
                  3,
                  (index) => Column(
                        children: [
                          CommonSkeleton(height: Sizes.s17, width: Sizes.s75),
                          const VSpace(Sizes.s7),
                          if (index == 0)
                            CommonSkeleton(height: Sizes.s2, width: Sizes.s88),
                        ],
                      ).padding(right: Sizes.s24)).toList(),
            ).paddingSymmetric(horizontal: Sizes.s20), */
            /*     CommonSkeleton(height: Sizes.s2, radius: 0), */
            const VSpace(Sizes.s15),
            /*  const ServicesShimmer(count: 3).padding(horizontal: Sizes.s20), */
          ],
        ).width(MediaQuery.of(context).size.width)); */
  }
}
