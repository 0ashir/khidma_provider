import '../../../../../config.dart';

class JobDescriptionLayout extends StatelessWidget {
  final String? icon, title, subtitle;
  final double? padding;
  final bool isExpanded;

  const JobDescriptionLayout(
      {super.key,
      this.icon,
      this.title,
      this.subtitle,
      this.padding,
      this.isExpanded = false});

  @override
  Widget build(BuildContext context) {
    /* return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(icon!,
                height: Sizes.s20,width: Sizes.s20,
                colorFilter: ColorFilter.mode(
                    appColor(context).appTheme.darkText, BlendMode.srcIn)),
            Container(
                height: Sizes.s15,
                width: 1,
                color: appColor(context).appTheme.stroke)
                .paddingSymmetric(horizontal: Insets.i9,vertical: Insets.i3),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              
                children: [
                  Text(language(context, title!),
                      style: appCss.dmDenseMedium12
                          .textColor(appColor(context).appTheme.darkText)),
              
                  Text(language(context, subtitle!),
                      style: appCss.dmDenseMedium12
                          .textColor(appColor(context).appTheme.lightText))
                ],
              ),
            )
          ]),
    ]);*/
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        SizedBox(
            height: Sizes.s17,
            width: Sizes.s17,
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
            : Expanded(
                child: Text(language(context, title!),
                    overflow: TextOverflow.clip,
                    style: appCss.dmDenseMedium12
                        .textColor(appColor(context).appTheme.darkText)),
              )
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
