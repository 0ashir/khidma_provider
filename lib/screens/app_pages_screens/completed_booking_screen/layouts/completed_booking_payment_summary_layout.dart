import '../../../../config.dart';

class CompletedBookingPaymentSummaryLayout extends StatelessWidget {
  final BookingModel? bookingModel;

  const CompletedBookingPaymentSummaryLayout({super.key, this.bookingModel});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(appColor(context).appTheme.isDark
                    ? eImageAssets.completedBg
                    : eImageAssets.paymentSummary),
                fit: BoxFit.fill)),
        child: Column(children: [
          // BillRowCommon(title: translations!.paymentId, price: "#544"),
          BillRowCommon(
              title: translations!.methodType,
              price: capitalizeFirstLetter(bookingModel!.paymentMethod!)),
          VSpace(10),
          BillRowCommon(
                  title: translations!.status,
                  price: bookingModel!.paymentMethod! == "on_hand" ||
                          bookingModel!.bookingStatus!.slug == "completed"
                      ? "Completed"
                      : "Pending",
                  style: appCss.dmDenseMedium14
                      .textColor(appColor(context).appTheme.online))
              .padding(bottom: 10),
        ]).padding(bottom: 10, vertical: Insets.i15));
  }
}
