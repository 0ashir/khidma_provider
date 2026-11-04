import 'package:flutter/material.dart';
import '../../../../app/generalImports.dart';
import 'expandableChargeRow.dart';
import 'taxBreakdownRows.dart';

typedef PaymentGatewayDetails = ({String paymentType, String paymentImage});

class PriceSectionWidget extends StatelessWidget {
  const PriceSectionWidget({
    super.key,
    required this.bookingsModel,
    required this.isBillDetailsCollapsed,
  });

  final BookingsModel bookingsModel;
  final ValueNotifier<bool> isBillDetailsCollapsed;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      color: context.colorScheme.secondaryColor,
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          _buildBillDetailsSection(context),
          const SizedBox(height: 10),
          _getPriceSectionTile(
            context: context,
            fontSize: 20,
            heading:
                (bookingsModel.paymentMethod == "cod"
                        ? "totalAmount".translate(context: context)
                        : 'paidAmount'.translate(context: context))
                    .translate(context: context),
            subHeading: _money(context, bookingsModel.finalTotal ?? '0'),
            textColor: context.colorScheme.blackColor,
            fontWeight: FontWeight.w700,
            subHeadingTextColor: context.colorScheme.accentColor,
          ),
          const SizedBox(height: 10),
          Divider(
            color: context.colorScheme.lightGreyColor,
            thickness: 0.5,
            height: 0.5,
          ),
          const SizedBox(height: 10),
          _buildPaymentModeWidget(context),
        ],
      ),
    );
  }

  Widget _buildBillDetailsSection(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isBillDetailsCollapsed,
      builder: (context, bool isCollapsed, _) {
        return Column(
          children: [
            CustomInkWellContainer(
              onTap: () {
                isBillDetailsCollapsed.value = !isBillDetailsCollapsed.value;
              },
              child: Row(
                children: [
                  Expanded(
                    child: CustomText(
                      "billDetails".translate(context: context),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: context.colorScheme.lightGreyColor,
                    ),
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: isCollapsed
                        ? Icon(
                            Icons.arrow_drop_down_sharp,
                            color: context.colorScheme.accentColor,
                            size: 24,
                          )
                        : Icon(
                            Icons.arrow_drop_up_sharp,
                            color: context.colorScheme.accentColor,
                            size: 24,
                          ),
                  ),
                ],
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              child: CustomContainer(
                constraints: isCollapsed
                    ? const BoxConstraints(maxHeight: 0.0)
                    : const BoxConstraints(
                        maxHeight: double.infinity,
                        maxWidth: double.maxFinite,
                      ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 10),
                    if (_hasTaxBreakdown)
                      ..._buildTaxBreakdownRows(context)
                    else
                      ..._buildLegacyRows(context),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  bool get _hasTaxBreakdown =>
      bookingsModel.taxBreakdown?.groups.isNotEmpty ?? false;

  String _money(BuildContext context, String amount) => amount
      .replaceAll(',', '')
      .priceFormat(
        context,
        currencySymbol: bookingsModel.currencySymbol,
        decimalPlaces: bookingsModel.currencyDecimalPlaces,
      );

  // Bookings placed before rule-based tax: no `tax_breakdown` in the response.
  List<Widget> _buildLegacyRows(BuildContext context) {
    return [
      _setServiceRowValues(
        title: 'totalServiceChargesLbl'.translate(context: context),
        quantity: '',
        price:
            (double.parse(bookingsModel.total!.toString().replaceAll(",", '')) -
                    double.parse(
                      bookingsModel.taxAmount!.toString().replaceAll(",", ''),
                    ))
                .toString(),
      ),
      const SizedBox(height: 5),
      if (bookingsModel.totalAdditionalChargeDouble != null &&
          bookingsModel.totalAdditionalChargeDouble! > 0)
        _setServiceRowValues(
          title: 'totalAdditionServiceChargesLbl'.translate(context: context),
          quantity: '',
          price: bookingsModel.totalAdditionalChargeDouble.toString(),
        ),
      if (bookingsModel.promoDiscount != '0') ...[
        const SizedBox(height: 5),
        _setServiceRowValues(
          title: 'couponDiscLbl'.translate(context: context),
          pricePrefix: "-",
          quantity: '',
          price: bookingsModel.promoDiscount!,
        ),
      ],
      if (bookingsModel.taxAmount != '' &&
          bookingsModel.taxAmount != null &&
          bookingsModel.taxAmount != "0" &&
          bookingsModel.taxAmount != "0.00")
        _setServiceRowValues(
          title: bookingsModel.taxType == 'included'
              ? "${"taxLbl".translate(context: context)} (${"included".translate(context: context)})"
              : "taxLbl".translate(context: context),
          price: bookingsModel.taxAmount!,
          quantity: '',
          pricePrefix: bookingsModel.taxType == 'included' ? null : "+",
        ),
      const SizedBox(height: 5),
      if (bookingsModel.visitingCharges != "0")
        _setServiceRowValues(
          title: 'visitingCharge'.translate(context: context),
          quantity: '',
          price: bookingsModel.visitingCharges!,
          pricePrefix: "+",
        ),
      if (bookingsModel.fees != null && bookingsModel.fees!.isNotEmpty) ...[
        const SizedBox(height: 5),
        ...bookingsModel.fees!.map(
          (fee) => Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: _setServiceRowValues(
              title: fee.title ?? '',
              quantity: '',
              price: fee.calculatedAmount ?? '0',
              pricePrefix: "+",
            ),
          ),
        ),
      ],
      const SizedBox(height: 5),
    ];
  }

  // Services, visiting charge and fees (each with its own tax), additional
  // charges and the promo, so the visible rows add up to `final_total`.
  List<Widget> _buildTaxBreakdownRows(BuildContext context) {
    final rows = <Widget>[
      TaxBreakdownRows(
        breakdown: bookingsModel.taxBreakdown!,
        fees: bookingsModel.fees,
        visitingCharges: bookingsModel.visitingCharges,
        currencySymbol: bookingsModel.currencySymbol,
        decimalPlaces: bookingsModel.currencyDecimalPlaces,
      ),
    ];

    final additionalCharges = bookingsModel.totalAdditionalChargeDouble ?? 0;
    if (additionalCharges > 0) {
      rows.add(
        _setServiceRowValues(
          title: 'totalAdditionServiceChargesLbl'.translate(context: context),
          quantity: '',
          price: additionalCharges.toString(),
          pricePrefix: '+',
        ),
      );
      rows.add(const SizedBox(height: 5));
    }

    final promoDiscount =
        double.tryParse(bookingsModel.promoDiscount ?? '') ?? 0;
    if (promoDiscount > 0) {
      final promoTax =
          double.tryParse(bookingsModel.promoTaxReduction ?? '') ?? 0;
      final code = bookingsModel.promoCode ?? '';
      final label =
          '${'couponDiscLbl'.translate(context: context)}${code.isEmpty ? '' : ' ($code)'}';
      // The discount comes off the price before tax, so the tax drops too: one
      // row for the total saving, its arrow explains the split.
      rows.add(
        promoTax > 0
            ? ExpandableChargeRow(
                key: const ValueKey('promo'),
                title: label,
                amount:
                    '- ${_money(context, (promoDiscount + promoTax).toString())}',
                details: [
                  ChargeDetailRow(
                    label: 'discountLbl'.translate(context: context),
                    amount: '- ${_money(context, promoDiscount.toString())}',
                  ),
                  ChargeDetailRow(
                    label: 'promoTaxReduction'.translate(context: context),
                    amount: '- ${_money(context, promoTax.toString())}',
                  ),
                ],
              )
            : _setServiceRowValues(
                title: label,
                quantity: '',
                price: promoDiscount.toString(),
                pricePrefix: '-',
              ),
      );
      rows.add(const SizedBox(height: 5));
    }
    return rows;
  }

  Widget _setServiceRowValues({
    required String title,
    required String quantity,
    required String price,
    String? pricePrefix,
    bool? isTitleBold,
    FontWeight? priceFontWeight,
  }) {
    return Builder(
      builder: (context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: CustomText(
              title,
              fontSize: 14,
              fontWeight: (isTitleBold ?? false)
                  ? FontWeight.bold
                  : ((title != 'serviceDetailsLbl'.translate(context: context))
                        ? FontWeight.w400
                        : FontWeight.w700),
              color: Theme.of(context).colorScheme.blackColor,
              maxLines: 1,
            ),
          ),
          if (quantity != '')
            Flexible(
              child: CustomText(
                (title == 'totalPriceLbl'.translate(context: context) ||
                        title ==
                            'totalServicePriceLbl'.translate(context: context))
                    ? "${"totalQtyLbl".translate(context: context)} $quantity"
                    : (title == 'gstLbl'.translate(context: context) ||
                          title == 'taxLbl'.translate(context: context))
                    ? quantity.formatPercentage()
                    : (title == 'couponDiscLbl'.translate(context: context))
                    ? "${quantity.formatPercentage()} ${"offLbl".translate(context: context)}"
                    : "${"qtyLbl".translate(context: context)} $quantity",
                fontSize: 14,
                textAlign: TextAlign.end,
                color: Theme.of(context).colorScheme.lightGreyColor,
              ),
            )
          else
            const SizedBox(),
          if (price != '')
            CustomText(
              pricePrefix != null
                  ? "$pricePrefix ${_money(context, price)}"
                  : _money(context, price),
              textAlign: TextAlign.end,
              fontSize: (title == 'totalPriceLbl'.translate(context: context))
                  ? 14
                  : 14,
              fontWeight: priceFontWeight ?? FontWeight.w500,
              color: Theme.of(context).colorScheme.blackColor,
            )
          else
            const SizedBox(),
        ],
      ),
    );
  }

  Widget _getPriceSectionTile({
    required final BuildContext context,
    required final String heading,
    required final String subHeading,
    required final Color textColor,
    final Color? subHeadingTextColor,
    required final double fontSize,
    final FontWeight? fontWeight,
  }) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      children: [
        Expanded(
          child: CustomText(
            heading,
            color: textColor,
            maxLines: 1,
            fontWeight: fontWeight,
            fontSize: fontSize,
          ),
        ),
        CustomText(
          subHeading,
          color: subHeadingTextColor ?? textColor,
          fontWeight: fontWeight,
          maxLines: 1,
          fontSize: fontSize,
        ),
      ],
    ),
  );

  Widget _buildPaymentModeWidget(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            CustomContainer(
              height: 44,
              width: 44,
              borderRadius: UiUtils.borderRadiusOf5,
              child: CustomSvgPicture(
                svgImage: _getPaymentGatewayDetails(
                  paymentMethod: bookingsModel.paymentMethod ?? '',
                ).paymentImage,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomText(
                    "paymentMode".translate(context: context),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: context.colorScheme.blackColor,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: CustomText(
                          _getPaymentGatewayDetails(
                            paymentMethod: bookingsModel.paymentMethod ?? '',
                          ).paymentType.translate(context: context),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: context.colorScheme.accentColor,
                        ),
                      ),
                      CustomText(
                        (bookingsModel.paymentStatus!.toLowerCase().isEmpty
                                ? 'pending'
                                : UiUtils.getPaymentStatus(
                                    bookingsModel.paymentStatus,
                                  ))
                            .translate(context: context),
                        color: UiUtils.getPaymentStatusColor(
                          paymentStatus: bookingsModel.paymentStatus ?? '',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  PaymentGatewayDetails _getPaymentGatewayDetails({
    required String paymentMethod,
  }) {
    switch (paymentMethod) {
      case "cod":
        return (paymentType: "cod", paymentImage: AppAssets.cod);
      case "stripe":
        return (paymentType: "stripe", paymentImage: AppAssets.icStripe);
      case "razorpay":
        return (paymentType: "razorpay", paymentImage: AppAssets.icRazorpay);
      case "paystack":
        return (paymentType: "paystack", paymentImage: AppAssets.icPaystack);
      case "paypal":
        return (paymentType: "paypal", paymentImage: AppAssets.icPaypal);
      case "xendit":
        return (paymentType: "xendit", paymentImage: AppAssets.icXendit);
      case "flutterwave":
        return (
          paymentType: "flutterwave",
          paymentImage: AppAssets.icFlutterwave,
        );
      case "cashfree":
        return (paymentType: "cashfree", paymentImage: AppAssets.icCashfree);
      default:
        return (paymentType: "cod", paymentImage: AppAssets.cod);
    }
  }
}
