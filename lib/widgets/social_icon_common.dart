import '../config.dart';

class SocialIconCommon extends StatelessWidget {
  final String? icon;
  final GestureTapCallback? onTap;
  const SocialIconCommon({super.key,this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: ShapeDecoration(
            shape: SmoothRectangleBorder(
                side: BorderSide(
                    color: appColor(context).appTheme.primary),
                borderRadius: const SmoothBorderRadius.all(
                    SmoothRadius(
                        cornerRadius: AppRadius.r8,
                        cornerSmoothing: 1)))),
        child: SvgPicture.asset(icon!,
            height: Sizes.s16, width: Sizes.s16,colorFilter: ColorFilter.mode(appColor(context).appTheme.primary, BlendMode.srcIn))
            .paddingAll(Insets.i10)
            .decorated(
            color: appColor(context)
                .appTheme
                .primary
                .withOpacity(0.15))).inkWell(onTap: onTap);
  }

}
