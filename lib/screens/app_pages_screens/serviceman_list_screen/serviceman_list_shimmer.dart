import 'package:fixit_provider/config.dart';

class ServicemanListShimmer extends StatelessWidget {
  const ServicemanListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDark(context) ? Colors.black : Colors.white,
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: Sizes.s20),
        children: [
          // const VSpace(Sizes.s20),
          // const Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //   CommonSkeleton(height: Sizes.s40, width: Sizes.s40, isCircle: true),
          //
          //   CommonSkeleton(height: Sizes.s23, width: Sizes.s138, radius: 12),
          //       CommonSkeleton(height: Sizes.s40, width: Sizes.s40, isCircle: true),
          // ]),
          // const VSpace(Sizes.s25),
          // const CommonSkeleton(
          //     height: Sizes.s48,
          //     radius: 20
          // ),
          const VSpace(Sizes.s20),
          GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: 4,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 230,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15),
              itemBuilder: (context, index) {
                return Container(
                    width: Sizes.s257,
                    padding: const EdgeInsets.all(Sizes.s12),
                    decoration: ShapeDecoration(
                        color: isDark(context)
                            ? Colors.black26
                            : appColor(context).appTheme.whiteBg,
                        shape: SmoothRectangleBorder(
                            borderRadius: SmoothBorderRadius(
                                cornerRadius: 8, cornerSmoothing: 1),
                            side: BorderSide(
                                color: isDark(context)
                                    ? Colors.black26
                                    : appColor(context)
                                        .appTheme
                                        .skeletonColor))),
                    child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonSkeleton(height: Sizes.s106, radius: 6),
                          VSpace(Sizes.s14),
                          CommonSkeleton(height: Sizes.s10, width: Sizes.s76),
                          VSpace(Sizes.s9),
                          CommonSkeleton(height: Sizes.s10, width: Sizes.s98),
                          VSpace(Sizes.s14),
                          CommonSkeleton(height: Sizes.s36, radius: 8),
                        ]));
              })
        ],
      ),
    );
  }
}
