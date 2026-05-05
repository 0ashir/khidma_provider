import '../../../../config.dart';

class CompletedBookingPaymentSummaryLayout extends StatelessWidget {
  final BookingModel? bookingModel;

  const CompletedBookingPaymentSummaryLayout({super.key, this.bookingModel});

  @override
  Widget build(BuildContext context) {
    if (bookingModel == null) return const SizedBox.shrink();

    final paymentMethod = bookingModel!.paymentMethod ?? '';
    final isCompleted = paymentMethod == "on_hand" ||
        bookingModel!.bookingStatus?.slug == "completed";

    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(appColor(context).appTheme.isDark
                    ? eImageAssets.completedBg
                    : eImageAssets.paymentSummary),
                fit: BoxFit.fill)),
        child: Column(children: [
          if (paymentMethod.isNotEmpty)
            BillRowCommon(
                title: translations!.methodType,
                price: capitalizeFirstLetter(paymentMethod)),
          const VSpace(10),
          BillRowCommon(
                  title: translations!.status,
                  price: isCompleted ? "Completed" : "Pending",
                  style: appCss.dmDenseMedium14
                      .textColor(appColor(context).appTheme.online))
              .padding(bottom: 10),
        ]).padding(bottom: 10, vertical: Insets.i15));
  }
}
