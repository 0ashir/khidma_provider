


import '../config.dart';

class ExpertiseModel {
  String? title;
  int? id;
  List<int>? reviewRatings;
  int? ratingCount;
  ExpertisePivot? pivot;
  List<CategoryModel>? categories;
  List<RelatedServices>? relatedServices;
  List<Media>? media;
  List<Reviews>? reviews;

  ExpertiseModel(
      {this.title,
        this.id,
        this.reviewRatings,
        this.ratingCount,
        this.pivot,
        this.categories,
        this.relatedServices,
        this.media,
        this.reviews});

  ExpertiseModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    id = json['id'];
    reviewRatings = json['review_ratings'].cast<int>();
    ratingCount = json['rating_count'];
    pivot = json['pivot'] != null ? ExpertisePivot.fromJson(json['pivot']) : null;
    if (json['categories'] != null) {
      categories = <CategoryModel>[];
      json['categories'].forEach((v) {
        categories!.add(CategoryModel.fromJson(v));
      });
    }
    if (json['related_services'] != null) {
      relatedServices = <RelatedServices>[];
      json['related_services'].forEach((v) {
        relatedServices!.add(RelatedServices.fromJson(v));
      });
    }
    if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media!.add(Media.fromJson(v));
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
    data['title'] = title;
    data['id'] = id;
    data['review_ratings'] = reviewRatings;
    data['rating_count'] = ratingCount;
    if (pivot != null) {
      data['pivot'] = pivot!.toJson();
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
    if (reviews != null) {
      data['reviews'] = reviews!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ExpertisePivot {
  String? userId;
  String? serviceId;

  ExpertisePivot({this.userId, this.serviceId});

  ExpertisePivot.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    serviceId = json['service_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['service_id'] = serviceId;
    return data;
  }
}


class RelatedServicePivot {
  String? relatedServiceId;
  String? serviceId;

  RelatedServicePivot({this.relatedServiceId, this.serviceId});

  RelatedServicePivot.fromJson(Map<String, dynamic> json) {
    relatedServiceId = json['related_service_id'];
    serviceId = json['service_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['related_service_id'] = relatedServiceId;
    data['service_id'] = serviceId;
    return data;
  }
}

class RelatedServices {
  int? id;
  String? title;
  String? price;
  String? status;
  String? duration;
  String? serviceRate;
  String? discount;
  String? description;
  String? userId;
  String? type;
  String? isFeatured;
  String? requiredServicemen;
  String? metaTitle;
  String? slug;
  String? metaDescription;
  String? createdById;
  String? isRandomRelatedServices;
  String? taxId;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  List<int>? reviewRatings;
  int? ratingCount;
  RelatedServicePivot? pivot;
  List<CategoryModel>? categories;
  List<Services>? relatedServices;
  List<Media>? media;
  List<Reviews>? reviews;

  RelatedServices(
      {this.id,
        this.title,
        this.price,
        this.status,
        this.duration,
        this.serviceRate,
        this.discount,
        this.description,
        this.userId,
        this.type,
        this.isFeatured,
        this.requiredServicemen,
        this.metaTitle,
        this.slug,
        this.metaDescription,
        this.createdById,
        this.isRandomRelatedServices,
        this.taxId,
        this.deletedAt,
        this.createdAt,
        this.updatedAt,
        this.reviewRatings,
        this.ratingCount,
        this.pivot,
        this.categories,
        this.relatedServices,
        this.media,
        this.reviews});

  RelatedServices.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    price = json['price'];
    status = json['status'];
    duration = json['duration'];
    serviceRate = json['service_rate'];
    discount = json['discount'];
    description = json['description'];
    userId = json['user_id'];
    type = json['type'];
    isFeatured = json['is_featured'];
    requiredServicemen = json['required_servicemen'];
    metaTitle = json['meta_title'];
    slug = json['slug'];
    metaDescription = json['meta_description'];
    createdById = json['created_by_id'];
    isRandomRelatedServices = json['is_random_related_services'];
    taxId = json['tax_id'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    reviewRatings = json['review_ratings'].cast<int>();
    ratingCount = json['rating_count'];
    pivot = json['pivot'] != null ? RelatedServicePivot.fromJson(json['pivot']) : null;
    if (json['categories'] != null) {
      categories = <CategoryModel>[];
      json['categories'].forEach((v) {
        categories!.add(CategoryModel.fromJson(v));
      });
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
    data['title'] = title;
    data['price'] = price;
    data['status'] = status;
    data['duration'] = duration;
    data['service_rate'] = serviceRate;
    data['discount'] = discount;
    data['description'] = description;
    data['user_id'] = userId;
    data['type'] = type;
    data['is_featured'] = isFeatured;
    data['required_servicemen'] = requiredServicemen;
    data['meta_title'] = metaTitle;
    data['slug'] = slug;
    data['meta_description'] = metaDescription;
    data['created_by_id'] = createdById;
    data['is_random_related_services'] = isRandomRelatedServices;
    data['tax_id'] = taxId;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['review_ratings'] = reviewRatings;
    data['rating_count'] = ratingCount;
    if (pivot != null) {
      data['pivot'] = pivot!.toJson();
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
    if (reviews != null) {
      data['reviews'] = reviews!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RelatedServicesPivot {
  String? relatedServiceId;
  String? serviceId;

  RelatedServicesPivot({this.relatedServiceId, this.serviceId});

  RelatedServicesPivot.fromJson(Map<String, dynamic> json) {
    relatedServiceId = json['related_service_id'];
    serviceId = json['service_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['related_service_id'] = relatedServiceId;
    data['service_id'] = serviceId;
    return data;
  }
}


