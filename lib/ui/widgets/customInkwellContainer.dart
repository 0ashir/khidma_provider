import 'package:flutter/material.dart';

class CustomInkWellContainer extends StatelessWidget {
  const CustomInkWellContainer({
    required this.child,
    final Key? key,
    this.onTap,
    this.borderRadius,
    this.showSplashEffect,
  }) : super(key: key);
  final bool? showSplashEffect;
  final Widget child;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;

  @override
  Widget build(final BuildContext context) => InkWell(
    borderRadius: borderRadius,
    splashColor: showSplashEffect ?? true ? null : Colors.transparent,
    highlightColor: Colors.transparent,
    hoverColor: Colors.transparent,
    splashFactory: showSplashEffect ?? true ? null : NoSplash.splashFactory,
    onTap: onTap,
    child: child,
  );
}
