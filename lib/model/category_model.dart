import '../config.dart';

class CategoryModel {
  int? id;
  String? title;
  String? slug;
  String? description;
  int? parentId;
  String? metaTitle;
  String? metaDescription;
  int? commission;
  int? status;
  String? isFeatured;
  String? categoryType;
  int? createdBy;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  List<Media>? media;
  Pivot? pivot;
  List<CategoryModel>? hasSubCategories;

  CategoryModel(
      {this.id,
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
      this.media,
      this.pivot,
      this.hasSubCategories});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
    description = json['description'];
    parentId = json['parent_id'];
    metaTitle = json['meta_title'];
    metaDescription = json['meta_description'];
    commission = json['commission'];
    status = json['status'];

    isFeatured = json['is_featured']?.toString();
    categoryType = json['category_type'];
    createdBy = json['created_by'] != null ? int.parse(json['created_by'].toString()):null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
     if (json['media'] != null && json['media'] is List) {
      media = <Media>[];
      for (var v in json['media']) {
        media!.add(Media.fromJson(v));
      }
    }
   /*  if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media!.add(Media.fromJson(v));
      });
    } */
    pivot = json['pivot'] != null ? Pivot.fromJson(json['pivot']) : null;
    if (json['has_sub_categories'] != null) {
      hasSubCategories = <CategoryModel>[];
      json['has_sub_categories'].forEach((v) {
        hasSubCategories!.add(CategoryModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['slug'] = slug;
    data['description'] = description;
    data['parent_id'] = parentId;
    data['meta_title'] = metaTitle;
    data['meta_description'] = metaDescription;
    data['commission'] = commission;
    data['status'] = status;
    data['is_featured'] = isFeatured;
    data['category_type'] = categoryType;
    data['created_by'] = createdBy;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    if (media != null) {
      data['media'] = media!.map((v) => v.toJson()).toList();
    }
    if (pivot != null) {
      data['pivot'] = pivot!.toJson();
    }
    if (hasSubCategories != null) {
      data['has_sub_categories'] =
          hasSubCategories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pivot {
  String? serviceId;
  String? categoryId;

  Pivot({this.serviceId, this.categoryId});

  Pivot.fromJson(Map<String, dynamic> json) {
    serviceId = json['service_id']?.toString();
    categoryId = json['category_id']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['service_id'] = serviceId;
    data['category_id'] = categoryId;
    return data;
  }
}

class HasSubCategories {
  int? id;
  String? title;
  String? slug;
  String? description;
  String? parentId;
  String? metaTitle;
  String? metaDescription;
  String? commission;
  String? status;
  String? isFeatured;
  String? categoryType;
  String? createdBy;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  List<Media>? media;

  HasSubCategories(
      {this.id,
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
      this.media});

  HasSubCategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
    description = json['description'];
    parentId = json['parent_id'];
    metaTitle = json['meta_title'];
    metaDescription = json['meta_description'];
    commission = json['commission'];
    status = json['status'];
    isFeatured = json['is_featured'];
    categoryType = json['category_type'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media!.add(Media.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['slug'] = slug;
    data['description'] = description;
    data['parent_id'] = parentId;
    data['meta_title'] = metaTitle;
    data['meta_description'] = metaDescription;
    data['commission'] = commission;
    data['status'] = status;
    data['is_featured'] = isFeatured;
    data['category_type'] = categoryType;
    data['created_by'] = createdBy;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    if (media != null) {
      data['media'] = media!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
