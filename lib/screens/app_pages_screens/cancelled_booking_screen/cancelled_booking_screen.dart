import 'package:fixit_provider/screens/app_pages_screens/pending_booking_screen/layouts/payment_status_summary.dart';

import '../../../config.dart';
import '../../bottom_screens/booking_screen/booking_shimmer/booking_detail_shimmer.dart';

class CancelledBookingScreen extends StatelessWidget {
  const CancelledBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CancelledBookingProvider>(builder: (context, value, child) {
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
                  title: translations!.cancelledBookings,
                  onTap: () => value.onBack(context, true),
                ),
                body: value.isLoading == true
                    ? const BookingDetailShimmer()
                    : value.isLoading == false && value.bookingModel == null
                        ? const BookingDetailShimmer() /* EmptyLayout(
                            isButton: false,
                            title: translations!.ohhNoListEmpty,
                            subtitle: translations!.yourBookingList,


                            
                            widget: Stack(
                              children: [
                                Image.asset(
                                  isFreelancer
                                      ? eImageAssets.noListFree
                                      : eImageAssets.noBooking,
                                  height: Sizes.s306,
                                ),
                              ],
                            ),
                          ) */
                        : RefreshIndicator(
                            onRefresh: () async {
                              value.onRefresh(context);
                            },
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                SingleChildScrollView(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                      StatusDetailLayout(
                                          data: value.bookingModel,
                                          onTapStatus: () => showBookingStatus(
                                              context, value.bookingModel)),
                                      Text(
                                              language(context,
                                                  translations!.billSummary),
                                              style: appCss.dmDenseMedium14
                                                  .textColor(appColor(context)
                                                      .appTheme
                                                      .darkText))
                                          .paddingOnly(
                                              top: Insets.i25,
                                              bottom: Insets.i10),
                                      CancelledBillSummary(
                                        bookingModel: value.bookingModel,
                                      ),
                                      const VSpace(Sizes.s20),
                                      if (value
                                          .bookingModel!.advancePaymentEnable!)
                                        PaymentSummaryWidget(
                                          booking: value.bookingModel!,
                                        ),
                                    ]).padding(
                                        horizontal: Insets.i20,
                                        top: Insets.i20,
                                        bottom: Insets.i100)),
                                Material(
                                    elevation: 20,
                                    child: AssignStatusLayout(
                                        status: translations!.reason,
                                        title: isFreelancer
                                            ? translations!.youChangedTimeSlot
                                            : translations!
                                                .servicemenIsNotAvailable))
                              ],
                            ),
                          ))),
      );
    });
  }
}
