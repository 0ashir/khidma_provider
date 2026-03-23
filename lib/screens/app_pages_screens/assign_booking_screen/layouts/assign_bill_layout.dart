import '../../../../config.dart';

class AssignBillLayout extends StatelessWidget {
  final BookingModel? bookingModel;
  const AssignBillLayout({super.key, this.bookingModel});

  @override
  Widget build(BuildContext context) {
   
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(appColor(context).appTheme.isDark
                    ? eImageAssets.bookingDetailBg
                    : eImageAssets.pendingBillBg),
                fit: BoxFit.fill)),
        child: Column(children: [
          if (bookingModel?.service?.price != null &&
              bookingModel?.service?.price != 0)
            BillRowCommon(
                    title: translations!.servicePrice ??
                        appFonts
                            .servicePrice /* translations!.perServiceCharge */,
                    price: symbolPosition
                        ? "${getSymbol(context)}${((currency(context).currencyVal * (bookingModel?.service?.price ?? 0)).toStringAsFixed(2))}"
                        : "${((currency(context).currencyVal * (bookingModel?.service?.price ?? 0)).toStringAsFixed(2))}${getSymbol(context)}")
                .marginOnly(bottom: Insets.i20),
          if (bookingModel!.service?.discount != null &&
              bookingModel!.service?.discount != 0)
            BillRowCommon(
                    color: appColor(context).appTheme.red,
                    title:
                        "${translations!.appliedDiscount ?? appFonts.appliedDiscount} (${bookingModel!.service!.discount}%)",
                    price: symbolPosition
                        ? "${getSymbol(context)}${bookingModel?.service?.discountAmount}"
                        : "${getSymbol(context)}${bookingModel?.service?.discountAmount}")
                .marginOnly(bottom: Insets.i20),
          if (bookingModel?.totalExtraServicemenCharge != null &&
              bookingModel?.totalExtraServicemenCharge != 0)
            BillRowCommon(
                    title: symbolPosition
                        ? "${(bookingModel!.requiredServicemen != null ? bookingModel!.requiredServicemen! : 0) + (bookingModel!.totalExtraServicemen != null ? bookingModel!.totalExtraServicemen! : 0)} ${language(context, translations!.serviceman)} (${getSymbol(context)}${bookingModel?.perServicemanCharge} × ${(bookingModel!.requiredServicemen != null ? bookingModel!.requiredServicemen! : 0) + (bookingModel!.totalExtraServicemen != null ? bookingModel!.totalExtraServicemen! : 0)})"
                        : "${(bookingModel!.requiredServicemen != null ? bookingModel!.requiredServicemen! : 0) + (bookingModel!.totalExtraServicemen != null ? bookingModel!.totalExtraServicemen! : 0)} ${language(context, translations!.serviceman)} (${bookingModel?.perServicemanCharge} × ${(bookingModel!.requiredServicemen != null ? bookingModel!.requiredServicemen! : 0) + (bookingModel!.totalExtraServicemen != null ? bookingModel!.totalExtraServicemen! : 0)})",
                    price: symbolPosition
                        ? "${getSymbol(context)}${bookingModel?.totalExtraServicemenCharge.toStringAsFixed(2)}"
                        : "${getSymbol(context)}${bookingModel?.totalExtraServicemenCharge.toStringAsFixed(2)}${getSymbol(context)}",
                    style: appCss.dmDenseBold14
                        .textColor(appColor(context).appTheme.darkText))
                .padding(bottom: Insets.i20),

          /*   BillRowCommon(
              title: translations!.tax,
              price:
                  "+${getSymbol(context)}${(currency(context).currencyVal * (bookingModel!.tax ?? 0.0)).toStringAsFixed(2)}",
              color: appColor(context).appTheme.online), */
          if (bookingModel!.additionalServices != null)
            ...bookingModel!.additionalServices!.map((charge) {
              return (charge.totalPrice != null && charge.totalPrice != 0)
                  ? BillRowCommon(
                      title:
                          "${charge.title} (\$${charge.price} × ${charge.qty})",
                      color: appColor(context).appTheme.green,
                      price: symbolPosition
                          ? "+${getSymbol(context)}${charge.totalPrice?.toStringAsFixed(2)}"
                          : "+${charge.totalPrice?.toStringAsFixed(2)}${getSymbol(context)}",
                    ).padding(bottom: Insets.i20)
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
                .padding(bottom: Insets.i20),
          if (bookingModel!.taxes != null && bookingModel!.taxes!.isNotEmpty)
            ...bookingModel!.taxes!.map((tax) {
              double rate = tax.rate ?? 0;

              return (tax.amount != null && tax.amount != 0)
                  ? BillRowCommon(
                      title:
                          "${translations!.tax} (${tax.name} ${rate.toStringAsFixed(0)}%)",
                      price: symbolPosition
                          ? "+${getSymbol(context)}${(tax.amount).toStringAsFixed(2)}"
                          : "+${(tax.amount).toStringAsFixed(2)}${getSymbol(context)}",
                      color: appColor(context).appTheme.online,
                    ).paddingOnly(bottom: Insets.i20)
                  : Container();
            }),
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
                  ? "${getSymbol(context)}${(currency(context).currencyVal * double.parse(bookingModel!.total.toString())).toStringAsFixed(2)}"
                  : "${(currency(context).currencyVal * double.parse(bookingModel!.total.toString())).toStringAsFixed(2)}${getSymbol(context)}",
              styleTitle: appCss.dmDenseMedium14
                  .textColor(appColor(context).appTheme.darkText),
              style: appCss.dmDenseBold16
                  .textColor(appColor(context).appTheme.primary))
        ]).paddingSymmetric(vertical: Insets.i20));
  }
}
