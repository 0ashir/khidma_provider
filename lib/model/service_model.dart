import 'package:fixit_provider/model/index.dart';
import 'package:fixit_provider/model/service_tax_model.dart';

import '../config.dart';

class Services {
  int? id;
  String? title;
  double? price;
  int? status;
  String? duration;
  String? durationUnit;
  double? serviceRate;
  int? discount;
  String? discountAmount;
  String? description;
  String? content;
  String? specialityDescription;
  int? userId;
  String? type;
  int? isFeatured;
  int? requiredServicemen;
  String? isRandomRelatedServices;
  String? isMultipleServiceman;
  String? metaDescription;
  String? selectServiceManType;
  String? bookingsCount;
  String? reviewsCount;
  DateTime? serviceDate;
  List<int>? reviewRatings;
  int? ratingCount;
  List<CategoryModel>? categories;
  List<Services>? relatedServices;
  List<Media>? media;
  List<ZoneModel>? zones;
  ProviderModel? user;
  List<ServiceAvailabilities>? serviceAvailabilities;
  List<Reviews>? reviews;
  List<ProviderModel>? selectedServiceMan;
  int? selectedRequiredServiceMan;
  String? selectDateTimeOption;
  String? selectedDateTimeFormat;
  String? selectedServiceNote;
  int? perServicemanCommission;
  PrimaryAddress? primaryAddress;
  int? addressId;
  Tax? tax;
  List<PrimaryAddress>? addresses;
  int? taxId;
  String? webImgThumbUrl;
  List<dynamic>? webImgGalleriesUrl;
  String? video;
  ServicePivot? pivot;
  dynamic highestCommission;
  List<Tax>? taxes;
  int? isAdvancePayment;
  int? advancePaymentPercentage;

  Services({
    this.id,
    this.title,
    this.price,
    this.status,
    this.duration,
    this.durationUnit,
    this.serviceRate,
    this.discount,
    this.highestCommission,
    this.description,
    this.content,
    this.addressId,
    this.specialityDescription,
    this.userId,
    this.type,
    this.isFeatured,
    this.requiredServicemen,
    this.isRandomRelatedServices,
    this.isMultipleServiceman,
    this.metaDescription,
    this.selectServiceManType,
    this.bookingsCount,
    this.reviewsCount,
    this.serviceDate,
    this.reviewRatings,
    this.ratingCount,
    this.categories,
    this.relatedServices,
    this.media,
    this.zones,
    this.user,
    this.reviews,
    this.selectedRequiredServiceMan,
    this.primaryAddress,
    this.tax,
    this.selectDateTimeOption,
    this.selectedDateTimeFormat,
    this.perServicemanCommission,
    this.selectedServiceNote,
    this.addresses,
    this.webImgGalleriesUrl,
    this.webImgThumbUrl,
    this.taxId,
    this.video,
    this.pivot,
    this.taxes,
    this.discountAmount,
    this.isAdvancePayment,
    this.advancePaymentPercentage,
  });

  Services.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    video = json['video'];
    addressId = json['address_id'];
    pivot = json["pivot"] == null ? null : ServicePivot.fromJson(json["pivot"]);
    title = json['title'];
    highestCommission = json['highest_commission']?.toString();
    isAdvancePayment = json['is_advance_payment_enabled'] == null
        ? null
        : (json['is_advance_payment_enabled'] is bool)
            ? (json['is_advance_payment_enabled'] ? 1 : 0)
            : int.tryParse(json['is_advance_payment_enabled'].toString());

    advancePaymentPercentage = json['advance_payment_percentage'] == null
        ? null
        : (json['advance_payment_percentage'] is int)
            ? json['advance_payment_percentage']
            : int.tryParse(json['advance_payment_percentage'].toString());
    price =
        json['price'] != null ? double.parse(json['price'].toString()) : null;
    status = json['status'];
    duration = json['duration'];
    specialityDescription = json['speciality_description'];
    durationUnit = json['duration_unit'];
    serviceRate = json['service_rate'] != null
        ? double.parse(json['service_rate'].toString())
        : null;
    discount = json['discount'];
    discountAmount = json['discount_amount'];
    description = json['description'];
    content = json['content'];
    userId = json['user_id'];
    type = json['type'];
    isFeatured = json['is_featured'];
    perServicemanCommission = json['per_serviceman_commission'];
    requiredServicemen = json['required_servicemen'];
    isRandomRelatedServices = json['is_random_related_services']?.toString();
    isMultipleServiceman = json['isMultipleServiceman']?.toString();
    metaDescription = json['meta_description'];
    selectServiceManType = json['selectServiceManType'];
    bookingsCount = json['bookings_count']?.toString();
    webImgThumbUrl = json['web_img_thumb_url'];
    webImgGalleriesUrl = json['web_img_galleries_url'] /* .cast<String>() */;
    reviewsCount = json['reviews_count']?.toString();

    serviceDate = json["serviceDate"] == null
        ? null
        : DateTime.parse(json["serviceDate"]);
    reviewRatings = json['review_ratings']?.cast<int>();
    ratingCount = json['rating_count'];
    selectedRequiredServiceMan = json['required_servicemen'] ?? 1;
    selectDateTimeOption = json['selectDateTimeOption'];
    selectedDateTimeFormat = json['selectedDateTimeFormat'];
    taxId = json['tax_id'];
    selectedServiceNote = json['selectedServiceNote'];
    if (json['categories'] != null) {
      categories = <CategoryModel>[];
      json[
          'categories']; /* .forEach((v) {
        categories!.add(CategoryModel.fromJson(v));
      }); */
    }
    if (json['related_services'] != null) {
      relatedServices = <Services>[];
      json['related_services'].forEach((v) {
        relatedServices!.add(Services.fromJson(v));
      });
    }
    if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media!.add(Media.fromJson(v));
      });
    }
    if (json['zones'] != null) {
      zones = <ZoneModel>[];
      json['zones'].forEach((v) {
        zones!.add(ZoneModel.fromJson(v));
      });
    }
    user = json['user'] != null ? ProviderModel.fromJson(json['user']) : null;
    if (json['service_availabilities'] != null) {
      serviceAvailabilities = <ServiceAvailabilities>[];
      json['service_availabilities'].forEach((v) {
        serviceAvailabilities!.add(ServiceAvailabilities.fromJson(v));
      });
    }
    primaryAddress = json['primary_address'] != null
        ? PrimaryAddress.fromJson(json['primary_address'])
        : null;
    tax = json['tax'] != null ? Tax.fromJson(json['tax']) : null;
    if (json['reviews'] != null) {
      reviews = <Reviews>[];
      json['reviews'].forEach((v) {
        reviews!.add(Reviews.fromJson(v));
      });
    }
    if (json['selectedServiceMan'] != null) {
      selectedServiceMan = <ProviderModel>[];
      json['selectedServiceMan'].forEach((v) {
        selectedServiceMan!.add(ProviderModel.fromJson(v));
      });
    }
    if (json['addresses'] != null) {
      addresses = <PrimaryAddress>[];
      json['addresses'].forEach((v) {
        addresses!.add(PrimaryAddress.fromJson(v));
      });
    }
    if (json['taxes'] != null) {
      taxes = <Tax>[];
      json['taxes'].forEach((v) {
        taxes!.add(Tax.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['video'] = video;
    if (pivot != null) data["pivot"] = pivot?.toJson();
    /*  data['video'] = video; */
    data['title'] = title;
    data['price'] = price;
    data['status'] = status;
    data['address_id'] = addressId;
    data['duration'] = duration;
    data['content'] = content;
    data['duration_unit'] = durationUnit;
    data['service_rate'] = serviceRate;
    data['discount'] = discount;
    data['discount_amount'] = discountAmount;
    data['description'] = description;
    data['speciality_description'] = specialityDescription;
    data['user_id'] = userId;
    data['type'] = type;
    data['highest_commission'] = highestCommission;
    data['is_advance_payment_enabled'] = isAdvancePayment;
    data['advance_payment_percentage'] = advancePaymentPercentage;
    data['is_featured'] = isFeatured;
    data['required_servicemen'] = requiredServicemen;
    data['is_random_related_services'] = isRandomRelatedServices;
    data['isMultipleServiceman'] = isMultipleServiceman;
    data['meta_description'] = metaDescription;
    data['selectServiceManType'] = selectServiceManType;
    data['bookings_count'] = bookingsCount;
    data['reviews_count'] = reviewsCount;
    data['tax_id'] = taxId;
    data['per_serviceman_commission'] = perServicemanCommission;
    data['serviceDate'] = serviceDate?.toIso8601String();
    data['review_ratings'] = reviewRatings;
    data['rating_count'] = ratingCount;
    data['selectedRequiredServiceMan'] = selectedRequiredServiceMan;
    data['selectDateTimeOption'] = selectDateTimeOption;
    data['selectedDateTimeFormat'] = selectedDateTimeFormat;
    data['selectedServiceNote'] = selectedServiceNote;
    data['web_img_thumb_url'] = webImgThumbUrl;
    data['web_img_galleries_url'] = webImgGalleriesUrl;
    if (primaryAddress != null) {
      data['primary_address'] = primaryAddress!.toJson();
    }
    if (tax != null) {
      data['tax'] = tax!.toJson();
    }
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    if (relatedServices != null) {
      data['related_services'] =
          relatedServices!.map((v) => v.toJson()).toList();
    }
    if (media != null) {
      data['media'] = media!.map((v) => v.toJson()).toList();
    }
    if (zones != null) {
      data['zones'] = zones!.map((v) => v.toJson()).toList();
    }
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (serviceAvailabilities != null) {
      data['service_availabilities'] =
          serviceAvailabilities!.map((v) => v.toJson()).toList();
    }
    if (reviews != null) {
      data['reviews'] = reviews!.map((v) => v.toJson()).toList();
    }
    if (selectedServiceMan != null) {
      data['selectedServiceMan'] =
          selectedServiceMan!.map((v) => v.toJson()).toList();
    }
    if (addresses != null) {
      data['addresses'] = addresses!.map((v) => v.toJson()).toList();
    }
    if (taxes != null) {
      data['taxes'] = taxes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CategoryService {
  int? id;
  List<Services>? serviceList;

  CategoryService({this.id, this.serviceList});

  CategoryService.fromJson(Map<String, dynamic> json) {
    id = json['id'];

    if (json['serviceList'] != null) {
      serviceList = <Services>[];
      json['serviceList'].forEach((v) {
        serviceList!.add(Services.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;

    if (serviceList != null) {
      data['serviceList'] = serviceList!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class ServicePivot {
  int? advertisementId;
  int? serviceId;

  ServicePivot({
    this.advertisementId,
    this.serviceId,
  });

  factory ServicePivot.fromJson(Map<String, dynamic> json) => ServicePivot(
        advertisementId: json["advertisement_id"],
        serviceId: json["service_id"],
      );

  Map<String, dynamic> toJson() => {
        "advertisement_id": advertisementId,
        "service_id": serviceId,
      };
}

class Tax {
  int? id;
  String? name;
  double? rate;
  dynamic amount;

  Tax({this.id, this.name, this.rate, this.amount});

  factory Tax.fromJson(Map<String, dynamic> json) => Tax(
      id: json['id'],
      name: json['name'],
      rate: (json['rate'] as num?)?.toDouble(),
      amount: (json['amount'] as num?)?.toDouble());

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'rate': rate, 'amount': amount};
}
