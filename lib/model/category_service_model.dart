// To parse this JSON data, do
//
//     final categoryServices = categoryServicesFromJson(jsonString);

import 'dart:convert';

CategoryServices categoryServicesFromJson(String str) =>
    CategoryServices.fromJson(json.decode(str));

String categoryServicesToJson(CategoryServices data) =>
    json.encode(data.toJson());

class CategoryServices {
  List<CategoryServicesCategory>? categories;
  List<Service>? services;

  CategoryServices({
    this.categories,
    this.services,
  });

  factory CategoryServices.fromJson(json) => CategoryServices(
        categories: json["categories"] == null
            ? []
            : List<CategoryServicesCategory>.from(json["categories"]!
                .map((x) => CategoryServicesCategory.fromJson(x))),
        services: json["services"] == null
            ? []
            : List<Service>.from(
                json["services"]!.map((x) => Service.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "categories": categories == null
            ? []
            : List<dynamic>.from(categories!.map((x) => x.toJson())),
        "services": services == null
            ? []
            : List<dynamic>.from(services!.map((x) => x.toJson())),
      };
}

class CategoryServicesCategory {
  int? id;
  String? title;
  bool? isChild;
  int? servicesCount;
  List<Media>? media;

  CategoryServicesCategory({
    this.id,
    this.title,
    this.isChild,
    this.servicesCount,
    this.media,
  });

  factory CategoryServicesCategory.fromJson(Map<String, dynamic> json) =>
      CategoryServicesCategory(
        id: json["id"],
        title: json["title"],
        isChild: json["is_child"],
        servicesCount: json["services_count"],
        media: json["media"] == null
            ? []
            : List<Media>.from(json["media"]!.map((x) => Media.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "is_child": isChild,
        "services_count": servicesCount,
        "media": media == null
            ? []
            : List<dynamic>.from(media!.map((x) => x.toJson())),
      };
}

class Media {
  int? id;
  CollectionName? collectionName;
  String? originalUrl;

  Media({
    this.id,
    this.collectionName,
    this.originalUrl,
  });

  factory Media.fromJson(Map<String, dynamic> json) => Media(
        id: json["id"],
        collectionName: collectionNameValues.map[json["collection_name"]]!,
        originalUrl: json["original_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "collection_name": collectionNameValues.reverse[collectionName],
        "original_url": originalUrl,
      };
}

enum CollectionName { IMAGE, THUMBNAIL }

final collectionNameValues = EnumValues(
    {"image": CollectionName.IMAGE, "thumbnail": CollectionName.THUMBNAIL});

class Service {
  int? id;
  String? title;
  dynamic price;
  int? status;
  String? duration;
  DurationUnit? durationUnit;
  int? discount;
  dynamic parentId;
  Type? type;
  int? isFeatured;
  int? isAdvertised;
  double? serviceRate;
  int? requiredServicemen;
  dynamic bookingsCount;
  dynamic ratingCount;
  dynamic serviceType;
  List<Media>? media;
  List<ServiceCategory>? categories;

  Service({
    this.id,
    this.title,
    this.price,
    this.status,
    this.duration,
    this.durationUnit,
    this.discount,
    this.parentId,
    this.type,
    this.isFeatured,
    this.isAdvertised,
    this.bookingsCount,
    this.ratingCount,
    this.serviceRate,
    this.requiredServicemen,
    this.serviceType,
    this.media,
    this.categories,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json["id"],
        title: json["title"],
        price: json["price"],
        status: json["status"],
        duration: json["duration"],
        durationUnit: durationUnitValues.map[json["duration_unit"]],
        discount: json["discount"],
        parentId: json["parent_id"],
        type: typeValues.map[json["type"]],
        isFeatured: json["is_featured"],
        isAdvertised: json["is_advertised"],
        serviceRate: json["service_rate"]?.toDouble(),
        requiredServicemen: json["required_servicemen"],
        bookingsCount: json["bookings_count"],
        ratingCount: json["rating_count"],
        serviceType: json["service_type"],
    media: (json["media"] != null && json["media"] is List)
        ? (json["media"] as List).map((x) => Media.fromJson(x)).toList()
        : [],
        categories: json["categories"] == null
            ? []
            : List<ServiceCategory>.from(
                json["categories"]!.map((x) => ServiceCategory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "price": price,
        "status": status,
        "duration": duration,
        "duration_unit": durationUnitValues.reverse[durationUnit],
        "discount": discount,
        "parent_id": parentId,
        "type": typeValues.reverse[type],
        "is_featured": isFeatured,
        "is_advertised": isAdvertised,
        "service_rate": serviceRate,
        "bookings_count": bookingsCount,
        "rating_count": ratingCount,
        "required_servicemen": requiredServicemen,
        "service_type": serviceType,
        "media": media == null
            ? []
            : List<dynamic>.from(media!.map((x) => x.toJson())),
        "categories": categories == null
            ? []
            : List<dynamic>.from(categories!.map((x) => x.toJson())),
      };
}

class ServiceCategory {
  int? id;
  String? title;

  ServiceCategory({
    this.id,
    this.title,
  });

  factory ServiceCategory.fromJson(Map<String, dynamic> json) =>
      ServiceCategory(
        id: json["id"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
      };
}

enum DurationUnit { HOURS, MINUTES }

final durationUnitValues =
    EnumValues({"hours": DurationUnit.HOURS, "minutes": DurationUnit.MINUTES});

enum Type { FIXED, PROVIDER_SITE }

final typeValues =
    EnumValues({"fixed": Type.FIXED, "provider_site": Type.PROVIDER_SITE});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
