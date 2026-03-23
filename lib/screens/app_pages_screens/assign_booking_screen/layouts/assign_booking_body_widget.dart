import 'dart:developer';

import 'package:fixit_provider/screens/app_pages_screens/pending_booking_screen/layouts/payment_status_summary.dart';

import '../../../../config.dart';

class AssignBookingBodyWidget extends StatelessWidget {
  const AssignBookingBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AcceptedBookingProvider, AssignBookingProvider>(
        builder: (context, acpCtrl, value, child) {
      log("value.bookingModel!.service!.type::: ${value.bookingModel!.service!.type}");
      return Stack(alignment: Alignment.bottomCenter, children: [
        SingleChildScrollView(
            child: Column(children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            StatusDetailLayout(
                data: value.bookingModel,
                onTapStatus: () =>
                    showBookingStatus(context, value.bookingModel)),
            if (value.amount != null)
              ServicemenPayableLayout(amount: value.amount),
            Text(language(context, translations!.billSummary),
                    style: appCss.dmDenseMedium14
                        .textColor(appColor(context).appTheme.darkText))
                .paddingOnly(top: Insets.i25, bottom: Insets.i10),
            AssignBillLayout(bookingModel: value.bookingModel),
            const VSpace(Sizes.s5),
            if (value.bookingModel!.advancePaymentEnable!)
              PaymentSummaryWidget(
                booking: value.bookingModel!,
              ),
            if (value.bookingModel!.service!.reviews == null &&
                value.bookingModel!.service!.reviews!.isEmpty)
              const VSpace(Sizes.s100),
            if (value.bookingModel!.service!.reviews != null &&
                value.bookingModel!.service!.reviews!.isNotEmpty)
              Column(
                children: [
                  HeadingRowCommon(
                      isViewAllShow:
                          value.bookingModel!.service!.reviews!.length >= 10,
                      title: translations!.review,
                      onTap: () {
                        Provider.of<ServiceReviewProvider>(context,
                                listen: false)
                            .getMyReview(context);
                        route.pushNamed(context, routeName.serviceReview);
                      }).paddingOnly(bottom: Insets.i12),
                  ...value.bookingModel!.service!.reviews!.asMap().entries.map(
                      (e) => SizedBox(
                                  child:
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                ListTile(
                                  dense: true,
                                  contentPadding: EdgeInsets.zero,
                                  leading: (e.value.consumer!.media!.isNotEmpty)
                                      ? CachedNetworkImage(
                                          imageUrl: e.value.consumer!.media
                                                  ?.first.originalUrl ??
                                              "",
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            height: Sizes.s40,
                                            width: Sizes.s40,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  image: imageProvider),
                                            ),
                                          ),
                                          placeholder: (context, url) =>
                                              CommonCachedImage(
                                                  height: Sizes.s40,
                                                  width: Sizes.s40,
                                                  isCircle: true,
                                                  image: eImageAssets
                                                      .noImageFound1),
                                          errorWidget: (context, url, error) =>
                                              CommonCachedImage(
                                                  height: Sizes.s40,
                                                  width: Sizes.s40,
                                                  isCircle: true,
                                                  image: eImageAssets
                                                      .noImageFound1),
                                        )
                                      : CommonCachedImage(
                                          height: Sizes.s40,
                                          width: Sizes.s40,
                                          isCircle: true,
                                          image: eImageAssets.noImageFound1),
                                  title: Text(
                                    e.value.consumer?.name ?? '',
                                    style: appCss.dmDenseMedium14.textColor(
                                        appColor(context).appTheme.darkText),
                                  ),
                                  subtitle: e.value.createdAt != null
                                      ? Text(
                                          getTime(DateTime.parse(
                                              e.value.createdAt.toString())),
                                          style: appCss.dmDenseMedium12
                                              .textColor(appColor(context)
                                                  .appTheme
                                                  .lightText),
                                        )
                                      : Container(),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SvgPicture.asset(eSvgAssets.star),
                                      const HSpace(Sizes.s4),
                                      Text(
                                        e.value.rating.toString(),
                                        style: appCss.dmDenseMedium12.textColor(
                                            appColor(context)
                                                .appTheme
                                                .darkText),
                                      ),
                                    ],
                                  ),
                                ),
                                const VSpace(Sizes.s5),
                                Text(e.value.description ?? "",
                                        style: appCss.dmDenseRegular12
                                            .textColor(appColor(context)
                                                .appTheme
                                                .darkText))
                                    .paddingOnly(bottom: Insets.i15),
                              ]))
                              .paddingSymmetric(horizontal: Insets.i15)
                              .boxBorderExtension(context,
                                  bColor: appColor(context).appTheme.stroke))
                ],
              )
            /* if (value.bookingModel!.service!.reviews != null &&
                value.bookingModel!.service!.reviews!.isNotEmpty)
              ReviewListWithTitle(
                  reviews: value.bookingModel!.service!.reviews!) */
          ]).padding(
              horizontal: Insets.i20,
              top: Insets.i20,
              bottom: value.isServicemen != true ? Insets.i10 : Insets.i80)
        ])).paddingOnly(bottom: isFreelancer ? Sizes.s80 : Sizes.s10),
        if (isFreelancer)
          ButtonCommon(
                  title: translations!.assignNow,
                  onTap: () => acpCtrl.onAssignTap(context,
                      bookingModel: value.bookingModel))
              .paddingAll(Sizes.s20)
              .backgroundColor(appColor(context).appTheme.whiteBg),
        if (value.bookingModel!.servicemen!.isNotEmpty)
          if (value.bookingModel!.servicemen!
              .where((element) =>
                  element.id.toString() == userModel!.id.toString())
              .isNotEmpty)
            Material(
                elevation: 20,
                child: (value.bookingModel!.service!.type == "remotely")
                    ? value.bookingModel!.zoomMeeting == null
                        ? ButtonCommon(
                            title: "Get Meeting Link",
                            onTap: () => value.getMeetingLink(
                                bookingId: value.bookingModel?.id,
                                context: context),
                          ).paddingAll(Insets.i20)
                        : ButtonCommon(
                            title: "Join Meeting",
                            onTap: () => value.openZoom(
                                meetingLink: value.bookingModel!.zoomMeeting
                                    ?.startUrl)).paddingAll(Insets
                            .i20) /*AssignStatusLayout(
                        status: translations!.reason,
                        isGreen: true,
                        title: "Wait for Call from Customer")*/
                    : BottomSheetButtonCommon(
                            textOne: translations!.cancelService,
                            textTwo: translations!.startDriving,
                            clearTap: () => value.onCancel(context),
                            applyTap: () => value.onStartServicePass(context))
                        .paddingAll(Insets.i20)
                        .decorated(color: appColor(context).appTheme.whiteBg))
      ]);
    });
  }
}
