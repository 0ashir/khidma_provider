import '../config.dart';

class ArrowRightCommon extends StatelessWidget {
  final GestureTapCallback? onTap;
  const ArrowRightCommon({super.key,this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: Sizes.s18,
        width: Sizes.s18,
        child: SvgPicture.asset(eSvgAssets.anchorArrowRight,
            colorFilter: ColorFilter.mode(
                appColor(context).appTheme.primary, BlendMode.srcIn))).inkWell(onTap: onTap);
  }
}
