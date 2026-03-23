import '../config.dart';

class StarLayout extends StatelessWidget {
  final String? star,rate;
  const StarLayout({super.key, this.star, this.rate});

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
      SvgPicture.asset(star!),
      const HSpace(Sizes.s4),
      Text(rate!,
          style: appCss.dmDenseMedium12
              .textColor(appColor(context).appTheme.darkText))
    ]);
  }
}
