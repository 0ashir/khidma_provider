import '../config.dart';

class PackageShimmer extends StatelessWidget {
  final bool isFullWidth;
  const PackageShimmer({super.key, this.isFullWidth = false});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      CommonSkeleton(
          height: Sizes.s142,
          width: isFullWidth ? MediaQuery.of(context).size.width : Sizes.s120),
      const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        CommonWhiteShimmer(height: Sizes.s32, width: Sizes.s32, radius: 6),
        VSpace(Sizes.s14),
        CommonWhiteShimmer(height: Sizes.s14, width: Sizes.s90),
        VSpace(Sizes.s7),
        CommonWhiteShimmer(height: Sizes.s15, width: Sizes.s62),
        VSpace(Sizes.s15),
        CommonWhiteShimmer(height: Sizes.s15, width: Sizes.s65),
      ]).marginSymmetric(horizontal: Sizes.s10, vertical: Sizes.s15)
    ]).marginSymmetric(horizontal: Sizes.s10);
  }
}
