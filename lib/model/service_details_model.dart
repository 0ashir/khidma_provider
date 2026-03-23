import 'package:fixit_provider/model/service_model.dart';

class ServiceDetailsModel {
  ServiceDetailsModel(
      {this.id,
      this.title,
      this.price,
      this.perServicemanCommission,
      this.status,
      this.duration,
      this.content,
      this.description,
      this.durationUnit,
      this.discount,
      this.parentId,
      this.type,
      this.isFavourite,
      this.categories,
      this.isFavouriteId,
      this.video,
      this.isFeatured,
      this.isAdvertised,
      this.serviceRate,
      this.Servicemen,
      this.addressId,
      this.selectedRequiredServiceMan,
      this.additionalServices,
      this.requiredServicemen,
      this.metaDescription,
      this.selectedAdditionalServices,
      this.highestCommission,
      this.media,
      this.user,
      this.tax,
      this.relatedServices,
      this.reviews,
      this.taxes});

  final dynamic id;
  final String? title;
  final dynamic price;
  final dynamic perServicemanCommission;
  final dynamic status;
  final dynamic categories;
  final String? duration;
  final String? content;
  final String? metaDescription;
  final String? description;
  final String? durationUnit;
  final dynamic discount;
  final dynamic tax;
  final dynamic parentId;
  final int? addressId;
  final String? type;
  final String? video;
  final dynamic isFeatured;
  int? isFavourite;
  final int? isFavouriteId;
  final dynamic isAdvertised;
  final dynamic serviceRate;
  final dynamic highestCommission;
  final dynamic requiredServicemen;
  final dynamic Servicemen;
  late final dynamic selectedRequiredServiceMan;
  final List<AdditionalService>? additionalServices;
  List<AdditionalService>? selectedAdditionalServices;
  final List<ServiceDetailsModelMedia>? media;
  final User? user;
  final List<RelatedService>? relatedServices;
  final List<dynamic>? reviews;
  final List<dynamic>? taxes;

  factory ServiceDetailsModel.fromJson(Map<String, dynamic> json) {
    return ServiceDetailsModel(
      id: json["id"],
      title: json["title"],
      price: json["price"],
      addressId: json["address_id"],
      perServicemanCommission: json["per_serviceman_commission"],
      status: json["status"],
      duration: json["duration"],
      content: json["content"],
      requiredServicemen: json['required_servicemen'],
      categories: json["categories"],
      description: json["description"],
      metaDescription: json["meta_description"],
      tax: json['tax'] == null ? null : double.parse(json['tax'].toString()),
      durationUnit: json["duration_unit"],
      discount: json["discount"],
      parentId: json["parent_id"],
      type: json["type"],
      video: json["video"],
      isFeatured: json["is_featured"],
      isFavourite: json["is_favourite"],
      isFavouriteId: json["is_favourite_id"],
      isAdvertised: json["is_advertised"],
      selectedAdditionalServices: [],
      serviceRate: json["service_rate"],
      highestCommission: json["highest_commission"],
      Servicemen: json["_servicemen"],
      selectedRequiredServiceMan: json["_servicemen"],
      additionalServices: json["additional_services"] == null
          ? []
          : List<AdditionalService>.from(json["additional_services"]!
              .map((x) => AdditionalService.fromJson(x))),
      media: json["media"] == null
          ? []
          : List<ServiceDetailsModelMedia>.from(
              json["media"]!.map((x) => ServiceDetailsModelMedia.fromJson(x))),
      user: json["user"] == null ? null : User.fromJson(json["user"]),
      relatedServices: json["related_services"] == null
          ? []
          : List<RelatedService>.from(
              json["related_services"]!.map((x) => RelatedService.fromJson(x))),
      reviews: json["reviews"] == null
          ? []
          : List<dynamic>.from(json["reviews"]!.map((x) => x)),
      taxes: json["taxes"] == null
          ? []
          : List<dynamic>.from(json["taxes"]!.map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "price": price,
        "per_serviceman_commission": perServicemanCommission,
        "status": status,
        "duration": duration,
        "content": content,
        "address_id": addressId,
        "description": description,
        "duration_unit": durationUnit,
        "highest_commission": highestCommission,
        "discount": discount,
        "parent_id": parentId,
        "type": type,
        "is_favourite": isFavourite,
        "tax": tax,
        "is_favourite_id": isFavouriteId,
        "video": video,
        "required_servicemen": requiredServicemen,
        "is_featured": isFeatured,
        "meta_description": metaDescription,
        "categories": categories,
        "is_advertised": isAdvertised,
        "service_rate": serviceRate,
        "_servicemen": Servicemen,
        "selectedRequiredServiceMan": selectedRequiredServiceMan,
        if (selectedAdditionalServices != null)
          'selectedAdditionalServices':
              selectedAdditionalServices!.map((v) => v.toJson()).toList(),
        "additional_services":
            additionalServices!.map((x) => x.toJson()).toList(),
        "media": media!.map((x) => x.toJson()).toList(),
        "user": user?.toJson(),
        "related_services": relatedServices!.map((x) => x.toJson()).toList(),
        "reviews": reviews!.map((x) => x).toList(),
        "taxes": taxes!.map((x) => x).toList(),
      };

  @override
  String toString() {
    return "$id, $title, $price, $addressId,$perServicemanCommission, $status, $duration, $description, $content, $durationUnit, $discount, $parentId, $type, $video, $isFeatured, $isAdvertised, $serviceRate, $Servicemen, $additionalServices, $media, $user, $relatedServices, $reviews, $taxes ";
  }
}

class AdditionalService {
  AdditionalService({
    this.id,
    this.title,
    this.price,
    this.media,
  });

  final dynamic id;
  final String? title;
  final dynamic price;
  final List<AdditionalServiceMedia>? media;

  factory AdditionalService.fromJson(Map<String, dynamic> json) {
    return AdditionalService(
      id: json["id"],
      title: json["title"],
      price: json["price"],
      media: json["media"] == null
          ? []
          : List<AdditionalServiceMedia>.from(
              json["media"]!.map((x) => AdditionalServiceMedia.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "price": price,
        "media": media!.map((x) => x.toJson()).toList(),
      };

  @override
  String toString() {
    return "$title, $price, $media, ";
  }
}

class AdditionalServiceMedia {
  AdditionalServiceMedia({
    this.originalId,
  });

  final String? originalId;

  factory AdditionalServiceMedia.fromJson(Map<String, dynamic> json) {
    return AdditionalServiceMedia(
      originalId: json["original_id"],
    );
  }

  Map<String, dynamic> toJson() => {
        "original_id": originalId,
      };

  @override
  String toString() {
    return "$originalId, ";
  }
}

class ServiceDetailsModelMedia {
  ServiceDetailsModelMedia({
    this.id,
    this.collectionName,
    this.originalUrl,
  });

  final String? originalUrl;
  final String? collectionName;
  final int? id;

  factory ServiceDetailsModelMedia.fromJson(Map<String, dynamic> json) {
    return ServiceDetailsModelMedia(
        originalUrl: json["original_url"],
        id: json["id"],
        collectionName: json["collection_name"]);
  }

  Map<String, dynamic> toJson() => {
        "original_url": originalUrl,
        "collection_name": collectionName,
        "id": id,
      };

  @override
  String toString() {
    return "$originalUrl, $collectionName,$id";
  }
}

class RelatedService {
  RelatedService({
    this.id,
    this.title,
    this.isFavourite,
    this.categories,
    this.serviceRate,
    this.Servicemen,
    this.selectedRequiredServiceMan,
    this.price,
    this.media,
  });

  final dynamic id;
  final String? title;
  final int? isFavourite;
  final List<Category>? categories;
  final dynamic serviceRate;
  final dynamic Servicemen;
  late final int? selectedRequiredServiceMan;
  final dynamic price;
  final List<ServiceDetailsModelMedia>? media;

  factory RelatedService.fromJson(Map<String, dynamic> json) {
    return RelatedService(
      id: json["id"],
      title: json["title"],
      isFavourite: json["is_favourite"],
      categories: json["categories"] == null
          ? []
          : List<Category>.from(
              json["categories"]!.map((x) => Category.fromJson(x))),
      serviceRate: json["service_rate"] is int
          ? (json["service_rate"] as int).toDouble()
          : json["service_rate"] is double
              ? json["service_rate"]
              : null,
      Servicemen: json["_servicemen"],
      selectedRequiredServiceMan: json["_servicemen"],
      price: json["price"],
      media: json["media"] == null
          ? []
          : List<ServiceDetailsModelMedia>.from(
              json["media"]!.map((x) => ServiceDetailsModelMedia.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "is_favourite": isFavourite,
        "categories": categories?.map((x) => x.toJson()).toList(),
        "service_rate": serviceRate,
        "_servicemen": Servicemen,
        "selectedRequiredServiceMan": selectedRequiredServiceMan,
        "price": price,
        "media": media?.map((x) => x.toJson()).toList(),
      };

  @override
  String toString() {
    return "$id, $title, $isFavourite, $categories, $serviceRate, $Servicemen, $price, $media, ";
  }
}

class Category {
  Category({
    this.title,
  });

  final String? title;

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      title: json["title"],
    );
  }

  Map<String, dynamic> toJson() => {
        "title": title,
      };

  @override
  String toString() {
    return "$title, ";
  }
}

class User {
  User({
    this.id,
    this.name,
    this.reviewRatings,
    this.media,
    this.experienceInterval,
    this.experienceDuration,
    this.served,
  });

  final dynamic id;
  final String? name;
  final dynamic reviewRatings;
  final List<ServiceDetailsModelMedia>? media;
  final String? experienceInterval;
  final dynamic experienceDuration;
  final dynamic served;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      name: json["name"],
      reviewRatings: json["review_ratings"],
      media: json["media"] == null
          ? []
          : List<ServiceDetailsModelMedia>.from(
              json["media"]!.map((x) => ServiceDetailsModelMedia.fromJson(x))),
      experienceInterval: json["experience_interval"],
      experienceDuration: json["experience_duration"],
      served: json["served"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "review_ratings": reviewRatings,
        "media": media?.map((x) => x.toJson()).toList(),
        "experience_interval": experienceInterval,
        "experience_duration": experienceDuration,
        "served": served,
      };

  @override
  String toString() {
    return "$id, $name, $reviewRatings, $media, $experienceInterval, $experienceDuration, $served, ";
  }
}

/*
class ServiceDetailsModel {
  ServiceDetailsModel({
     this.id,
     this.title,
     this.price,
     this.status,
     this.duration,
     this.description,
     this.durationUnit,
     this.discount,
     this.parentId,
     this.type,
     this.video,
     this.isFeatured,
     this.isAdvertised,
     this.isRandomRelatedServices,
    required this.serviceRate,
    required this.requiredServicemen,
    required this.serviceType,
    required this.media,
    required this.user,
    required this.relatedServices,
  });

  final dynamic id;
  final String? title;
  final dynamic price;
  final dynamic status;
  final String? duration;
  final String? description;
  final String? durationUnit;
  final String? video;
  final dynamic discount;
  final dynamic parentId;
  final String? type;
  final dynamic isFeatured;
  final dynamic isAdvertised;
  final dynamic isRandomRelatedServices;
  final dynamic serviceRate;
  final dynamic requiredServicemen;
  final dynamic serviceType;
  final List<ServiceDetailsModelMedia> media;
  final User? user;
  final List<RelatedService> relatedServices;

  factory ServiceDetailsModel.fromJson(Map<String, dynamic> json){
    return ServiceDetailsModel(
      id: json["id"],
      title: json["title"],
      price: json["price"],
      status: json["status"],
      duration: json["duration"],
      description: json["description"],
      video: json["video"],
      durationUnit: json["duration_unit"],
      discount: json["discount"],
      parentId: json["parent_id"],
      type: json["type"],
      isFeatured: json["is_featured"],
      isAdvertised: json["is_advertised"],
      isRandomRelatedServices: json["is_random_related_services"],
      serviceRate: json["service_rate"],
      requiredServicemen: json["required_servicemen"],
      serviceType: json["service_type"],
      media: json["media"] == null ? [] : List<ServiceDetailsModelMedia>.from(json["media"]!.map((x) => ServiceDetailsModelMedia.fromJson(x))),
      user: json["user"] == null ? null : User.fromJson(json["user"]),
      relatedServices: json["related_services"] == null ? [] : List<RelatedService>.from(json["related_services"]!.map((x) => RelatedService.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "price": price,
    "status": status,
    "duration": duration,
    "description": description,
    "duration_unit": durationUnit,
    "discount": discount,
    "parent_id": parentId,
    "type": type,
    "video": video,
    "is_featured": isFeatured,
    "is_advertised": isAdvertised,
    "is_random_related_services": isRandomRelatedServices,
    "service_rate": serviceRate,
    "required_servicemen": requiredServicemen,
    "service_type": serviceType,
    "media": media.map((x) => x.toJson()).toList(),
    "user": user?.toJson(),
    "related_services": relatedServices.map((x) => x.toJson()).toList(),
  };

  @override
  String toString(){
    return "$id, $title, $price, $status, $duration, $description, $durationUnit, $discount, $parentId, $type, $isFeatured, $isAdvertised, $isRandomRelatedServices, $serviceRate, $requiredServicemen, $serviceType, $media, $user, $relatedServices, ";
  }
}

class ServiceDetailsModelMedia {
  ServiceDetailsModelMedia({
    required this.id,
    required this.collectionName,
    required this.originalUrl,
  });

  final dynamic id;
  final String? collectionName;
  final String? originalUrl;

  factory ServiceDetailsModelMedia.fromJson(Map<String, dynamic> json){
    return ServiceDetailsModelMedia(
      id: json["id"],
      collectionName: json["collection_name"],
      originalUrl: json["original_url"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "collection_name": collectionName,
    "original_url": originalUrl,
  };

  @override
  String toString(){
    return "$id, $collectionName, $originalUrl, ";
  }
}

class RelatedService {
  RelatedService({
    required this.id,
    required this.title,
    required this.categories,
    required this.serviceRate,
    required this.price,
    required this.media,
  });

  final dynamic id;
  final String? title;
  final List<Category> categories;
  final double? serviceRate;
  final dynamic price;
  final List<RelatedServiceMedia> media;

  factory RelatedService.fromJson(Map<String, dynamic> json){
    return RelatedService(
      id: json["id"],
      title: json["title"],
      categories: json["categories"] == null ? [] : List<Category>.from(json["categories"]!.map((x) => Category.fromJson(x))),
      serviceRate: json["service_rate"] is int
          ? (json["service_rate"] as int).toDouble()
          : json["service_rate"] is double
          ? json["service_rate"]
          : null,
      price: json["price"],
      media: json["media"] == null ? [] : List<RelatedServiceMedia>.from(json["media"]!.map((x) => RelatedServiceMedia.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "categories": categories.map((x) => x.toJson()).toList(),
    "service_rate": serviceRate,
    "price": price,
    "media": media.map((x) => x.toJson()).toList(),
  };

  @override
  String toString(){
    return "$id, $title, $categories, $serviceRate, $price, $media, ";
  }
}

class Category {
  Category({
    required this.title,
  });

  final String? title;

  factory Category.fromJson(Map<String, dynamic> json){
    return Category(
      title: json["title"],
    );
  }

  Map<String, dynamic> toJson() => {
    "title": title,
  };

  @override
  String toString(){
    return "$title, ";
  }
}

class RelatedServiceMedia {
  RelatedServiceMedia({
    required this.originalUrl,
  });

  final String? originalUrl;

  factory RelatedServiceMedia.fromJson(Map<String, dynamic> json){
    return RelatedServiceMedia(
      originalUrl: json["original_url"],
    );
  }

  Map<String, dynamic> toJson() => {
    "original_url": originalUrl,
  };

  @override
  String toString(){
    return "$originalUrl, ";
  }
}

class User {
  User({
    required this.id,
    required this.name,
    required this.reviewRatings,
    required this.media,
    required this.experienceInterval,
    required this.experienceDuration,
    required this.served,
  });

  final dynamic id;
  final String? name;
  final dynamic reviewRatings;
  final List<RelatedServiceMedia> media;
  final String? experienceInterval;
  final dynamic experienceDuration;
  final dynamic served;

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id: json["id"],
      name: json["name"],
      reviewRatings: json["review_ratings"],
      media: json["media"] == null ? [] : List<RelatedServiceMedia>.from(json["media"]!.map((x) => RelatedServiceMedia.fromJson(x))),
      experienceInterval: json["experience_interval"],
      experienceDuration: json["experience_duration"],
      served: json["served"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "review_ratings": reviewRatings,
    "media": media.map((x) => x.toJson()).toList(),
    "experience_interval": experienceInterval,
    "experience_duration": experienceDuration,
    "served": served,
  };

  @override
  String toString(){
    return "$id, $name, $reviewRatings, $media, $experienceInterval, $experienceDuration, $served, ";
  }
}
*/
