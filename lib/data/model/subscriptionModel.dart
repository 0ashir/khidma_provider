class SubscriptionInformation {
  final String? subscriptionId;
  final String? isSubscriptionActive;
  final String? translatedStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  //0-pending 1-success 2-failed
  final String? isPayment;
  final String? id;
  final String? partnerId;
  final String? purchaseDate;
  final String? expiryDate;
  final String? name;
  final String? translatedName;
  final String? description;
  final String? translatedDescription;
  final String? duration;
  final String? price;
  final String? priceWithTax;
  final String? discountPrice;
  final String? discountPriceWithTax;
  final String? orderType;
  final String? maxOrderLimit;
  final String? isCommision;
  final String? commissionThreshold;
  final String? commissionPercentage;
  final String? publish;
  final String? taxId;
  final String? taxType;
  final String? taxPercenrage;
  final bool? isOneTimePurchase;

  /// Currency of the plan's amounts; empty / null → system currency.
  final String? currency;
  final String? currencySymbol;
  final int? currencyDecimalPlaces;

  SubscriptionInformation({
    this.priceWithTax,
    this.discountPriceWithTax,
    this.subscriptionId,
    this.isSubscriptionActive,
    this.translatedStatus,
    this.createdAt,
    this.updatedAt,
    this.isPayment,
    this.id,
    this.partnerId,
    this.purchaseDate,
    this.expiryDate,
    this.name,
    this.translatedName,
    this.description,
    this.translatedDescription,
    this.duration,
    this.price,
    this.discountPrice,
    this.orderType,
    this.maxOrderLimit,
    this.isCommision,
    this.commissionThreshold,
    this.commissionPercentage,
    this.publish,
    this.taxId,
    this.taxType,
    this.taxPercenrage,
    this.isOneTimePurchase,
    this.currency,
    this.currencySymbol,
    this.currencyDecimalPlaces,
  });

  factory SubscriptionInformation.fromJson(Map<String, dynamic> json) {
    return SubscriptionInformation(
      subscriptionId: json["subscription_id"]?.toString() ?? '',
      isSubscriptionActive: json["isSubscriptionActive"]?.toString() ?? '',
      translatedStatus: json["translated_status"]?.toString() ?? '',
      //0-pending 1-success 2-failed
      isPayment: json["is_payment"]?.toString() ?? '',
      id: json["id"]?.toString() ?? '',
      partnerId: json["partner_id"]?.toString() ?? '',
      purchaseDate: json["purchase_date"]?.toString() ?? '',
      expiryDate: json["expiry_date"]?.toString() ?? '',
      name: json["name"]?.toString() ?? '',
      translatedName: json["translated_name"]?.toString() ?? '',
      description: json["description"]?.toString() ?? '',
      translatedDescription: json["translated_description"]?.toString() ?? '',
      duration: json["duration"]?.toString() ?? '',
      price: json["price"]?.toString() ?? '',
      discountPrice: json["discount_price"]?.toString() ?? '',
      orderType: json["order_type"]?.toString() ?? '',
      maxOrderLimit: json["max_order_limit"]?.toString() ?? '',
      isCommision: json["is_commision"]?.toString() ?? '',
      commissionThreshold: json["commission_threshold"]?.toString() ?? '',
      commissionPercentage: json["commission_percentage"]?.toString() ?? '',
      publish: json["publish"]?.toString() ?? '',
      taxId: json["tax_id"]?.toString() ?? '',
      taxType: json["tax_type"]?.toString() ?? '',
      discountPriceWithTax: json["price_with_tax"]?.toString() ?? '',
      priceWithTax: json["original_price_with_tax"]?.toString() ?? '',
      taxPercenrage: json["tax_percentage"] != ''
          ? double.parse(
              (json["tax_percentage"] ?? "0").toString(),
            ).round().toString()
          : "0",
      isOneTimePurchase: json["is_one_time_purchase"]?.toString() == '1',
      currency: json["currency"]?.toString(),
      currencySymbol: json["currency_symbol"]?.toString(),
      currencyDecimalPlaces: int.tryParse(
        json["currency_decimal_places"]?.toString() ?? '',
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    "subscription_id": subscriptionId,
    "isSubscriptionActive": isSubscriptionActive,
    "translated_status": translatedStatus,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "is_payment": isPayment,
    "id": id,
    "partner_id": partnerId,
    "name": name,
    "translated_name": translatedName,
    "description": description,
    "translated_description": translatedDescription,
    "duration": duration,
    "price": price,
    "discount_price": discountPrice,
    "order_type": orderType,
    "max_order_limit": maxOrderLimit,
    "is_commision": isCommision,
    "commission_threshold": commissionThreshold,
    "commission_percentage": commissionPercentage,
    "publish": publish,
    "tax_id": taxId,
    "tax_type": taxType,
    "purchase_date": purchaseDate,
    "expiry_date": expiryDate,
    "price_with_tax": discountPriceWithTax,
    "original_price_with_tax": priceWithTax,
    "tax_percentage": taxPercenrage,
    "is_one_time_purchase": isOneTimePurchase == true ? "1" : "0",
    "currency": currency,
    "currency_symbol": currencySymbol,
    "currency_decimal_places": currencyDecimalPlaces,
  };
}
