import '../config.dart';

class GridShimmer extends StatelessWidget {
  const GridShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      children: List.generate(8, (index) {
        return const Column(children: [
          CommonSkeleton(height: Sizes.s60, width: Sizes.s60, radius: 10),
          VSpace(Sizes.s11),
          CommonSkeleton(height: Sizes.s13, width: Sizes.s60, radius: 10)
        ]).padding(horizontal: Sizes.s14, bottom: Sizes.s22);
      }),
    ).width(MediaQuery.of(context).size.width).paddingOnly(
        left: rtl(context) ? 0 : Insets.i12,
        right: rtl(context) ? Insets.i12 : 0);
  }
}
