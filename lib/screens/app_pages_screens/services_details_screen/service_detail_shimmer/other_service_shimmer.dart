import '../../../../config.dart';

class OtherServiceShimmer extends StatelessWidget {
  const OtherServiceShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
              2,
                  (index) => Container(
                  margin: EdgeInsets.only(
                      right: rtl(context) ? 0 : Sizes.s15,
                      left: rtl(context) ? Sizes.s15 : 0),
                  padding: const EdgeInsets.all(Sizes.s12),
                  decoration: ShapeDecoration(
                      color:isDark(context) ?Colors.black26: appColor(context).appTheme.whiteColor,
                      shadows:isDark(context) ?[]: [
                        BoxShadow(
                            color: appColor(context).appTheme
                                .darkText
                                .withOpacity(0.06),
                            blurRadius: 4,
                            spreadRadius: 0,
                            offset: const Offset(0, 2))
                      ],
                      shape: SmoothRectangleBorder(
                          side: BorderSide(
                              color: appColor(context).appTheme.fieldCardBg),
                          borderRadius: SmoothBorderRadius(
                              cornerRadius: Sizes.s8,
                              cornerSmoothing: 1))),
                  child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonSkeleton(
                            width: Sizes.s198, height: Sizes.s106),
                        VSpace(Sizes.s12),
                        CommonSkeleton(
                            width: Sizes.s158, height: Sizes.s18),
                        VSpace(Sizes.s7),
                        CommonSkeleton(
                            width: Sizes.s116, height: Sizes.s18),
                        VSpace(Sizes.s9),
                        CommonSkeleton(
                            width: Sizes.s56, height: Sizes.s18)
                      ]))).toList(),
        ).paddingSymmetric(horizontal: Sizes.s20));
  }
}
