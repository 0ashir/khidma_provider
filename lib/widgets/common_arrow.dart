import '../config.dart';

class CommonArrow extends StatelessWidget {
  final String? arrow;
  final bool? isThirteen;
  final Color? color, svgColor;
  final GestureTapCallback? onTap;

  const CommonArrow(
      {super.key,
      this.arrow,
      this.color,
      this.svgColor,
      this.onTap,
      this.isThirteen = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: isThirteen == true ? Sizes.s30 : Sizes.s40,
      width: isThirteen == true ? Sizes.s30 : Sizes.s40,
      child: SvgPicture.asset(
        arrow!,
        fit: BoxFit.scaleDown,
        colorFilter: ColorFilter.mode(
            svgColor ?? appColor(context).appTheme.darkText, BlendMode.srcIn),
      ),
    )
        .decorated(
            shape: BoxShape.circle,
            color: color ?? appColor(context).appTheme.fieldCardBg)
        .inkWell(onTap: onTap);
  }
}
