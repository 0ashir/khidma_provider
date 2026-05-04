import '../../../../config.dart';

class AcceptBillSummary extends StatelessWidget {
  final BookingModel? bookingModel;

  const AcceptBillSummary({super.key, this.bookingModel});

  @override
  Widget build(BuildContext context) {
    final price = bookingModel?.service?.price ?? 0.0;
    final requiredServicemen = bookingModel?.service?.requiredServicemen ?? 1;
    final selectedRequiredServiceMan =
        bookingModel?.service?.selectedRequiredServiceMan ?? 1;
    final serviceRate = bookingModel?.service?.serviceRate ?? 0.0;

    final currencyVal = currency(context).currencyVal;

    double totalPrice = (currencyVal *
        ((price / requiredServicemen) * selectedRequiredServiceMan));
    double baseRate =
        (currencyVal * (serviceRate * selectedRequiredServiceMan));
    double difference = totalPrice - baseRate;
    String formattedDifference =
        appSettingModel?.general?.defaultCurrency?.symbolPosition == "left"
            ? "-${getSymbol(context)}${difference.toStringAsFixed(2)}"
            : "-${difference.toStringAsFixed(2)}${getSymbol(context)}";
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(appColor(context).appTheme.isDark
                    ? eImageAssets.bookingDetailBg
                    : eImageAssets.pendingBillBg),
                fit: BoxFit.fill)),
        child: Column(children: [
          //service price //discount //required serviceman //addons //platform fees //taxes //total amount
          if (bookingModel?.service?.price != null &&
              bookingModel?.service?.price != 0)
            BillRowCommon(
                    title: translations!.servicePrice ??
                        appFonts
                            .servicePrice /* translations!.perServiceCharge */,
                    price: symbolPosition
                        ? "${getSymbol(context)}${((currency(context).currencyVal * (bookingModel?.service?.price ?? 0)).toStringAsFixed(2))}"
                        : "${((currency(context).currencyVal * (bookingModel?.service?.price ?? 0)).toStringAsFixed(2))}${getSymbol(context)}")
                .marginOnly(bottom: Insets.i10),

          if (bookingModel!.service?.discount != null &&
              bookingModel!.service?.discount != 0)
            BillRowCommon(
                    color: appColor(context).appTheme.red,
                    title:
                        "${translations!.appliedDiscount ?? appFonts.appliedDiscount} (${bookingModel!.service!.discount}%)",
                    price: formattedDifference)
                .marginOnly(bottom: Insets.i10),
          if (bookingModel?.totalExtraServicemenCharge != null &&
              bookingModel?.totalExtraServicemenCharge != 0)
            BillRowCommon(
                    title: symbolPosition
                        ? "${(bookingModel!.requiredServicemen != null ? bookingModel!.requiredServicemen! : 0) + (bookingModel!.totalExtraServicemen != null ? bookingModel!.totalExtraServicemen! : 0)} ${language(context, translations!.serviceman)} (${getSymbol(context)}${bookingModel?.perServicemanCharge} × ${(bookingModel!.requiredServicemen != null ? bookingModel!.requiredServicemen! : 0) + (bookingModel!.totalExtraServicemen != null ? bookingModel!.totalExtraServicemen! : 0)})"
                        : "${(bookingModel!.requiredServicemen != null ? bookingModel!.requiredServicemen! : 0) + (bookingModel!.totalExtraServicemen != null ? bookingModel!.totalExtraServicemen! : 0)} ${language(context, translations!.serviceman)} (${bookingModel?.perServicemanCharge}${getSymbol(context)} × ${(bookingModel!.requiredServicemen != null ? bookingModel!.requiredServicemen! : 0) + (bookingModel!.totalExtraServicemen != null ? bookingModel!.totalExtraServicemen! : 0)})",
                    price: symbolPosition
                        ? "${getSymbol(context)}${bookingModel?.totalExtraServicemenCharge.toStringAsFixed(2)}"
                        : "${bookingModel?.totalExtraServicemenCharge.toStringAsFixed(2)}${getSymbol(context)}",
                    style: appCss.dmDenseBold14
                        .textColor(appColor(context).appTheme.darkText))
                .marginOnly(bottom: Insets.i10),
          if (bookingModel!.additionalServices != null)
            ...bookingModel!.additionalServices!.map((charge) {
              return (charge.totalPrice != null && charge.totalPrice != 0)
                  ? BillRowCommon(
                          title:
                              "${charge.title} (\$${charge.price} × ${charge.qty})",
                          color: appColor(context).appTheme.green,
                          price: symbolPosition
                              ? "+${getSymbol(context)}${charge.totalPrice?.toStringAsFixed(2)}"
                              : "+${charge.totalPrice?.toStringAsFixed(2)}${getSymbol(context)}")
                      .padding(bottom: Insets.i10)
                  : Container();
            }),
          if (bookingModel?.platformFees != null &&
              bookingModel?.platformFees != 0)
            BillRowCommon(
                    title: translations!.platformFees,
                    price: symbolPosition
                        ? "+${getSymbol(context)}${(currency(context).currencyVal * (bookingModel!.platformFees ?? 0.0)).toStringAsFixed(2)}"
                        : "+${(currency(context).currencyVal * (bookingModel!.platformFees ?? 0.0)).toStringAsFixed(2)}${getSymbol(context)}",
                    color: appColor(context).appTheme.online)
                .marginOnly(bottom: Insets.i10),
          if (bookingModel!.taxes != null && bookingModel!.taxes!.isNotEmpty)
            ...bookingModel!.taxes!.map((tax) {
              return (tax.amount != null && tax.amount != 0)
                  ? BillRowCommon(
                          title:
                              "${translations!.tax} (${tax.name} ${tax.rate?.toStringAsFixed(0)}%)",
                          price: symbolPosition
                              ? "+${getSymbol(context)}${tax.amount.toStringAsFixed(2)}"
                              : "+${tax.amount.toStringAsFixed(2)}${getSymbol(context)}",
                          color: appColor(context).appTheme.online)
                      .paddingOnly(bottom: Insets.i20)
                  : Container();
            }),
          /*  BillRowCommon(
              title: translations!.tax,
              price:
                  "+${getSymbol(context)}${(currency(context).currencyVal * (bookingModel!.tax ?? 0.0))}",
              color: appColor(context).appTheme.online), */

          Divider(
                  color: appColor(context).appTheme.stroke,
                  thickness: 1,
                  height: 1,
                  indent: 6,
                  endIndent: 6)
              .paddingOnly(bottom: Insets.i23),
          BillRowCommon(
              title: translations!.totalAmount,
              price: symbolPosition
                  ? "${getSymbol(context)}${(currency(context).currencyVal * double.parse(bookingModel!.total.toString()))}"
                  : "${(currency(context).currencyVal * double.parse(bookingModel!.total.toString()))}${getSymbol(context)}",
              styleTitle: appCss.dmDenseMedium14
                  .textColor(appColor(context).appTheme.darkText),
              style: appCss.dmDenseBold16
                  .textColor(appColor(context).appTheme.primary))
        ]).paddingSymmetric(vertical: Insets.i20));
  }
}
