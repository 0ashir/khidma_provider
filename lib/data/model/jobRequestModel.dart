import 'package:edemand_partner/app/generalImports.dart';

class JobRequestModel {
  String? id;
  String? userId;
  String? categoryId;
  String? serviceTitle;
  String? serviceShortDescription;
  String? minPrice;
  String? maxPrice;
  String? requestedStartDate;
  String? requestedStartTime;
  String? requestedEndDate;
  String? requestedEndTime;
  DateTime? requestStartDateTime;
  DateTime? requestEndDateTime;
  DateTime? createdAt;
  String? updatedAt;
  String? status;
  String? username;
  String? image;
  String? categoryName;
  String? categoryImage;
  String? partnerId;
  String? counterPrice;
  String? note;
  String? duration;
  String? customJobRequestId;
  String? customJobId;
  String? taxId;
  String? taxAmount;
  String? taxPercentage;
  String? finalTotal;

  /// Currency the request was created in (min/max/counter price, tax and final
  /// total all use it); empty when the API does not send it.
  String? currencySymbol;
  int? currencyDecimalPlaces;
  String? translatedServiceTitle;
  String? translatedServiceShortDescription;
  String? translatedCategoryName;
  bool? bidApplied;
  String? cancelReasonId;
  String? cancelReason;
  String? cancelAdditionalInfo;
  List<String>? files;

  JobRequestModel({
    this.id,
    this.userId,
    this.categoryId,
    this.serviceTitle,
    this.serviceShortDescription,
    this.minPrice,
    this.maxPrice,
    this.requestedStartDate,
    this.requestedStartTime,
    this.requestedEndDate,
    this.requestedEndTime,
    this.requestEndDateTime,
    this.requestStartDateTime,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.username,
    this.image,
    this.categoryName,
    this.categoryImage,
    this.partnerId,
    this.counterPrice,
    this.note,
    this.duration,
    this.customJobRequestId,
    this.customJobId,
    this.taxId,
    this.taxAmount,
    this.taxPercentage,
    this.finalTotal,
    this.currencySymbol,
    this.currencyDecimalPlaces,
    this.translatedServiceTitle,
    this.translatedServiceShortDescription,
    this.translatedCategoryName,
    this.bidApplied,
    this.cancelReasonId,
    this.cancelReason,
    this.cancelAdditionalInfo,
    this.files,
  });

  JobRequestModel.fromJson(Map<String, dynamic> json) {
    id = json["id"]?.toString() ?? '';
    userId = json["user_id"]?.toString() ?? '';
    categoryId = json["category_id"]?.toString() ?? '';
    serviceTitle = json["service_title"]?.toString() ?? '';
    serviceShortDescription =
        json["service_short_description"]?.toString() ?? '';
    minPrice = json["min_price"]?.toString() ?? '';
    maxPrice = json["max_price"]?.toString() ?? '';
    requestedStartDate = json["requested_start_date"]?.toString() ?? '';
    requestedStartTime = json["requested_start_time"]?.toString() ?? '';
    requestedEndDate = json["requested_end_date"]?.toString() ?? '';
    requestedEndTime = json["requested_end_time"]?.toString() ?? '';
    requestStartDateTime = DateTime.tryParse(
      json["request_start_datetime"]?.toString() ?? '',
    );
    requestEndDateTime = DateTime.tryParse(
      json["request_end_datetime"]?.toString() ?? '',
    );
    createdAt = DateTime.tryParse(json["created_at"]?.toString() ?? '');
    updatedAt = json["updated_at"]?.toString() ?? '';
    status = json["status"]?.toString() ?? '';
    username = json["username"]?.toString() ?? '';
    image = json["image"]?.toString() ?? '';
    categoryName = json["category_name"]?.toString() ?? '';
    categoryImage = json["category_image"]?.toString() ?? '';
    partnerId = json["partner_id"]?.toString() ?? '';
    counterPrice = json["counter_price"]?.toString() ?? '';
    note = json["note"]?.toString() ?? '';
    duration = json["duration"]?.toString() ?? '';
    customJobRequestId = json["custom_job_request_id"]?.toString() ?? '';
    customJobId = json["custom_job_id"]?.toString() ?? '';
    taxId = json["tax_id"]?.toString() ?? '';
    taxAmount = json["tax_amount"]?.toString() ?? '';
    taxPercentage = json["tax_percentage"]?.toString() ?? '';
    finalTotal = json["final_total"]?.toString() ?? '';
    currencySymbol = json["currency_symbol"]?.toString() ?? '';
    currencyDecimalPlaces = int.tryParse(
      json["currency_decimal_places"]?.toString() ?? '',
    );
    translatedServiceTitle =
        (json['translated_service_title']?.toString() ?? '').isNotEmpty
        ? json['translated_service_title'].toString()
        : (json['service_title']?.toString() ?? '');
    translatedServiceShortDescription =
        (json['translated_service_short_description']?.toString() ?? '')
            .isNotEmpty
        ? json['translated_service_short_description'].toString()
        : (json['service_short_description']?.toString() ?? '');
    translatedCategoryName =
        (json['translated_category_name']?.toString() ?? '').isNotEmpty
        ? json['translated_category_name'].toString()
        : (json['category_name']?.toString() ?? '');
    bidApplied = json["bid_applied"]?.toString() == '1';
    cancelReasonId = json["cancel_reason_id"]?.toString() ?? '';
    cancelReason = json["cancel_reason"]?.toString() ?? '';
    cancelAdditionalInfo = json["cancel_additional_info"]?.toString() ?? '';
    files = (json["files"] as List?)?.map((e) => e.toString()).toList() ?? [];
  }
}

extension JobRequestPriceFormat on JobRequestModel {
  /// [amount] in the request's own currency and decimal places.
  String formatPrice(final BuildContext context, final String? amount) =>
      (amount ?? '0')
          .replaceAll(',', '')
          .providerPriceFormat(
            context,
            currencySymbol: currencySymbol,
            decimalPlaces: currencyDecimalPlaces,
          );
}
