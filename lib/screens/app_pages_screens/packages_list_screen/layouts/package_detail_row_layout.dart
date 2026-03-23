import '../../../../config.dart';

class PackageDetailRowLayout extends StatelessWidget {
  final String? title, subtext;

  const PackageDetailRowLayout({super.key, this.title, this.subtext});

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(language(context, title!),
            style: appCss.dmDenseRegular12
                .textColor(appColor(context).appTheme.lightText)),
        const VSpace(Sizes.s2),
        Text(
            language(context,
                "$subtext ${language(context, title == translations!.serviceIncluded ? translations!.service : "")}"),
            style: appCss.dmDenseMedium12
                .textColor(appColor(context).appTheme.darkText))
      ])
    ]).paddingSymmetric(vertical: Insets.i15);
  }
}
