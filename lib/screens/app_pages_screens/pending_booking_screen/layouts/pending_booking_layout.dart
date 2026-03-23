import 'package:fixit_provider/config.dart';
import 'package:fixit_provider/screens/app_pages_screens/pending_booking_screen/layouts/payment_status_summary.dart';

class PendingBookingLayout extends StatelessWidget {
  const PendingBookingLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PendingBookingProvider>(builder: (context, value, child) {
      return Stack(alignment: Alignment.bottomCenter, children: [
        SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
              StatusDetailLayout(
                  data: value.bookingModel,
                  onTapStatus: () =>
                      showBookingStatus(context, value.bookingModel)),
              if (value.isAmount)
                ServicemenPayableLayout(amount: value.amountCtrl.text),
              Text(language(context, translations!.billSummary),
                      style: appCss.dmDenseMedium14
                          .textColor(appColor(context).appTheme.darkText))
                  .paddingOnly(top: Insets.i25, bottom: Insets.i10),
              if (value.bookingModel != null)
                CancelledBillSummary(bookingModel: value.bookingModel),
              const VSpace(Sizes.s20),
              if (value.bookingModel!.advancePaymentEnable!)
                PaymentSummaryWidget(
                  booking: value.bookingModel!,
                ),
              // if (value.bookingModel?.service?.reviews != null &&
              //     value.bookingModel!.service!.reviews!.isNotEmpty)
              //   ReviewListWithTitle(
              //       reviews: value.bookingModel!.service!.reviews!)
            ]).paddingAll(Insets.i20))
            .paddingOnly(bottom: Insets.i100),
        if (value.isLoading == false)
          Material(
              elevation: 20,
              child: BottomSheetButtonCommon(
                      textOne: translations!.reject,
                      textTwo: translations!.accept,
                      clearTap: () => value.onRejectBooking(context),
                      applyTap: () {
                        value.onAcceptBooking(context);
                      })
                  .paddingAll(Insets.i20)
                  .decorated(color: appColor(context).appTheme.whiteBg))
      ]);
    });
  }
}
