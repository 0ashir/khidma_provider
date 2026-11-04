import 'package:flutter/material.dart';

import '../../app/generalImports.dart';

class SetDottedBorderWithHint extends StatelessWidget {
  const SetDottedBorderWithHint({
    super.key,
    required this.height,
    required this.width,
    required this.strPrefix,
    required this.str,
    required this.radius,
    this.customIconWidget,
    this.borderColor,
  });
  final double height;
  final double width;
  final String strPrefix;
  final String str;
  final double radius;
  final Color? borderColor;
  final Widget? customIconWidget;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        CustomContainer(
          height: height,
          width: width,
          borderRadius: UiUtils.borderRadiusOf10,
          color: context.colorScheme.accentColor.withAlpha(20),
        ),
        SizedBox(
          height: height,
          width: width,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                customIconWidget ??
                    CustomSvgPicture(
                      svgImage: AppAssets.gallery,
                      color: Theme.of(context).colorScheme.accentColor,
                    ),
                const SizedBox(width: 8.0),
                if (strPrefix != 'chooseFileLbl'.translate(context: context))
                  CustomText(
                    '$strPrefix $str',
                    color: Theme.of(context).colorScheme.blackColor,
                    fontSize: 12,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
