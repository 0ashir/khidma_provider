import 'package:flutter/material.dart';
import '../../../../app/generalImports.dart';

class ServiceDetailsWidget extends StatelessWidget {
  const ServiceDetailsWidget({super.key, required this.bookingsModel});

  final BookingsModel bookingsModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomContainer(
          color: Theme.of(context).colorScheme.secondaryColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _getTitle(title: 'serviceDetailsLbl'),
                    const SizedBox(height: 8),
                    for (Services service in bookingsModel.services!) ...[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomContainer(
                              height: 40,
                              width: 40,
                              borderRadius: UiUtils.borderRadiusOf5,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  UiUtils.borderRadiusOf5,
                                ),
                                child: (service.image ?? '').isNotEmpty
                                    ? CustomCachedNetworkImage(
                                        imageUrl: service.image!,
                                        height: 40,
                                        width: 40,
                                        fit: BoxFit.cover,
                                      )
                                    : Icon(
                                        Icons.home_repair_service,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.accentColor,
                                      ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _setServiceRowValues(
                                title: service.serviceTitle!,
                                quantity: service.quantity!,
                                price: service.discountPrice != "0"
                                    ? service.discountPrice!
                                    : service.price!,
                                currencySymbol: bookingsModel.currencySymbol,
                                decimalPlaces:
                                    bookingsModel.currencyDecimalPlaces,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 5),
                    if (bookingsModel.additionalCharges != null &&
                        bookingsModel.additionalCharges!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _getTitle(
                              title: 'additionalServiceChargesDetailsLbl',
                            ),
                            const SizedBox(height: 8),
                            for (
                              int i = 0;
                              i < bookingsModel.additionalCharges!.length;
                              i++
                            ) ...[
                              _setServiceRowValues(
                                title:
                                    bookingsModel.additionalCharges![i]["name"],
                                quantity: '',
                                price: bookingsModel
                                    .additionalCharges![i]["charge"],
                                currencySymbol: bookingsModel.currencySymbol,
                                decimalPlaces:
                                    bookingsModel.currencyDecimalPlaces,
                              ),
                            ],
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              _showDivider(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _setServiceRowValues({
    required String title,
    required String quantity,
    required String price,
    String? pricePrefix,
    bool? isTitleBold,
    FontWeight? priceFontWeight,
    String? currencySymbol,
    int? decimalPlaces,
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
                  ? "$pricePrefix ${price.replaceAll(',', '').priceFormat(context, currencySymbol: currencySymbol, decimalPlaces: decimalPlaces)}"
                  : price
                        .replaceAll(',', '')
                        .priceFormat(
                          context,
                          currencySymbol: currencySymbol,
                          decimalPlaces: decimalPlaces,
                        ),
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

  Widget _getTitle({required String title, String? subTitle}) {
    return Builder(
      builder: (context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            title.translate(context: context),
            maxLines: 1,
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Theme.of(context).colorScheme.blackColor,
          ),
          if (subTitle != null) ...[
            const SizedBox(height: 5),
            CustomText(
              subTitle.translate(context: context),
              maxLines: 1,
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Theme.of(context).colorScheme.lightGreyColor,
            ),
          ],
        ],
      ),
    );
  }

  Widget _showDivider(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 0.5,
      color: Theme.of(context).colorScheme.lightGreyColor,
    );
  }
}
