

import '../config.dart';

class CouponModel {
  int? id;
  String? code;
  String? type;
  int? amount;
  int? minSpend;
  int? isUnlimited;
  String? usagePerCoupon;
  String? usagePerCustomer;
  String? used;
  int? status;
  int? isExpired;
  int? isApplyAll;
  int? isFirstOrder;
  String? startDate;
  String? endDate;
  String? createdById;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  List<Services>? services;
  List<Services>? excludeServices;

  CouponModel(
      {this.id,
        this.code,
        this.type,
        this.amount,
        this.minSpend,
        this.isUnlimited,
        this.usagePerCoupon,
        this.usagePerCustomer,
        this.used,
        this.status,
        this.isExpired,
        this.isApplyAll,
        this.isFirstOrder,
        this.startDate,
        this.endDate,
        this.createdById,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.services,
        this.excludeServices});

  CouponModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    type = json['type'];
    amount = json['amount'];
    minSpend = json['min_spend'];
    isUnlimited = json['is_unlimited'];
    usagePerCoupon = json['usage_per_coupon'];
    usagePerCustomer = json['usage_per_customer'];
    used = json['used'];
    status = json['status'];
    isExpired = json['is_expired'];
    isApplyAll = json['is_apply_all'];
    isFirstOrder = json['is_first_order'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    createdById = json['created_by_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    if (json['services'] != null) {
      services = <Services>[];
      json['services'].forEach((v) {
        services!.add(Services.fromJson(v));
      });
    }
    if (json['exclude_services'] != null) {
      excludeServices = <Services>[];
      json['exclude_services'].forEach((v) {
        excludeServices!.add(Services.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['type'] = type;
    data['amount'] = amount;
    data['min_spend'] = minSpend;
    data['is_unlimited'] = isUnlimited;
    data['usage_per_coupon'] = usagePerCoupon;
    data['usage_per_customer'] = usagePerCustomer;
    data['used'] = used;
    data['status'] = status;
    data['is_expired'] = isExpired;
    data['is_apply_all'] = isApplyAll;
    data['is_first_order'] = isFirstOrder;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['created_by_id'] = createdById;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    if (services != null) {
      data['services'] = services!.map((v) => v.toJson()).toList();
    }
    if (excludeServices != null) {
      data['exclude_services'] =
          excludeServices!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}