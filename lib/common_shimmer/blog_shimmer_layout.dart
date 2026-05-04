import '../config.dart';

class BlogShimmerLayout extends StatelessWidget {
  const BlogShimmerLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: Sizes.s257,
        margin: const EdgeInsets.only(right: Insets.i15),
        decoration: ShapeDecoration(
            color: isDark(context) ?Colors.black26: appColor(context).appTheme.whiteBg,
            shape: SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius(
                    cornerRadius: 8, cornerSmoothing: 1),
                side: BorderSide(
                    color: isDark(context) ? Colors.black26: appColor(context).appTheme.skeletonColor))),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CommonSkeleton(
                  width: Sizes.s257,
                  height: Sizes.s155,
                  isAllRadius: true,
                  tLRadius: 8,
                  tRRadius: 8,
                  bLRadius: 1,
                  bRRadius: 0),
              const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    VSpace(Sizes.s14),
                    CommonSkeleton(
                        height: Sizes.s18, width: Sizes.s200),
                    VSpace(Sizes.s7),
                    CommonSkeleton(
                        height: Sizes.s18, width: Sizes.s155),
                    VSpace(Sizes.s11),
                    Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          CommonSkeleton(
                              height: Sizes.s18,
                              width: Sizes.s40,
                              radius: 9),
                          CommonSkeleton(
                              height: Sizes.s18, width: Sizes.s38)
                        ]),
                    VSpace(Sizes.s11)
                  ]).paddingSymmetric(horizontal: Sizes.s12)
            ]));
  }
}
