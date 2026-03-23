import 'dart:developer';

import '../config.dart';

class ProviderModel {
  int? id;
  String? name;
  String? email;
  String? served;
  String? phone;
  String? code;
  String? fcmToken;
  int? providerId;
  String? description;
  int? status;
  int? isFeatured;
  int? isVerified;
  String? type;
  String? emailVerifiedAt;
  String? experienceInterval;
  int? experienceDuration;
  int? createdBy;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  double? reviewRatings;
  int? reviewCount;
  List<CategoryModel>? categories;
  PrimaryAddress? primaryAddress;
  List<Services>? relatedServices;
  List<Services>? services;
  List<Media>? media;
  WalletModel? wallet;
  List<KnownLanguageModel>? knownLanguages;
  List<ExpertiseModel>? expertise;
  List<PrimaryAddress>? addresses;
  List<ServicemanModel>? servicemans;
  List<Reviews>? reviews;
  List<ZoneModel>? zones;

  ProviderModel(
      {this.id,
      this.name,
      this.email,
      this.fcmToken,
      this.served,
      this.phone,
      this.code,
      this.providerId,
      this.description,
      this.status,
      this.isFeatured,
      this.isVerified,
      this.type,
      this.emailVerifiedAt,
      this.experienceInterval,
      this.experienceDuration,
      this.createdBy,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.reviewRatings,
      this.reviewCount,
      this.categories,
      this.primaryAddress,
      this.relatedServices,
      this.media,
      this.wallet,
      this.knownLanguages,
      this.expertise,
      this.addresses,
      this.servicemans,
      this.reviews,
      this.services,
      this.zones});

  ProviderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    served = json['served']?.toString();
    phone = json['phone']?.toString();
    code = json['code']?.toString();
    providerId = json['provider_id'];
    description = json['description'];
    status = json['status'];
    isFeatured = json['is_featured'];
    isVerified = json['is_verified'];
    type = json['type'] ?? "";
    fcmToken = json['fcm_token'];
    emailVerifiedAt = json['email_verified_at'] ?? "";
    experienceInterval = json['experience_interval'];
    experienceDuration = json['experience_duration'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    reviewRatings = json['review_ratings'] != null
        ? double.parse(json['review_ratings'].toString())
        : null;
    reviewCount = json['reviewCount'];
    if (json['categories'] != null) {
      categories = <CategoryModel>[];
      json['categories'].forEach((v) {
        categories!.add(CategoryModel.fromJson(v));
      });
    }
    primaryAddress = json['primary_address'] != null
        ? PrimaryAddress.fromJson(json['primary_address'])
        : null;
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
    if (json['wallet'] != null) {
      wallet =
          json['wallet'] != null ? WalletModel.fromJson(json['wallet']) : null;
    }
    if (json['known_languages'] != null) {
      knownLanguages = <KnownLanguageModel>[];
      json['known_languages'].forEach((v) {
        knownLanguages!.add(KnownLanguageModel.fromJson(v));
      });
    }
    if (json['expertise'] != null) {
      expertise = <ExpertiseModel>[];
      json['expertise'].forEach((v) {
        expertise!.add(ExpertiseModel.fromJson(v));
      });
    }
    if (json['addresses'] != null) {
      addresses = <PrimaryAddress>[];
      json['addresses'].forEach((v) {
        addresses!.add(PrimaryAddress.fromJson(v));
      });
    }
    if (json['servicemans'] != null) {
      servicemans = <ServicemanModel>[];
      json['servicemans'].forEach((v) {
        servicemans!.add(ServicemanModel.fromJson(v));
      });
    }
    if (json['reviews'] != null) {
      reviews = <Reviews>[];
      json['reviews'].forEach((v) {
        reviews!.add(Reviews.fromJson(v));
      });
    }
    if (json['services'] != null) {
      services = <Services>[];
      json['services'].forEach((v) {
        if (v != null) {
          services!.add(Services.fromJson(v));
        }
      });
    }
    if (json['zones'] != null) {
      zones = <ZoneModel>[];
      json['zones'].forEach((v) {
        zones!.add(ZoneModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['served'] = served;
    data['phone'] = phone;
    data['code'] = code;
    data['provider_id'] = providerId;
    data['description'] = description;
    data['status'] = status;
    data['is_featured'] = isFeatured;
    data['is_verified'] = isVerified;
    data['fcm_token'] = fcmToken;
    data['type'] = type;
    data['email_verified_at'] = emailVerifiedAt;
    data['experience_interval'] = experienceInterval;
    data['experience_duration'] = experienceDuration;
    data['created_by'] = createdBy;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['review_ratings'] = reviewRatings;
    data['reviewCount'] = reviewCount;
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    if (primaryAddress != null) {
      data['primary_address'] = primaryAddress!.toJson();
    }
    if (relatedServices != null) {
      data['relatedServices'] =
          relatedServices!.map((v) => v.toJson()).toList();
    }
    if (media != null) {
      data['media'] = media!.map((v) => v.toJson()).toList();
    }
    if (wallet != null) {
      data['wallet'] = wallet;
    }
    if (knownLanguages != null) {
      data['known_languages'] = knownLanguages!.map((v) => v.toJson()).toList();
    }
    if (expertise != null) {
      data['expertise'] = expertise!.map((v) => v.toJson()).toList();
    }
    if (addresses != null) {
      data['addresses'] = addresses!.map((v) => v.toJson()).toList();
    }
    if (servicemans != null) {
      data['servicemans'] = servicemans!.map((v) => v.toJson()).toList();
    }
    if (reviews != null) {
      data['reviews'] = reviews!.map((v) => v.toJson()).toList();
    }
    if (services != null) {
      data['services'] = services!.map((v) => v.toJson()).toList();
    }
    if (zones != null) {
      data['zones'] = zones!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
