
import '../../../../config.dart';

class BlogDetailShimmer extends StatelessWidget {
  const BlogDetailShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDark(context) ? Colors.black : Colors.white,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.s20),
        children: [
          const VSpace(Sizes.s30),
          // const Row(children: [
          //   CommonSkeleton(height: Sizes.s40, width: Sizes.s40, isCircle: true),
          //   HSpace(Sizes.s48),
          //   CommonSkeleton(height: Sizes.s23, width: Sizes.s138, radius: 12)
          // ]),
          // const VSpace(Sizes.s25),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CommonSkeleton(height: Sizes.s142, radius: 6),
              const VSpace(Sizes.s20),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonSkeleton(height: Sizes.s15, width: Sizes.s65),
                            VSpace(Sizes.s10),
                            CommonSkeleton(
                                height: Sizes.s15, width: Sizes.s170),
                          ],
                        ),
                        CommonSkeleton(
                            height: Sizes.s32, width: Sizes.s106, radius: 4),
                      ]),
                  VSpace(Sizes.s18),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CommonSkeleton(height: Sizes.s10, width: Sizes.s85),
                        CommonSkeleton(height: Sizes.s10, width: Sizes.s35),
                      ]),
                  VSpace(Sizes.s11),
                  CommonSkeleton(height: Sizes.s11, width: Sizes.s92),
                  VSpace(Sizes.s20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonSkeleton(height: Sizes.s11, width: Sizes.s88),
                      CommonSkeleton(height: Sizes.s11, width: Sizes.s58),
                    ],
                  ),
                  VSpace(Sizes.s14),
                  DottedLines(),
                  VSpace(Sizes.s20),
                  CommonSkeleton(height: Sizes.s11, width: Sizes.s88),
                  VSpace(Sizes.s20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonSkeleton(height: Sizes.s15, width: Sizes.s65),
                      VSpace(Sizes.s10),
                      CommonSkeleton(height: Sizes.s15, width: Sizes.s185),
                      VSpace(Sizes.s8),
                      CommonSkeleton(height: Sizes.s15, width: Sizes.s185),
                      VSpace(Sizes.s8),
                      CommonSkeleton(height: Sizes.s15, width: Sizes.s185),
                      CommonSkeleton(height: Sizes.s15, width: Sizes.s65),
                      VSpace(Sizes.s10),
                      CommonSkeleton(height: Sizes.s15, width: Sizes.s185),
                      VSpace(Sizes.s8),
                      CommonSkeleton(height: Sizes.s15, width: Sizes.s185),
                      VSpace(Sizes.s8),
                      CommonSkeleton(height: Sizes.s15, width: Sizes.s185),
                      CommonSkeleton(height: Sizes.s15, width: Sizes.s65),
                      VSpace(Sizes.s10),
                      CommonSkeleton(height: Sizes.s15, width: Sizes.s185),
                      VSpace(Sizes.s8),
                      CommonSkeleton(height: Sizes.s15, width: Sizes.s185),
                      VSpace(Sizes.s8),
                      CommonSkeleton(height: Sizes.s15, width: Sizes.s185),
                    ],
                  ),
                  VSpace(Sizes.s20),
                ],
              ).paddingSymmetric(horizontal: Sizes.s20),
            ],
          ).boxBorderExtension(context,
              color: isDark(context) ? Colors.black : Colors.white,
              bColor: appColor(context).appTheme.stroke,
              isShadow: true)
        ],
      ).width(MediaQuery.of(context).size.width),
    );
  }
}
