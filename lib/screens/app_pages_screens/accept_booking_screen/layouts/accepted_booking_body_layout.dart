import 'dart:developer';
import 'package:fixit_provider/screens/app_pages_screens/pending_booking_screen/layouts/payment_status_summary.dart';

import '../../../../config.dart';

class AcceptedBookingBodyLayout extends StatelessWidget {
  const AcceptedBookingBodyLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AcceptedBookingProvider, AssignBookingProvider>(
        builder: (context1, value, assignValue, child) {
      log("value.bookingModel!.bookingStatus!.asdasdasd::${value.bookingModel!.bookingStatus!.slug}");
      return Stack(alignment: Alignment.bottomCenter, children: [
        SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          StatusDetailLayout(
              data: value.bookingModel,
              onTapStatus: () =>
                  showBookingStatus(context, value.bookingModel)),
          if (isFreelancer != true && value.amount != "0")
            ServicemenPayableLayout(amount: value.amount),
          Text(language(context, translations!.billSummary),
                  style: appCss.dmDenseMedium14
                      .textColor(appColor(context).appTheme.darkText))
              .paddingOnly(top: Insets.i25, bottom: Insets.i10),
          AcceptBillSummary(bookingModel: value.bookingModel),
          if (value.bookingModel!.advancePaymentEnable!)
            PaymentSummaryWidget(
              booking: value.bookingModel!,
            ),
          if (value.bookingModel!.service!.reviews != null &&
              value.bookingModel!.service!.reviews!.isNotEmpty)
            ReviewListWithTitle(reviews: value.bookingModel!.service!.reviews!)
        ]).padding(
                    horizontal: Insets.i20,
                    top: Insets.i20,
                    bottom: Insets.i100)),
        if (value.bookingModel!.bookingStatus!.slug == translations!.pending ||
            value.bookingModel!.bookingStatus!.slug == appFonts.accepted)
          /* value.bookingModel!.servicemen != null &&
                  value.bookingModel!.servicemen!.isNotEmpty
              ? Container()
              :*/
          Material(
              elevation: 20,
              child: isFreelancer
                  ? BottomSheetButtonCommon(
                          textOne: translations!.cancelService,
                          textTwo: translations!.startService,
                          clearTap: () => assignValue.onCancel(context),
                          applyTap: () =>
                              assignValue.onStartServicePass(context))
                      .paddingAll(Insets.i20)
                  : Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          decoration: ShapeDecoration(
                              color: appColor(context).appTheme.primary,
                              shape: SmoothRectangleBorder(
                                  borderRadius: SmoothBorderRadius(
                                      cornerRadius: AppRadius.r8,
                                      cornerSmoothing: 1))),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                value.isAssignServiceman
                                    ? const CircularProgressIndicator(
                                            color: Colors.white)
                                        .center()
                                        .padding(vertical: Sizes.s5)
                                    : Text(
                                        language(
                                            context, translations!.assignNow),
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        style: appCss.dmDenseRegular16
                                            .textColor(appColor(context)
                                                .appTheme
                                                .whiteColor))
                              ]))
                      .inkWell(
                          onTap: () => value.onAssignTap(context,
                              bookingModel: value.bookingModel))
                      /* ButtonCommon(
                              title: translations!.


                              onTap: () => value.onAssignTap(context)) */
                      .paddingAll(Insets.i20))
      ]);
    });
  }
}
