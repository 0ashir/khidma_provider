import '../../../../config.dart';

class ServiceDescription extends StatelessWidget {
  final dynamic services;

  const ServiceDescription({super.key, this.services});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ServiceDetailsProvider, LocationProvider>(
        builder: (context1, value, val, child) {
      // log("services::${services.categories}");
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        DescriptionLayoutCommon(
                icon: eSvgAssets.category,
                title: translations!.category,
                subtitle: /* services!
                        .categories */
                    services!.categories!
                            .map((cat) => "${cat['title']}")
                            .join(', ') ??
                        '')
            .paddingSymmetric(horizontal: Insets.i25, vertical: Sizes.s17),
        Container(
            width: MediaQuery.of(context).size.width,
            height: 1,
            color: appColor(context).appTheme.stroke),
        DescriptionLayoutCommon(
                icon: eSvgAssets.mailBold,
                title: translations?.serviceType,
                subtitle: services!.type)
            .paddingSymmetric(horizontal: Insets.i25, vertical: Sizes.s17),
        Container(
            width: MediaQuery.of(context).size.width,
            height: 1,
            color: appColor(context).appTheme.stroke),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
              child: DescriptionLayoutCommon(
                  icon: eSvgAssets.clock,
                  title: translations!.duration,
                  subtitle:
                      "${services!.duration ?? 1} ${services!.durationUnit ?? "hour"}")),
          Container(
                  height: Sizes.s78,
                  width: 1,
                  color: appColor(context).appTheme.stroke)
              .paddingSymmetric(horizontal: Insets.i20),
          Expanded(
              child: DescriptionLayoutCommon(
                  icon: eSvgAssets.tagUser,
                  title: translations!.serviceman,
                  subtitle: "${services!.requiredServicemen ?? 1} servicemen"))
        ]).paddingSymmetric(horizontal: Insets.i25),
        Container(
            width: MediaQuery.of(context).size.width,
            height: 1,
            color: appColor(context).appTheme.stroke),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
              child: DescriptionLayoutCommon(
                  icon: eSvgAssets.commission,
                  title: translations!.adminCommission,
                  isExpanded: true,
                  subtitle:
                      '${services.highestCommission}' /* "${etCategoryCommission(services!.categories!)}%" */)),
          Container(
            height: Sizes.s78,
            /*  width: 1,
                  color: appColor(context).appTheme.stroke */
          ).paddingSymmetric(horizontal: Insets.i20),
          /* Expanded(
              child: DescriptionLayoutCommon(
                  icon: eSvgAssets.receiptDiscount,
                  title: translations!.tax,
                  subtitle: "${services!.tax?.rate ?? 0}%")) */
        ]).paddingSymmetric(horizontal: Insets.i25),
        Container(
            width: MediaQuery.of(context).size.width,
            height: 1,
            color: appColor(context).appTheme.stroke),
        if (services!.content != null)
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(language(context, "content" /* translations!.description */),
                style: appCss.dmDenseMedium12
                    .textColor(appColor(context).appTheme.lightText)),
            const VSpace(Sizes.s6),
            ReadMoreLayout(
              text: services!.content ?? "",
              isHtml: true,
            ),
            // if (services!.metaDescription != null) const VSpace(Sizes.s15),
            // if (services!.metaDescription != null)
            //   Text("${services!.metaDescription}",
            //       style: appCss.dmDenseMedium13
            //           .textColor(appColor(context).appTheme.lightText))
          ]).paddingSymmetric(horizontal: Insets.i20, vertical: Insets.i20)
      ]).boxBorderExtension(context, isShadow: true);
    });
  }
}
