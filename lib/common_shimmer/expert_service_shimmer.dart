import '../config.dart';

class ExpertServiceShimmer extends StatelessWidget {
  final int count;
  const ExpertServiceShimmer({super.key, this.count = 2});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...List.generate(count, (index) {
          return Container(
              margin: const EdgeInsets.symmetric(horizontal: Sizes.s20),
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
                              spreadRadius: 2,
                              blurRadius: 12)
                        ],
                  shape: SmoothRectangleBorder(
                      borderRadius: SmoothBorderRadius(
                          cornerRadius: 8, cornerSmoothing: 1),
                      side: BorderSide(
                          color: isDark(context)
                              ? Colors.black26
                              : appColor(context).appTheme.skeletonColor))),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(children: [
                      CommonSkeleton(
                          height: Sizes.s72, width: Sizes.s72, radius: 8),
                      HSpace(Sizes.s15),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonSkeleton(
                                height: Sizes.s15, width: Sizes.s115),
                            VSpace(Sizes.s6),
                            CommonSkeleton(height: Sizes.s15, width: Sizes.s90),
                            VSpace(Sizes.s10),
                            CommonSkeleton(height: Sizes.s15, width: Sizes.s110)
                          ])
                    ]).paddingAll(Sizes.s15),
                    const CommonSkeleton(height: Sizes.s16, width: Sizes.s36)
                        .paddingAll(Sizes.s15)
                  ])).marginOnly(bottom: index != 2 ? Sizes.s15 : 0);
        })
      ],
    );
  }
}
