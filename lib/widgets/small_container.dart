import '../config.dart';

class SmallContainer extends StatelessWidget {
  const SmallContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
        width: 4,
        height: Sizes.s26
    ).decorated(color: appColor(context).appTheme.primary,borderRadius: BorderRadius.circular(AppRadius.r50));
  }
}
