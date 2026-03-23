class PromotionPlanModel {
  int? id;
  String? price;
  int? durationDays;
  int? status;
  int? createdBy;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;

  PromotionPlanModel(
      {this.id,
        this.price,
        this.durationDays,
        this.status,
        this.createdBy,
        this.deletedAt,
        this.createdAt,
        this.updatedAt});

  PromotionPlanModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    durationDays = json['duration_days'];
    status = json['status'];
    createdBy = json['created_by'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['price'] = price;
    data['duration_days'] = durationDays;
    data['status'] = status;
    data['created_by'] = createdBy;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
