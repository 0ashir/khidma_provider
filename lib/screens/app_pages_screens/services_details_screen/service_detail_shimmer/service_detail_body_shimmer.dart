import '../../../../config.dart';

class ServiceDetailBodyShimmer extends StatelessWidget {
  const ServiceDetailBodyShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: Sizes.s20),
      padding: const EdgeInsets.symmetric(
          horizontal: Sizes.s26, vertical: Sizes.s20),
      decoration: ShapeDecoration(
          color: isDark(context)
              ? Colors.black26
              : appColor(context).appTheme.whiteColor,
          shadows: isDark(context)
              ? []
              : [
                  BoxShadow(
                      color:
                          appColor(context).appTheme.darkText.withOpacity(0.06),
                      blurRadius: 12,
                      spreadRadius: 0,
                      offset: const Offset(0, 2))
                ],
          shape: SmoothRectangleBorder(
              side: BorderSide(color: appColor(context).appTheme.fieldCardBg),
              borderRadius: SmoothBorderRadius(
                  cornerRadius: Sizes.s12, cornerSmoothing: 1))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
            children: List.generate(2, (index) {
          return const Expanded(
              child: Row(children: [
            CommonSkeleton(height: Sizes.s20, width: Sizes.s20, radius: 0),
            HSpace(Sizes.s18),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              CommonSkeleton(height: Sizes.s12, width: Sizes.s42),
              VSpace(Sizes.s8),
              CommonSkeleton(height: Sizes.s12, width: Sizes.s69)
            ])
          ]));
        }).toList()),
        const VSpace(Sizes.s35),
        const Row(children: [
          CommonSkeleton(height: Sizes.s20, width: Sizes.s20, radius: 0),
          HSpace(Sizes.s18),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            CommonSkeleton(height: Sizes.s12, width: Sizes.s140),
            VSpace(Sizes.s8),
            CommonSkeleton(height: Sizes.s12, width: Sizes.s100)
          ])
        ]),
        const VSpace(Sizes.s22),
        const CommonSkeleton(height: Sizes.s14),
        const VSpace(Sizes.s8),
        const CommonSkeleton(height: Sizes.s14),
        const VSpace(Sizes.s8),
        const CommonSkeleton(height: Sizes.s14, width: Sizes.s198),
        const VSpace(Sizes.s24),
        Stack(
          alignment: Alignment.topCenter,
          children: [
            const CommonSkeleton(height: Sizes.s142, radius: 10),
            const Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CommonWhiteShimmer(height: Sizes.s14, width: Sizes.s82),
                    CommonWhiteShimmer(height: Sizes.s14, width: Sizes.s85),
                  ],
                ),
                VSpace(Sizes.s12),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CommonWhiteShimmer(
                              height: Sizes.s38,
                              width: Sizes.s38,
                              isCircle: true),
                          HSpace(Sizes.s12),
                          CommonWhiteShimmer(
                              height: Sizes.s14, width: Sizes.s57),
                        ],
                      ),
                      CommonWhiteShimmer(height: Sizes.s14, width: Sizes.s44)
                    ]),
                VSpace(Sizes.s7),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonWhiteShimmer(height: Sizes.s14, width: Sizes.s110),
                      CommonWhiteShimmer(height: Sizes.s14, width: Sizes.s128)
                    ]),
                VSpace(Sizes.s12),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonWhiteShimmer(height: Sizes.s14, width: Sizes.s135),
                      CommonWhiteShimmer(height: Sizes.s14, width: Sizes.s65)
                    ])
              ],
            ).paddingSymmetric(horizontal: Sizes.s12, vertical: Sizes.s15)
          ],
        ),
        const VSpace(Sizes.s22),
        const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          CommonSkeleton(height: Sizes.s18, width: Sizes.s138),
          CommonSkeleton(height: Sizes.s18, width: Sizes.s44)
        ]),
        const VSpace(Sizes.s12),
        ...List.generate(
            3,
            (index) => Container(
                  margin: EdgeInsets.only(bottom: index != 2 ? Insets.i15 : 0),
                  decoration: ShapeDecoration(
                      shape: SmoothRectangleBorder(
                          borderRadius: SmoothBorderRadius(
                              cornerRadius: 8, cornerSmoothing: 1),
                          side: BorderSide(
                              color: isDark(context)
                                  ? Colors.black26
                                  : appColor(context).appTheme.stroke))),
                  padding: const EdgeInsets.all(Sizes.s15),
                  child: const Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              CommonSkeleton(
                                  height: Sizes.s38,
                                  width: Sizes.s38,
                                  isCircle: true),
                              HSpace(Sizes.s12),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CommonSkeleton(
                                        height: Sizes.s14, width: Sizes.s135),
                                    VSpace(Sizes.s8),
                                    CommonSkeleton(
                                        height: Sizes.s14, width: Sizes.s76)
                                  ])
                            ]),
                            CommonSkeleton(height: Sizes.s14, width: Sizes.s30)
                          ]),
                      VSpace(Sizes.s16),
                      CommonSkeleton(height: Sizes.s14, width: Sizes.s224)
                    ],
                  ),
                ))
      ]),
    );
  }
}
