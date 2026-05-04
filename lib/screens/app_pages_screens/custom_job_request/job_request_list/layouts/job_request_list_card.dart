import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:fixit_provider/providers/app_pages_provider/job_request_providers/job_request_details_provider.dart';
import '../../../../../config.dart';

class JobRequestListCard extends StatefulWidget {
  final JobRequestModel? data;
  // final LatestServiceRequest? data;

  const JobRequestListCard({
    super.key,
    this.data,
  });

  @override
  State<JobRequestListCard> createState() => _JobRequestListCardState();
}

class _JobRequestListCardState extends State<JobRequestListCard> {
  /* final jobrequest =
      Provider.of<JobRequestListProvider>(context, listen: false); */
  @override
  Widget build(BuildContext context) {
    return Consumer<JobRequestDetailsProvider>(
        builder: (context, value, child) {
      return Column(children: [
        Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(children: [
                  widget.data!.media!.isNotEmpty
                      ? CommonImageLayout(
                              height: Sizes.s52,
                              width: Sizes.s52,
                              radius: 8,
                              image:
                                  widget.data?.media?.first.originalUrl ?? "",
                              assetImage: eImageAssets.noImageFound3)
                          .boxShapeExtension()
                      : CommonCachedImage(
                              image: eImageAssets.noImageFound3,
                              //assetImage: eImageAssets.noImageFound3,
                              height: Sizes.s52,
                              width: Sizes.s52)
                          .boxShapeExtension(),
                  HSpace(Sizes.s10),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text(capitalizeFirstLetter(widget.data!.title),
                            style: appCss.dmDenseMedium14.textColor(
                                appColor(context).appTheme.darkText)),
                        const VSpace(Sizes.s8),
                        Text(
                            (widget.data!.status != "accepted")
                                ? symbolPosition
                                    ? "${getSymbol(context)}${currency(context).currencyVal * widget.data!.initialPrice!}"
                                    : "${currency(context).currencyVal * widget.data!.initialPrice!}${getSymbol(context)}"
                                : symbolPosition
                                    ? "${getSymbol(context)}${currency(context).currencyVal * widget.data!.finalPrice!}"
                                    : "${currency(context).currencyVal * widget.data!.finalPrice!}${getSymbol(context)}",
                            overflow: TextOverflow.ellipsis,
                            style: appCss.dmDenseSemiBold12.textColor(
                                appColor(context).appTheme.darkText)),
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
                          color: colorCondition(widget.data!.status, context),
                          shape: SmoothRectangleBorder(
                              borderRadius: SmoothBorderRadius(
                                  cornerRadius: 11, cornerSmoothing: 2))),
                      child: Text(capitalizeFirstLetter(widget.data!.status),
                          style: appCss.dmDenseMedium10.textColor(
                              appColor(context).appTheme.whiteColor))),
                  const VSpace(Sizes.s8),
                  /*  Text(
                    DateFormat("MMM d, yyyy")
                        .format(DateTime.parse(data!.bookingDate!)),
                    style: appCss.dmDenseMedium12
                        .textColor(appColor(context).appTheme.lightText)) */
                  Text(
                    () {
                      try {
                        if (widget.data?.bookingDate != null) {
                          return DateFormat("MMM d, yyyy").format(
                              DateTime.parse(widget.data!.bookingDate!));
                        }
                      } catch (e) {
                        log("Date parse error: $e");
                      }
                      return "";
                    }(),
                    style: appCss.dmDenseMedium12
                        .textColor(appColor(context).appTheme.lightText),
                  )
                ],
              )
            ]),
      ])
          .paddingAll(12)
          .boxBorderExtension(context, isShadow: true)
          .marginOnly(bottom: Sizes.s20)
          .inkWell(onTap: () {
        /*   log("=-=-=-=-=-===---= ${data?.toJson()}"); */
        value.getServiceById(context, widget.data?.id!);
        route.pushNamed(context, routeName.jobRequestDetail,
            arg: {"services": widget.data?.toJson()});
      });
    });
  }
}
