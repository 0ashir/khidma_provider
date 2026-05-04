import '../../../../../config.dart';

class PackageDescriptionLayout extends StatelessWidget {
  // final ServicePackageModel? data;
  const PackageDescriptionLayout({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<PackageDetailProvider>(builder: (context, value, child) {
      var data = value.packageModel;
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const DottedLines(),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
              child: DescriptionLayoutCommon(
                  isExpanded: true,
                  icon: eSvgAssets.calender,
                  title: "${language(context, translations!.startDate)}:",
                  subtitle: data!.startedAt)),
          Container(
                  height: Sizes.s78,
                  width: 1,
                  color: appColor(context).appTheme.stroke)
              .paddingSymmetric(horizontal: Insets.i20),
          Expanded(
              child: DescriptionLayoutCommon(
                  icon: eSvgAssets.calender,
                  title: "${language(context, translations!.endDate)}:",
                  subtitle: data!.endedAt))
        ]).paddingSymmetric(horizontal: Insets.i20),
        const DottedLines(),
        const VSpace(Sizes.s17),
        /* DescriptionLayoutCommon(
            isExpanded: true,
              icon: eSvgAssets.tagUser,
              title: translations!.noOfRequired,
              subtitle: "${data!.reqServicemen} ${translations!.serviceman}")
              .paddingSymmetric(horizontal: Insets.i25),*/
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const VSpace(Sizes.s15),
          Text(language(context, translations!.description),
              style: appCss.dmDenseMedium14
                  .textColor(appColor(context).appTheme.darkText)),
          const VSpace(Sizes.s6),
          ReadMoreLayout(
              color: appColor(context).appTheme.lightText,
              text: data.description),
        ]).paddingSymmetric(horizontal: Insets.i20)
      ]);
    });
  }
}
