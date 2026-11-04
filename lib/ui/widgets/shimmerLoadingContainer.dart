import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../app/generalImports.dart';

class ShimmerLoadingContainer extends StatelessWidget {
  const ShimmerLoadingContainer({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.shimmerBaseColor,
      highlightColor: Theme.of(context).colorScheme.shimmerHighlightColor,
      child: child,
    );
  }
}
