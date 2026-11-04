import 'package:flutter/material.dart';

import '../../app/generalImports.dart';

class CustomShimmerContainer extends StatelessWidget {
  const CustomShimmerContainer({
    super.key,
    this.height,
    this.width,
    this.borderRadius,
    this.margin,
  });
  final double? height;
  final double? width;
  final double? borderRadius;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      width: width,
      margin: margin,
      height: height ?? 10,
      color: Theme.of(context).colorScheme.shimmerContentColor,
      borderRadius: borderRadius ?? UiUtils.borderRadiusOf10,
    );
  }
}
