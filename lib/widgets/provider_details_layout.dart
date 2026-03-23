import '../../../../config.dart';

class ProviderDetailLayout extends StatelessWidget {
  final String? name, image, rate, star;
  final GestureTapCallback? onTapMore;
  const ProviderDetailLayout(
      {super.key, this.image, this.rate, this.name, this.star, this.onTapMore});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(language(context, translations!.providerDetails),
            style: appCss.dmDenseMedium12
                .textColor(appColor(context).appTheme.lightText)),
        Row(children: [
          Text(language(context, translations!.view),
              style: appCss.dmDenseMedium12
                  .textColor(appColor(context).appTheme.primary)),
          const HSpace(Sizes.s4),
          SvgPicture.asset(eSvgAssets.anchorArrowRight,
              colorFilter: ColorFilter.mode(
                  appColor(context).appTheme.primary, BlendMode.srcIn))
        ]).inkWell(onTap: onTapMore)
      ]).paddingSymmetric(horizontal: Insets.i15),
      Divider(height: 1, color: appColor(context).appTheme.stroke)
          .paddingSymmetric(vertical: Insets.i15),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(children: [
          Container(
              height: Sizes.s40,
              width: Sizes.s40,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      fit: BoxFit.cover, image: AssetImage(image!)))),
          const HSpace(Sizes.s12),
          Text(name!,
              style: appCss.dmDenseMedium14
                  .textColor(appColor(context).appTheme.darkText))
        ]),
        Row(children: [
          SvgPicture.asset(star!),
          const HSpace(Sizes.s4),
          Text(rate!,
              style: appCss.dmDenseMedium12
                  .textColor(appColor(context).appTheme.darkText))
        ])
      ]).paddingSymmetric(horizontal: Insets.i15)
    ]).paddingSymmetric(vertical: Insets.i15).boxShapeExtension(
        color: appColor(context).appTheme.fieldCardBg, radius: AppRadius.r10);
  }
}
