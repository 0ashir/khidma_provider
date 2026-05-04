import 'media_model.dart';

class ReferralModel {
  int? id;
  int? referrerBonusAmount;
  int? referredBonusAmount;
  int? bookingAmount;
  int? referrerPercentage;
  int? referredPercentage;
  String? referrerType;
  String? referredType;
  String? status;
  String? creditedAt;
  Referrer? referrer;
  Referrer? referred;

  ReferralModel({
    this.id,
    this.referrerBonusAmount,
    this.referredBonusAmount,
    this.bookingAmount,
    this.referrerPercentage,
    this.referredPercentage,
    this.referrerType,
    this.referredType,
    this.status,
    this.creditedAt,
    this.referrer,
    this.referred,
  });

  ReferralModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    referrerBonusAmount = json['referrer_bonus_amount'];
    referredBonusAmount = json['referred_bonus_amount'];
    bookingAmount = json['booking_amount'];
    referrerPercentage = json['referrer_percentage'];
    referredPercentage = json['referred_percentage'];
    referrerType = json['referrer_type'];
    referredType = json['referred_type'];
    status = json['status'];
    creditedAt = json['credited_at'];
    referrer =
        json['referrer'] != null ? Referrer.fromJson(json['referrer']) : null;
    referred =
        json['referred'] != null ? Referrer.fromJson(json['referred']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['referrer_bonus_amount'] = referrerBonusAmount;
    data['referred_bonus_amount'] = referredBonusAmount;
    data['booking_amount'] = bookingAmount;
    data['referrer_percentage'] = referrerPercentage;
    data['referred_percentage'] = referredPercentage;
    data['referrer_type'] = referrerType;
    data['referred_type'] = referredType;
    data['status'] = status;
    data['credited_at'] = creditedAt;
    if (referrer != null) {
      data['referrer'] = referrer!.toJson();
    }
    if (referred != null) {
      data['referred'] = referred!.toJson();
    }
    return data;
  }
}

class Referrer {
  int? id;
  String? name;
  String? email;
  List<Media>? media;

  Referrer({
    this.id,
    this.name,
    this.email,
    this.media,
  });

  Referrer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
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
    if (media != null) {
      data['media'] = media!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
