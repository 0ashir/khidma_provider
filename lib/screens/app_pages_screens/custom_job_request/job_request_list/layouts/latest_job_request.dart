import 'dart:developer';

import 'package:intl/intl.dart';
import '../../../../../config.dart';
import '../../../../../model/dash_board_model.dart' show LatestServiceRequest;

class LatestJobRequestListCard extends StatelessWidget {
  final LatestServiceRequest? data;

  const LatestJobRequestListCard({
    super.key,
    this.data,
  });

  @override
  Widget build(BuildContext context) {
    // log("services::${data!.media}");
    return Column(children: [
      Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(children: [
                data!.media!
                        .isNotEmpty /* ||
                        data?.media?.first.originalUrl != null */
                    ? CommonImageLayout(
                            height: Sizes.s52,
                            width: Sizes.s52,
                            radius: 8,
                            image: data?.media?.first.originalUrl ?? "",
                            assetImage: eImageAssets.noImageFound3)
                        .boxShapeExtension()
                    : CommonCachedImage(
                            image: eImageAssets.noImageFound3,
                            //assetImage: eImageAssets.noImageFound3,
                            height: Sizes.s52,
                            width: Sizes.s52)
                        .boxShapeExtension(),
                const HSpace(Sizes.s10),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(capitalizeFirstLetter(data!.title),
                          style: appCss.dmDenseMedium14
                              .textColor(appColor(context).appTheme.darkText)),
                      const VSpace(Sizes.s8),
                      Text(
                          (data!.status != "accepted")
                              ? symbolPosition
                                  ? "${getSymbol(context)}${currency(context).currencyVal * data!.initialPrice!}"
                                  : "${currency(context).currencyVal * data!.initialPrice!}${getSymbol(context)}"
                              : symbolPosition
                                  ? "${getSymbol(context)}${currency(context).currencyVal * data!.finalPrice!}"
                                  : "${currency(context).currencyVal * data!.finalPrice!}${getSymbol(context)}",
                          overflow: TextOverflow.ellipsis,
                          style: appCss.dmDenseSemiBold12
                              .textColor(appColor(context).appTheme.darkText)),
                    ]).paddingOnly(left: Insets.i10))
              ]),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Sizes.s12, vertical: Sizes.s4),
                    decoration: ShapeDecoration(
                        color: colorCondition(data!.status, context),
                        shape: SmoothRectangleBorder(
                            borderRadius: SmoothBorderRadius(
                                cornerRadius: 11, cornerSmoothing: 2))),
                    child: Text(capitalizeFirstLetter(data!.status),
                        style: appCss.dmDenseMedium10
                            .textColor(appColor(context).appTheme.whiteColor))),
                // const VSpace(Sizes.s8),
                // Text(DateFormat("MMM d, yyyy").format(data!.bookingDate!),
                //     style: appCss.dmDenseMedium12
                //         .textColor(appColor(context).appTheme.lightText))
              ],
            )
          ]),
    ])
        .paddingAll(12)
        .boxBorderExtension(context, isShadow: true)
        .marginOnly(bottom: Sizes.s20)
        .inkWell(
            onTap: () => route.pushNamed(
                context, routeName.homeJobRequestDetails,
                arg: {"serviceId": data!.id}));
  }
}
