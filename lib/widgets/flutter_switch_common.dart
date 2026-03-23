import '../config.dart';

class FlutterSwitchCommon extends StatelessWidget {
  final bool? value;
  final ValueChanged<bool>? onToggle;
  const FlutterSwitchCommon({super.key,this.value = false,this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ThemeData(useMaterial3: false),
        child: FlutterSwitch(
            width: Sizes.s32,
            height: Sizes.s20,
            toggleSize: Sizes.s12,
            value: value!,
            borderRadius: 15,
            padding: 4,
            toggleColor: appColor(context).appTheme.whiteBg,
            inactiveToggleColor: appColor(context).appTheme.lightText,
            activeColor: appColor(context).appTheme.primary,
            inactiveColor: appColor(context).appTheme.stroke,
            onToggle: onToggle!));
  }
}
