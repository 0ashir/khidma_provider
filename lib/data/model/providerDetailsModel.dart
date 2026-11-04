import 'dart:convert';

import 'package:edemand_partner/app/generalImports.dart';

class ProviderDetails {
  ProviderDetails({
    this.locationInformation,
    this.user,
    this.providerInformation,
    this.workingDays,
    this.subscriptionInformation,
    this.deletedOtherImages,
    this.unreadCustomerSupportChatCounter,
    this.customFields,
  });

  factory ProviderDetails.createEmptyModel() {
    return ProviderDetails(
      workingDays: [],
      user: UserDetails(),
      providerInformation: ProviderInformation(),
      locationInformation: LocationInformation(),
      subscriptionInformation: SubscriptionInformation(),
      unreadCustomerSupportChatCounter: 0,
      customFields: [],
    );
  }

  factory ProviderDetails.fromJson(Map<String, dynamic> json) {
    // Extract translated_fields from provider information only
    final Map<String, dynamic> providerInfoJson = Map.from(
      json['provder_information'] ?? {},
    );

    // Prepare user JSON with translated_fields from provider information
    final Map<String, dynamic> userJson = Map.from(json['user'] ?? {});

    return ProviderDetails(
      locationInformation: LocationInformation.fromJson(
        Map.from(json['location_information'] ?? {}),
      ),
      user: UserDetails.fromJson(userJson),
      providerInformation: ProviderInformation.fromJson(providerInfoJson),
      workingDays: json['working_days'] == null
          ? []
          : (json['working_days'] as List).map((e) {
              return WorkingDay.fromJson(Map.from(e));
            }).toList(),
      subscriptionInformation: SubscriptionInformation.fromJson(
        Map.from(json["subscription_information"] ?? {}),
      ),
      unreadCustomerSupportChatCounter:
          int.tryParse(json['unread_chats_count']?.toString() ?? "0") ?? 0,
      customFields: json['provider_custom_fields'] == null
          ? []
          : List<Map<String, dynamic>>.from(json['provider_custom_fields']),
    );
  }

  final LocationInformation? locationInformation;
  final UserDetails? user;
  final ProviderInformation? providerInformation;
  final List<WorkingDay>? workingDays;
  final SubscriptionInformation? subscriptionInformation;
  final Set<String>? deletedOtherImages;
  final int? unreadCustomerSupportChatCounter;
  final List<Map<String, dynamic>>? customFields;

  ///used when need to store data in hive (locally)
  Map<String, dynamic> toJsonData() => {
    'subscription_information': subscriptionInformation?.toJson(),
    'location_information': locationInformation?.toJson(),
    'user': user?.toJson(),
    'provder_information': providerInformation?.toJson(),
    'working_days': workingDays?.map((e) => e.toJson()).toList(),
    'unread_chats_count': unreadCustomerSupportChatCounter,
    'provider_custom_fields': customFields,
  };

  Map<String, dynamic> toJson() {
    // Debug: Log what translatedFields contains

    final Map<String, dynamic> parameters = {
      'city': locationInformation?.city,
      'current_location': locationInformation?.city,
      'latitude': locationInformation?.latitude,
      'longitude': locationInformation?.longitude,
      'address': locationInformation?.address,
      'email': user?.email,
      'mobile': user?.phone,
      'image': user?.image,
      'password': user?.password,
      'password_confirm': user?.password,
      'country_code': user?.countryCode,

      'days': workingDays == null
          ? []
          : List<dynamic>.from(workingDays!.map((WorkingDay x) => x.toJson())),
      'national_id': providerInformation?.nationalId,
      'banner_image': providerInformation?.banner,
      'address_id': providerInformation?.addressId,
      'passport': providerInformation?.passport,
      'advance_booking_days': providerInformation?.advanceBookingDays,
      'type': providerInformation?.type,
      'number_of_members': providerInformation?.numberOfMembers,
      'visiting_charges': providerInformation?.visitingCharges,
      'max_serviceable_distance': providerInformation?.maxServiceableDistance,
      'other_images': providerInformation?.otherImages,

      // Translated fields (like serviceModel.dart)
      'translated_fields': jsonEncode(providerInformation?.translatedFields),

      "post_booking_chat": providerInformation?.isPostBookingChatAllowed,
      "pre_booking_chat": providerInformation?.isPreBookingChatAllowed,
      "custom_job_categories": providerInformation?.customJobCategories,
      "at_store": providerInformation?.atStore,
      "at_doorstep": providerInformation?.atDoorstep,

      // SEO fields
      'seo_title': providerInformation?.seoTitle,
      'seo_description': providerInformation?.seoDescription,
      'seo_keywords': providerInformation?.seoKeywords,
      'seo_schema_markup': providerInformation?.seoSchemaMarkup,
      'seo_og_image': providerInformation?.seoOgImage,

      //delete images field
      'images_to_delete': deletedOtherImages?.toList(),
      'custom_fields': customFields,
    };

    final String jsonString = jsonEncode(parameters['days']);
    parameters['days'] = jsonString;

    return parameters;
  }
}

class LocationInformation {
  LocationInformation({this.city, this.latitude, this.longitude, this.address});

  factory LocationInformation.fromJson(Map<String, dynamic> json) {
    return LocationInformation(
      city: json['city'] ?? '',
      latitude: json['latitude'].toString(),
      longitude: json['longitude'].toString(),
      address: json['address'].toString(),
    );
  }

  final String? city;
  final String? latitude;
  final String? longitude;
  final String? address;

  Map<String, dynamic> toJson() => {
    'city': city,
    'latitude': latitude,
    'longitude': longitude,
    'address': address,
  };
}

class ProviderInformation {
  ProviderInformation({
    this.id,
    this.partnerId,
    // this.companyName, // Use getTranslatedCompanyName() instead
    // this.about, // Use getTranslatedAbout() instead
    this.nationalId,
    this.banner,
    this.addressId,
    this.passport,
    this.advanceBookingDays,
    this.type,
    this.numberOfMembers,
    this.adminCommission,
    this.visitingCharges,
    this.isApproved,
    this.kycStatus,
    this.atStore,
    this.atDoorstep,
    this.serviceRange,
    this.ratings,
    this.numberOfRatings,
    this.createdAt,
    this.updatedAt,
    // this.longDescription, // Use getTranslatedLongDescription() instead
    this.otherImages,
    this.isPostBookingChatAllowed,
    this.isPreBookingChatAllowed,
    this.totalJobRequests,
    this.customJobCategories,
    this.seoTitle,
    this.seoDescription,
    this.seoKeywords,
    this.seoSchemaMarkup,
    this.seoOgImage,
    // Complete translated_fields structure
    this.translatedFields,
    this.maxServiceableDistance,
    this.disapprovalReason,
    this.isVerified,
    this.countryId,
    this.country,
    this.regionId,
    this.region,
    this.taxRegistrationNumber,
  });

  factory ProviderInformation.fromJson(Map<String, dynamic> json) {
    return ProviderInformation(
      id: json['id'] ?? '0',
      partnerId: json['partner_id'] ?? '0',
      // companyName: json['company_name']?.toString() ?? '', // Use getTranslatedCompanyName() instead
      // about: json['about']?.toString() ?? '', // Use getTranslatedAbout() instead
      nationalId: json['national_id']?.toString() ?? '',
      banner: json['banner']?.toString() ?? '',
      addressId: json['address_id']?.toString() ?? '',
      passport: json['passport']?.toString() ?? '',
      advanceBookingDays: json['advance_booking_days']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      numberOfMembers: json['number_of_members']?.toString() ?? '',
      adminCommission: json['admin_commission']?.toString() ?? '',
      visitingCharges: json['visiting_charges']?.toString() ?? '',
      isApproved: json['is_approved']?.toString() ?? '',
      kycStatus: json['kyc_status']?.toString() ?? '',
      atDoorstep: json['at_doorstep']?.toString() ?? '',
      atStore: json['at_store']?.toString() ?? '',
      serviceRange: json['service_range']?.toString() ?? '',
      ratings: json['ratings']?.toString() ?? '',
      numberOfRatings: json['number_of_ratings']?.toString() ?? '',
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at']),
      updatedAt: json['updated_at']?.toString() ?? '',
      otherImages: json["other_images"] != null && json["other_images"] != ''
          ? json["other_images"].map<String>((e) => e.toString()).toList()
          : <String>[],
      // longDescription: json["long_description"]?.toString() ?? '', // Use getTranslatedLongDescription() instead
      isPreBookingChatAllowed: json["pre_booking_chat"]?.toString() ?? '',
      isPostBookingChatAllowed: json["post_booking_chat"]?.toString() ?? '',
      customJobCategories:
          json["custom_job_categories"] != null &&
              json["custom_job_categories"] != ''
          ? json["custom_job_categories"]
                .map<String>((e) => e.toString())
                .toList()
          : <String>[],
      totalJobRequests: (json['total_job_request'] ?? "0")?.toString() ?? '',
      seoTitle: json['seo_title']?.toString() ?? '',
      seoDescription: json['seo_description']?.toString() ?? '',
      seoKeywords: json['seo_keywords']?.toString() ?? '',
      seoSchemaMarkup: json['seo_schema_markup']?.toString() ?? '',
      seoOgImage: json['seo_og_image']?.toString() ?? '',
      // Store complete translated_fields structure (like serviceModel.dart)
      translatedFields: json['translated_fields'] != null
          ? Map<String, dynamic>.from(json['translated_fields'])
          : null,
      maxServiceableDistance:
          json['max_serviceable_distance']?.toString() ?? '',
      disapprovalReason: json['disapproval_reason']?.toString() ?? '',
      isVerified: json['is_verified']?.toString() == '1',
      countryId: json['country_id']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
      regionId: json['region_id']?.toString() ?? '',
      region: json['region']?.toString() ?? '',
      taxRegistrationNumber: json['tax_registration_number']?.toString() ?? '',
    );
  }

  final String? id;
  final String? partnerId;

  // Use getTranslatedCompanyName(languageCode) instead
  // final String? companyName;
  // Use getTranslatedAbout(languageCode) instead
  // final String? about;
  final String? nationalId;
  final String? banner;
  final String? addressId;
  final String? passport;
  final String? advanceBookingDays;
  final String? type;
  final String? numberOfMembers;
  final String? adminCommission;
  final String? visitingCharges;
  final String? isApproved;
  final String? kycStatus;
  final String? atStore;
  final String? atDoorstep;
  final dynamic serviceRange;
  final String? ratings;
  final String? numberOfRatings;
  final DateTime? createdAt;
  final String? updatedAt;
  final List<String>? otherImages;

  // Use getTranslatedLongDescription(languageCode) instead
  // final String? longDescription;
  final String? isPreBookingChatAllowed;
  final String? isPostBookingChatAllowed;
  List<String>? customJobCategories;
  final String? totalJobRequests;
  final String? seoTitle;
  final String? seoDescription;
  final String? seoKeywords;
  final String? seoSchemaMarkup;
  final String? seoOgImage;

  // Complete translated_fields structure (like serviceModel.dart)
  final Map<String, dynamic>? translatedFields;
  final String? maxServiceableDistance;

  /// Reason provided by the admin when disapproving this provider.
  /// Only populated when [isApproved] != '1'.
  final String? disapprovalReason;

  /// Whether the provider's latest verification request was approved.
  /// Distinct from [kycStatus] and [isApproved].
  final bool? isVerified;

  /// Country and region the provider registered with, as returned by login.
  final String? countryId;
  final String? country;
  final String? regionId;
  final String? region;

  /// Government tax registration number (GST, SIN, VAT...). Empty when the
  /// provider has not entered one. Sent as an empty string to clear it.
  final String? taxRegistrationNumber;

  Map<String, dynamic> toJson() => {
    'id': id,
    'partner_id': partnerId,
    // 'company_name': companyName, // Use getTranslatedCompanyName() instead
    // 'about': about, // Use getTranslatedAbout() instead
    'national_id': nationalId,
    'banner': banner,
    'address_id': addressId,
    'passport': passport,
    'advance_booking_days': advanceBookingDays,
    'type': type,
    'number_of_members': numberOfMembers,
    'admin_commission': adminCommission,
    'visiting_charges': visitingCharges,
    'is_approved': isApproved,
    'kyc_status': kycStatus,
    'is_verified': isVerified == true ? '1' : '0',
    'at_store': atStore,
    'at_doorstep': atDoorstep,
    'service_range': serviceRange,
    'ratings': ratings,
    'number_of_ratings': numberOfRatings,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt,
    // 'long_description': longDescription, // Use getTranslatedLongDescription() instead
    'other_images': otherImages,
    'costom_job_categories': customJobCategories,
    'total_job_request': totalJobRequests,
    'seo_title': seoTitle,
    'seo_description': seoDescription,
    'seo_keywords': seoKeywords,
    'seo_schema_markup': seoSchemaMarkup,
    'seo_og_image': seoOgImage,
    // Add translated fields (like serviceModel.dart)
    if (translatedFields != null && translatedFields!.isNotEmpty)
      'translated_fields': translatedFields,
    'max_serviceable_distance': maxServiceableDistance,
    if (disapprovalReason != null && disapprovalReason!.isNotEmpty)
      'disapproval_reason': disapprovalReason,
    'country_id': countryId,
    'country': country,
    'region_id': regionId,
    'region': region,
    // Omitting keeps the stored value, an empty string clears it.
    if (taxRegistrationNumber != null)
      ApiParam.taxRegistrationNumber: taxRegistrationNumber,
  };

  // Helper methods to get translated data based on current language (like serviceModel.dart)
  String? getTranslatedUsername(String languageCode) {
    return translatedFields?['username']?[languageCode]?.toString();
  }

  String? getTranslatedCompanyName(String languageCode) {
    return translatedFields?['company_name']?[languageCode]?.toString();
  }

  String? getTranslatedAbout(String languageCode) {
    return translatedFields?['about']?[languageCode]?.toString();
  }

  String? getTranslatedLongDescription(String languageCode) {
    return translatedFields?['long_description']?[languageCode]?.toString();
  }

  String? getTranslatedSeoTitle(String languageCode) {
    return translatedFields?['seo_title']?[languageCode]?.toString();
  }

  String? getTranslatedSeoDescription(String languageCode) {
    return translatedFields?['seo_description']?[languageCode]?.toString();
  }

  String? getTranslatedSeoKeywords(String languageCode) {
    final dynamic data = translatedFields?['seo_keywords']?[languageCode];
    if (data == null) return null;
    if (data is List) {
      return data
          .map((e) => e.toString().trim())
          .where((e) => e.isNotEmpty)
          .join(', ');
    }
    return data.toString();
  }

  String? getTranslatedSeoSchemaMarkup(String languageCode) {
    return translatedFields?['seo_schema_markup']?[languageCode]?.toString();
  }
}

class UserDetails {
  UserDetails({
    this.id,
    // this.username, // Use providerInformation.getTranslatedUsername() instead
    this.email,
    this.password,
    this.balance,
    this.active,
    this.firstName,
    this.lastName,
    this.company,
    this.phone,
    this.fcmId,
    this.image,
    this.cityId,
    this.countryCode,
    this.loginType,
    // this.translatedUsername, // Removed - use providerInformation.translatedFields instead
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      id: json['id'] ?? '0',
      // username: json['username'].toString(), // Use providerInformation.getTranslatedUsername() instead
      email: json['email'].toString(),
      balance: json['balance'].toString(),
      active: json['active'].toString(),
      firstName: json['first_name'].toString(),
      lastName: json['last_name'].toString(),
      company: json['company'].toString(),
      phone: json['phone'].toString(),
      countryCode: json['country_code'].toString(),
      fcmId: json['fcm_id'].toString(),
      image: json['image'].toString(),
      cityId: json['city_id'].toString(),
      password: json['password'].toString(),
      loginType: LoginType.fromAPIValue(json['login_type']?.toString()),
      // translatedUsername: removed - use providerInformation.translatedFields instead
    );
  }

  final String? id;

  // Use providerInformation.getTranslatedUsername(languageCode) instead
  // final String? username;
  final String? email;
  final String? balance;
  final String? active;
  final dynamic firstName;
  final dynamic lastName;
  final dynamic company;
  final String? phone;
  final String? countryCode;
  final dynamic fcmId;
  final dynamic image;
  final String? cityId;
  final String? password;
  final LoginType? loginType;

  // final Map<String, String>? translatedUsername; // Removed - use providerInformation.translatedFields instead

  Map<String, dynamic> toJson() => {
    'id': id,
    // 'username': username, // Use providerInformation.getTranslatedUsername() instead
    'email': email,
    'balance': balance,
    'active': active,
    'first_name': firstName,
    'last_name': lastName,
    'company': company,
    'phone': phone,
    'fcm_id': fcmId,
    'image': image,
    'city_id': cityId,
    'password': password,
    'country_code': countryCode,
    'login_type': loginType?.value,
    // translatedFields are now in providerInformation.translatedFields
  };
}

class WorkingDay {
  WorkingDay({this.day, this.isOpen, this.startTime, this.endTime});

  factory WorkingDay.fromJson(Map<String, dynamic> json) {
    return WorkingDay(
      day: json['day'].toString(),
      isOpen: int.parse(json['isOpen'].toString()),
      startTime: json['start_time'].toString(),
      endTime: json['end_time'].toString(),
    );
  }

  final String? day;
  final int? isOpen;
  final String? startTime;
  final String? endTime;

  Map<String, dynamic> toJson() => {
    'day': day,
    'isOpen': isOpen,
    'start_time': startTime,
    'end_time': endTime,
  };
}
