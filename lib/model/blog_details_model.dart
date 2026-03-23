// To parse this JSON data, do
//
//     final blogModel = blogModelFromJson(jsonString);

import 'dart:convert';

/* BlogModel blogModelFromJson(String str) => BlogModel.fromJson(json.decode(str));

String blogModelToJson(BlogModel data) => json.encode(data.toJson()); */

class BlogModel {
  int? id;
  String? title;
  String? slug;
  String? description;
  String? content;
  String? metaTitle;
  String? metaDescription;
  int? isFeatured;
  int? status;
  int? createdById;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  int? commentsCount;
  String? webImgThumbUrl;
  List<Media>? media;
  List<Category>? categories;
  CreatedBy? createdBy;
  List<Tag>? tags;

  BlogModel({
    this.id,
    this.title,
    this.slug,
    this.description,
    this.content,
    this.metaTitle,
    this.metaDescription,
    this.isFeatured,
    this.status,
    this.createdById,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.commentsCount,
    this.webImgThumbUrl,
    this.media,
    this.categories,
    this.createdBy,
    this.tags,
  });

  factory BlogModel.fromJson(Map<String, dynamic> json) => BlogModel(
        id: json["id"],
        title: json["title"],
        slug: json["slug"],
        description: json["description"],
        content: json["content"],
        metaTitle: json["meta_title"],
        metaDescription: json["meta_description"],
        isFeatured: json["is_featured"],
        status: json["status"],
        createdById: json["created_by_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        commentsCount: json["comments_count"],
        webImgThumbUrl: json["web_img_thumb_url"],
        media: json["media"] == null
            ? []
            : List<Media>.from(json["media"]!.map((x) => Media.fromJson(x))),
        categories: json["categories"] == null
            ? []
            : List<Category>.from(
                json["categories"]!.map((x) => Category.fromJson(x))),
        createdBy: json["created_by"] == null
            ? null
            : CreatedBy.fromJson(json["created_by"]),
        tags: json["tags"] == null
            ? []
            : List<Tag>.from(json["tags"]!.map((x) => Tag.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "slug": slug,
        "description": description,
        "content": content,
        "meta_title": metaTitle,
        "meta_description": metaDescription,
        "is_featured": isFeatured,
        "status": status,
        "created_by_id": createdById,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "comments_count": commentsCount,
        "web_img_thumb_url": webImgThumbUrl,
        "media": media == null
            ? []
            : List<dynamic>.from(media!.map((x) => x.toJson())),
        "categories": categories == null
            ? []
            : List<dynamic>.from(categories!.map((x) => x.toJson())),
        "created_by": createdBy?.toJson(),
        "tags": tags == null
            ? []
            : List<dynamic>.from(tags!.map((x) => x.toJson())),
      };
}

class Category {
  int? id;
  String? title;
  String? slug;
  String? description;
  dynamic parentId;
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
  List<dynamic>? media;
  List<dynamic>? zones;

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

  factory Category.fromJson(Map<String, dynamic> json) => Category(
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
            : List<dynamic>.from(json["media"]!.map((x) => x)),
        zones: json["zones"] == null
            ? []
            : List<dynamic>.from(json["zones"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
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
        "media": media == null ? [] : List<dynamic>.from(media!.map((x) => x)),
        "zones": zones == null ? [] : List<dynamic>.from(zones!.map((x) => x)),
      };
}

class CategoryPivot {
  int? blogId;
  int? categoryId;

  CategoryPivot({
    this.blogId,
    this.categoryId,
  });

  factory CategoryPivot.fromJson(Map<String, dynamic> json) => CategoryPivot(
        blogId: json["blog_id"],
        categoryId: json["category_id"],
      );

  Map<String, dynamic> toJson() => {
        "blog_id": blogId,
        "category_id": categoryId,
      };
}

class CreatedBy {
  int? id;
  String? name;
  String? slug;
  String? email;
  int? systemReserve;
  int? served;
  int? phone;
  int? code;
  dynamic providerId;
  int? status;
  int? isFeatured;
  int? isVerified;
  dynamic type;
  DateTime? emailVerifiedAt;
  dynamic fcmToken;
  dynamic experienceInterval;
  dynamic experienceDuration;
  dynamic description;
  int? createdBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  dynamic companyId;
  dynamic locationCordinates;
  int? bookingsCount;
  int? reviewsCount;
  Role? role;
  int? reviewRatings;
  List<int>? providerRatingList;
  List<int>? serviceManRatingList;
  dynamic primaryAddress;
  int? totalDaysExperience;
  int? servicemanReviewRatings;
  List<dynamic>? media;
  dynamic wallet;
  dynamic providerWallet;
  dynamic servicemanWallet;
  List<dynamic>? knownLanguages;
  List<dynamic>? expertise;
  List<dynamic>? zones;
  dynamic provider;
  List<Role>? roles;
  List<dynamic>? reviews;
  List<dynamic>? servicemanreviews;

  CreatedBy({
    this.id,
    this.name,
    this.slug,
    this.email,
    this.systemReserve,
    this.served,
    this.phone,
    this.code,
    this.providerId,
    this.status,
    this.isFeatured,
    this.isVerified,
    this.type,
    this.emailVerifiedAt,
    this.fcmToken,
    this.experienceInterval,
    this.experienceDuration,
    this.description,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.companyId,
    this.locationCordinates,
    this.bookingsCount,
    this.reviewsCount,
    this.role,
    this.reviewRatings,
    this.providerRatingList,
    this.serviceManRatingList,
    this.primaryAddress,
    this.totalDaysExperience,
    this.servicemanReviewRatings,
    this.media,
    this.wallet,
    this.providerWallet,
    this.servicemanWallet,
    this.knownLanguages,
    this.expertise,
    this.zones,
    this.provider,
    this.roles,
    this.reviews,
    this.servicemanreviews,
  });

  factory CreatedBy.fromJson(Map<String, dynamic> json) => CreatedBy(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        email: json["email"],
        systemReserve: json["system_reserve"],
        served: json["served"],
        phone: json["phone"],
        code: json["code"],
        providerId: json["provider_id"],
        status: json["status"],
        isFeatured: json["is_featured"],
        isVerified: json["is_verified"],
        type: json["type"],
        emailVerifiedAt: json["email_verified_at"] == null
            ? null
            : DateTime.parse(json["email_verified_at"]),
        fcmToken: json["fcm_token"],
        experienceInterval: json["experience_interval"],
        experienceDuration: json["experience_duration"],
        description: json["description"],
        createdBy: json["created_by"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        companyId: json["company_id"],
        locationCordinates: json["location_cordinates"],
        bookingsCount: json["bookings_count"],
        reviewsCount: json["reviews_count"],
        role: json["role"] == null ? null : Role.fromJson(json["role"]),
        reviewRatings: json["review_ratings"],
        providerRatingList: json["provider_rating_list"] == null
            ? []
            : List<int>.from(json["provider_rating_list"]!.map((x) => x)),
        serviceManRatingList: json["service_man_rating_list"] == null
            ? []
            : List<int>.from(json["service_man_rating_list"]!.map((x) => x)),
        primaryAddress: json["primary_address"],
        totalDaysExperience: json["total_days_experience"],
        servicemanReviewRatings: json["ServicemanReviewRatings"],
        media: json["media"] == null
            ? []
            : List<dynamic>.from(json["media"]!.map((x) => x)),
        wallet: json["wallet"],
        providerWallet: json["provider_wallet"],
        servicemanWallet: json["serviceman_wallet"],
        knownLanguages: json["known_languages"] == null
            ? []
            : List<dynamic>.from(json["known_languages"]!.map((x) => x)),
        expertise: json["expertise"] == null
            ? []
            : List<dynamic>.from(json["expertise"]!.map((x) => x)),
        zones: json["zones"] == null
            ? []
            : List<dynamic>.from(json["zones"]!.map((x) => x)),
        provider: json["provider"],
        roles: json["roles"] == null
            ? []
            : List<Role>.from(json["roles"]!.map((x) => Role.fromJson(x))),
        reviews: json["reviews"] == null
            ? []
            : List<dynamic>.from(json["reviews"]!.map((x) => x)),
        servicemanreviews: json["servicemanreviews"] == null
            ? []
            : List<dynamic>.from(json["servicemanreviews"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "email": email,
        "system_reserve": systemReserve,
        "served": served,
        "phone": phone,
        "code": code,
        "provider_id": providerId,
        "status": status,
        "is_featured": isFeatured,
        "is_verified": isVerified,
        "type": type,
        "email_verified_at": emailVerifiedAt?.toIso8601String(),
        "fcm_token": fcmToken,
        "experience_interval": experienceInterval,
        "experience_duration": experienceDuration,
        "description": description,
        "created_by": createdBy,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "company_id": companyId,
        "location_cordinates": locationCordinates,
        "bookings_count": bookingsCount,
        "reviews_count": reviewsCount,
        "role": role?.toJson(),
        "review_ratings": reviewRatings,
        "provider_rating_list": providerRatingList == null
            ? []
            : List<dynamic>.from(providerRatingList!.map((x) => x)),
        "service_man_rating_list": serviceManRatingList == null
            ? []
            : List<dynamic>.from(serviceManRatingList!.map((x) => x)),
        "primary_address": primaryAddress,
        "total_days_experience": totalDaysExperience,
        "ServicemanReviewRatings": servicemanReviewRatings,
        "media": media == null ? [] : List<dynamic>.from(media!.map((x) => x)),
        "wallet": wallet,
        "provider_wallet": providerWallet,
        "serviceman_wallet": servicemanWallet,
        "known_languages": knownLanguages == null
            ? []
            : List<dynamic>.from(knownLanguages!.map((x) => x)),
        "expertise": expertise == null
            ? []
            : List<dynamic>.from(expertise!.map((x) => x)),
        "zones": zones == null ? [] : List<dynamic>.from(zones!.map((x) => x)),
        "provider": provider,
        "roles": roles == null
            ? []
            : List<dynamic>.from(roles!.map((x) => x.toJson())),
        "reviews":
            reviews == null ? [] : List<dynamic>.from(reviews!.map((x) => x)),
        "servicemanreviews": servicemanreviews == null
            ? []
            : List<dynamic>.from(servicemanreviews!.map((x) => x)),
      };
}

class Role {
  int? id;
  String? name;
  String? guardName;
  int? systemReserve;
  DateTime? createdAt;
  DateTime? updatedAt;
  RolePivot? pivot;

  Role({
    this.id,
    this.name,
    this.guardName,
    this.systemReserve,
    this.createdAt,
    this.updatedAt,
    this.pivot,
  });

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        id: json["id"],
        name: json["name"],
        guardName: json["guard_name"],
        systemReserve: json["system_reserve"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        pivot: json["pivot"] == null ? null : RolePivot.fromJson(json["pivot"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "guard_name": guardName,
        "system_reserve": systemReserve,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "pivot": pivot?.toJson(),
      };
}

class RolePivot {
  String? modelType;
  int? modelId;
  int? roleId;

  RolePivot({
    this.modelType,
    this.modelId,
    this.roleId,
  });

  factory RolePivot.fromJson(Map<String, dynamic> json) => RolePivot(
        modelType: json["model_type"],
        modelId: json["model_id"],
        roleId: json["role_id"],
      );

  Map<String, dynamic> toJson() => {
        "model_type": modelType,
        "model_id": modelId,
        "role_id": roleId,
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

  factory Media.fromJson(Map<String, dynamic> json) => Media(
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

  factory CustomProperties.fromJson(Map<String, dynamic> json) =>
      CustomProperties(
        language: json["language"],
      );

  Map<String, dynamic> toJson() => {
        "language": language,
      };
}

class Tag {
  int? id;
  String? name;
  String? slug;
  String? type;
  String? description;
  int? createdById;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  TagPivot? pivot;

  Tag({
    this.id,
    this.name,
    this.slug,
    this.type,
    this.description,
    this.createdById,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.pivot,
  });

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        type: json["type"],
        description: json["description"],
        createdById: json["created_by_id"],
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        pivot: json["pivot"] == null ? null : TagPivot.fromJson(json["pivot"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "type": type,
        "description": description,
        "created_by_id": createdById,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "pivot": pivot?.toJson(),
      };
}

class TagPivot {
  int? blogId;
  int? tagId;

  TagPivot({
    this.blogId,
    this.tagId,
  });

  factory TagPivot.fromJson(Map<String, dynamic> json) => TagPivot(
        blogId: json["blog_id"],
        tagId: json["tag_id"],
      );

  Map<String, dynamic> toJson() => {
        "blog_id": blogId,
        "tag_id": tagId,
      };
}
