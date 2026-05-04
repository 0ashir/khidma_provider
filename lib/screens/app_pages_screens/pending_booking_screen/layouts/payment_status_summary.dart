import '../../../../config.dart';

class PaymentSummaryWidget extends StatelessWidget {
  final BookingModel booking;

  const PaymentSummaryWidget({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          language(context, translations!.paymentSummary),
          style: appCss.dmDenseSemiBold14
              .textColor(appColor(context).appTheme.darkText),
        ).paddingOnly(top: Insets.i15, bottom: Insets.i10),
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                isDark(context)
                    ? eImageAssets.paymentBillBgDark
                    : eImageAssets.paymentBillBg,
              ),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            children: [
              BillRowCommon(
                title: "${translations?.paymentMethod}",
                price: booking.paymentMethod,
              ).padding(bottom: Insets.i10),
              BillRowCommon(
                title: "${translations!.status}",
                price: "${booking.paymentStatus}",
              ).marginOnly(bottom: Insets.i10),
              if (booking.advancePaymentAmount != null &&
                  booking.advancePaymentAmount != 0)
                BillRowCommon(
                  title: "${translations!.advancePayment}",
                  price: symbolPosition
                      ? "${getSymbol(context)}${booking.advancePaymentAmount?.toStringAsFixed(2)}"
                      : "${booking.advancePaymentAmount?.toStringAsFixed(2)}${getSymbol(context)}",
                  color: appColor(context).appTheme.green,
                ).marginOnly(bottom: Insets.i10),
              if (booking.advancePaymentAmount != null &&
                  booking.advancePaymentAmount != 0)
                BillRowCommon(
                  title: "${translations!.advancePaymentStatus}",
                  price: "${booking.advancePaymentStatus}",
                  color: appColor(context).appTheme.green,
                ).padding(bottom: Insets.i10),
              if (booking.remainingPaymentAmount != null &&
                  booking.remainingPaymentAmount != 0)
                BillRowCommon(
                  title: "${translations!.remainingPayment}",
                  price: symbolPosition
                      ? "${getSymbol(context)}${booking.remainingPaymentAmount?.toStringAsFixed(2)}"
                      : "${booking.remainingPaymentAmount?.toStringAsFixed(2)}${getSymbol(context)}",
                ).padding(bottom: Insets.i10),
              if (booking.remainingPaymentAmount != null &&
                  booking.remainingPaymentAmount != 0)
                BillRowCommon(
                  title: "${translations!.remainingPaymentStatus}",
                  price: "${booking.remainingPaymentStatus}",
                ).padding(bottom: Insets.i10),
            ],
          ).paddingSymmetric(vertical: Insets.i20),
        ),
      ],
    );
  }
}
