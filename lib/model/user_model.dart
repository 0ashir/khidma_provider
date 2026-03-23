import 'package:fixit_provider/config.dart';

class UserModel {
  int? id;
  String? name;
  String? email;
  String? served;
  int? phone;
  String? code;
  int? providerId;
  int? status;
  int? isFeatured;
  int? isVerified;
  String? type;
  String? emailVerifiedAt;
  String? fcmToken;
  String? experienceInterval;
  String? experienceDuration;
  String? description;
  int? createdBy;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? companyId;
  String? referralCode;
  String? role;
  PrimaryAddress? primaryAddress;
  Company? company;
  List<Media>? media;
  WalletModel? wallet;
  ProviderWallet? providerWallet;
  ProviderWallet? servicemanWallet;
  List<KnownLanguageModel>? knownLanguages;
  List<ExpertiseModel>? expertise;
  ActiveSubscription? activeSubscription;
  List<ZoneModel>? zones;
  String? subscriptionReminderNote;

  UserModel(
      {this.id,
      this.name,
      this.email,
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
      this.role,
      this.primaryAddress,
      this.company,
      this.media,
      this.wallet,
      this.providerWallet,
      this.knownLanguages,
      this.expertise,
      this.activeSubscription,
      this.zones,
      this.subscriptionReminderNote});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id'].toString()) ?? 0;

    name = json['name'];
    email = json['email'];
    served = json['served']?.toString();
    phone = json['phone'];
    code = json['code'].toString();
    providerId = json['provider_id'];
    referralCode = json['referral_code'];
    status = json['status'];
    isFeatured = json['is_featured'];
    isVerified = json['is_verified'];
    type = json['type'];
    emailVerifiedAt = json['email_verified_at'];
    fcmToken = json['fcm_token'];
    experienceInterval = json['experience_interval'];
    experienceDuration = json['experience_duration']?.toString();
    description = json['description'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    subscriptionReminderNote = json['subscription_reminder_note'];
    companyId = json['company_id']?.toString();
    role = json['role'] /*!= null ? Role.fromJson(json['role']) : null*/;

    primaryAddress = json['primary_address'] != null
        ? PrimaryAddress.fromJson(json['primary_address'])
        : null;
    company =
        json['company'] != null ? Company.fromJson(json['company']) : null;
    if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media!.add(Media.fromJson(v));
      });
    }

    wallet =
        json['wallet'] != null ? WalletModel.fromJson(json['wallet']) : null;
    providerWallet = json['provider_wallet'] != null
        ? ProviderWallet.fromJson(json['provider_wallet'])
        : null;
    servicemanWallet = json['serviceman_wallet'] != null
        ? ProviderWallet.fromJson(json['serviceman_wallet'])
        : null;
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
    activeSubscription = json['active_subscription'] != null
        ? ActiveSubscription.fromJson(json['active_subscription'])
        : null;
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
    data['status'] = status;
    data['is_featured'] = isFeatured;
    data['is_verified'] = isVerified;
    data['type'] = type;
    data['email_verified_at'] = emailVerifiedAt;
    data['fcm_token'] = fcmToken;
    data['experience_interval'] = experienceInterval;
    data['experience_duration'] = experienceDuration;
    data['description'] = description;
    data['created_by'] = createdBy;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['company_id'] = companyId;
    data['subscription_reminder_note'] = subscriptionReminderNote;

    data['role'] = role;
    /*    if (role != null) {
      data['role'] = role!.toJson();
    }*/

    if (primaryAddress != null) {
      data['primary_address'] = primaryAddress!.toJson();
    }
    if (company != null) {
      data['company'] = company!.toJson();
    }
    if (media != null) {
      data['media'] = media!.map((v) => v.toJson()).toList();
    }
    data['wallet'] = wallet;
    if (providerWallet != null) {
      data['provider_wallet'] = providerWallet!.toJson();
    }
    if (servicemanWallet != null) {
      data['serviceman_wallet'] = servicemanWallet!.toJson();
    }
    if (knownLanguages != null) {
      data['known_languages'] = knownLanguages!.map((v) => v.toJson()).toList();
    }
    if (expertise != null) {
      data['expertise'] = expertise!.map((v) => v.toJson()).toList();
    }
    if (activeSubscription != null) {
      data['active_subscription'] = activeSubscription!.toJson();
    }
    if (zones != null) {
      data['zones'] = zones!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Role {
  int? id;
  String? name;
  String? guardName;

  String? createdAt;
  String? updatedAt;
  Pivot? pivot;

  Role(
      {this.id,
      this.name,
      this.guardName,
      this.createdAt,
      this.updatedAt,
      this.pivot});

  Role.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    guardName = json['guard_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    pivot = json['pivot'] != null ? Pivot.fromJson(json['pivot']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['guard_name'] = guardName;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (pivot != null) {
      data['pivot'] = pivot!.toJson();
    }
    return data;
  }
}

class Company {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? code;
  String? description;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  PrimaryAddress? primaryAddress; // Changed to List<PrimaryAddress>
  List<Media>? media;

  Company({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.code,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.primaryAddress,
    this.media,
  });

  Company.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone']?.toString();
    code = json['code']?.toString();
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];

    primaryAddress = json['primary_address'] != null
        ? PrimaryAddress.fromJson(json['primary_address'])
        : null;

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
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['code'] = code;
    data['description'] = description;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;

    if (primaryAddress != null) {
      data['primary_address'] = primaryAddress!.toJson();
    }

    if (media != null) {
      data['media'] = media!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProviderWallet {
  int? id;
  int? providerId;
  double? balance;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  ProviderWallet(
      {this.id,
      this.providerId,
      this.balance,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  ProviderWallet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    providerId = json['provider_id'];
    balance = json['balance'] != null
        ? double.parse(json['balance'].toString())
        : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['provider_id'] = providerId;
    data['balance'] = balance;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    return data;
  }
}
