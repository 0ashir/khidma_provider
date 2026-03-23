import 'package:fixit_provider/screens/bottom_screens/booking_screen/booking_shimmer/booking_detail_shimmer.dart';

import '../../../config.dart';

class BookingDetailsScreen extends StatelessWidget {
  const BookingDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingDetailsProvider>(builder: (context1, value, child) {
      return StatefulWrapper(
          onInit: () => Future.delayed(
              const Duration(milliseconds: 150), () => value.onReady(context)),
          child: LoadingComponent(
            child: Scaffold(
                appBar: AppBarCommon(title: translations!.bookingDetails),
                body: value.isLoading == true
                    ? BookingDetailShimmer()
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
                        : SingleChildScrollView(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                BookingDetailsLayout(data: value.bookingModel)
                              ]).padding(
                                horizontal: Insets.i20,
                                bottom: Insets.i10,
                                top: Insets.i5))),
          ));
    });
  }
}
