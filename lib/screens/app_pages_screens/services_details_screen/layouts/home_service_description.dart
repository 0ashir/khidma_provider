/* import 'package:fixit_provider/model/dash_board_model.dart';

import '../../../../config.dart';

class HomeServiceDescription extends StatelessWidget {
  final PopularService? services;

  const HomeServiceDescription({super.key, this.services});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ServiceDetailsProvider, LocationProvider>(
        builder: (context1, value, val, child) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        DescriptionLayoutCommon(
                icon: eSvgAssets.category,
                title: translations!.category,
                subtitle: getCategoryName(
                    services!.categories!.cast<PopularServiceCategory>()))
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
                  subtitle: "${etCategoryCommission(services!.categories!)}%")),
          Container(
                  height: Sizes.s78,
                  width: 1,
                  color: appColor(context).appTheme.stroke)
              .paddingSymmetric(horizontal: Insets.i20),
          Expanded(
              child: DescriptionLayoutCommon(
                  icon: eSvgAssets.receiptDiscount,
                  title: translations!.tax,
                  subtitle: "${services!.tax?.rate}%"))
        ]).paddingSymmetric(horizontal: Insets.i25),
        Container(
            width: MediaQuery.of(context).size.width,
            height: 1,
            color: appColor(context).appTheme.stroke),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(language(context, translations!.description),
              style: appCss.dmDenseMedium12
                  .textColor(appColor(context).appTheme.lightText)),
          const VSpace(Sizes.s6),
          ReadMoreLayout(text: services!.description),
          if (services!.metaDescription != null) const VSpace(Sizes.s15),
          if (services!.metaDescription != null)
            Text("\u2022 ${services!.metaDescription ?? ""}.",
                style: appCss.dmDenseMedium13
                    .textColor(appColor(context).appTheme.lightText))
        ])
            .paddingSymmetric(horizontal: Insets.i20)
            .paddingSymmetric(vertical: Insets.i20)
      ]).boxBorderExtension(context, isShadow: true);
    });
  }
}
 */
