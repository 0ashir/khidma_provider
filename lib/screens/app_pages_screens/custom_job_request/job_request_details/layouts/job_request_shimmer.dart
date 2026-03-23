import 'package:fixit_provider/config.dart';

class JobRequestShimmer extends StatelessWidget {
  const JobRequestShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDark(context) ? Colors.black : Colors.white,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ListView(children: [
            const CommonSkeleton(
                height: Sizes.s230,
                isAllRadius: true,
                bLRadius: 20,
                bRRadius: 20),
            const VSpace(Sizes.s12),
            const VSpace(Sizes.s18),
            Stack(alignment: Alignment.center, children: [
              const CommonSkeleton(height: Sizes.s53, radius: 10),
              const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CommonWhiteShimmer(height: Sizes.s16, width: Sizes.s50),
                    CommonWhiteShimmer(height: Sizes.s23, width: Sizes.s58)
                  ]).paddingSymmetric(horizontal: Sizes.s14)
            ]).padding(horizontal: Sizes.s20, bottom: Sizes.s20),
            Container(
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
                              color: appColor(context)
                                  .appTheme
                                  .darkText
                                  .withOpacity(0.06),
                              blurRadius: 12,
                              spreadRadius: 0,
                              offset: const Offset(0, 2))
                        ],
                  shape: SmoothRectangleBorder(
                      side: BorderSide(
                          color: appColor(context).appTheme.fieldCardBg),
                      borderRadius: SmoothBorderRadius(
                          cornerRadius: Sizes.s12, cornerSmoothing: 1))),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        children: List.generate(2, (index) {
                      return const Expanded(
                          child: Row(children: [
                        CommonSkeleton(
                            height: Sizes.s20, width: Sizes.s20, radius: 0),
                        HSpace(Sizes.s18),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonSkeleton(
                                  height: Sizes.s12, width: Sizes.s42),
                              VSpace(Sizes.s8),
                              CommonSkeleton(
                                  height: Sizes.s12, width: Sizes.s69)
                            ])
                      ]));
                    }).toList()),
                    const VSpace(Sizes.s35),
                    const Row(children: [
                      CommonSkeleton(
                          height: Sizes.s20, width: Sizes.s20, radius: 0),
                      HSpace(Sizes.s18),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonSkeleton(
                                height: Sizes.s12, width: Sizes.s140),
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
                        const CommonSkeleton(height: Sizes.s100, radius: 10),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonWhiteShimmer(
                                height: Sizes.s14, width: Sizes.s82),
                            VSpace(Sizes.s12),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                ]),
                            VSpace(Sizes.s7),
                          ],
                        ).paddingSymmetric(
                            horizontal: Sizes.s12, vertical: Sizes.s15)
                      ],
                    ),
                  ]),
            ),
          ]),
          const Stack(alignment: Alignment.center, children: [
            CommonSkeleton(height: Sizes.s50),
            CommonWhiteShimmer(height: Sizes.s15, width: Sizes.s88)
          ])
              .marginSymmetric(horizontal: Sizes.s15)
              .paddingOnly(bottom: Sizes.s15)
              .backgroundColor(isDark(context)
                  ? Colors.black
                  : appColor(context).appTheme.whiteColor)
        ],
      ),
    );
  }
}
