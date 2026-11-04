import 'package:edemand_partner/app/generalImports.dart';
import 'package:flutter/material.dart';

class CustomMainAppBarContainer extends StatefulWidget {
  const CustomMainAppBarContainer({
    super.key,
    required this.headingHeight,
    required this.child,
  });
  final ValueNotifier<double> headingHeight;

  final Widget child;
  @override
  State<CustomMainAppBarContainer> createState() =>
      _CustomMainAppBarContainerState();
}

class _CustomMainAppBarContainerState extends State<CustomMainAppBarContainer> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: widget.headingHeight,
      builder: (context, height, child) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          height: height,
          padding: EdgeInsets.symmetric(vertical: height / 30),
          color: Theme.of(context).colorScheme.primaryColor,
          child: SafeArea(child: widget.child),
        );
      },
    );
  }
}
