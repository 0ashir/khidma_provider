// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:fixit_provider/screens/app_pages_screens/pending_booking_screen/layouts/pending_booking_layout.dart';

import '../../../config.dart';
import '../../bottom_screens/booking_screen/booking_shimmer/booking_detail_shimmer.dart';

class PendingBookingScreen extends StatelessWidget {
  const PendingBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PendingBookingProvider>(builder: (context, value, child) {
      return PopScope(
        canPop: true,
        onPopInvoked: (didPop) {
          value.onBack(context, false);
          if (didPop) return;
        },
        child: StatefulWrapper(
            onInit: /*() => value.onReady(
                context)*/
                () => Future.delayed(const Duration(milliseconds: 100),
                    () => value.onReady(context)),
            child: Scaffold(
                appBar: AppBarCommon(
                    title: translations!.pendingBooking,
                    onTap: () => value.onBack(context, true)),
                body:
                    value.isLoading == true /* && value.bookingModel == null */
                        ? const BookingDetailShimmer()
                        : SafeArea(
                            child: RefreshIndicator(
                                onRefresh: () async {
                                  value.onRefresh(context);
                                },
                                child: value.isLoading == true
                                    ? const BookingDetailShimmer()
                                    : value.bookingModel == null
                                        ? const BookingDetailShimmer()
                                        : const PendingBookingLayout()),
                          ))),
      );
    });
  }
}
