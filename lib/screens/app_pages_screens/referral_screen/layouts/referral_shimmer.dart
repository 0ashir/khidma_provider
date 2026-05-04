import '../../../../config.dart';

class ReferralShimmer extends StatelessWidget {
  const ReferralShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: Insets.i12),
      padding: const EdgeInsets.all(Insets.i12),
      decoration: BoxDecoration(
        color: appColor(context).appTheme.whiteBg,
        borderRadius: BorderRadius.circular(AppRadius.r10),
        border: Border.all(
          color: appColor(context).appTheme.fieldCardBg,
        ),
      ),
      child: const Row(
        children: [
          // Circular Profile Image Shimmer
          CommonSkeleton(
            height: Sizes.s45,
            width: Sizes.s45,
            isCircle: true,
          ),
          HSpace(Sizes.s12),

          // Name and Email Shimmer
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonSkeleton(
                  height: Sizes.s14,
                  width: Sizes.s100,
                ),
                VSpace(Sizes.s8),
                CommonSkeleton(
                  height: Sizes.s12,
                  width: Sizes.s150,
                ),
              ],
            ),
          ),

          // Status Badge Shimmer
          CommonSkeleton(
            height: Sizes.s24,
            width: Sizes.s60,
            radius: AppRadius.r20,
          ),
        ],
      ),
    );
  }
}
