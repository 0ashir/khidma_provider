class ActiveSubscription {
  dynamic id;
  dynamic userId;
  dynamic userPlanId;
  String? startDate;
  String? endDate;
  String? total;
  dynamic allowedMaxServices;
  dynamic allowedMaxAddresses;
  dynamic allowedMaxServicemen;
  dynamic allowedMaxServicePackages;
  dynamic isIncludedFreeTrial;
  dynamic isActive;
  String? createdAt;
  String? updatedAt;
  String? productId;

  ActiveSubscription(
      {this.id,
      this.userId,
      this.userPlanId,
      this.startDate,
      this.endDate,
      this.total,
      this.allowedMaxServices,
      this.allowedMaxAddresses,
      this.allowedMaxServicemen,
      this.allowedMaxServicePackages,
      this.isIncludedFreeTrial,
      this.isActive,
      this.productId,
      this.createdAt,
      this.updatedAt});

  ActiveSubscription.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    userPlanId = json['user_plan_id'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    total = json['total'];
    productId = json['product_id'];
    allowedMaxServices = json['allowed_max_services'];
    allowedMaxAddresses = json['allowed_max_addresses'];
    allowedMaxServicemen = json['allowed_max_servicemen'];
    allowedMaxServicePackages = json['allowed_max_service_packages'];
    isIncludedFreeTrial = json['is_included_free_trial'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['user_plan_id'] = userPlanId;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['total'] = total;
    data['product_id'] = productId;
    data['allowed_max_services'] = allowedMaxServices;
    data['allowed_max_addresses'] = allowedMaxAddresses;
    data['allowed_max_servicemen'] = allowedMaxServicemen;
    data['allowed_max_service_packages'] = allowedMaxServicePackages;
    data['is_included_free_trial'] = isIncludedFreeTrial;
    data['is_active'] = isActive;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
