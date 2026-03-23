class AdvertisementModel {
  AdvertisementModel({
    required this.id,
    required this.providerId,
    required this.type,
    required this.screen,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.media,
    required this.services,
    required this.videoLink,
    required this.bannerType,
    required this.zone,
  });

  final int? id;
  final int? providerId;
  final String? type;
  final String? screen;
  final String? status;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<Media> media;
  final List<Service> services;
  final String? videoLink;
  final String? bannerType;
  final String? zone;

  factory AdvertisementModel.fromJson(Map<String, dynamic> json) {
    return AdvertisementModel(
      id: json["id"],
      providerId: json["provider_id"],
      type: json["type"],
      screen: json["screen"],
      status: json["status"],
      startDate: DateTime.tryParse(json["start_date"] ?? ""),
      endDate: DateTime.tryParse(json["end_date"] ?? ""),
      media: json["media"] == null
          ? []
          : List<Media>.from(json["media"]!.map((x) => Media.fromJson(x))),
      services: json["services"] == null
          ? []
          : List<Service>.from(
              json["services"]!.map((x) => Service.fromJson(x))),
      videoLink: json["video_link"],
      bannerType: json["banner_type"],
      zone: json["zone"],
    );
  }
}

class Media {
  Media({
    this.id,
    this.collectionName,
    this.name,
    this.customProperties,
    this.responsiveImages,
    this.createdAt,
    this.originalUrl,
  });

  final int? id;
  final String? collectionName;
  final String? name;
  final CustomProperties? customProperties;
  final List<dynamic>? responsiveImages;
  final DateTime? createdAt;
  final String? originalUrl;

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      id: json["id"],
      collectionName: json["collection_name"],
      name: json["name"],
      customProperties: json["custom_properties"] == null
          ? null
          : CustomProperties.fromJson(json["custom_properties"]),
      responsiveImages: json["responsive_images"] == null
          ? []
          : List<dynamic>.from(json["responsive_images"]!.map((x) => x)),
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      originalUrl: json["original_url"],
    );
  }
}

class CustomProperties {
  CustomProperties({
    required this.language,
  });

  final String? language;

  factory CustomProperties.fromJson(Map<String, dynamic> json) {
    return CustomProperties(
      language: json["language"],
    );
  }
}

class Service {
  Service({
    required this.id,
    required this.title,
    required this.price,
    required this.discount,
    required this.requiredServicemen,
    required this.serviceRate,
    required this.description,
    required this.media,
  });

  final int? id;
  final String? title;
  final int? price;
  final int? discount;
  final int? requiredServicemen;
  final int? serviceRate;
  final String? description;
  final List<Media> media;

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json["id"],
      title: json["title"],
      price: json["price"],
      discount: json["discount"],
      requiredServicemen: json["required_servicemen"],
      serviceRate: json["service_rate"],
      description: json["description"],
      media: json["media"] == null
          ? []
          : List<Media>.from(json["media"]!.map((x) => Media.fromJson(x))),
    );
  }
}
