import 'package:fixit_provider/screens/app_pages_screens/pending_booking_screen/layouts/payment_status_summary.dart';

import '../../../config.dart';
import '../../bottom_screens/booking_screen/booking_shimmer/booking_detail_shimmer.dart';

class OngoingBookingScreen extends StatelessWidget {
  const OngoingBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<OngoingBookingProvider, AddExtraChargesProvider>(
        builder: (context1, value, addValue, child) {
      return PopScope(
        canPop: true,
        onPopInvoked: (didPop) {
          value.onBack(context, false);
          if (didPop) return;
        },
        child: StatefulWrapper(
            onInit: () => Future.delayed(
                const Duration(milliseconds: 50), () => value.onReady(context)),
            child: Scaffold(
                appBar: AppBarCommon(
                    title: translations!.ongoingBooking,
                    onTap: () => value.onBack(context, true)),
                body: value.bookingModel == null
                    ? const BookingDetailShimmer()
                    : RefreshIndicator(
                        onRefresh: () async {
                          value.onRefresh(context);
                        },
                        child:
                            Stack(alignment: Alignment.bottomCenter, children: [
                          SingleChildScrollView(
                              child: Column(children: [
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  StatusDetailLayout(
                                      data: value.bookingModel,
                                      onTapStatus: () => showBookingStatus(
                                          context, value.bookingModel)),
                                  if (value.amount != null)
                                    ServicemenPayableLayout(
                                        amount: value.amount),
                                  Text(
                                          language(context,
                                              translations!.billSummary),
                                          style: appCss.dmDenseMedium14
                                              .textColor(appColor(context)
                                                  .appTheme
                                                  .darkText))
                                      .paddingOnly(
                                          top: Insets.i25, bottom: Insets.i10),
                                  !(userModel!.role == "provider")
                                      ? PendingApprovalBillSummary(
                                          bookingModel: value.bookingModel)
                                      : OngoingBillSummary(
                                          bookingModel: value.bookingModel),
                                  // const VSpace(Sizes.s20),
                                  if (value.bookingModel!.advancePaymentEnable == true)
                                    PaymentSummaryWidget(
                                      booking: value.bookingModel!,
                                    ),
                                  if (value.bookingModel!.extraCharges !=
                                          null &&
                                      value.bookingModel!.extraCharges!
                                          .isNotEmpty)
                                    Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              language(
                                                  context,
                                                  translations!
                                                      .addServiceDetails),
                                              style: appCss.dmDenseMedium14
                                                  .textColor(appColor(context)
                                                      .appTheme
                                                      .darkText)),
                                          const VSpace(Sizes.s10),
                                          AddServiceLayout(
                                              extraCharge: value
                                                  .bookingModel!.extraCharges),
                                          const VSpace(Sizes.s25)
                                        ]),
                                  /* if (value.bookingModel!.service!.reviews !=
                                          null &&
                                      value.bookingModel!.service!.reviews!
                                          .isNotEmpty)
                                    ReviewListWithTitle(
                                        reviews: value
                                            .bookingModel!.service!.reviews!) */
                                  if (value.bookingModel!.service?.reviews !=
                                          null &&
                                      value.bookingModel!.service!.reviews!
                                          .isNotEmpty)
                                    Column(children: [
                                      HeadingRowCommon(
                                          isViewAllShow: value.bookingModel!
                                                  .service!.reviews!.length >=
                                              10,
                                          title: translations!.review,
                                          onTap: () {
                                            Provider.of<ServiceReviewProvider>(
                                                    context,
                                                    listen: false)
                                                .getMyReview(context);
                                            route.pushNamed(context,
                                                routeName.serviceReview);
                                          }).paddingOnly(bottom: Insets.i12),
                                      ...value.bookingModel!.service!.reviews!
                                          .asMap()
                                          .entries
                                          .map((e) => SizedBox(
                                                      child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                    ListTile(
                                                        dense: true,
                                                        contentPadding:
                                                            EdgeInsets.zero,
                                                        leading: (e
                                                                .value
                                                                .consumer!
                                                                .media!
                                                                .isNotEmpty)
                                                            ? CachedNetworkImage(
                                                                imageUrl: e
                                                                        .value
                                                                        .consumer!
                                                                        .media
                                                                        ?.first
                                                                        .originalUrl ??
                                                                    "",
                                                                imageBuilder: (context, imageProvider) => Container(
                                                                    height: Sizes
                                                                        .s40,
                                                                    width: Sizes
                                                                        .s40,
                                                                    decoration: BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                        image:
                                                                            DecorationImage(image: imageProvider))),
                                                                placeholder: (context, url) => CommonCachedImage(height: Sizes.s40, width: Sizes.s40, isCircle: true, image: eImageAssets.noImageFound1),
                                                                errorWidget: (context, url, error) => CommonCachedImage(height: Sizes.s40, width: Sizes.s40, isCircle: true, image: eImageAssets.noImageFound1))
                                                            : CommonCachedImage(height: Sizes.s40, width: Sizes.s40, isCircle: true, image: eImageAssets.noImageFound1),
                                                        title: Text(e.value.consumer?.name ?? '', style: appCss.dmDenseMedium14.textColor(appColor(context).appTheme.darkText)),
                                                        subtitle: e.value.createdAt != null ? Text(getTime(DateTime.parse(e.value.createdAt.toString())), style: appCss.dmDenseMedium12.textColor(appColor(context).appTheme.lightText)) : Container(),
                                                        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                                                          SvgPicture.asset(
                                                              eSvgAssets.star),
                                                          const HSpace(
                                                              Sizes.s4),
                                                          Text(
                                                              e.value.rating
                                                                  .toString(),
                                                              style: appCss
                                                                  .dmDenseMedium12
                                                                  .textColor(appColor(
                                                                          context)
                                                                      .appTheme
                                                                      .darkText))
                                                        ])),
                                                    const VSpace(Sizes.s5),
                                                    Text(
                                                            e.value.description ??
                                                                "",
                                                            style: appCss
                                                                .dmDenseRegular12
                                                                .textColor(appColor(
                                                                        context)
                                                                    .appTheme
                                                                    .darkText))
                                                        .paddingOnly(
                                                            bottom: Insets.i15)
                                                  ]))
                                                  .paddingSymmetric(
                                                      horizontal: Insets.i15)
                                                  .boxBorderExtension(context,
                                                      bColor: appColor(context)
                                                          .appTheme
                                                          .stroke))
                                    ])
                                ]).paddingAll(Insets.i20),
                          ]).paddingOnly(bottom: Insets.i100)),
                          if (value.bookingModel?.service?.type != "remotely")
                            Material(
                                elevation: 20,
                                child: _buildServicemanActions(context, value))
                        ]),
                      ))),
      );
    });
  }

  Widget _buildServicemanActions(BuildContext context, OngoingBookingProvider value) {
    final booking = value.bookingModel!;
    final slug = value.currentSlug;

    // Not assigned to this user — view only
    final isAssigned = booking.servicemen != null &&
        booking.servicemen!.any((e) => e.id.toString() == userModel!.id.toString());
    if (!isAssigned) {
      return AssignStatusLayout(
          status: translations!.status,
          title: translations!.serviceInProgress,
          isGreen: true);
    }

    // Serviceman is on the way — show Start Service
    if (slug == appFonts.ontheway || slug == appFonts.ontheway1) {
      return ButtonCommon(
              title: translations!.startService,
              onTap: () => value.onStart(context))
          .paddingAll(Insets.i20)
          .decorated(color: appColor(context).appTheme.whiteBg);
    }

    // Service on hold — show Restart
    if (slug == appFonts.onHold || slug == appFonts.onHold1) {
      return ButtonCommon(
              title: "Restart Service",
              onTap: () => value.onPauseConfirmation(context, isHold: false))
          .paddingAll(Insets.i20)
          .decorated(color: appColor(context).appTheme.whiteBg);
    }

    // Service ongoing — show Pause + Complete (with optional Add Charges)
    if (slug == appFonts.onGoing || slug == appFonts.startAgain) {
      return Row(children: [
        Expanded(
            child: ButtonCommon(
                title: "Pause Service",
                color: const Color(0xFFFF4B4B),
                onTap: () => value.onPauseConfirmation(context))),
        const HSpace(Sizes.s10),
        Expanded(
            child: ButtonCommon(
                title: "Complete",
                color: appColor(context).appTheme.green,
                onTap: () => value.completeConfirmation(context))),
        if (appSettingModel?.activation?.extraChargeStatus == "1") ...[
          const HSpace(Sizes.s10),
          Expanded(
              child: ButtonCommon(
                  title: translations!.addCharges,
                  onTap: () => value.addCharges(context))),
        ]
      ]).paddingAll(Insets.i20).decorated(color: appColor(context).appTheme.whiteBg);
    }

    // Default — service not started yet
    return AssignStatusLayout(
        status: translations!.status,
        title: translations!.serviceNotStarted,
        isGreen: true);
  }
}
