import '../../../../config.dart';

class HoldBillSummary extends StatelessWidget {
  final BookingModel? bookingModel;
  const HoldBillSummary({super.key, this.bookingModel});

  @override
  Widget build(BuildContext context) {
    double currencyVal =
        double.tryParse(currency(context).currencyVal.toString()) ?? 1.0;
    double total =
        double.tryParse(bookingModel?.total.toString() ?? '0.0') ?? 0.0;

    double totalPrice = currencyVal * total;
    String formattedPrice = symbolPosition
        ? "${getSymbol(context)}${totalPrice.toStringAsFixed(2)}"
        : "${totalPrice.toStringAsFixed(2)}${getSymbol(context)}";
    final quantity = bookingModel?.quantity ?? 1;
    final unitPrice =
        currency(context).currencyVal * (bookingModel?.service?.price ?? 0);
    final quantityLabel =
        quantity > 1 ? translations!.services : translations!.service;
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(appColor(context).appTheme.isDark
                    ? eImageAssets.bookingDetailBg
                    : eImageAssets.pendingBillBg),
                fit: BoxFit.fill)),
        child: Column(children: [
          if (bookingModel?.perServicemanCharge != null &&
              bookingModel?.perServicemanCharge != 0)
            BillRowCommon(
                title: translations!.perServiceCharge,
                price: symbolPosition
                    ? "${getSymbol(context)}${(currency(context).currencyVal * bookingModel!.perServicemanCharge!).toStringAsFixed(2)}"
                    : "${(currency(context).currencyVal * bookingModel!.perServicemanCharge!).toStringAsFixed(2)}${getSymbol(context)}"),
          if (bookingModel?.service?.price != null)
            BillRowCommon(
                    title: symbolPosition
                        ? "$quantity ${language(context, quantityLabel)} (${getSymbol(context)}${unitPrice.toStringAsFixed(2)} × $quantity)"
                        : "$quantity ${language(context, quantityLabel)} (${unitPrice.toStringAsFixed(2)}${getSymbol(context)} × $quantity)",
                    price: symbolPosition
                        ? "${getSymbol(context)}${(unitPrice * quantity).toStringAsFixed(2)}"
                        : "${(unitPrice * quantity).toStringAsFixed(2)}${getSymbol(context)}",
                    style: appCss.dmDenseBold14
                        .textColor(appColor(context).appTheme.darkText))
                .paddingSymmetric(vertical: Insets.i20),
          if (bookingModel?.tax != null && bookingModel?.tax != 0)
            BillRowCommon(
                title: translations!.tax,
                price: symbolPosition
                    ? "+${getSymbol(context)}${(currency(context).currencyVal * (bookingModel?.tax ?? 0.0)).toStringAsFixed(2)}"
                    : "+${getSymbol(context)}${(currency(context).currencyVal * (bookingModel?.tax ?? 0.0)).toStringAsFixed(2)}",
                color: appColor(context).appTheme.online),
          if (bookingModel?.platformFees != null &&
              bookingModel?.platformFees != 0)
            BillRowCommon(
                    title: translations!.platformFees,
                    price: symbolPosition
                        ? "+${getSymbol(context)}${(currency(context).currencyVal * (bookingModel!.platformFees ?? 0.0)).toStringAsFixed(2)}"
                        : "+${(currency(context).currencyVal * (bookingModel!.platformFees ?? 0.0)).toStringAsFixed(2)}${getSymbol(context)}",
                    color: appColor(context).appTheme.online)
                .paddingSymmetric(vertical: Insets.i20),
          Divider(
              color: appColor(context).appTheme.stroke,
              thickness: 1,
              height: 1,
              indent: 6,
              endIndent: 6)
              .paddingOnly(bottom: Insets.i23),
          BillRowCommon(
              title: translations!.totalAmount,
              price: formattedPrice,
              styleTitle: appCss.dmDenseMedium14
                  .textColor(appColor(context).appTheme.darkText),
              style: appCss.dmDenseBold16
                  .textColor(appColor(context).appTheme.primary))
        ]).paddingSymmetric(vertical: Insets.i20));
  }
}