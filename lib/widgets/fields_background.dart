import '../config.dart';

class FieldsBackground extends StatelessWidget {

  const FieldsBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: SizedBox(
          width: MediaQuery.of(context).size.width
      ).decorated(color: appColor(context).appTheme.fieldCardBg,borderRadius: BorderRadius.circular(AppRadius.r12)).paddingSymmetric(horizontal: Insets.i2),
    );
  }
}
