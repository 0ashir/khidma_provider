import '../../../../config.dart';

class OngoingBillSummary extends StatelessWidget {
  final BookingModel? bookingModel;

  const OngoingBillSummary({super.key, this.bookingModel});

  @override
  Widget build(BuildContext context) {
    if (bookingModel == null) return const SizedBox.shrink();

    final discount = double.tryParse(
            bookingModel!.service?.discountAmount?.toString() ?? "0") ??
        0.0;
    final hasExtraCharges = bookingModel!.extraCharges != null &&
        bookingModel!.extraCharges!.isNotEmpty;
    final hasTaxId = bookingModel!.service?.taxId != null;

    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(appColor(context).appTheme.isDark
                    ? eImageAssets.completedBillBg
                    : eImageAssets.ongoingBg),
                fit: BoxFit.fill)),
        child: Column(children: [
          if (bookingModel!.service?.price != null &&
              bookingModel!.service?.price != 0)
            BillRowCommon(
                    title: translations!.servicePrice,
                    price: symbolPosition
                        ? "${getSymbol(context)}${((currency(context).currencyVal * (bookingModel!.service?.price ?? 0)).toStringAsFixed(2))}"
                        : "${((currency(context).currencyVal * (bookingModel!.service?.price ?? 0)).toStringAsFixed(2))}${getSymbol(context)}")
                .marginOnly(bottom: Insets.i20),
          if (discount > 0)
            BillRowCommon(
                    color: appColor(context).appTheme.red,
                    title:
                        "${translations!.appliedDiscount ?? appFonts.appliedDiscount} (${bookingModel!.service?.discount}%)",
                    price: symbolPosition
                        ? "-${getSymbol(context)}${bookingModel!.service?.discountAmount}"
                        : "-${bookingModel!.service?.discountAmount}${getSymbol(context)}")
                .marginOnly(bottom: Insets.i20),
          if (bookingModel!.couponId != null &&
              bookingModel!.couponTotalDiscount != null &&
              bookingModel!.couponTotalDiscount != 0)
            BillRowCommon(
                title: "Coupon discount ",
                price: symbolPosition
                    ? "-${getSymbol(context)}${bookingModel!.couponTotalDiscount!}"
                    : "-${bookingModel!.couponTotalDiscount!}${getSymbol(context)}",
                style: appCss.dmDenseBold14
                    .textColor(appColor(context).appTheme.red)),
          if (bookingModel!.totalExtraServicemenCharge != null &&
              bookingModel!.totalExtraServicemenCharge != 0)
            BillRowCommon(
                    title: symbolPosition
                        ? "${(bookingModel!.requiredServicemen ?? 0) + (bookingModel!.totalExtraServicemen ?? 0)} ${language(context, translations!.serviceman)} (${getSymbol(context)}${bookingModel!.perServicemanCharge} × ${(bookingModel!.requiredServicemen ?? 0) + (bookingModel!.totalExtraServicemen ?? 0)})"
                        : "${(bookingModel!.requiredServicemen ?? 0) + (bookingModel!.totalExtraServicemen ?? 0)} ${language(context, translations!.serviceman)} (${bookingModel!.perServicemanCharge} × ${(bookingModel!.requiredServicemen ?? 0) + (bookingModel!.totalExtraServicemen ?? 0)})",
                    price: symbolPosition
                        ? "${getSymbol(context)}${bookingModel!.totalExtraServicemenCharge?.toStringAsFixed(2)}"
                        : "${bookingModel!.totalExtraServicemenCharge?.toStringAsFixed(2)}${getSymbol(context)}",
                    style: appCss.dmDenseBold14
                        .textColor(appColor(context).appTheme.darkText))
                .padding(bottom: Insets.i20),
          if (bookingModel!.additionalServices != null)
            ...bookingModel!.additionalServices!.map((charge) {
              return (charge.totalPrice != null && charge.totalPrice != 0)
                  ? BillRowCommon(
                          title:
                              "${charge.title} (\$${charge.price} × ${charge.qty})",
                          color: appColor(context).appTheme.green,
                          price: symbolPosition
                              ? "+${getSymbol(context)}${charge.totalPrice!.toStringAsFixed(2)}"
                              : "+${charge.totalPrice!.toStringAsFixed(2)}${getSymbol(context)}")
                      .padding(bottom: Insets.i20)
                  : Container();
            }),
          if (bookingModel!.platformFees != null &&
              bookingModel!.platformFees != 0)
            BillRowCommon(
                title: translations!.platformFees,
                price: symbolPosition
                    ? "+${getSymbol(context)}${(currency(context).currencyVal * (bookingModel!.platformFees ?? 0.0)).toStringAsFixed(2)}"
                    : "+${(currency(context).currencyVal * (bookingModel!.platformFees ?? 0.0)).toStringAsFixed(2)}${getSymbol(context)}",
                color: appColor(context).appTheme.online),
          const VSpace(Sizes.s20),
          if (hasTaxId && bookingModel!.taxes != null)
            ...bookingModel!.taxes!.map((tax) {
              double rate = tax.rate ?? 0;
              return (tax.amount != null && tax.amount != 0)
                  ? BillRowCommon(
                      title:
                          "${translations!.tax} (${tax.name} ${rate.toStringAsFixed(0)}%)",
                      price: symbolPosition
                          ? "+${getSymbol(context)}${tax.amount!.toStringAsFixed(2)}"
                          : "+${tax.amount!.toStringAsFixed(2)}${getSymbol(context)}",
                      color: appColor(context).appTheme.online,
                    ).paddingOnly(bottom: Insets.i20)
                  : Container();
            }),
          if (hasExtraCharges)
            ...bookingModel!.extraCharges!.asMap().entries.map((e) =>
                (e.value.perServiceAmount != null &&
                        e.value.perServiceAmount != 0)
                    ? BillRowCommon(
                            title:
                                "Extra service charge(${e.value.perServiceAmount} × ${e.value.noServiceDone})",
                            price: symbolPosition
                                ? "+${getSymbol(context)}${((e.value.noServiceDone ?? 1) * (currency(context).currencyVal * e.value.perServiceAmount!)).toStringAsFixed(2)}"
                                : "+${((e.value.noServiceDone ?? 1) * (currency(context).currencyVal * e.value.perServiceAmount!)).toStringAsFixed(2)}${getSymbol(context)}",
                            style: appCss.dmDenseBold14
                                .textColor(appColor(context).appTheme.green))
                        .paddingOnly(bottom: Insets.i20)
                    : Container()),
          if (hasExtraCharges && hasTaxId)
            BillRowCommon(
              title: language(context, translations!.tax),
              color: appColor(context).appTheme.green,
              price: symbolPosition
                  ? "+ ${getSymbol(context)}${bookingModel!.extraChargesTotal?.taxAmount?.toStringAsFixed(2)}"
                  : "+ ${bookingModel!.extraChargesTotal?.taxAmount?.toStringAsFixed(2)}${getSymbol(context)}",
            ).padding(bottom: Insets.i20),
          if (hasExtraCharges) const VSpace(Sizes.s10),
          Divider(color: appColor(context).appTheme.stroke)
              .paddingSymmetric(horizontal: Insets.i8),
          hasExtraCharges
              ? BillRowCommon(
                      title: translations!.amount,
                      price: symbolPosition
                          ? "${getSymbol(context)}${(currency(context).currencyVal * (bookingModel!.grandTotalWithExtras ?? 0)).toStringAsFixed(2)}"
                          : "${(currency(context).currencyVal * (bookingModel!.grandTotalWithExtras ?? 0)).toStringAsFixed(2)}${getSymbol(context)}",
                      styleTitle: appCss.dmDenseMedium14
                          .textColor(appColor(context).appTheme.darkText),
                      style: appCss.dmDenseBold16
                          .textColor(appColor(context).appTheme.primary))
                  .paddingOnly(bottom: Insets.i10)
              : BillRowCommon(
                      title: translations!.amount,
                      price: symbolPosition
                          ? "${getSymbol(context)}${bookingModel!.total}"
                          : "${bookingModel!.total}${getSymbol(context)}",
                      styleTitle: appCss.dmDenseMedium14
                          .textColor(appColor(context).appTheme.darkText),
                      style: appCss.dmDenseBold16
                          .textColor(appColor(context).appTheme.primary))
                  .paddingOnly(bottom: Insets.i3),
        ]).paddingSymmetric(vertical: Insets.i20));
  }
}
