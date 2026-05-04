import '../../../../config.dart';

class PackageVerticalDivider extends StatelessWidget {
  const PackageVerticalDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return VerticalDivider(
        width: 1,
        color: appColor(context).appTheme.stroke,
        thickness: 1,
        endIndent: 20,
        indent: 20);
  }
}
