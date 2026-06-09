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
              if (value.bookingModel?.advancePaymentEnable == true)
                PaymentSummaryWidget(booking: value.bookingModel!),
            ]).paddingAll(Insets.i20))
            .paddingOnly(bottom: Insets.i100),
        if (value.isLoading == false)
          Material(
              elevation: 20,
              child: _buildBottomActions(context, value)),
      ]);
    });
  }

  Widget _buildBottomActions(
      BuildContext context, PendingBookingProvider value) {
    final status = value.displayStatus;

    // Accepted: show Assign Now (spinner while the assign API is in flight)
    if (status == appFonts.accepted) {
      return ButtonCommon(
              title: translations!.assignNow,
              isLoading: value.isAssigningNow,
              onTap: value.isAssigningNow
                  ? null
                  : () => value.showAssignDialog(context))
          .paddingAll(Insets.i20)
          .decorated(color: appColor(context).appTheme.whiteBg);
    }

    // Assigned or beyond: buttons no longer needed on this screen
    if (status == appFonts.assigned ||
        status == appFonts.ontheway ||
        status == appFonts.ontheway1 ||
        status == appFonts.onGoing) {
      return const SizedBox.shrink();
    }

    // Default (pending): Cancel | Accept
    return BottomSheetButtonCommon(
            textOne: translations!.reject,
            textTwo: translations!.accept,
            clearTap: () => value.onRejectBooking(context),
            applyTap: () => value.onAcceptBooking(context))
        .paddingAll(Insets.i20)
        .decorated(color: appColor(context).appTheme.whiteBg);
  }
}
