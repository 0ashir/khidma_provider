import '../config.dart';

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
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  List<Media>? media;
  List<CategoryModel>? categories;
  CreatedBy? createdBy;
  List<Tags>? tags;

  BlogModel(
      {this.id,
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
      this.media,
      this.categories,
      this.createdBy,
      this.tags});

  BlogModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
    description = json['description'];
    content = json['content'];
    metaTitle = json['meta_title'];
    metaDescription = json['meta_description'];
    isFeatured = json['is_featured'];
    status = json['status'];
    createdById = json['created_by_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media!.add(Media.fromJson(v));
      });
    }
    if (json['categories'] != null) {
      categories = <CategoryModel>[];
      json['categories'].forEach((v) {
        categories!.add(CategoryModel.fromJson(v));
      });
    }
    createdBy = json['created_by'] != null
        ? CreatedBy.fromJson(json['created_by'])
        : null;
    if (json['tags'] != null) {
      tags = <Tags>[];
      json['tags'].forEach((v) {
        tags!.add(Tags.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['slug'] = slug;
    data['description'] = description;
    data['content'] = content;
    data['meta_title'] = metaTitle;
    data['meta_description'] = metaDescription;
    data['is_featured'] = isFeatured;
    data['status'] = status;
    data['created_by_id'] = createdById;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    if (media != null) {
      data['media'] = media!.map((v) => v.toJson()).toList();
    }
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    if (createdBy != null) {
      data['created_by'] = createdBy!.toJson();
    }
    if (tags != null) {
      data['tags'] = tags!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CreatedBy {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? code;
  String? providerId;
  String? status;
  String? isFeatured;
  String? type;
  String? emailVerifiedAt;
  String? createdBy;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? primaryAddress;
  List<Media>? media;
  WalletModel? wallet;

  CreatedBy(
      {this.id,
      this.name,
      this.email,
      this.phone,
      this.code,
      this.providerId,
      this.status,
      this.isFeatured,
      this.type,
      this.emailVerifiedAt,
      this.createdBy,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.primaryAddress,
      this.media,
      this.wallet});

  CreatedBy.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];

    phone = json['phone']?.toString();
    code = json['code']?.toString();
    providerId = json['provider_id']?.toString();
    status = json['status']?.toString();
    isFeatured = json['is_featured']?.toString();
    type = json['type'];
    emailVerifiedAt = json['email_verified_at'];
    createdBy = json['created_by']?.toString();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    primaryAddress = json['primary_address'];
    if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media!.add(Media.fromJson(v));
      });
    }
    wallet =
        json['wallet'] != null ? WalletModel.fromJson(json['wallet']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;

    data['phone'] = phone;
    data['code'] = code;
    data['provider_id'] = providerId;
    data['status'] = status;
    data['is_featured'] = isFeatured;
    data['type'] = type;
    data['email_verified_at'] = emailVerifiedAt;
    data['created_by'] = createdBy;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['primary_address'] = primaryAddress;
    if (media != null) {
      data['media'] = media!.map((v) => v.toJson()).toList();
    }
    data['wallet'] = wallet;
    return data;
  }
}

class Tags {
  int? id;
  String? name;
  String? slug;
  String? type;
  String? description;
  String? createdById;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  Pivot? pivot;

  Tags(
      {this.id,
      this.name,
      this.slug,
      this.type,
      this.description,
      this.createdById,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.pivot});

  Tags.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    type = json['type'];
    description = json['description'];
    createdById = json['created_by_id']?.toString();
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    pivot = json['pivot'] != null ? Pivot.fromJson(json['pivot']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['type'] = type;
    data['description'] = description;
    data['created_by_id'] = createdById?.toString();
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    if (pivot != null) {
      data['pivot'] = pivot!.toJson();
    }
    return data;
  }
}
