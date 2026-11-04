import 'package:edemand_partner/ui/widgets/enumForWarningMEssage.dart';
import 'package:flutter/material.dart';

import '../../app/generalImports.dart';

class NoDataContainer extends StatelessWidget {
  const NoDataContainer({
    super.key,
    this.textColor,
    required this.title,
    this.imageTitle,
    this.subTitle,
    this.fontSize,
    this.fontWeight,
  });
  final Color? textColor;
  final String title;
  final String? subTitle;
  final String? imageTitle;
  final double? fontSize;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    final String imagePath = MessageType.getImageFromMessage(title);

    return CustomContainer(
      color: context.colorScheme.primaryColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: context.screenHeight * 0.025),
            SizedBox(
              height: context.screenHeight * 0.35,
              child: CustomSvgPicture(svgImage: imageTitle ?? imagePath),
            ),
            SizedBox(height: context.screenHeight * 0.025),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor ?? Theme.of(context).colorScheme.blackColor,
                  fontSize: fontSize ?? 16,
                  fontWeight: fontWeight,
                ),
              ),
            ),
            SizedBox(height: context.screenHeight * 0.015),
            subTitle != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      subTitle!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color:
                            textColor ??
                            Theme.of(
                              context,
                            ).colorScheme.blackColor.withValues(alpha: 0.5),
                        fontSize: 14,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
