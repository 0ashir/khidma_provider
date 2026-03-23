import '../config.dart';

class AuthTopLayout extends StatelessWidget {
  final String? image, title, subTitle, number;
  final bool isNumber;

  const AuthTopLayout(
      {super.key,
      this.title,
      this.image,
      this.number,
      this.subTitle,
      this.isNumber = false});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Image.asset(image!, height: Sizes.s175, width: Sizes.s165),
      const VSpace(Sizes.s42),
      Text(language(context, title!),
          style: appCss.dmDenseBold20
              .textColor(appColor(context).appTheme.darkText)),
      const VSpace(Sizes.s6),
      Text(language(context, subTitle!),
          style: appCss.dmDenseMedium14
              .textColor(appColor(context).appTheme.lightText)),
      const VSpace(Sizes.s8),
      if (isNumber)
        Text(number!,
            style: appCss.dmDenseExtraBold16
                .textColor(appColor(context).appTheme.darkText)),
      const VSpace(Sizes.s25)
    ]);
  }
}
