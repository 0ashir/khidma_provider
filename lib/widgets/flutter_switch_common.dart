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
  final bool isLoading;

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
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final loader = SizedBox(
        width: (toggleSize ?? Sizes.s12) * 0.6,
        height: (toggleSize ?? Sizes.s12) * 0.6,
        child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
                value! ? (activeColor ?? appColor(context).appTheme.primary) : (inactiveColor ?? appColor(context).appTheme.stroke))));
    return Theme(
        data: ThemeData(useMaterial3: false),
        child: FlutterSwitch(
            width: width ?? Sizes.s32,
            height: height ?? Sizes.s20,
            toggleSize: toggleSize ?? Sizes.s12,
            value: value!,
            borderRadius: 15,
            padding: 4,
            disabled: isLoading,
            activeIcon: isLoading ? loader : null,
            inactiveIcon: isLoading ? loader : null,
            toggleColor: toggleColor ?? appColor(context).appTheme.whiteBg,
            inactiveToggleColor: inactiveToggleColor ?? appColor(context).appTheme.lightText,
            activeColor: activeColor ?? appColor(context).appTheme.primary,
            inactiveColor: inactiveColor ?? appColor(context).appTheme.stroke,
            onToggle: onToggle!));
  }
}
