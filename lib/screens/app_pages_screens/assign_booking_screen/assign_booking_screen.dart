import '../../../config.dart';
import '../../bottom_screens/booking_screen/booking_shimmer/booking_detail_shimmer.dart';

class AssignBookingScreen extends StatelessWidget {
  const AssignBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AssignBookingProvider>(builder: (context1, value, child) {
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
                    onTap: () => value.onBack(context, true),
                    title: translations!.assignBooking),
                body: value.isLoading == true
                    ? const BookingDetailShimmer()
                    : value.isLoading == false && value.bookingModel == null
                        ? EmptyLayout(
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
                          )
                        : RefreshIndicator(
                            onRefresh: () async {
                              value.onRefresh(context);
                            },
                            child: const AssignBookingBodyWidget()))),
      );
    });
  }
}
