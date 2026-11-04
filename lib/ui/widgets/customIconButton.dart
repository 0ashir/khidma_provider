import 'package:flutter/material.dart';

import '../../app/generalImports.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key,
    required this.imgName,
    required this.titleText,
    required this.fontSize,
    required this.titleColor,
    required this.bgColor,
    this.fontWeight = FontWeight.w200,
    this.borderColor,
    this.borderRadius = UiUtils.borderRadiusOf10,
    this.textDirection = TextDirection.ltr, // this one is not used anymore
    this.onPressed,
    this.iconColor,
  });
  final String imgName;
  final String titleText;
  final double fontSize;
  final FontWeight fontWeight;
  final Color titleColor;
  final Color bgColor;
  final Color? borderColor;
  final double borderRadius;
  final TextDirection textDirection;
  final VoidCallback? onPressed;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ButtonStyle(
        elevation: WidgetStateProperty.all(0),
        padding: WidgetStateProperty.all(
          const EdgeInsetsDirectional.only(start: 2, end: 2),
        ),
        shape: WidgetStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            side: BorderSide(color: borderColor ?? bgColor),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        backgroundColor: WidgetStateProperty.all(bgColor),
      ),
      icon: CustomText(
        titleText,
        color: titleColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
      label: CustomSvgPicture(
        svgImage: imgName,
        color: iconColor ?? Theme.of(context).colorScheme.primaryColor,
      ),
    );
  }
}
