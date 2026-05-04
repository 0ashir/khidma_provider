

import '../../../../config.dart';

class BookingShimmer extends StatelessWidget {
  const BookingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDark(context)?Colors.black:Colors.white,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.s20),
        children: [
          const VSpace(Sizes.s50),
          const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommonSkeleton(
                    height: Sizes.s23, width: Sizes.s138, radius: 12),
                CommonSkeleton(
                    height: Sizes.s40, width: Sizes.s40, isCircle: true)
              ]),
          const VSpace(Sizes.s34),
          const CommonSkeleton(height: Sizes.s46, radius: 25),
          const VSpace(Sizes.s25),
          const CommonSkeleton(height: Sizes.s16, width: Sizes.s96)
              .alignment(Alignment.topLeft),
          const VSpace(Sizes.s22),
          ...List.generate(
              5,
              (index) => Column(children: [
                    const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  CommonSkeleton(
                                      height: Sizes.s14, width: Sizes.s50),
                                  HSpace(Sizes.s5),
                                  CommonSkeleton(
                                      height: Sizes.s22,
                                      width: Sizes.s68,
                                      radius: 12)
                                ]),
                                VSpace(Sizes.s8),
                                CommonSkeleton(
                                    height: Sizes.s14, width: Sizes.s124),
                                VSpace(Sizes.s11),
                                CommonSkeleton(
                                    height: Sizes.s14, width: Sizes.s124)
                              ]),
                          CommonSkeleton(
                              height: Sizes.s84, width: Sizes.s84, radius: 10)
                        ]),
                    const VSpace(Sizes.s15),
                    const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonSkeleton(height: Sizes.s14, width: Sizes.s40),
                          CommonSkeleton(
                              height: Sizes.s22, width: Sizes.s66, radius: 12),
                        ]),
                    const VSpace(Sizes.s14),
                    const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonSkeleton(height: Sizes.s14, width: Sizes.s116),
                          CommonSkeleton(height: Sizes.s14, width: Sizes.s76),
                        ]),
                    const VSpace(Sizes.s15),
                    const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonSkeleton(height: Sizes.s14, width: Sizes.s106),
                          CommonSkeleton(height: Sizes.s14, width: Sizes.s76)
                        ]),
                    const VSpace(Sizes.s15),
                    const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonSkeleton(height: Sizes.s14, width: Sizes.s106),
                          CommonSkeleton(height: Sizes.s14, width: Sizes.s76)
                        ]),
                    const VSpace(Sizes.s12),
                    const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonSkeleton(height: Sizes.s14, width: Sizes.s106),
                          CommonSkeleton(height: Sizes.s14, width: Sizes.s106)
                        ]),
                    const VSpace(Sizes.s17),
                    Stack(alignment: Alignment.center, children: [
                      const CommonSkeleton(height: Sizes.s68, radius: 8),
                      const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              CommonWhiteShimmer(
                                  height: Sizes.s36,
                                  width: Sizes.s36,
                                  isCircle: true),
                              HSpace(Sizes.s9),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CommonWhiteShimmer(
                                        height: Sizes.s10, width: Sizes.s55),
                                    VSpace(Sizes.s5),
                                    CommonWhiteShimmer(
                                        height: Sizes.s12, width: Sizes.s78)
                                  ])
                            ]),
                            CommonWhiteShimmer(
                                height: Sizes.s12, width: Sizes.s30)
                          ]).paddingSymmetric(horizontal: Sizes.s12)
                    ])
                  ])
                      .padding(
                          horizontal: Sizes.s15,
                          top: Sizes.s23,
                          bottom: Sizes.s15)
                      .boxBorderExtension(context,
                          color: isDark(context)?Colors.black26:appColor(context).appTheme.whiteColor,
                          bColor:isDark(context)?Colors.grey.withOpacity(.2): appColor(context).appTheme.stroke)
                      .paddingOnly(bottom: Sizes.s15)),
          const VSpace(Sizes.s120),
        ],
      ),
    );
  }
}
