import '../../config.dart';

class ButtonCommon extends StatelessWidget {
  final String? title;
  final double? padding, margin, radius, height, fontSize, width;
  final GestureTapCallback? onTap;
  final TextStyle? style;
  final Color? color, fontColor, borderColor;
  final Widget? icon;
  final Widget? widget;
  final FontWeight? fontWeight;
  final bool isLoading;

  const ButtonCommon({
    super.key,
    required this.title,
    this.padding,
    this.margin = 0,
    this.radius = AppRadius.r8,
    this.height = 50,
    this.fontSize = FontSizes.f30,
    this.onTap,
    this.style,
    this.color,
    this.fontColor,
    this.icon,
    this.borderColor,
    this.width,
    this.fontWeight = FontWeight.w700,
    this.widget,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
            width: width ?? MediaQuery.of(context).size.width,
            height: height,
            margin: EdgeInsets.symmetric(horizontal: margin!),
            decoration: ShapeDecoration(
                color: color ?? appColor(context).appTheme.primary,
                shape: SmoothRectangleBorder(
                    side: BorderSide(
                        color: borderColor ?? appColor(context).appTheme.trans),
                    borderRadius: SmoothBorderRadius(
                        cornerRadius: radius!, cornerSmoothing: 1))),
            child: isLoading
                ? Center(
                    child: SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          fontColor ?? appColor(context).appTheme.whiteColor,
                        ),
                      ),
                    ),
                  )
                : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Expanded(
                        child: Text(language(context, title ?? ''),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: style ??
                                appCss.dmDenseRegular16.textColor(
                                    appColor(context).appTheme.whiteColor))),
                    if (icon != null)
                      Row(children: [
                        icon ?? const HSpace(0),
                        const HSpace(Sizes.s10)
                      ]).paddingOnly(left: Insets.i8),
                    if (widget != null)
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            widget ?? const HSpace(0),
                            const HSpace(Sizes.s10)
                          ]).paddingOnly(left: Insets.i8),
                  ]))
        .inkWell(onTap: onTap);
  }
}
