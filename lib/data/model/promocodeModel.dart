class PromocodeModel {
  String? id;
  String? partnerId;
  String? partnerName;
  String? promoCode;
  String? message;
  String? translatedMessage;
  String? startDate;
  String? endDate;
  String? noOfUsers;
  String? minimumOrderAmount;
  String? discount;
  String? discountType;
  String? maxDiscountAmount;
  String? repeatUsage;
  String? noOfRepeatUsage;
  String? image;
  String? status;
  String? createdAt;
  String? totalUsedNumber;
  Map<String, String>? translatedMessages;

  PromocodeModel({
    this.id,
    this.partnerId,
    this.partnerName,
    this.promoCode,
    this.message,
    this.translatedMessage,
    this.startDate,
    this.endDate,
    this.noOfUsers,
    this.minimumOrderAmount,
    this.discount,
    this.discountType,
    this.maxDiscountAmount,
    this.repeatUsage,
    this.noOfRepeatUsage,
    this.image,
    this.status,
    this.totalUsedNumber,
    this.createdAt,
    this.translatedMessages,
  });

  PromocodeModel.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString() ?? '';
    promoCode = json['promo_code']?.toString() ?? '';
    partnerId = json['partner_id']?.toString() ?? '';
    startDate = json['start_date']?.toString() ?? '';
    endDate = json['end_date']?.toString() ?? '';
    minimumOrderAmount = json['minimum_order_amount']?.toString() ?? '';
    discount = json['discount']?.toString() ?? '';
    discountType = json['discount_type']?.toString() ?? '';
    maxDiscountAmount = json['max_discount_amount']?.toString() ?? '';
    status = json['status']?.toString() ?? '';
    message = json['message']?.toString() ?? '';
    translatedMessage = json['translated_message']?.toString() ?? '';
    image = json['image']?.toString() ?? '';
    noOfUsers = json['no_of_users']?.toString() ?? '';
    totalUsedNumber = json['total_used_number']?.toString() ?? '0';
    repeatUsage = json['repeat_usage']?.toString() ?? '';
    partnerName = json['partner_name']?.toString() ?? '';
    noOfRepeatUsage = json['no_of_repeat_usage']?.toString() ?? '';
    createdAt = json['created_at']?.toString() ?? '';

    // Parse translated_fields for multi-language messages
    if (json['translated_fields'] != null &&
        json['translated_fields']['message'] != null) {
      translatedMessages = {};
      final translatedMessageData =
          json['translated_fields']['message'] as Map<String, dynamic>;
      translatedMessageData.forEach((key, value) {
        translatedMessages![key] = value.toString();
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['partner_id'] = partnerId;
    data['partner_name'] = partnerName;
    data['promo_code'] = promoCode;
    data['message'] = message;
    data['translated_message'] = translatedMessage;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['no_of_users'] = noOfUsers;
    data['minimum_order_amount'] = minimumOrderAmount;
    data['discount'] = discount;
    data['discount_type'] = discountType;
    data['max_discount_amount'] = maxDiscountAmount;
    data['repeat_usage'] = repeatUsage;
    data['no_of_repeat_usage'] = noOfRepeatUsage;
    data['image'] = image;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['total_used_number'] = totalUsedNumber;
    return data;
  }

  @override
  String toString() {
    return 'PromocodeModel(id: $id, partnerId: $partnerId, partnerName: $partnerName, promoCode: $promoCode, message: $message,translatedMessage:$translatedMessage startDate: $startDate, endDate: $endDate, noOfUsers: $noOfUsers, minimumOrderAmount: $minimumOrderAmount, discount: $discount, discountType: $discountType, maxDiscountAmount: $maxDiscountAmount, repeatUsage: $repeatUsage, noOfRepeatUsage: $noOfRepeatUsage, image: $image, status: $status, createdAt: $createdAt)';
  }
}
