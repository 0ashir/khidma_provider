import 'dart:developer';

import '../config.dart';

class ServicePackageModel {
  int? id;
  String? title;
  double? price;
  String? description;
  String? disclaimer;
  int? discount;
  int? status;
  int? isFeatured;
  String? hexaCode;
  String? slug;
  String? metaTitle;
  String? metaDescription;
  int? providerId;
  int? createdById;
  String? startedAt;
  String? endedAt;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  dynamic serviceCount;
  List<Services>? services;
  List<Media>? media;
  UserModel? user;

  ServicePackageModel(
      {this.id,
      this.title,
      this.price,
      this.description,
      this.disclaimer,
      this.discount,
      this.status,
      this.isFeatured,
      this.hexaCode,
      this.slug,
      this.metaTitle,
      this.metaDescription,
      this.providerId,
      this.createdById,
      this.serviceCount,
      this.startedAt,
      this.endedAt,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.services,
      this.media,
      this.user});

  ServicePackageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    price =
        json['price'] != null ? double.parse(json['price'].toString()) : null;
    description = json['description'];
    disclaimer = json['disclaimer'];
    discount = json['discount'];
    status = json['status'];
    isFeatured = json['is_featured'];
    hexaCode = json['hexa_code'];
    serviceCount = json['service_count'];
    slug = json['slug'];
    metaTitle = json['meta_title'];
    metaDescription = json['meta_description'];
    providerId = json['provider_id'];
    createdById = json['created_by_id'];
    startedAt = json['started_at'];
    endedAt = json['ended_at'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['services'] != null) {
      services = <Services>[];
      json['services'].forEach((v) {
        services!.add(Services.fromJson(v));
      });
    }
    if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media!.add(Media.fromJson(v));
      });
    }
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['price'] = price;
    data['description'] = description;
    data['disclaimer'] = disclaimer;
    data['discount'] = discount;
    data['status'] = status;
    data['is_featured'] = isFeatured;
    data['hexa_code'] = hexaCode;
    data['slug'] = slug;
    data['meta_title'] = metaTitle;
    data['meta_description'] = metaDescription;
    data['provider_id'] = providerId;
    data['created_by_id'] = createdById;
    data['started_at'] = startedAt;
    data['service_count'] = serviceCount;
    data['ended_at'] = endedAt;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (services != null) {
      data['services'] = services!.map((v) => v.toJson()).toList();
    }
    if (media != null) {
      data['media'] = media!.map((v) => v.toJson()).toList();
    }
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}
