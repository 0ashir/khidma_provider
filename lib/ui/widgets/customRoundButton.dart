import 'package:flutter/material.dart';

import '../../app/generalImports.dart';

class CustomRoundedButton extends StatelessWidget {
  const CustomRoundedButton({
    this.buttonTitle,
    this.buttonTitleWidget,
    required this.showBorder,
    required this.widthPercentage,
    required this.backgroundColor,
    final Key? key,
    this.child,
    this.maxLines,
    this.borderColor,
    this.elevation,
    this.onTap,
    this.radius,
    this.shadowColor,
    this.height,
    this.titleColor,
    this.fontWeight,
    this.textSize,
    this.width,
  }) : super(key: key);

  final Widget? buttonTitleWidget;
  final String? buttonTitle;
  final double? height;
  final double? width;
  final double widthPercentage;
  final Function? onTap;
  final Color backgroundColor;
  final double? radius;
  final Color? shadowColor;
  final bool showBorder;
  final Color? borderColor;
  final Color? titleColor;
  final double? textSize;
  final FontWeight? fontWeight;
  final double? elevation;
  final int? maxLines;
  final Widget? child;

  @override
  Widget build(final BuildContext context) => SizedBox(
    height: height ?? 48,
    width: width ?? MediaQuery.sizeOf(context).width * widthPercentage,
    child: Platform.isIOS
        ? CustomContainer(
            borderRadius: radius ?? UiUtils.borderRadiusOf10,
            color: showBorder
                ? borderColor ?? Theme.of(context).colorScheme.accentColor
                : Colors.transparent,
            child: CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              alignment: Alignment.center,
              onPressed: onTap as void Function()?,
              color: backgroundColor,
              borderRadius: BorderRadius.circular(
                radius ?? UiUtils.borderRadiusOf10,
              ),
              child: Center(
                child:
                    child ??
                    buttonTitleWidget ??
                    CustomText(
                      '$buttonTitle',
                      maxLines: maxLines ?? 2,
                      fontSize: textSize ?? 18.0,
                      color: titleColor ?? AppColors.whiteColors,
                      fontWeight: fontWeight ?? FontWeight.normal,
                    ),
              ),
            ),
          )
        : MaterialButton(
            height: height ?? 48.0,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            visualDensity: VisualDensity.standard,
            textColor: titleColor,
            focusElevation: 0.3,
            enableFeedback: true,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: showBorder
                    ? borderColor ?? Theme.of(context).colorScheme.accentColor
                    : Colors.transparent,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(radius ?? UiUtils.borderRadiusOf10),
              ),
            ),
            onPressed: onTap as void Function()?,
            elevation: elevation ?? 0.0,
            color: backgroundColor,
            child: Center(
              child:
                  child ??
                  buttonTitleWidget ??
                  CustomText(
                    '$buttonTitle',
                    maxLines: maxLines ?? 1,
                    fontSize: textSize ?? 18.0,
                    color: titleColor ?? AppColors.whiteColors,
                    fontWeight: fontWeight ?? FontWeight.normal,
                  ),
            ),
          ),
  );
}
