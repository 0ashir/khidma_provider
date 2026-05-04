import 'dart:developer';

import '../../../../config.dart';

class CancelledBillSummary extends StatelessWidget {
  final BookingModel? bookingModel;

  const CancelledBillSummary({super.key, this.bookingModel});

  @override
  Widget build(BuildContext context) {
    final price = bookingModel!.service?.price ?? 0;
    final discount = bookingModel!.service?.discount ?? 0;

    final discountedAmount = discount > 0 ? (price * discount / 100) : 0;
    final requiredServicemen = bookingModel?.service?.requiredServicemen ?? 1;
    final selectedRequiredServiceMan =
        bookingModel?.service?.selectedRequiredServiceMan ?? 1;
    final serviceRate = bookingModel?.service?.serviceRate ?? 0.0;

    final currencyVal = currency(context).currencyVal;
    final totalValue =
        double.tryParse(bookingModel?.total.toString() ?? '') ?? 0;
    double totalPrice = (currencyVal *
        ((price / requiredServicemen) * selectedRequiredServiceMan));

    double baseRate =
        (currencyVal * (serviceRate * selectedRequiredServiceMan));
    log("bookingModel?.subtotal::${baseRate}///$totalPrice");

    dynamic difference = totalPrice - (bookingModel?.subtotal ?? 0);
    String formattedDifference = symbolPosition
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
          //service //discount //required serviceman //addons //platform fees //taxes //total amount
          if (bookingModel?.service?.price != null &&
              bookingModel?.service?.price != 0)
            BillRowCommon(
                title: translations!.servicePrice,
                price: symbolPosition
                    ? "${getSymbol(context)}${bookingModel?.service?.price?.toStringAsFixed(2)}"
                    : "${bookingModel?.service?.price?.toStringAsFixed(2)}${getSymbol(context)}"),
          if (bookingModel!.service?.discount != null &&
              bookingModel!.service?.discount != 0)
            BillRowCommon(
                    color: appColor(context).appTheme.red,
                    title:
                        "${translations!.appliedDiscount ?? appFonts.appliedDiscount} ",
                    //(${bookingModel!.service!.discount}%)
                    price: symbolPosition
                        ? "-${getSymbol(context)}${bookingModel?.service?.discountAmount}"
                        : "-${bookingModel?.service?.discountAmount}${getSymbol(context)}")
                .marginOnly(bottom: Insets.i10, top: Insets.i10),
          /* if (bookingModel?.coupon != null)
            BillRowCommon(
                title:
                "Coupon discount ( ${bookingModel!.coupon!.amount}${bookingModel!.coupon!.type == "percentage" ? "%" : "off"})",
                price:
                "-${getSymbol(context)}${currency(context).currencyVal * bookingModel!.couponTotalDiscount!}",
                style: appCss.dmDenseMedium14
                    .textColor(appColor(context).appTheme.red)),*/
          if (bookingModel!.couponTotalDiscount != null &&
              bookingModel!.couponTotalDiscount != 0)
            BillRowCommon(
                color: appColor(context).appTheme.red,
                title: "Coupon discount",
                // "${"Coupon Document" /* appFonts.appliedDiscount */} ",
                //(${bookingModel!.service!.discount}%)
                price: symbolPosition
                    ? "-${getSymbol(context)} ${bookingModel!.couponTotalDiscount.toStringAsFixed(2)}"
                    : "-${bookingModel!.couponTotalDiscount.toStringAsFixed(2)}${getSymbol(context)}"),
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
                .paddingSymmetric(vertical: Insets.i10),
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
                        ? "+${getSymbol(context)}${(currency(context).currencyVal * (bookingModel?.platformFees ?? 0.0)).toStringAsFixed(2)}"
                        : "+${(currency(context).currencyVal * (bookingModel?.platformFees ?? 0.0)).toStringAsFixed(2)}${getSymbol(context)}",
                    color: appColor(context).appTheme.online)
                .padding(/* top: Insets.i10, */ bottom: Insets.i10),
          if (bookingModel?.taxes != null && bookingModel!.taxes!.isNotEmpty)
            ...bookingModel!.taxes!.map((tax) {
              double rate = tax.rate ?? 0;

              return (tax.amount != null && tax.amount != 0)
                  ? BillRowCommon(
                          title:
                              "${translations!.tax} (${tax.name} ${rate.toStringAsFixed(0)}%)",
                          price: "+${getSymbol(context)}${tax.amount}",
                          color: appColor(context).appTheme.online)
                      .paddingOnly(bottom: Insets.i10)
                  : Container();
            }),

          if (bookingModel!.taxes != null && bookingModel!.taxes!.isNotEmpty)
            const VSpace(Sizes.s20),
          /*  BillRowCommon(
            title:
                "${(bookingModel!.requiredServicemen != null ? bookingModel!.requiredServicemen! : 0) + (bookingModel!.totalExtraServicemen != null ? bookingModel!.totalExtraServicemen! : 0)} ${language(context, translations!.serviceman)} (${getSymbol(context)}${((currency(context).currencyVal * (bookingModel?.service?.price ?? 0)).toStringAsFixed(2))} × ${(bookingModel!.requiredServicemen != null ? bookingModel!.requiredServicemen! : 0) + (bookingModel!.totalExtraServicemen != null ? bookingModel!.totalExtraServicemen! : 0)})",
            /* () {
              final servicemenCount = (bookingModel?.requiredServicemen ?? 0) +
                  (bookingModel?.totalExtraServicemen ?? 0);
              final perServicemanCharge =
                  bookingModel?.perServicemanCharge != null
                      ? (currency(context).currencyVal *
                              bookingModel!.perServicemanCharge!)
                          .toStringAsFixed(2)
                      : 0.0;
              final servicemanLabel = translations?.serviceman ?? 'serviceman';

              return "$servicemenCount ${language(context, servicemanLabel)} (${getSymbol(context)}$perServicemanCharge × $servicemenCount)";
            }() */
            price:
                "${getSymbol(context)}${(currency(context).currencyVal * (bookingModel?.service?.price ?? 0) * (bookingModel!.requiredServicemen != null ? bookingModel!.requiredServicemen! : 0) + (bookingModel!.totalExtraServicemen != null ? bookingModel!.totalExtraServicemen! : 0)).toStringAsFixed(2)}",
            /* bookingModel?.subtotal != null
                ? "${getSymbol(context)}${(currency(context).currencyVal * bookingModel?.subtotal).toStringAsFixed(2)}"
                : "${getSymbol(context)}0.0", */
            style: appCss.dmDenseMedium14
                .textColor(appColor(context).appTheme.darkText),
          ).paddingSymmetric(vertical: Insets.i18), */

          // if (bookingModel?.coupon != null) const VSpace(Sizes.s18),
          /* BillRowCommon(
              title: translations!.tax,
              price:
                  "+${getSymbol(context)}${(currency(context).currencyVal * (bookingModel!.tax ?? 0.0)!)}",
              color: appColor(context).appTheme.online), */
          Divider(
                  color: appColor(context).appTheme.stroke,
                  thickness: 1,
                  height: 1,
                  endIndent: 6,
                  indent: 6)
              .paddingOnly(bottom: Insets.i20),
          BillRowCommon(
                  title: translations!.totalAmount,
                  price: symbolPosition
                      ? "${getSymbol(context)}${((currency(context).currencyVal) * totalValue).toStringAsFixed(2)}"
                      : "${((currency(context).currencyVal) * totalValue).toStringAsFixed(2)}${getSymbol(context)}",
                  styleTitle: appCss.dmDenseMedium14
                      .textColor(appColor(context).appTheme.darkText),
                  style: appCss.dmDenseBold16
                      .textColor(appColor(context).appTheme.primary))
              .paddingOnly(bottom: Insets.i10)
        ]).paddingSymmetric(vertical: Insets.i20));
  }
}
