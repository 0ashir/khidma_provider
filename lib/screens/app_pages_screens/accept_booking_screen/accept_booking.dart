import '../../../config.dart';
import '../../bottom_screens/booking_screen/booking_shimmer/booking_detail_shimmer.dart';

class AcceptBookingScreen extends StatelessWidget {
  const AcceptBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AcceptedBookingProvider, AssignBookingProvider>(
        builder: (context1, value, assignValue, child) {
      return PopScope(
          canPop: true,
          onPopInvoked: (didPop) {
            value.onBack(context, false);
            if (didPop) return;
          },
          child: StatefulWrapper(
              onInit: () => value.onReady(
                  context) /* () => Future.delayed(const Duration(milliseconds: 150),
                  () => value.onReady(context)) */
              ,
              child: Scaffold(
                  appBar: AppBarCommon(
                      title: translations!.acceptedBooking,
                      onTap: () => value.onBack(context, true)),
                  body: RefreshIndicator(
                      onRefresh: () async {
                        value.onRefresh(context);
                      },
                      child: value.isLoading == true
                          ? const BookingDetailShimmer()
                          : value.bookingModel == null
                              ? const BookingDetailShimmer()
                              : const AcceptedBookingBodyLayout()))));
    });
  }
}
