import '../config.dart';

class BookingModel {
  int? id;
  int? parentId;
  int? amount;
  String? bookingNumber;
  String? parentBookingNumber;
  dynamic? grandTotalWithExtras;
  int? consumerId;
  int? couponId;
  double? taxTotal;
  double? walletBalance;
  double? convertWalletBalance;
  int? providerId;
  int? serviceId;
  int? servicePackageId;
  int? addressId;

  // double? servicePrice;
  double? tax;
  double? perServicemanCharge;
  int? totalExtraServicemen;
  int? totalServicemen;
  int? requiredServicemen;
  int? perServicemanCommission;
  dynamic totalExtraServicemenCharge;
  dynamic couponTotalDiscount;
  dynamic subtotal;
  dynamic total;
  String? dateTime;
  int? bookingStatusId;
  String? paymentMethod;
  String? paymentStatus;
  String? description;
  String? invoiceUrl;
  int? createdById;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  double? platformFees;
  String? platformFeesType;
  String? role;
  BookingProviderModel? provider;
  Services? service;
  List<ServicemanModel>? servicemen;
  CouponModel? coupon;
  BookingStatus? bookingStatus;
  List<BookingStatusLogs>? bookingStatusLogs;
  UserModel? consumer;
  BookingAddress? address;
  List<BookingReasons>? bookingReasons;
  bool? isExpand;
  List<ExtraCharges>? extraCharges;
  List<ServiceProofs>? serviceProofs;
  List<AdditionalServices>? additionalServices;
  ExtraChargesTotal? extraChargesTotal;
  List<Tax>? taxes;
  ZoomMeeting? zoomMeeting;
  double? advancePaymentAmount;
  double? advancePaymentPercentage;
  bool? advancePaymentEnable;
  String? remainingPaymentStatus;
  double? remainingPaymentAmount;
  String? advancePaymentStatus;

  BookingModel(
      {this.id,
      this.zoomMeeting,
      this.parentId,
      this.bookingNumber,
      this.grandTotalWithExtras,
      this.parentBookingNumber,
      this.consumerId,
      this.couponId,
      this.walletBalance,
      this.convertWalletBalance,
      this.providerId,
      this.serviceId,
      this.servicePackageId,
      this.addressId,
      // this.servicePrice,
      this.tax,
      this.perServicemanCharge,
      this.totalExtraServicemen,
      this.totalServicemen,
      this.requiredServicemen,
      this.perServicemanCommission,
      this.totalExtraServicemenCharge,
      this.couponTotalDiscount,
      this.subtotal,
      this.total,
      this.dateTime,
      this.bookingStatusId,
      this.paymentMethod,
      this.paymentStatus,
      this.description,
      this.invoiceUrl,
      this.createdById,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.platformFees,
      this.platformFeesType,
      this.role,
      this.provider,
      this.service,
      this.servicemen,
      this.coupon,
      this.bookingStatus,
      this.bookingStatusLogs,
      this.consumer,
      this.address,
      this.bookingReasons,
      this.isExpand,
      this.extraCharges,
      this.serviceProofs,
      this.additionalServices,
      this.extraChargesTotal,
      this.taxes,
      this.advancePaymentAmount,
      this.advancePaymentEnable,
      this.advancePaymentPercentage,
      this.remainingPaymentStatus,
      this.remainingPaymentAmount,
      this.advancePaymentStatus});

  BookingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    grandTotalWithExtras = json['grand_total_with_extras'];
    parentId = json['parent_id'] != null
        ? int.parse(json['parent_id'].toString())
        : null;
    bookingNumber = json['booking_number']?.toString();
    parentBookingNumber = json['parent_booking_number']?.toString();

    consumerId = json['consumer_id'];
    couponId = json['coupon_id'];
    walletBalance = json['wallet_balance'] != null
        ? double.parse(json['wallet_balance'].toString())
        : null;
    convertWalletBalance = json['convert_wallet_balance'] != null
        ? double.parse(json['convert_wallet_balance'].toString())
        : null;
    providerId = json['provider_id'];
    serviceId = json['service_id'];
    servicePackageId = json['service_package_id'];
    addressId = json['address_id'];
    // servicePrice = double.parse(json['service_price'].toString());
    tax = json['tax'] == null ? null : double.parse(json['tax'].toString());
    perServicemanCharge = json['per_serviceman_charge'] == null
        ? null
        : double.parse(json['per_serviceman_charge'].toString());
    perServicemanCommission = json['per_serviceman_commission'];
    totalExtraServicemen = json['total_extra_servicemen'];
    totalServicemen = json['total_servicemen'];
    totalExtraServicemenCharge = /* double.parse( */
        json['total_extra_servicemen_charge'] /* .toString()) */;
    couponTotalDiscount =
        /* double.parse( */ json['coupon_total_discount'] /* .toString()) */;
    subtotal = /* double.parse( */ json['subtotal'] /* .toString()) */;
    platformFees = json['platform_fees'] != null
        ? double.parse(json['platform_fees'].toString())
        : 0.0;
    total = json['total'].toString() /*double.parse(json['total'].toString())*/;
    advancePaymentEnable = json['is_advance_payment_enabled'] != null
        ? json['is_advance_payment_enabled']
        : null;
    advancePaymentPercentage = json['advance_payment_percentage'] != null
        ? double.parse(json['advance_payment_percentage'].toString())
        : null;
    advancePaymentAmount = json['advance_payment_amount'] != null
        ? double.parse(json['advance_payment_amount'].toString())
        : null;
    advancePaymentStatus = json['advance_payment_status'] != null
        ? json['advance_payment_status']
        : null;
    remainingPaymentAmount = json['remaining_payment_amount'] != null
        ? double.parse(json['remaining_payment_amount'].toString())
        : null;
    remainingPaymentStatus = json['remaining_payment_status'] != null
        ? json['remaining_payment_status']
        : null;
    dateTime = json['date_time'];
    bookingStatusId = json['booking_status_id'];
    paymentMethod = json['payment_method'];
    paymentStatus = json['payment_status'];
    description = json['description'];
    invoiceUrl = json['invoice_url'];
    createdById = json['created_by_id'];
    requiredServicemen = json['required_servicemen'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    provider = json['provider'] != null
        ? BookingProviderModel.fromJson(json['provider'])
        : null;
    service =
        json['service'] != null ? Services.fromJson(json['service']) : null;
    if (json['servicemen'] != null) {
      servicemen = <ServicemanModel>[];
      json['servicemen'].forEach((v) {
        servicemen!.add(ServicemanModel.fromJson(v));
      });
    }
    coupon =
        json['coupon'] != null ? CouponModel.fromJson(json['coupon']) : null;
    bookingStatus = json['booking_status'] != null
        ? BookingStatus.fromJson(json['booking_status'])
        : null;
    isExpand = false;
    consumer =
        json['consumer'] != null ? UserModel.fromJson(json['consumer']) : null;
    zoomMeeting =
        json['zoom'] != null ? ZoomMeeting.fromJson(json['zoom']) : null;
    if (json['booking_status_logs'] != null) {
      bookingStatusLogs = <BookingStatusLogs>[];
      json['booking_status_logs'].forEach((v) {
        bookingStatusLogs!.add(BookingStatusLogs.fromJson(v));
      });
    }
    if (json['extra_charges'] != null) {
      extraCharges = <ExtraCharges>[];
      json['extra_charges'].forEach((v) {
        extraCharges!.add(ExtraCharges.fromJson(v));
      });
    }
    if (json['additional_services'] != null) {
      additionalServices = <AdditionalServices>[];
      json['additional_services'].forEach((v) {
        additionalServices!.add(AdditionalServices.fromJson(v));
      });
    }

    address = json['address'] != null
        ? BookingAddress.fromJson(json['address'])
        : null;
    platformFeesType = json['platform_fees_type'];
    role = json['role'];
    if (json['booking_reasons'] != null) {
      bookingReasons = <BookingReasons>[];
      json['booking_reasons'].forEach((v) {
        bookingReasons!.add(BookingReasons.fromJson(v));
      });
    }
    if (json['service_proofs'] != null) {
      serviceProofs = <ServiceProofs>[];
      json['service_proofs'].forEach((v) {
        serviceProofs!.add(ServiceProofs.fromJson(v));
      });
    }
    if (json['taxes'] != null) {
      taxes = <Tax>[];
      json['taxes'].forEach((v) {
        taxes!.add(Tax.fromJson(v));
      });
    }

    extraChargesTotal = json['extra_charges_total'] != null
        ? ExtraChargesTotal.fromJson(json['extra_charges_total'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['parent_id'] = parentId;
    data['grand_total_with_extras'] = grandTotalWithExtras;
    data['booking_number'] = bookingNumber;
    data['parent_booking_number'] = parentBookingNumber;
    data['consumer_id'] = consumerId;
    data['coupon_id'] = couponId;
    data['wallet_balance'] = walletBalance;
    data['convert_wallet_balance'] = convertWalletBalance;
    data['provider_id'] = providerId;
    data['service_id'] = serviceId;
    data['service_package_id'] = servicePackageId;
    data['address_id'] = addressId;
    // data['service_price'] = servicePrice;
    data['tax'] = tax;
    data['per_serviceman_charge'] = perServicemanCharge;
    data['per_serviceman_commission'] = perServicemanCommission;
    data['total_extra_servicemen'] = totalExtraServicemen;
    data['total_servicemen'] = totalServicemen;
    data['required_servicemen'] = requiredServicemen;
    data['total_extra_servicemen_charge'] = totalExtraServicemenCharge;
    data['coupon_total_discount'] = couponTotalDiscount;
    data['subtotal'] = subtotal;
    data['total'] = total;
    data['date_time'] = dateTime;
    data['booking_status_id'] = bookingStatusId;
    data['payment_method'] = paymentMethod;
    data['payment_status'] = paymentStatus;
    data['description'] = description;
    data['invoice_url'] = invoiceUrl;
    data['created_by_id'] = createdById;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['platform_fees'] = platformFees;
    data['platform_fees_type'] = platformFeesType;
    data['advance_payment_amount'] = advancePaymentAmount;
    data['is_advance_payment_enabled'] = advancePaymentEnable;
    data['advance_payment_percentage'] = advancePaymentPercentage;
    data['remaining_payment_amount'] = remainingPaymentAmount;
    data['remaining_payment_status'] = remainingPaymentStatus;
    data['advance_payment_status'] = advancePaymentStatus;

    data['role'] = role;

    if (provider != null) {
      data['provider'] = provider!.toJson();
    }
    if (service != null) {
      data['service'] = service!.toJson();
    }
    if (servicemen != null) {
      data['servicemen'] = servicemen!.map((v) => v.toJson()).toList();
    }
    data['coupon'] = coupon;
    if (bookingStatus != null) {
      data['booking_status'] = bookingStatus!.toJson();
    }
    if (bookingStatusLogs != null) {
      data['booking_status_logs'] =
          bookingStatusLogs!.map((v) => v.toJson()).toList();
    }
    if (consumer != null) {
      data['consumer'] = consumer!.toJson();
    }
    if (zoomMeeting != null) {
      data['zoom'] = zoomMeeting!.toJson();
    }
    if (address != null) {
      data['address'] = address!.toJson();
    }
    if (bookingReasons != null) {
      data['booking_reasons'] = bookingReasons!.map((v) => v.toJson()).toList();
    }
    if (extraCharges != null) {
      data['extra_charges'] = extraCharges!.map((v) => v.toJson()).toList();
    }
    if (additionalServices != null) {
      data['additional_services'] =
          additionalServices!.map((v) => v.toJson()).toList();
    }
    if (serviceProofs != null) {
      data['service_proofs'] = serviceProofs!.map((v) => v.toJson()).toList();
    }
    if (taxes != null) {
      data['taxes'] = taxes!.map((v) => v.toJson()).toList();
    }
    if (extraChargesTotal != null) {
      data['extra_charges_total'] = extraChargesTotal!.toJson();
    }
    return data;
  }
}

class ExtraChargesTotal {
  dynamic totalAmount;
  dynamic taxAmount;
  dynamic platformFees;
  dynamic grandTotal;

  ExtraChargesTotal(
      {this.totalAmount, this.taxAmount, this.platformFees, this.grandTotal});

  ExtraChargesTotal.fromJson(Map<String, dynamic> json) {
    totalAmount = json['total_amount'];
    taxAmount = json['tax_amount'];
    platformFees = json['platform_fees'];
    grandTotal = json['grand_total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_amount'] = totalAmount;
    data['tax_amount'] = taxAmount;
    data['platform_fees'] = platformFees;
    data['grand_total'] = grandTotal;
    return data;
  }
}

class Status {
  int? id;
  String? name;
  String? hexaCode;

  Status({this.id, this.name, this.hexaCode});

  Status.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    hexaCode = json['hexa_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['hexa_code'] = hexaCode;
    return data;
  }
}

class BookingReasons {
  int? id;
  int? bookingId;
  int? statusId;
  String? reason;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  BookingStatusModel? status;

  BookingReasons(
      {this.id,
      this.bookingId,
      this.statusId,
      this.reason,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.status});

  BookingReasons.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookingId = json['booking_id'];
    statusId = json['status_id'];
    reason = json['reason'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    status = json['status'] != null
        ? BookingStatusModel.fromJson(json['status'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['booking_id'] = bookingId;
    data['status_id'] = statusId;
    data['reason'] = reason;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    if (status != null) {
      data['status'] = status!.toJson();
    }
    return data;
  }
}

class BookingAddress {
  Country? country;
  Country? state;
  dynamic area;
  String? address;
  String? postalCode;

  BookingAddress({
    this.country,
    this.state,
    this.area,
    this.address,
    this.postalCode,
  });

  factory BookingAddress.fromJson(Map<String, dynamic> json) => BookingAddress(
        country:
            json["country"] == null ? null : Country.fromJson(json["country"]),
        state: json["state"] == null ? null : Country.fromJson(json["state"]),
        area: json["area"],
        address: json["address"],
        postalCode: json["postal_code"],
      );

  Map<String, dynamic> toJson() => {
        "country": country?.toJson(),
        "state": state?.toJson(),
        "area": area,
        "address": address,
        "postal_code": postalCode
      };
}

class UserDetail {
  int? id;
  String? name;
  String? reviewRatings;
  PrimaryAddress? primaryAddress;
  List<Media>? media;
  WalletModel? wallet;
  List<KnownLanguageModel>? knownLanguages;
  List<ExpertiseModel>? expertise;
  List<Reviews>? reviews;

  UserDetail(
      {this.id,
      this.name,
      this.reviewRatings,
      this.primaryAddress,
      this.media,
      this.wallet,
      this.knownLanguages,
      this.expertise,
      this.reviews});

  UserDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    reviewRatings = json['review_ratings'];
    primaryAddress = json['primary_address'] != null
        ? PrimaryAddress.fromJson(json['primary_address'])
        : null;
    if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media!.add(Media.fromJson(v));
      });
    }
    wallet =
        json['wallet'] != null ? WalletModel.fromJson(json['wallet']) : null;
    if (json['known_languages'] != null) {
      knownLanguages = <KnownLanguageModel>[];
      json['known_languages'].forEach((v) {
        knownLanguages!.add(KnownLanguageModel.fromJson(v));
      });
    }
    if (json['expertise'] != null) {
      expertise = <ExpertiseModel>[];
      json['expertise'].forEach((v) {
        expertise!.add(ExpertiseModel.fromJson(v));
      });
    }
    if (json['reviews'] != null) {
      reviews = <Reviews>[];
      json['reviews'].forEach((v) {
        reviews!.add(Reviews.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['review_ratings'] = reviewRatings;
    if (primaryAddress != null) {
      data['primary_address'] = primaryAddress!.toJson();
    }
    if (media != null) {
      data['media'] = media!.map((v) => v.toJson()).toList();
    }
    if (wallet != null) {
      data['wallet'] = wallet!.toJson();
    }
    if (knownLanguages != null) {
      data['known_languages'] = knownLanguages!.map((v) => v.toJson()).toList();
    }
    if (expertise != null) {
      data['expertise'] = expertise!.map((v) => v.toJson()).toList();
    }
    if (reviews != null) {
      data['reviews'] = reviews!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BookingStatusLogs {
  int? id;
  int? bookingId;
  int? bookingStatusId;
  String? title;
  String? description;
  String? createdAt;
  String? updatedAt;
  BookingStatusModel? status;

  BookingStatusLogs(
      {this.id,
      this.bookingId,
      this.bookingStatusId,
      this.title,
      this.description,
      this.createdAt,
      this.updatedAt,
      this.status});

  BookingStatusLogs.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookingId = json['booking_id'];
    bookingStatusId = json['booking_status_id'];
    title = json['title'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'] != null
        ? BookingStatusModel.fromJson(json['status'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['booking_id'] = bookingId;
    data['booking_status_id'] = bookingStatusId;
    data['title'] = title;
    data['description'] = description;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (status != null) {
      data['status'] = status!.toJson();
    }
    return data;
  }
}

class BookingStatus {
  int? id;
  String? name;
  String? slug;

  BookingStatus({this.id, this.name, this.slug});

  BookingStatus.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    return data;
  }
}

class BookingProviderModel {
  int? id;
  String? name;
  String? experienceInterval;
  int? experienceDuration;
  String? email;
  String? phone;
  double? reviewRatings;
  PrimaryAddress? primaryAddress;
  List<Media>? media;
  WalletModel? wallet;
  WalletModel? providerWallet;
  List<KnownLanguageModel>? knownLanguages;
  List<ExpertiseModel>? expertise;
  List<Reviews>? reviews;

  BookingProviderModel(
      {this.id,
      this.name,
      this.experienceInterval,
      this.experienceDuration,
      this.email,
      this.phone,
      this.reviewRatings,
      this.primaryAddress,
      this.media,
      this.wallet,
      this.providerWallet,
      this.knownLanguages,
      this.expertise,
      this.reviews});

  BookingProviderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    experienceInterval = json['experience_interval'];
    experienceDuration = json['experience_duration'];
    email = json['email'];
    phone = json['phone']?.toString();
    reviewRatings = json['review_ratings'] != null
        ? double.parse(json['review_ratings'].toString())
        : null;
    primaryAddress = json['primary_address'] != null
        ? PrimaryAddress.fromJson(json['primary_address'])
        : null;
    if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media!.add(Media.fromJson(v));
      });
    }
    wallet =
        json['wallet'] != null ? WalletModel.fromJson(json['wallet']) : null;
    providerWallet = json['provider_wallet'] != null
        ? WalletModel.fromJson(json['provider_wallet'])
        : null;
    if (json['known_languages'] != null) {
      knownLanguages = <KnownLanguageModel>[];
      json['known_languages'].forEach((v) {
        knownLanguages!.add(KnownLanguageModel.fromJson(v));
      });
    }
    if (json['expertise'] != null) {
      expertise = <ExpertiseModel>[];
      json['expertise'].forEach((v) {
        expertise!.add(ExpertiseModel.fromJson(v));
      });
    }
    if (json['reviews'] != null) {
      reviews = <Reviews>[];
      json['reviews'].forEach((v) {
        reviews!.add(Reviews.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['experience_interval'] = experienceInterval;
    data['experience_duration'] = experienceDuration;
    data['email'] = email;
    data['phone'] = phone;
    data['review_ratings'] = reviewRatings;
    if (primaryAddress != null) {
      data['primary_address'] = primaryAddress!.toJson();
    }
    if (media != null) {
      data['media'] = media!.map((v) => v.toJson()).toList();
    }
    if (wallet != null) {
      data['wallet'] = wallet!.toJson();
    }
    if (providerWallet != null) {
      data['provider_wallet'] = providerWallet!.toJson();
    }

    if (knownLanguages != null) {
      data['known_languages'] = knownLanguages!.map((v) => v.toJson()).toList();
    }
    if (expertise != null) {
      data['expertise'] = expertise!.map((v) => v.toJson()).toList();
    }
    if (reviews != null) {
      data['reviews'] = reviews!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BookingPivot {
  String? serviceId;
  String? categoryId;

  BookingPivot({this.serviceId, this.categoryId});

  BookingPivot.fromJson(Map<String, dynamic> json) {
    serviceId = json['service_id'];
    categoryId = json['category_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['service_id'] = serviceId;
    data['category_id'] = categoryId;
    return data;
  }
}

class ZoomMeeting {
  final String startUrl;
  final String joinUrl;

  ZoomMeeting({
    required this.startUrl,
    required this.joinUrl,
  });

  factory ZoomMeeting.fromJson(Map<String, dynamic> json) {
    return ZoomMeeting(
      startUrl: json['start_url'] as String,
      joinUrl: json['join_url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'start_url': startUrl,
      'join_url': joinUrl,
    };
  }
}

/*
class BookingModel {


  int? id;
  String? parentId;
  String? bookingNumber;
  int? consumerId;
  int? couponId;
  double? walletBalance;
  double? convertWalletBalance;
  String? providerId;
  String? serviceId;
  String? servicePackageId;
  String? addressId;
  double? servicePrice;
  double? tax;
  double? perServicemanCharge;
  String? totalExtraServicemen;
  double? totalExtraServicemenCharge;
  double? subtotal;
  double? platformFees;
  double? total;
  String? dateTime;
  int? bookingStatusId;
  String? paymentMethod;

  String? paymentStatus;
  String? description;
  String? invoiceUrl;
  int? createdById;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  BookingProviderModel? provider;
  Services? service;
  List<Services>? extraService;
  List<ServicemanModel>? servicemen;
  CouponModel? coupon;
  BookingStatus? bookingStatus;
  List<BookingStatusLogs>? bookingStatusLogs;
  UserModel? consumer;
  bool? isExpand;
  PrimaryAddress? address;

  double? couponTotalDiscount;
  String? platformFeesType;
  String? role;
  List<BookingReasons>? bookingReasons;

  BookingModel(
      {this.id,
        this.parentId,
        this.bookingNumber,
        this.consumerId,
        this.couponId,
        this.walletBalance,
        this.convertWalletBalance,
        this.providerId,
        this.serviceId,
        this.servicePackageId,
        this.addressId,
        this.servicePrice,
        this.tax,
        this.perServicemanCharge,
        this.totalExtraServicemen,
        this.totalExtraServicemenCharge,
        this.subtotal,
        this.platformFees,
        this.total,
        this.dateTime,
        this.bookingStatusId,
        this.paymentMethod,
        this.paymentStatus,
        this.description,
        this.invoiceUrl,
        this.createdById,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.provider,
        this.service,
        this.servicemen,
        this.coupon,
        this.bookingStatus,this.isExpand,this.consumer,this.bookingStatusLogs,this.extraService,this.address,
        this.couponTotalDiscount,
        this.platformFeesType,
        this.role,});

  BookingModel.fromJson(Map<String, dynamic> json) {

    id = json['id'];
    parentId = json['parent_id'];
    bookingNumber = json['booking_number'];
    consumerId = json['consumer_id'];
    couponId = json['coupon_id'];
    walletBalance = json['wallet_balance'] != null ? double.parse(json['wallet_balance'].toString()) :null;
    convertWalletBalance = json['convert_wallet_balance'] != null? double.parse(json['convert_wallet_balance'].toString()):null;
    providerId = json['provider_id'];
    serviceId = json['service_id'];
    servicePackageId = json['service_package_id'];
    addressId = json['address_id'];
    servicePrice = double.parse(json['service_price'].toString());
    tax = double.parse(json['tax'].toString());
    perServicemanCharge = double.parse(json['per_serviceman_charge'].toString());
    totalExtraServicemen =json['total_extra_servicemen'];
    totalExtraServicemenCharge = double.parse(json['total_extra_servicemen_charge'].toString());
    couponTotalDiscount = double.parse(json['coupon_total_discount'].toString());
    subtotal = double.parse(json['subtotal'].toString());
    platformFees = json['platform_fees'] != null ? double.parse(json['platform_fees'].toString()) :0.0;
    total = double.parse(json['total'].toString());
    dateTime = json['date_time'];
    bookingStatusId = json['booking_status_id'];
    paymentMethod = json['payment_method'];
    paymentStatus = json['payment_status'];
    description = json['description'];
    invoiceUrl = json['invoice_url'];
    createdById = json['created_by_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    provider = json['provider'] != null
        ? BookingProviderModel.fromJson(json['provider'])
        : null;
    service =
    json['service'] != null ? Services.fromJson(json['service']) : null;
    if (json['servicemen'] != null) {
      servicemen = <ServicemanModel>[];
      json['servicemen'].forEach((v) {
        servicemen!.add(ServicemanModel.fromJson(v));
      });
    }
    coupon = json['coupon'];
    bookingStatus = json['booking_status'] != null
        ? BookingStatus.fromJson(json['booking_status'])
        : null;
    isExpand = false;
    consumer = json['consumer'] != null
        ? UserModel.fromJson(json['consumer'])
        : null;
    if (json['booking_status_logs'] != null) {
      bookingStatusLogs = <BookingStatusLogs>[];
      json['booking_status_logs'].forEach((v) {
        bookingStatusLogs!.add( BookingStatusLogs.fromJson(v));
      });
    }
    if (json['extra_services'] != null) {
      extraService = <Services>[];
      json['extra_services'].forEach((v) {
        extraService!.add(Services.fromJson(v));
      });
    }
    address = json['address'] != null
        ?  PrimaryAddress.fromJson(json['address'])
        : null;

    platformFees = json['platform_fees'];
    platformFeesType = json['platform_fees_type'];
    role = json['role'];
    if (json['booking_reasons'] != null) {
      bookingReasons = <BookingReasons>[];
      json['booking_reasons'].forEach((v) {
        bookingReasons!.add(BookingReasons.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['parent_id'] = parentId;
    data['booking_number'] = bookingNumber;
    data['consumer_id'] = consumerId;
    data['coupon_id'] = couponId;
    data['wallet_balance'] = walletBalance;
    data['convert_wallet_balance'] = convertWalletBalance;
    data['provider_id'] = providerId;
    data['service_id'] = serviceId;
    data['service_package_id'] = servicePackageId;
    data['address_id'] = addressId;
    data['service_price'] = servicePrice;
    data['tax'] = tax;
    data['per_serviceman_charge'] = perServicemanCharge;
    data['total_extra_servicemen'] = totalExtraServicemen;
    data['total_extra_servicemen_charge'] = totalExtraServicemenCharge;
    data['coupon_total_discount'] = couponTotalDiscount;
    data['subtotal'] = subtotal;
    data['total'] = total;
    data['date_time'] = dateTime;
    data['booking_status_id'] = bookingStatusId;
    data['payment_method'] = paymentMethod;
    data['payment_status'] = paymentStatus;
    data['description'] = description;
    data['invoice_url'] = invoiceUrl;
    data['created_by_id'] = createdById;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['platform_fees'] = platformFees;
    data['platform_fees_type'] = platformFeesType;
    data['role'] = role;
    if (provider != null) {
      data['provider'] = provider!.toJson();
    }
    if (service != null) {
      data['service'] = service!.toJson();
    }
    if (servicemen != null) {
      data['servicemen'] = servicemen!.map((v) => v.toJson()).toList();
    }
    data['coupon'] = coupon;
    if (bookingStatus != null) {
      data['booking_status'] = bookingStatus!.toJson();
    }
    if (bookingStatusLogs != null) {
      data['booking_status_logs'] =
          bookingStatusLogs!.map((v) => v.toJson()).toList();
    }
    if (consumer != null) {
      data['consumer'] = consumer!.toJson();
    }
    if (address != null) {
      data['address'] = address!.toJson();
    }
    if (bookingReasons != null) {
      data['booking_reasons'] =
          bookingReasons!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BookingReasons {
  int? id;
  String? bookingId;
  String? statusId;
  String? reason;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  BookingStatusModel? status;

  BookingReasons(
      {this.id,
        this.bookingId,
        this.statusId,
        this.reason,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.status});

  BookingReasons.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookingId = json['booking_id'];
    statusId = json['status_id'];
    reason = json['reason'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    status =
    json['status'] != null ? BookingStatusModel.fromJson(json['status']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['booking_id'] = bookingId;
    data['status_id'] = statusId;
    data['reason'] = reason;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    if (status != null) {
      data['status'] = status!.toJson();
    }
    return data;
  }
}


class UserDetail {
  int? id;
  String? name;
  String? reviewRatings;
  PrimaryAddress? primaryAddress;
  List<Media>? media;
  WalletModel? wallet;
  List<KnownLanguageModel>? knownLanguages;
  List<ExpertiseModel>? expertise;
  List<Reviews>? reviews;

  UserDetail(
      {this.id,
        this.name,
        this.reviewRatings,
        this.primaryAddress,
        this.media,
        this.wallet,
        this.knownLanguages,
        this.expertise,
        this.reviews});

  UserDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    reviewRatings = json['review_ratings'];
    primaryAddress = json['primary_address'] != null
        ? PrimaryAddress.fromJson(json['primary_address'])
        : null;
    if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media!.add(Media.fromJson(v));
      });
    }
    wallet =
    json['wallet'] != null ? WalletModel.fromJson(json['wallet']) : null;
    if (json['known_languages'] != null) {
      knownLanguages = <KnownLanguageModel>[];
      json['known_languages'].forEach((v) {
        knownLanguages!.add(KnownLanguageModel.fromJson(v));
      });
    }
    if (json['expertise'] != null) {
      expertise = <ExpertiseModel>[];
      json['expertise'].forEach((v) {
        expertise!.add(ExpertiseModel.fromJson(v));
      });
    }
    if (json['reviews'] != null) {
      reviews = <Reviews>[];
      json['reviews'].forEach((v) {
        reviews!.add(Reviews.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['review_ratings'] = reviewRatings;
    if (primaryAddress != null) {
      data['primary_address'] = primaryAddress!.toJson();
    }
    if (media != null) {
      data['media'] = media!.map((v) => v.toJson()).toList();
    }
    if (wallet != null) {
      data['wallet'] = wallet!.toJson();
    }
    if (knownLanguages != null) {
      data['known_languages'] =
          knownLanguages!.map((v) => v.toJson()).toList();
    }
    if (expertise != null) {
      data['expertise'] = expertise!.map((v) => v.toJson()).toList();
    }
    if (reviews != null) {
      data['reviews'] = reviews!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BookingStatusLogs {
  int? id;
  String? bookingId;
  String? bookingStatusId;
  String? title;
  String? description;
  String? createdAt;
  String? updatedAt;
  BookingStatusModel? status;

  BookingStatusLogs(
      {this.id,
        this.bookingId,
        this.bookingStatusId,
        this.title,
        this.description,
        this.createdAt,
        this.updatedAt,
        this.status});

  BookingStatusLogs.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookingId = json['booking_id'];
    bookingStatusId = json['booking_status_id'];
    title = json['title'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status =
    json['status'] != null ?  BookingStatusModel.fromJson(json['status']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['booking_id'] = bookingId;
    data['booking_status_id'] = bookingStatusId;
    data['title'] = title;
    data['description'] = description;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (status != null) {
      data['status'] = status!.toJson();
    }
    return data;
  }
}

class BookingBookingProviderModelModel {
  int? id;
  String? name;
  String? experienceInterval;
  String? experienceDuration;
  String? email;
  String? phone;
  int? reviewRatings;
  PrimaryAddress? primaryAddress;
  List<Media>? media;
  WalletModel? wallet;
  List<KnownLanguageModel>? knownLanguages;
  List<ExpertiseModel>? expertise;
  List<Reviews>? reviews;

  BookingBookingProviderModelModel(
      {this.id,
        this.name,
        this.experienceInterval,
        this.experienceDuration,
        this.email,
        this.phone,
        this.reviewRatings,
        this.primaryAddress,
        this.media,
        this.wallet,
        this.knownLanguages,
        this.expertise,
        this.reviews});

  BookingBookingProviderModelModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    experienceInterval = json['experience_interval'];
    experienceDuration = json['experience_duration'];
    email = json['email'];
    phone = json['phone'];
    reviewRatings = json['review_ratings'];
    primaryAddress = json['primary_address'] != null
        ? PrimaryAddress.fromJson(json['primary_address'])
        : null;
    if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media!.add(Media.fromJson(v));
      });
    }
    wallet = json['wallet'];
    if (json['known_languages'] != null) {
      knownLanguages = <KnownLanguageModel>[];
      json['known_languages'].forEach((v) {
        knownLanguages!.add(KnownLanguageModel.fromJson(v));
      });
    }
    if (json['expertise'] != null) {
      expertise = <ExpertiseModel>[];
      json['expertise'].forEach((v) {
        expertise!.add(ExpertiseModel.fromJson(v));
      });
    }
    if (json['reviews'] != null) {
      reviews = <Reviews>[];
      json['reviews'].forEach((v) {
        reviews!.add(Reviews.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['experience_interval'] = experienceInterval;
    data['experience_duration'] = experienceDuration;
    data['email'] = email;
    data['phone'] = phone;
    data['review_ratings'] = reviewRatings;
    if (primaryAddress != null) {
      data['primary_address'] = primaryAddress!.toJson();
    }
    if (media != null) {
      data['media'] = media!.map((v) => v.toJson()).toList();
    }
    if (wallet != null) {
      data['wallet'] = wallet;
    }
    if (knownLanguages != null) {
      data['known_languages'] =
          knownLanguages!.map((v) => v.toJson()).toList();
    }
    if (expertise != null) {
      data['expertise'] = expertise!.map((v) => v.toJson()).toList();
    }
    if (reviews != null) {
      data['reviews'] = reviews!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BookingStatus {
  int? id;
  String? name;

  BookingStatus({this.id, this.name});

  BookingStatus.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

class BookingProviderModel {
  int? id;
  String? name;
  String? experienceInterval;
  String? experienceDuration;
  String? email;
  String? phone;
  int? reviewRatings;
  PrimaryAddress? primaryAddress;
  List<Media>? media;
  WalletModel? wallet;
  List<KnownLanguageModel>? knownLanguages;
  List<ExpertiseModel>? expertise;
  List<Reviews>? reviews;

  BookingProviderModel(
      {this.id,
        this.name,
        this.experienceInterval,
        this.experienceDuration,
        this.email,
        this.phone,
        this.reviewRatings,
        this.primaryAddress,
        this.media,
        this.wallet,
        this.knownLanguages,
        this.expertise,
        this.reviews});

  BookingProviderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    experienceInterval = json['experience_interval'];
    experienceDuration = json['experience_duration'];
    email = json['email'];
    phone = json['phone'];
    reviewRatings = json['review_ratings'];
    primaryAddress = json['primary_address'] != null
        ? PrimaryAddress.fromJson(json['primary_address'])
        : null;
    if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media!.add(Media.fromJson(v));
      });
    }
    wallet = json['wallet'];
    if (json['known_languages'] != null) {
      knownLanguages = <KnownLanguageModel>[];
      json['known_languages'].forEach((v) {
        knownLanguages!.add(KnownLanguageModel.fromJson(v));
      });
    }
    if (json['expertise'] != null) {
      expertise = <ExpertiseModel>[];
      json['expertise'].forEach((v) {
        expertise!.add(ExpertiseModel.fromJson(v));
      });
    }
    if (json['reviews'] != null) {
      reviews = <Reviews>[];
      json['reviews'].forEach((v) {
        reviews!.add(Reviews.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['experience_interval'] = experienceInterval;
    data['experience_duration'] = experienceDuration;
    data['email'] = email;
    data['phone'] = phone;
    data['review_ratings'] = reviewRatings;
    if (primaryAddress != null) {
      data['primary_address'] = primaryAddress!.toJson();
    }
    if (media != null) {
      data['media'] = media!.map((v) => v.toJson()).toList();
    }
    data['wallet'] = wallet;
    if (knownLanguages != null) {
      data['known_languages'] =
          knownLanguages!.map((v) => v.toJson()).toList();
    }
    if (expertise != null) {
      data['expertise'] = expertise!.map((v) => v.toJson()).toList();
    }
    if (reviews != null) {
      data['reviews'] = reviews!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BookingPivot {
  String? serviceId;
  String? categoryId;

  BookingPivot({this.serviceId, this.categoryId});

  BookingPivot.fromJson(Map<String, dynamic> json) {
    serviceId = json['service_id'];
    categoryId = json['category_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['service_id'] = serviceId;
    data['category_id'] = categoryId;
    return data;
  }
}
*/
