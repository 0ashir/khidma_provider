import 'package:flutter/material.dart';

import '../../app/generalImports.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({
    super.key,
    required this.max,
    required this.current,
    this.color,
  });
  final double max;
  final double current;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, BoxConstraints boxConstraints) {
        final double x = boxConstraints.maxWidth;
        final double percent = (current / max) * x;
        return Stack(
          children: [
            CustomContainer(
              width: x,
              height: 7,
              color: Theme.of(context).colorScheme.accentColor.withAlpha(20),
              borderRadius: UiUtils.borderRadiusOf20,
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: percent,
              height: 7,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(UiUtils.borderRadiusOf20),
              ),
            ),
          ],
        );
      },
    );
  }
}
