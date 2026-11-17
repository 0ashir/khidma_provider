import 'booking/assignedHandymanModel.dart';
import 'taxBreakdownModel.dart';

class BookingsModel {
  BookingsModel({
    this.id,
    this.customer,
    this.customerId,
    this.customerNo,
    this.customerEmail,
    this.userWallet,
    this.paymentMethod,
    this.partner,
    this.profileImage,
    this.userId,
    this.partnerId,
    this.cityId,
    this.total,
    this.taxPercentage,
    this.taxAmount,
    this.taxType,
    this.promoCode,
    this.promoDiscount,
    this.finalTotal,
    this.adminEarnings,
    this.partnerEarnings,
    this.addressId,
    this.address,
    this.dateOfService,
    this.startingTime,
    this.endingTime,
    this.duration,
    this.isCancelable,
    this.status,
    this.translatedStatus,
    this.otp,
    this.remarks,
    this.createdAt,
    this.companyName,
    this.visitingCharges,
    this.services,
    this.latitude,
    this.longitude,
    this.advanceBookingDays,
    this.invoiceNo,
    this.additionalCharges,
    this.totalAdditionalCharges,
    this.paymentMethodOfAdditionalCharge,
    this.paymentStatusOfAdditionalCharge,
    this.workCompletedProof,
    this.workStartedProof,
    this.multipleDaysBooking,
    this.newEndTimeWithDate,
    this.paymentStatus,
    this.newStartTimeWithDate,
    this.customJobRequestId,
    this.cancelReason,
    this.cancelReasonId,
    this.cancelAdditionalInfo,
    this.assignedHandymen,
    this.assignableHandymen,
    this.fees,
    this.taxBreakdown,
    this.visitingChargesTax,
    this.promoTaxReduction,
    this.currencySymbol,
    this.currencyDecimalPlaces,
  });

  BookingsModel.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude']?.toString() ?? '';
    longitude = json['longitude']?.toString() ?? '';
    id = json['id']?.toString() ?? '';
    customer = json['customer']?.toString() ?? '';
    customerId = json['customer_id']?.toString() ?? '';
    customerNo = json['customer_no']?.toString() ?? '';
    customerEmail = json['customer_email']?.toString() ?? '';
    userWallet = json['user_wallet']?.toString() ?? '';
    paymentMethod = json['payment_method']?.toString() ?? '';
    paymentStatus = json['payment_status']?.toString() ?? '';
    partner = json['partner']?.toString() ?? '';
    profileImage = json['profile_image']?.toString() ?? '';
    userId = json['user_id']?.toString() ?? '';
    partnerId = json['partner_id']?.toString() ?? '';
    cityId = json['city_id']?.toString() ?? '';
    total = json['total']?.toString() ?? '';
    taxPercentage = json['tax_percentage']?.toString() ?? '';
    taxAmount = json['tax_amount']?.toString() ?? '';
    taxType = json['tax_type']?.toString() ?? '';
    promoCode = json['promo_code']?.toString() ?? '';
    promoDiscount = json['promo_discount']?.toString() ?? '';
    finalTotal = json['final_total']?.toString() ?? '';
    adminEarnings = json['admin_earnings']?.toString() ?? '';
    partnerEarnings = json['partner_earnings']?.toString() ?? '';
    addressId = json['address_id']?.toString() ?? '';
    address = json['address']?.toString() ?? '';
    dateOfService = json['date_of_service']?.toString() ?? '';
    startingTime = json['starting_time']?.toString() ?? '';
    endingTime = json['ending_time']?.toString() ?? '';
    duration = json['duration']?.toString() ?? '';
    isCancelable = json['is_cancelable']?.toInt() ?? 0;
    status = json['status']?.toString() ?? '';
    translatedStatus = (json['translated_status']?.toString() ?? '').isNotEmpty
        ? json['translated_status'].toString()
        : (json['status']?.toString() ?? '');
    otp = json['otp']?.toString() ?? '';
    remarks = json['remarks']?.toString() ?? '';
    carPlateNumber = json['car_plate_number']?.toString() ?? '';
    createdAt = json['created_at']?.toString() ?? '';
    companyName = json['company_name']?.toString() ?? '';
    advanceBookingDays = json['advance_booking_days']?.toString() ?? '';
    workStartedProof = json['work_started_proof'] ?? [];
    workCompletedProof = json['work_completed_proof'] ?? [];
    additionalCharges = json['additional_charges'] ?? [];
    totalAdditionalCharges = json['total_additional_charge']?.toString() ?? '0';
    paymentMethodOfAdditionalCharge =
        json['payment_method_of_additional_charge']?.toString() ?? '';
    paymentStatusOfAdditionalCharge =
        json['payment_status_of_additional_charge']?.toString() ?? '';
    invoiceNo = json['invoice_no']?.toString() ?? '';
    visitingCharges = json['visiting_charges']?.toString() ?? '';
    customJobRequestId = json['custom_job_request_id']?.toString() ?? '';
    if (json['services'] != null) {
      services = <Services>[];
      json['services'].forEach((v) {
        services!.add(Services.fromJson(v));
      });
    }
    newStartTimeWithDate = json['new_start_time_with_date']?.toString() ?? '';
    newEndTimeWithDate = json['new_end_time_with_date']?.toString() ?? '';
    cancelReason = json['cancel_reason']?.toString() ?? '';
    cancelReasonId = json['cancel_reason_id']?.toString() ?? '';
    cancelAdditionalInfo = json['cancel_additional_info']?.toString() ?? '';
    multipleDaysBooking = MultipleDaysBooking.tryParse(
      json['multiple_days_booking'],
    );
    if (json['assigned_handymen'] != null) {
      assignedHandymen = (json['assigned_handymen'] as List)
          .map(
            (e) => AssignedHandymanModel.fromJson(Map<String, dynamic>.from(e)),
          )
          .toList();
    } else {
      assignedHandymen = [];
    }

    if (json['assignable_handymen'] != null) {
      assignableHandymen = (json['assignable_handymen'] as List)
          .map(
            (e) => AssignedHandymanModel.fromJson(Map<String, dynamic>.from(e)),
          )
          .toList();
    } else {
      assignableHandymen = [];
    }

    if (json['fees'] != null) {
      fees = (json['fees'] as List)
          .map((e) => BookingFee.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } else {
      fees = [];
    }

    if (json['tax_breakdown'] is Map) {
      taxBreakdown = TaxBreakdown.fromJson(
        Map<String, dynamic>.from(json['tax_breakdown'] as Map),
      );
    }
    visitingChargesTax = json['visiting_charges_tax']?.toString() ?? '0';
    promoTaxReduction = json['promo_tax_reduction']?.toString() ?? '0';
    currencySymbol = json['currency_symbol']?.toString() ?? '';
    currencyDecimalPlaces = int.tryParse(
      json['currency_decimal_places']?.toString() ?? '',
    );
  }

  String? id;
  String? customer;
  String? latitude;
  String? longitude;
  String? customerId;
  String? customerNo;
  String? customerEmail;
  String? userWallet;
  String? paymentMethod;
  String? partner;
  String? profileImage;
  String? userId;
  String? partnerId;
  String? cityId;
  String? total;
  String? taxPercentage;
  String? taxAmount;
  String? taxType;
  String? promoCode;
  String? promoDiscount;
  String? finalTotal;
  String? adminEarnings;
  String? partnerEarnings;
  String? addressId;
  String? address;
  String? dateOfService;
  String? startingTime;
  String? endingTime;
  String? duration;
  int? isCancelable;
  String? status;
  String? otp;
  String? remarks;
  String? carPlateNumber;
  String? createdAt;
  String? companyName;
  String? visitingCharges;
  List<Services>? services;
  List<dynamic>? workStartedProof;
  List<dynamic>? workCompletedProof;
  List<dynamic>? additionalCharges;
  String? totalAdditionalCharges;
  String? paymentMethodOfAdditionalCharge;
  String? paymentStatusOfAdditionalCharge;
  String? invoiceNo;
  String? advanceBookingDays;
  String? newStartTimeWithDate;
  String? newEndTimeWithDate;
  MultipleDaysBooking? multipleDaysBooking;
  String? customJobRequestId;
  String? paymentStatus;
  String? translatedStatus;
  String? cancelReason;
  String? cancelReasonId;
  String? cancelAdditionalInfo;
  List<AssignedHandymanModel>? assignedHandymen;
  List<AssignedHandymanModel>? assignableHandymen;
  List<BookingFee>? fees;
  TaxBreakdown? taxBreakdown;
  String? visitingChargesTax;
  String? promoTaxReduction;

  /// Booking's own currency; null on older bookings → use system currency.
  String? currencySymbol;
  int? currencyDecimalPlaces;

  double? get totalAdditionalChargeDouble {
    return double.tryParse(
      double.parse(
        totalAdditionalCharges?.toString().replaceAll(",", '') ?? '',
      ).toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['customer'] = customer;
    data['customer_id'] = customerId;
    data['customer_no'] = customerNo;
    data['customer_email'] = customerEmail;
    data['user_wallet'] = userWallet;
    data['payment_method'] = paymentMethod;
    data['partner'] = partner;
    data['profile_image'] = profileImage;
    data['user_id'] = userId;
    data['partner_id'] = partnerId;
    data['city_id'] = cityId;
    data['total'] = total;
    data['tax_percentage'] = taxPercentage ?? '';
    data['tax_amount'] = taxAmount;
    data['tax_type'] = taxType;
    data['promo_code'] = promoCode;
    data['promo_discount'] = promoDiscount;
    data['final_total'] = finalTotal;
    data['admin_earnings'] = adminEarnings;
    data['partner_earnings'] = partnerEarnings;
    data['address_id'] = addressId;
    data['address'] = address;
    data['date_of_service'] = dateOfService;
    data['starting_time'] = startingTime;
    data['ending_time'] = endingTime;
    data['duration'] = duration;
    data['is_cancelable'] = isCancelable;
    data['status'] = status;
    data['translated_status'] = translatedStatus;
    data['otp'] = otp;
    data['remarks'] = remarks;
    data['car_plate_number'] = carPlateNumber;
    data['created_at'] = createdAt;
    data['company_name'] = companyName;
    data['visiting_charges'] = visitingCharges;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['advance_booking_days'] = advanceBookingDays;
    data['work_started_proof'] = workStartedProof;
    data['work_completed_proof'] = workCompletedProof;
    data['additional_charges'] = additionalCharges;
    data['total_additional_charge'] = totalAdditionalCharges;
    data['payment_method_of_additional_charge'] =
        paymentMethodOfAdditionalCharge;
    data['payment_status_of_additional_charge'] =
        paymentStatusOfAdditionalCharge;
    data['custom_job_request_id'] = customJobRequestId;
    data['payment_status'] = paymentStatus;
    data['cancel_reason'] = cancelReason;
    data['cancel_reason_id'] = cancelReasonId;
    data['cancel_additional_info'] = cancelAdditionalInfo;

    if (services != null) {
      data['services'] = services!.map((Services v) => v.toJson()).toList();
    }
    data['invoice_no'] = invoiceNo;
    if (assignedHandymen != null) {
      data['assigned_handymen'] = assignedHandymen!
          .map((e) => e.toJson())
          .toList();
    }
    if (assignableHandymen != null) {
      data['assignable_handymen'] = assignableHandymen!
          .map((e) => e.toJson())
          .toList();
    }
    if (fees != null) {
      data['fees'] = fees!.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

class BookingFee {
  BookingFee({
    this.id,
    this.feeId,
    this.title,
    this.valueType,
    this.value,
    this.calculatedAmount,
    this.isRefundable,
    this.isTaxable = false,
    this.taxAmount,
  });

  BookingFee.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString() ?? '';
    feeId = json['fee_id']?.toString() ?? '';
    title = json['title']?.toString() ?? '';
    valueType = json['value_type']?.toString() ?? '';
    value = json['value']?.toString() ?? '';
    calculatedAmount = json['calculated_amount']?.toString() ?? '';
    isRefundable = json['is_refundable']?.toInt() ?? 0;
    isTaxable = json['is_taxable']?.toString() == '1';
    taxAmount = json['tax_amount']?.toString() ?? '0';
  }

  String? id;
  String? feeId;
  String? title;
  String? valueType;
  String? value;
  String? calculatedAmount;
  int? isRefundable;
  bool isTaxable = false;
  String? taxAmount;

  Map<String, dynamic> toJson() => {
    'id': id,
    'fee_id': feeId,
    'title': title,
    'value_type': valueType,
    'value': value,
    'calculated_amount': calculatedAmount,
    'is_refundable': isRefundable,
    'is_taxable': isTaxable ? 1 : 0,
    'tax_amount': taxAmount,
  };
}

/// `multiple_days_booking`: the first and last day of a booking that spans
/// several days. Times may carry a zone (`09:00:00Z`).
class MultipleDaysBooking {
  const MultipleDaysBooking({
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.startDateTime,
    required this.endDateTime,
  });

  factory MultipleDaysBooking.fromJson(final Map<String, dynamic> json) {
    return MultipleDaysBooking(
      startDate: json['start_date']?.toString() ?? '',
      endDate: json['end_date']?.toString() ?? '',
      startTime: json['start_time']?.toString() ?? '',
      endTime: json['end_time']?.toString() ?? '',
      startDateTime: json['start_date_time']?.toString() ?? '',
      endDateTime: json['end_date_time']?.toString() ?? '',
    );
  }

  /// Null for a single-day booking: no object, an empty list or no start date.
  static MultipleDaysBooking? tryParse(final dynamic json) {
    if (json is! Map) return null;
    final MultipleDaysBooking booking = MultipleDaysBooking.fromJson(
      Map<String, dynamic>.from(json),
    );
    return booking.startDate.isEmpty ? null : booking;
  }

  final String startDate;
  final String endDate;
  final String startTime;
  final String endTime;
  final String startDateTime;
  final String endDateTime;
}

class Services {
  String? id;
  String? orderId;
  String? serviceId;
  String? serviceTitle;
  String? image;
  String? taxPercentage;
  String? taxAmount;
  String? price;
  String? taxValue;
  String? priceWithTax;
  String? discountPrice;
  String? originalPriceWithTax;
  String? quantity;
  String? subTotal;
  String? status;
  String? translatedStatus;
  String? tags;
  String? duration;
  String? categoryId;
  String? isCancelable;
  String? cancelableTill;
  String? rating;
  String? comment;
  String? advanceBookingDays;

  Services({
    this.id,
    this.orderId,
    this.serviceId,
    this.serviceTitle,
    this.image,
    this.taxPercentage,
    this.taxAmount,
    this.price,
    this.originalPriceWithTax,
    this.discountPrice,
    this.priceWithTax,
    this.taxValue,
    this.quantity,
    this.subTotal,
    this.status,
    this.translatedStatus,
    this.tags,
    this.duration,
    this.categoryId,
    this.isCancelable,
    this.cancelableTill,
    this.rating,
    this.comment,
    this.advanceBookingDays,
  });

  Services.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString() ?? '';
    orderId = json['order_id']?.toString() ?? '';
    serviceId = json['service_id']?.toString() ?? '';
    serviceTitle = json['service_title']?.toString() ?? '';
    image = json['image']?.toString() ?? '';
    taxPercentage = json['tax_percentage']?.toString() ?? '';
    taxAmount = json['tax_amount']?.toString() ?? '';
    price = json['price']?.toString() ?? '';
    priceWithTax = json['price_with_tax']?.toString() ?? '';
    discountPrice = json['discount_price']?.toString() ?? '0';
    originalPriceWithTax = json['original_price_with_tax']?.toString() ?? '';
    taxValue = json['tax_value']?.toString() ?? '';
    quantity = json['quantity']?.toString() ?? '';
    subTotal = json['sub_total']?.toString() ?? '';
    status = json['status']?.toString() ?? '';
    translatedStatus = (json['translated_status']?.toString() ?? '').isNotEmpty
        ? json['translated_status'].toString()
        : (json['status']?.toString() ?? '');

    tags = json['tags']?.toString() ?? '';
    duration = json['duration']?.toString() ?? '';
    categoryId = json['category_id']?.toString() ?? '';
    isCancelable = json['is_cancelable']?.toString() ?? '';
    cancelableTill = json['cancelable_till']?.toString() ?? '';
    rating = json['rating']?.toString() ?? '';
    comment = json['comment']?.toString() ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_id'] = orderId;
    data['service_id'] = serviceId;
    data['service_title'] = serviceTitle;
    data['image'] = image;
    data['tax_percentage'] = taxPercentage;
    data['tax_amount'] = taxAmount;
    data['price'] = price;
    data['quantity'] = quantity;
    data['sub_total'] = subTotal;
    data['status'] = status;
    data['translated_status'] = translatedStatus;
    data['tags'] = tags;
    data['duration'] = duration;
    data['category_id'] = categoryId;
    data['is_cancelable'] = isCancelable;
    data['cancelable_till'] = cancelableTill;
    data['rating'] = rating;
    data['comment'] = comment;
    return data;
  }
}
