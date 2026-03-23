import '../../../../config.dart';

class RatingLayout extends StatelessWidget {
  final double? initialRating;
  final Color? color;
  const RatingLayout({super.key,this.initialRating,this.color});

  @override
  Widget build(BuildContext context) {
    return  RatingBar(
        initialRating: initialRating ?? 4.5,
        direction: Axis.horizontal,
        allowHalfRating: true,
        itemCount: 5,
        maxRating: 5,
        itemSize: Sizes.s16,
        ignoreGestures: true,
        ratingWidget: RatingWidget(
            full: SvgPicture.asset(eSvgAssets.star,
                height: Sizes.s16,
                colorFilter: ColorFilter.mode( color ??
                    appColor(context).appTheme.primary,
                    BlendMode.srcIn)),
            half: SvgPicture.asset(eSvgAssets.halfStar,
                height: Sizes.s16,
                colorFilter: ColorFilter.mode(color ??
                    appColor(context).appTheme.primary,
                    BlendMode.srcIn)),
            empty: SvgPicture.asset(eSvgAssets.starOut,
                height: Sizes.s16,
                colorFilter: ColorFilter.mode(color ??
                    appColor(context).appTheme.primary,
                    BlendMode.srcIn))),
        onRatingUpdate: (double value) {});
  }
}
