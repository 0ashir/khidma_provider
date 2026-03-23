import '../config.dart';

class DividerCommon extends StatelessWidget {
  final Color? color;
  const DividerCommon({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Divider(
        color: color ?? appColor(context).appTheme.stroke,
        thickness: 1,
        height: 1);
  }
}
