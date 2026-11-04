import 'package:edemand_partner/app/generalImports.dart';
import 'package:flutter/material.dart';

class CustomRefreshIndicator extends StatelessWidget {
  const CustomRefreshIndicator({
    required this.onRefresh,
    required this.child,
    this.displacment,
    final Key? key,
  }) : super(key: key);
  final Widget child;
  final Function onRefresh;
  final double? displacment;

  @override
  Widget build(final BuildContext context) => RefreshIndicator(
    displacement: displacment ?? 15,
    triggerMode: RefreshIndicatorTriggerMode.anywhere,
    color: Theme.of(context).colorScheme.accentColor,
    onRefresh: () async {
      onRefresh();
    },
    child: child,
  );
}
