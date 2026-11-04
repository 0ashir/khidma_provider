class CreatePromocodeModel {
  CreatePromocodeModel({
    this.promoCode,
    this.partnerId,
    this.promo_id,
    this.startDate,
    this.endDate,
    this.minimumOrderAmount,
    this.discount,
    this.discountType,
    this.maxDiscountAmount,
    this.status,
    this.image,
    this.repeat_usage,
    this.no_of_users,
    this.no_of_repeat_usage,
    this.message,
    this.multiLanguageMessages,
    this.translatedFieldsJson,
  });

  CreatePromocodeModel.fromJson(Map<String, dynamic> json) {
    promoCode = json['promo_code']?.toString() ?? '';
    partnerId = json['partner_id']?.toString() ?? '';
    startDate = json['start_date']?.toString() ?? '';
    promo_id = json['promo_id']?.toString() ?? '';
    endDate = json['end_date']?.toString() ?? '';
    minimumOrderAmount = json['minimum_order_amount']?.toString() ?? '';
    discount = json['discount']?.toString() ?? '';
    discountType = json['discount_type']?.toString() ?? '';
    maxDiscountAmount = json['max_discount_amount']?.toString() ?? '';
    status = json['status']?.toString() ?? '';
    message = json['message']?.toString() ?? '';
    image = json['image']?.toString() ?? '';
    no_of_users = json['no_of_users']?.toString() ?? '';
    no_of_repeat_usage = json['no_of_repeat_usage']?.toString() ?? '';
    repeat_usage = json['repeat_usage']?.toString() ?? '';

    // Parse translated_fields for multi-language messages
    if (json['translated_fields'] != null &&
        json['translated_fields']['message'] != null) {
      multiLanguageMessages = {};
      final translatedMessages =
          json['translated_fields']['message'] as Map<String, dynamic>;
      translatedMessages.forEach((key, value) {
        multiLanguageMessages![key] = value.toString();
      });
    }
  }
  String? promoCode;
  String? promo_id;
  String? partnerId;
  String? startDate;
  String? endDate;
  String? minimumOrderAmount;
  String? discount;
  String? discountType;
  String? maxDiscountAmount;
  String? status;
  String? message;
  String? no_of_users;
  dynamic image;
  String? repeat_usage;
  String? no_of_repeat_usage;
  Map<String, String>? multiLanguageMessages;
  String? translatedFieldsJson;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['promo_code'] = promoCode;
    data['partner_id'] = partnerId;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['minimum_order_amount'] = minimumOrderAmount;
    data['discount'] = discount;
    data['discount_type'] = discountType;
    data['max_discount_amount'] = maxDiscountAmount;
    data['status'] = status;
    data['message'] = message;
    data['no_of_users'] = no_of_users;
    data['image'] = image;
    data['promo_id'] = promo_id;
    data['repeat_usage'] = repeat_usage;
    data['no_of_repeat_usage'] = no_of_repeat_usage;

    // Add multi-language messages in translated_fields format
    // Priority: Use JSON encoded string if provided, otherwise use the map format
    if (translatedFieldsJson != null && translatedFieldsJson!.isNotEmpty) {
      data['translated_fields'] = translatedFieldsJson;
    } else if (multiLanguageMessages != null &&
        multiLanguageMessages!.isNotEmpty) {
      data['translated_fields'] = {'message': multiLanguageMessages};
    }

    return data;
  }
}
