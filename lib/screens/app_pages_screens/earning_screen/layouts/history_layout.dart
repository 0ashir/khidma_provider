import 'package:intl/intl.dart';

import '../../../../config.dart';

class HistoryLayout extends StatelessWidget {
  final Histories? data;

  const HistoryLayout({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
            width: MediaQuery.of(context).size.width / 1.6,
            child: Text(data?.booking?.service?.title ?? "",
                overflow: TextOverflow.ellipsis,
                style: appCss.dmDenseMedium14
                    .textColor(appColor(context).appTheme.darkText))),
        const VSpace(Sizes.s3),
        Text(
            DateFormat("dd MMM, yyyy")
                .format(DateTime.parse(data!.createdAt!.toString())),
            style: appCss.dmDenseRegular12
                .textColor(appColor(context).appTheme.lightText))
      ]),
      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Text(
            symbolPosition
                ? "${getSymbol(context)}${currency(context).currencyVal * data!.providerCommission!}"
                : "${currency(context).currencyVal * data!.providerCommission!}${getSymbol(context)}",
            style: appCss.dmDenseSemiBold14
                .textColor(appColor(context).appTheme.darkText)),
        const VSpace(Sizes.s3),
        /*  Text(data["status"],
            style: appCss.dmDenseMedium12.textColor(data["status"] == "Credit"
                ? appColor(context).appTheme.online
                : appColor(context).appTheme.red))*/
      ])
    ])
        .paddingAll(Insets.i12)
        .boxShapeExtension(
            color: appColor(context).appTheme.fieldCardBg, radius: AppRadius.r8)
        .paddingOnly(bottom: Insets.i15);
  }
}
