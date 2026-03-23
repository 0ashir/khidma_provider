/* // To parse this JSON data, do
//
//     final advertisementDetailsModel = advertisementDetailsModelFromJson(jsonString);

import 'package:fixit_provider/model/service_model.dart';

class AdvertisementDetailsModel {
  bool? success;
  Data? data;

  AdvertisementDetailsModel({
    this.success,
    this.data,
  });

  factory AdvertisementDetailsModel.fromJson(Map<dynamic, dynamic> json) =>
      AdvertisementDetailsModel(
        success: json["success"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<dynamic, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
      };
}

class Data {
  int? id;
  int? providerId;
  int? zone;
  String? type;
  String? screen;
  DateTime? startDate;
  DateTime? endDate;
  int? price;
  String? bannerType;
  dynamic videoLink;
  String? status;
  int? createdBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  List<Media>? media;
  List<Services>? services;

  Data({
    this.id,
    this.providerId,
    this.zone,
    this.type,
    this.screen,
    this.startDate,
    this.endDate,
    this.price,
    this.bannerType,
    this.videoLink,
    this.status,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.media,
    this.services,
  });

  factory Data.fromJson(Map<dynamic, dynamic> json) => Data(
        id: json["id"],
        providerId: json["provider_id"],
        zone: json["zone"],
        type: json["type"],
        screen: json["screen"],
        startDate: json["start_date"] == null
            ? null
            : DateTime.parse(json["start_date"]),
        endDate:
            json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
        price: json["price"],
        bannerType: json["banner_type"],
        videoLink: json["video_link"],
        status: json["status"],
        createdBy: json["created_by"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        media: json["media"] == null
            ? []
            : List<Media>.from(json["media"]!.map((x) => Media.fromJson(x))),
        services: json["services"] == null
            ? []
            : List<Services>.from(json["services"]!.map((x) => x)),
      );

  Map<dynamic, dynamic> toJson() => {
        "id": id,
        "provider_id": providerId,
        "zone": zone,
        "type": type,
        "screen": screen,
        "start_date":
            "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}",
        "end_date":
            "${endDate!.year.toString().padLeft(4, '0')}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}",
        "price": price,
        "banner_type": bannerType,
        "video_link": videoLink,
        "status": status,
        "created_by": createdBy,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "media": media == null
            ? []
            : List<dynamic>.from(media!.map((x) => x.toJson())),
        "services": services == null
            ? []
            : List<Services>.from(services!.map((x) => x)),
      };
}

class Media {
  int? id;
  String? modelType;
  int? modelId;
  String? uuid;
  String? collectionName;
  String? name;
  String? fileName;
  String? mimeType;
  String? disk;
  String? conversionsDisk;
  int? size;
  List<dynamic>? manipulations;
  CustomProperties? customProperties;
  List<dynamic>? generatedConversions;
  List<dynamic>? responsiveImages;
  int? orderColumn;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? originalUrl;
  String? previewUrl;

  Media({
    this.id,
    this.modelType,
    this.modelId,
    this.uuid,
    this.collectionName,
    this.name,
    this.fileName,
    this.mimeType,
    this.disk,
    this.conversionsDisk,
    this.size,
    this.manipulations,
    this.customProperties,
    this.generatedConversions,
    this.responsiveImages,
    this.orderColumn,
    this.createdAt,
    this.updatedAt,
    this.originalUrl,
    this.previewUrl,
  });

  factory Media.fromJson(Map<dynamic, dynamic> json) => Media(
        id: json["id"],
        modelType: json["model_type"],
        modelId: json["model_id"],
        uuid: json["uuid"],
        collectionName: json["collection_name"],
        name: json["name"],
        fileName: json["file_name"],
        mimeType: json["mime_type"],
        disk: json["disk"],
        conversionsDisk: json["conversions_disk"],
        size: json["size"],
        manipulations: json["manipulations"] == null
            ? []
            : List<dynamic>.from(json["manipulations"]!.map((x) => x)),
        customProperties: json["custom_properties"] == null
            ? null
            : CustomProperties.fromJson(json["custom_properties"]),
        generatedConversions: json["generated_conversions"] == null
            ? []
            : List<dynamic>.from(json["generated_conversions"]!.map((x) => x)),
        responsiveImages: json["responsive_images"] == null
            ? []
            : List<dynamic>.from(json["responsive_images"]!.map((x) => x)),
        orderColumn: json["order_column"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        originalUrl: json["original_url"],
        previewUrl: json["preview_url"],
      );

  Map<dynamic, dynamic> toJson() => {
        "id": id,
        "model_type": modelType,
        "model_id": modelId,
        "uuid": uuid,
        "collection_name": collectionName,
        "name": name,
        "file_name": fileName,
        "mime_type": mimeType,
        "disk": disk,
        "conversions_disk": conversionsDisk,
        "size": size,
        "manipulations": manipulations == null
            ? []
            : List<dynamic>.from(manipulations!.map((x) => x)),
        "custom_properties": customProperties?.toJson(),
        "generated_conversions": generatedConversions == null
            ? []
            : List<dynamic>.from(generatedConversions!.map((x) => x)),
        "responsive_images": responsiveImages == null
            ? []
            : List<dynamic>.from(responsiveImages!.map((x) => x)),
        "order_column": orderColumn,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "original_url": originalUrl,
        "preview_url": previewUrl,
      };
}

class CustomProperties {
  String? language;

  CustomProperties({
    this.language,
  });

  factory CustomProperties.fromJson(Map<dynamic, dynamic> json) =>
      CustomProperties(
        language: json["language"],
      );

  Map<dynamic, dynamic> toJson() => {
        "language": language,
      };
}
 */

// To parse this JSON data, do
//
//     final advertisementDetailsModel = advertisementDetailsModelFromJson(jsonString);

/* import 'dart:convert'; */

/* AdvertisementDetailsModel advertisementDetailsModelFromJson(String str) =>
    AdvertisementDetailsModel.fromJson(json.decode(str));

String advertisementDetailsModelToJson(AdvertisementDetailsModel data) =>
    json.encode(data.toJson()); */

import 'package:fixit_provider/model/service_model.dart';

class AdvertisementDetailsModel {
  int? id;
  int? providerId;
  String? type;
  dynamic bannerType;
  String? screen;
  String? status;
  String? startDate;
  String? endDate;
  List<Media>? media;
  List<Services>? services;
  String? videoLink;
  String? zone;

  AdvertisementDetailsModel(
      {this.id,
      this.providerId,
      this.type,
      this.bannerType,
      this.screen,
      this.status,
      this.startDate,
      this.endDate,
      this.media,
      this.services,
      this.videoLink,
      this.zone});

  AdvertisementDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    providerId = json['provider_id'];
    type = json['type'];
    bannerType = json['banner_type'];
    screen = json['screen'];
    status = json['status'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media!.add(Media.fromJson(v));
      });
    }
    if (json['services'] != null) {
      services = <Services>[];
      json['services'].forEach((v) {
        services!.add(new Services.fromJson(v));
      });
    }
    videoLink = json['video_link'];
    zone = json['zone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['provider_id'] = this.providerId;
    data['type'] = this.type;
    data['banner_type'] = this.bannerType;
    data['screen'] = this.screen;
    data['status'] = this.status;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    if (this.media != null) {
      data['media'] = this.media!.map((v) => v.toJson()).toList();
    }
    if (this.services != null) {
      data['services'] = this.services!.map((v) => v.toJson()).toList();
    }
    data['video_link'] = this.videoLink;
    data['zone'] = this.zone;
    return data;
  }
}

/* class Service {
  int? id;
  String? title;
  int? price;
  dynamic video;
  int? status;
  String? duration;
  String? durationUnit;
  int? serviceRate;
  int? discount;
  int? perServicemanCommission;
  String? description;
  String? content;
  String? specialityDescription;
  int? userId;
  dynamic parentId;
  String? type;
  int? isFeatured;
  int? isAdvertised;
  int? requiredServicemen;
  dynamic metaTitle;
  String? slug;
  dynamic metaDescription;
  int? createdById;
  int? isRandomRelatedServices;
  dynamic deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic destinationLocation;
  int? bookingsCount;
  int? reviewsCount;
  int? perServicemanCharge;
  List<int>? reviewRatings;
  dynamic ratingCount;
  String? webImgThumbUrl;
  List<String>? webImgGalleriesUrl;
  int? highestCommission;
  ServicePivot? pivot;
  List<Category>? categories;
  List<Media>? media;
  List<dynamic>? reviews;

  Service({
    this.id,
    this.title,
    this.price,
    this.video,
    this.status,
    this.duration,
    this.durationUnit,
    this.serviceRate,
    this.discount,
    this.perServicemanCommission,
    this.description,
    this.content,
    this.specialityDescription,
    this.userId,
    this.parentId,
    this.type,
    this.isFeatured,
    this.isAdvertised,
    this.requiredServicemen,
    this.metaTitle,
    this.slug,
    this.metaDescription,
    this.createdById,
    this.isRandomRelatedServices,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.destinationLocation,
    this.bookingsCount,
    this.reviewsCount,
    this.perServicemanCharge,
    this.reviewRatings,
    this.ratingCount,
    this.webImgThumbUrl,
    this.webImgGalleriesUrl,
    this.highestCommission,
    this.pivot,
    this.categories,
    this.media,
    this.reviews,
  });

  factory Service.fromJson(Map<dynamic, dynamic> json) => Service(
        id: json["id"],
        title: json["title"],
        price: json["price"],
        video: json["video"],
        status: json["status"],
        duration: json["duration"],
        durationUnit: json["duration_unit"],
        serviceRate: json["service_rate"],
        discount: json["discount"],
        perServicemanCommission: json["per_serviceman_commission"],
        description: json["description"],
        content: json["content"],
        specialityDescription: json["speciality_description"],
        userId: json["user_id"],
        parentId: json["parent_id"],
        type: json["type"],
        isFeatured: json["is_featured"],
        isAdvertised: json["is_advertised"],
        requiredServicemen: json["required_servicemen"],
        metaTitle: json["meta_title"],
        slug: json["slug"],
        metaDescription: json["meta_description"],
        createdById: json["created_by_id"],
        isRandomRelatedServices: json["is_random_related_services"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        destinationLocation: json["destination_location"],
        bookingsCount: json["bookings_count"],
        reviewsCount: json["reviews_count"],
        perServicemanCharge: json["per_serviceman_charge"],
        reviewRatings: json["review_ratings"] == null
            ? []
            : List<int>.from(json["review_ratings"]!.map((x) => x)),
        ratingCount: json["rating_count"],
        webImgThumbUrl: json["web_img_thumb_url"],
        webImgGalleriesUrl: json["web_img_galleries_url"] == null
            ? []
            : List<String>.from(json["web_img_galleries_url"]!.map((x) => x)),
        highestCommission: json["highest_commission"],
        pivot:
            json["pivot"] == null ? null : ServicePivot.fromJson(json["pivot"]),
        categories: json["categories"] == null
            ? []
            : List<Category>.from(
                json["categories"]!.map((x) => Category.fromJson(x))),
        media: json["media"] == null
            ? []
            : List<Media>.from(json["media"]!.map((x) => Media.fromJson(x))),
        reviews: json["reviews"] == null
            ? []
            : List<dynamic>.from(json["reviews"]!.map((x) => x)),
      );

  Map<dynamic, dynamic> toJson() => {
        "id": id,
        "title": title,
        "price": price,
        "video": video,
        "status": status,
        "duration": duration,
        "duration_unit": durationUnit,
        "service_rate": serviceRate,
        "discount": discount,
        "per_serviceman_commission": perServicemanCommission,
        "description": description,
        "content": content,
        "speciality_description": specialityDescription,
        "user_id": userId,
        "parent_id": parentId,
        "type": type,
        "is_featured": isFeatured,
        "is_advertised": isAdvertised,
        "required_servicemen": requiredServicemen,
        "meta_title": metaTitle,
        "slug": slug,
        "meta_description": metaDescription,
        "created_by_id": createdById,
        "is_random_related_services": isRandomRelatedServices,
        "deleted_at": deletedAt,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "destination_location": destinationLocation,
        "bookings_count": bookingsCount,
        "reviews_count": reviewsCount,
        "per_serviceman_charge": perServicemanCharge,
        "review_ratings": reviewRatings == null
            ? []
            : List<dynamic>.from(reviewRatings!.map((x) => x)),
        "rating_count": ratingCount,
        "web_img_thumb_url": webImgThumbUrl,
        "web_img_galleries_url": webImgGalleriesUrl == null
            ? []
            : List<dynamic>.from(webImgGalleriesUrl!.map((x) => x)),
        "highest_commission": highestCommission,
        "pivot": pivot?.toJson(),
        "categories": categories == null
            ? []
            : List<dynamic>.from(categories!.map((x) => x.toJson())),
        "media": media == null
            ? []
            : List<dynamic>.from(media!.map((x) => x.toJson())),
        "reviews":
            reviews == null ? [] : List<dynamic>.from(reviews!.map((x) => x)),
      };
}
 */
class Category {
  int? id;
  String? title;
  String? slug;
  String? description;
  int? parentId;
  dynamic metaTitle;
  dynamic metaDescription;
  int? commission;
  int? status;
  int? isFeatured;
  String? categoryType;
  int? createdBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  int? servicesCount;
  CategoryPivot? pivot;
  List<Media>? media;
  List<Zone>? zones;

  Category({
    this.id,
    this.title,
    this.slug,
    this.description,
    this.parentId,
    this.metaTitle,
    this.metaDescription,
    this.commission,
    this.status,
    this.isFeatured,
    this.categoryType,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.servicesCount,
    this.pivot,
    this.media,
    this.zones,
  });

  factory Category.fromJson(Map<dynamic, dynamic> json) => Category(
        id: json["id"],
        title: json["title"],
        slug: json["slug"],
        description: json["description"],
        parentId: json["parent_id"],
        metaTitle: json["meta_title"],
        metaDescription: json["meta_description"],
        commission: json["commission"],
        status: json["status"],
        isFeatured: json["is_featured"],
        categoryType: json["category_type"],
        createdBy: json["created_by"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        servicesCount: json["services_count"],
        pivot: json["pivot"] == null
            ? null
            : CategoryPivot.fromJson(json["pivot"]),
        media: json["media"] == null
            ? []
            : List<Media>.from(json["media"]!.map((x) => Media.fromJson(x))),
        zones: json["zones"] == null
            ? []
            : List<Zone>.from(json["zones"]!.map((x) => Zone.fromJson(x))),
      );

  Map<dynamic, dynamic> toJson() => {
        "id": id,
        "title": title,
        "slug": slug,
        "description": description,
        "parent_id": parentId,
        "meta_title": metaTitle,
        "meta_description": metaDescription,
        "commission": commission,
        "status": status,
        "is_featured": isFeatured,
        "category_type": categoryType,
        "created_by": createdBy,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "services_count": servicesCount,
        "pivot": pivot?.toJson(),
        "media": media == null
            ? []
            : List<dynamic>.from(media!.map((x) => x.toJson())),
        "zones": zones == null
            ? []
            : List<dynamic>.from(zones!.map((x) => x.toJson())),
      };
}

class Media {
  Media({
    this.id,
    this.modelType,
    this.modelId,
    this.uuid,
    this.collectionName,
    this.name,
    this.fileName,
    this.mimeType,
    this.disk,
    this.conversionsDisk,
    this.size,
    this.manipulations,
    this.customProperties,
    this.generatedConversions,
    this.responsiveImages,
    this.orderColumn,
    this.createdAt,
    this.updatedAt,
    this.originalUrl,
    this.previewUrl,
  });
  final int? id;
  final String? modelType;
  final int? modelId;
  final String? uuid;
  final String? collectionName;
  final String? name;
  final String? fileName;
  final String? mimeType;
  final String? disk;
  final String? conversionsDisk;
  final int? size;
  final List<dynamic>? manipulations;
  final CustomProperties? customProperties;
  final List<dynamic>? generatedConversions;
  final List<dynamic>? responsiveImages;
  final int? orderColumn;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? originalUrl;
  final String? previewUrl;

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      id: json["id"],
      modelType: json["model_type"],
      modelId: json["model_id"],
      uuid: json["uuid"],
      collectionName: json["collection_name"],
      name: json["name"],
      fileName: json["file_name"],
      mimeType: json["mime_type"],
      disk: json["disk"],
      conversionsDisk: json["conversions_disk"],
      size: json["size"],
      manipulations: json["manipulations"] == null
          ? []
          : List<dynamic>.from(json["manipulations"]!.map((x) => x)),
      customProperties: json["custom_properties"] == null
          ? null
          : CustomProperties.fromJson(json["custom_properties"]),
      generatedConversions: json["generated_conversions"] == null
          ? []
          : List<dynamic>.from(json["generated_conversions"]!.map((x) => x)),
      responsiveImages: json["responsive_images"] == null
          ? []
          : List<dynamic>.from(json["responsive_images"]!.map((x) => x)),
      orderColumn: json["order_column"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      originalUrl: json["original_url"],
      previewUrl: json["preview_url"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "model_type": modelType,
        "model_id": modelId,
        "uuid": uuid,
        "collection_name": collectionName,
        "name": name,
        "file_name": fileName,
        "mime_type": mimeType,
        "disk": disk,
        "conversions_disk": conversionsDisk,
        "size": size,
        "manipulations": manipulations?.map((x) => x).toList(),
        "custom_properties": customProperties?.toJson(),
        "generated_conversions": generatedConversions?.map((x) => x).toList(),
        "responsive_images": responsiveImages?.map((x) => x).toList(),
        "order_column": orderColumn,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "original_url": originalUrl,
        "preview_url": previewUrl,
      };
}

enum CollectionName { IMAGE, THUMBNAIL, WEB_IMAGES, WEB_THUMBNAIL }

final collectionNameValues = EnumValues({
  "image": CollectionName.IMAGE,
  "thumbnail": CollectionName.THUMBNAIL,
  "web_images": CollectionName.WEB_IMAGES,
  "web_thumbnail": CollectionName.WEB_THUMBNAIL
});

enum Disk { PUBLIC }

final diskValues = EnumValues({"public": Disk.PUBLIC});

class CustomProperties {
  Language? language;

  CustomProperties({
    this.language,
  });

  factory CustomProperties.fromJson(Map<dynamic, dynamic> json) =>
      CustomProperties(
        language: languageValues.map[json["language"]]!,
      );

  Map<dynamic, dynamic> toJson() => {
        "language": languageValues.reverse[language],
      };
}

enum Language { EN }

final languageValues = EnumValues({"en": Language.EN});

enum MimeType { IMAGE_JPEG, IMAGE_PNG }

final mimeTypeValues = EnumValues(
    {"image/jpeg": MimeType.IMAGE_JPEG, "image/png": MimeType.IMAGE_PNG});

enum ModelType { APP_MODELS_CATEGORY, APP_MODELS_SERVICE }

final modelTypeValues = EnumValues({
  "App\\Models\\Category": ModelType.APP_MODELS_CATEGORY,
  "App\\Models\\Service": ModelType.APP_MODELS_SERVICE
});

class CategoryPivot {
  int? serviceId;
  int? categoryId;

  CategoryPivot({
    this.serviceId,
    this.categoryId,
  });

  factory CategoryPivot.fromJson(Map<dynamic, dynamic> json) => CategoryPivot(
        serviceId: json["service_id"],
        categoryId: json["category_id"],
      );

  Map<dynamic, dynamic> toJson() => {
        "service_id": serviceId,
        "category_id": categoryId,
      };
}

class Zone {
  int? id;
  String? name;
  PlacePoints? placePoints;
  List<Location>? locations;
  String? status;
  int? createdById;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  ZonePivot? pivot;

  Zone({
    this.id,
    this.name,
    this.placePoints,
    this.locations,
    this.status,
    this.createdById,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.pivot,
  });

  factory Zone.fromJson(Map<dynamic, dynamic> json) => Zone(
        id: json["id"],
        name: json["name"],
        placePoints: json["place_points"] == null
            ? null
            : PlacePoints.fromJson(json["place_points"]),
        locations: json["locations"] == null
            ? []
            : List<Location>.from(
                json["locations"]!.map((x) => Location.fromJson(x))),
        status: json["status"],
        createdById: json["created_by_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        pivot: json["pivot"] == null ? null : ZonePivot.fromJson(json["pivot"]),
      );

  Map<dynamic, dynamic> toJson() => {
        "id": id,
        "name": name,
        "place_points": placePoints?.toJson(),
        "locations": locations == null
            ? []
            : List<dynamic>.from(locations!.map((x) => x.toJson())),
        "status": status,
        "created_by_id": createdById,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "pivot": pivot?.toJson(),
      };
}

class Location {
  double? lat;
  double? lng;

  Location({
    this.lat,
    this.lng,
  });

  factory Location.fromJson(Map<dynamic, dynamic> json) => Location(
        lat: json["lat"]?.toDouble(),
        lng: json["lng"]?.toDouble(),
      );

  Map<dynamic, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
      };
}

class ZonePivot {
  int? categoryId;
  int? zoneId;

  ZonePivot({
    this.categoryId,
    this.zoneId,
  });

  factory ZonePivot.fromJson(Map<dynamic, dynamic> json) => ZonePivot(
        categoryId: json["category_id"],
        zoneId: json["zone_id"],
      );

  Map<dynamic, dynamic> toJson() => {
        "category_id": categoryId,
        "zone_id": zoneId,
      };
}

class PlacePoints {
  String? type;
  List<List<List<double>>>? coordinates;

  PlacePoints({
    this.type,
    this.coordinates,
  });

  factory PlacePoints.fromJson(Map<dynamic, dynamic> json) => PlacePoints(
        type: json["type"],
        coordinates: json["coordinates"] == null
            ? []
            : List<List<List<double>>>.from(json["coordinates"]!.map((x) =>
                List<List<double>>.from(x.map(
                    (x) => List<double>.from(x.map((x) => x?.toDouble())))))),
      );

  Map<dynamic, dynamic> toJson() => {
        "type": type,
        "coordinates": coordinates == null
            ? []
            : List<dynamic>.from(coordinates!.map((x) => List<dynamic>.from(
                x.map((x) => List<dynamic>.from(x.map((x) => x)))))),
      };
}

class ServicePivot {
  int? advertisementId;
  int? serviceId;

  ServicePivot({
    this.advertisementId,
    this.serviceId,
  });

  factory ServicePivot.fromJson(Map<dynamic, dynamic> json) => ServicePivot(
        advertisementId: json["advertisement_id"],
        serviceId: json["service_id"],
      );

  Map<dynamic, dynamic> toJson() => {
        "advertisement_id": advertisementId,
        "service_id": serviceId,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
