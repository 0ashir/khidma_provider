import 'package:edemand_partner/app/generalImports.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomBackArrow extends StatelessWidget {
  final bool? canGoBack;
  final VoidCallback? onTap;

  const CustomBackArrow({super.key, this.canGoBack, this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      icon: CustomSvgPicture(
        svgImage:
            Directionality.of(
              context,
            ).toString().contains(TextDirection.RTL.value.toLowerCase())
            ? AppAssets.arrowNext
            : AppAssets.backArrowLight,
        boxFit: BoxFit.scaleDown,
        color: Theme.of(context).colorScheme.accentColor,
      ),
      onPressed:
          onTap ??
          () {
            if (canGoBack ?? true) {
              Navigator.of(context).pop();
            }
          },
    );
  }
}
