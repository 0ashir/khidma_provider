import '../../../../config.dart';

class ContactUsLayout extends StatelessWidget {
  const ContactUsLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
        color: appColor(context).appTheme.stroke,
        borderType: BorderType.RRect,
        radius: const Radius.circular(15),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            SvgPicture.asset(eSvgAssets.email),
            const HSpace(Sizes.s8),
            Text(language(context, translations!.email),
                style: appCss.dmDenseMedium14
                    .textColor(appColor(context).appTheme.lightText))
          ]),
          const VSpace(Sizes.s8),
          Text("example.help&support@gmail.com",
              style: appCss.dmDenseRegular16
                  .textColor(appColor(context).appTheme.darkText)),
          Divider(height: 1, color: appColor(context).appTheme.stroke)
              .paddingSymmetric(vertical: Insets.i20),
          Column(children: [
            Row(children: [
              SvgPicture.asset(eSvgAssets.phone),
              const HSpace(Sizes.s8),
              Text(language(context, translations!.phone),
                  style: appCss.dmDenseMedium14
                      .textColor(appColor(context).appTheme.lightText))
            ]),
            const VSpace(Sizes.s8),
            IntrinsicHeight(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                  Text("(406) 555-0120",
                      style: appCss.dmDenseRegular16
                          .textColor(appColor(context).appTheme.darkText)),
                  VerticalDivider(
                      color: appColor(context).appTheme.stroke,
                      width: 1,
                      endIndent: 3,
                      indent: 3),
                  Text("(704) 555-0127",
                      style: appCss.dmDenseRegular16
                          .textColor(appColor(context).appTheme.darkText))
                ]))
          ])
        ]).paddingAll(Insets.i15).decorated(
            color: appColor(context).appTheme.fieldCardBg,
            borderRadius: BorderRadius.circular(AppRadius.r13)));
  }
}
