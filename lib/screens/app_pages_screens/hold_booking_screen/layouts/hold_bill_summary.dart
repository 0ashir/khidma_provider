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
          if (bookingModel?.subtotal != null && bookingModel?.subtotal != 0)
            BillRowCommon(
                    title: symbolPosition
                        ? "${(bookingModel!.requiredServicemen != null ? bookingModel!.requiredServicemen! : 0) + (bookingModel!.totalExtraServicemen != null ? bookingModel!.totalExtraServicemen! : 0)} ${language(context, translations!.serviceman)} (${getSymbol(context)}${(currency(context).currencyVal * bookingModel!.perServicemanCharge!).toStringAsFixed(2)} × ${(bookingModel!.requiredServicemen != null ? bookingModel!.requiredServicemen! : 0) + (bookingModel!.totalExtraServicemen != null ? bookingModel!.totalExtraServicemen! : 0)})"
                        : "${(bookingModel!.requiredServicemen != null ? bookingModel!.requiredServicemen! : 0) + (bookingModel!.totalExtraServicemen != null ? bookingModel!.totalExtraServicemen! : 0)} ${language(context, translations!.serviceman)} (${(currency(context).currencyVal * bookingModel!.perServicemanCharge!).toStringAsFixed(2)} × ${(bookingModel!.requiredServicemen != null ? bookingModel!.requiredServicemen! : 0) + (bookingModel!.totalExtraServicemen != null ? bookingModel!.totalExtraServicemen! : 0)}${getSymbol(context)})",
                    price: symbolPosition
                        ? "${getSymbol(context)}${(currency(context).currencyVal * bookingModel!.subtotal!).toStringAsFixed(2)}"
                        : "${(currency(context).currencyVal * bookingModel!.subtotal!).toStringAsFixed(2)}${getSymbol(context)}",
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