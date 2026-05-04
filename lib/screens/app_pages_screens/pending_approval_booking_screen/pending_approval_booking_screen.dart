import '../../../config.dart';
import '../../bottom_screens/booking_screen/booking_shimmer/booking_detail_shimmer.dart';

class PendingApprovalBookingScreen extends StatelessWidget {
  const PendingApprovalBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PendingApprovalBookingProvider>(
        builder: (context, value, child) {
      return StatefulWrapper(
          onInit: () => Future.delayed(
              const Duration(milliseconds: 150), () => value.onReady(context)),
          child: LoadingComponent(
            child: Scaffold(
                appBar:
                    AppBarCommon(title: translations!.pendingApprovalBooking),
                body: value.isLoading == true
                    ? const BookingDetailShimmer()
                    : RefreshIndicator(
                        onRefresh: () async {
                          value.getBookingDetailById(context);
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
                                  if (isFreelancer != true)
                                    const ServicemenPayableLayout(
                                        amount: "30.36"),
                                  Text(
                                          language(context,
                                              translations!.billSummary),
                                          style: appCss.dmDenseMedium14
                                              .textColor(appColor(context)
                                                  .appTheme
                                                  .darkText))
                                      .paddingOnly(
                                          top: Insets.i25, bottom: Insets.i10),
                                  const PendingApprovalBillSummary(),
                                  const VSpace(Sizes.s20),
                                  // if (value.bookingModel!.service!.reviews !=
                                  //         null &&
                                  //     value.bookingModel!.service!.reviews!
                                  //         .isNotEmpty)
                                  //   ReviewListWithTitle(
                                  //       reviews: value
                                  //           .bookingModel!.service!.reviews!)
                                ]).padding(
                                    horizontal: Insets.i20,
                                    top: Insets.i20,
                                    bottom: Insets.i100)),
                            Material(
                                elevation: 20,
                                child: AssignStatusLayout(
                                    title:
                                        translations!.theServicemenNotApprove,
                                    status:
                                        translations!.status!.toUpperCase()))
                          ],
                        ),
                      )),
          ));
    });
  }
}
