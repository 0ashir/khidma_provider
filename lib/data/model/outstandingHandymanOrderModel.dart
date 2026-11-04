class OutstandingHandymanOrderModel {
  const OutstandingHandymanOrderModel({
    this.id,
    this.handymanId,
    this.orderId,
    this.amount,
    this.createdAt,
    this.customerName,
    this.handymanName,
    this.handymanImage,
    this.handymanEmail,
    this.handymanPhone,
    this.outstandingAmount,
    this.currency,
    this.currencySymbol,
    this.currencyDecimalPlaces,
  });

  factory OutstandingHandymanOrderModel.fromJson(Map<String, dynamic> json) {
    return OutstandingHandymanOrderModel(
      id: json['id']?.toString() ?? '',
      handymanId: json['handyman_id']?.toString() ?? '',
      orderId: json['order_id']?.toString() ?? '',
      amount: json['amount']?.toString() ?? '0',
      createdAt: json['created_at']?.toString() ?? '',
      customerName: json['customer_name']?.toString() ?? '',
      handymanName: json['handyman_name']?.toString() ?? '',
      handymanImage: json['handyman_image']?.toString() ?? '',
      handymanEmail: json['handyman_email']?.toString() ?? '',
      handymanPhone: json['handyman_phone']?.toString() ?? '',
      outstandingAmount: json['outstanding_amount']?.toString() ?? '0',
      currency: json['currency']?.toString() ?? '',
      currencySymbol: json['currency_symbol']?.toString(),
      currencyDecimalPlaces: int.tryParse(
        json['currency_decimal_places']?.toString() ?? '',
      ),
    );
  }

  final String? id;
  final String? handymanId;
  final String? orderId;
  final String? amount;
  final String? createdAt;
  final String? customerName;
  final String? handymanName;
  final String? handymanImage;
  final String? handymanEmail;
  final String? handymanPhone;
  final String? outstandingAmount;
  final String? currency;

  /// Currency of the order; null → provider's country currency.
  final String? currencySymbol;
  final int? currencyDecimalPlaces;
}
