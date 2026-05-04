import '../../../../config.dart';

class DescriptionLayout extends StatelessWidget {
  // final dynamic data;
  final double? padding;
  final bool? isDark;
  /*  final List? list; */
  final String? icon;
  final String? title;
  final String? subTitle;
  /* final int? index; */

  const DescriptionLayout(
      {super.key,
        this.padding,
        this.isDark = false,
        /*  this.index, */
        /*   this.list, */
        this.icon,
        this.title,
        this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
          height: Sizes.s20,
          width: Sizes.s20,
          child: SvgPicture.asset(icon.toString(),
              fit: BoxFit.contain,
              colorFilter: ColorFilter.mode(
                  appColor(context).appTheme.darkText, BlendMode.srcIn)),
        ),
        Container(
            height: Sizes.s15,
            width: 1,
            color: appColor(context).appTheme.stroke)
            .paddingSymmetric(horizontal: Insets.i9),
        Text(language(context, title /* data["title"] */),
            style: isDark == true
                ? appCss.dmDenseRegular12.textColor(isDark == true
                ? appColor(context).appTheme.lightText
                : appColor(context).appTheme.darkText)
                : appCss.dmDenseMedium12.textColor(isDark == true
                ? appColor(context).appTheme.lightText
                : appColor(context).appTheme.darkText))
            .expanded()
      ]).paddingSymmetric(horizontal: Insets.i10),
      if (isDark == true)
        Text(language(context, subTitle /* data["subtitle"] */),
            style: appCss.dmDenseMedium14
                .textColor(appColor(context).appTheme.darkText))
            .paddingSymmetric(horizontal: Insets.i10)
            .paddingOnly(
            left: rtl(context) ? 0 : Insets.i38,
            right: rtl(context) ? Insets.i38 : 0),
      /*  if (index != list!.length - 1) */
      /*   Divider(
                height: 1,
                thickness: 1,
                color: appColor(context).appTheme.stroke)
            .paddingSymmetric(vertical: Insets.i15) */
    ]);
  }
}