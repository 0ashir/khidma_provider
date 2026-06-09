import '../config.dart';

class FlutterSwitchCommon extends StatelessWidget {
  final bool? value;
  final ValueChanged<bool>? onToggle;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? toggleColor;
  final Color? inactiveToggleColor;
  final double? width;
  final double? height;
  final double? toggleSize;

  const FlutterSwitchCommon({
    super.key,
    this.value = false,
    this.onToggle,
    this.activeColor,
    this.inactiveColor,
    this.toggleColor,
    this.inactiveToggleColor,
    this.width,
    this.height,
    this.toggleSize,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ThemeData(useMaterial3: false),
        child: FlutterSwitch(
            width: width ?? Sizes.s32,
            height: height ?? Sizes.s20,
            toggleSize: toggleSize ?? Sizes.s12,
            value: value!,
            borderRadius: 15,
            padding: 4,
            toggleColor: toggleColor ?? appColor(context).appTheme.whiteBg,
            inactiveToggleColor: inactiveToggleColor ?? appColor(context).appTheme.lightText,
            activeColor: activeColor ?? appColor(context).appTheme.primary,
            inactiveColor: inactiveColor ?? appColor(context).appTheme.stroke,
            onToggle: onToggle!));
  }
}
