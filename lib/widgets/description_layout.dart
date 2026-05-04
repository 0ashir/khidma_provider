import '../../../../config.dart';

class DescriptionLayoutCommon extends StatelessWidget {
  final String? icon, title, subtitle;
  final double? padding;
  final bool? isExpanded;

  const DescriptionLayoutCommon(
      {super.key,
      this.icon,
      this.title,
      this.subtitle,
      this.padding,
      this.isExpanded = false});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        SizedBox(
            height: Sizes.s20,
            width: Sizes.s20,
            child: SvgPicture.asset(icon!,
                colorFilter: ColorFilter.mode(
                    appColor(context).appTheme.darkText, BlendMode.srcIn))),
        Container(
                height: Sizes.s15,
                width: 1,
                color: appColor(context).appTheme.stroke)
            .paddingSymmetric(horizontal: Insets.i9),
        isExpanded == true
            ? Expanded(
                child: Text(language(context, title!),
                    overflow: TextOverflow.ellipsis,
                    style: appCss.dmDenseMedium12
                        .textColor(appColor(context).appTheme.darkText)),
              )
            : Text(language(context, title!),
                overflow: TextOverflow.ellipsis,
                style: appCss.dmDenseMedium12
                    .textColor(appColor(context).appTheme.darkText))
      ]),
      Text(language(context, subtitle!),
              style: appCss.dmDenseMedium12
                  .textColor(appColor(context).appTheme.lightText))
          .paddingOnly(
              left: rtl(context) ? 0 : Insets.i40,
              right: rtl(context) ? Insets.i40 : 0)
    ]);
  }
}
