import 'package:edemand_partner/app/generalImports.dart';
import 'package:flutter/material.dart';

class CustomSwitch extends StatelessWidget {
  final bool value;
  final Color? trackColor;
  final Color? activeColor;
  final Color? thumbColor;
  final void Function(bool)? onChanged;

  const CustomSwitch({
    super.key,
    required this.onChanged,
    required this.value,
    this.trackColor,
    this.activeColor,
    this.thumbColor,
  });

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoSwitch(
            activeTrackColor:
                activeColor ?? Theme.of(context).colorScheme.secondaryColor,
            thumbColor: thumbColor ?? Theme.of(context).colorScheme.blackColor,
            inactiveTrackColor:
                trackColor ?? Theme.of(context).colorScheme.secondaryColor,
            value: value,
            onChanged: onChanged,
          )
        : Switch(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            value: value,
            trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
            thumbColor: WidgetStateProperty.all(
              thumbColor ?? Theme.of(context).colorScheme.secondaryColor,
            ),
            trackColor: WidgetStateProperty.all(
              trackColor ?? Theme.of(context).colorScheme.secondaryColor,
            ),
            onChanged: onChanged,
          );
  }
}
