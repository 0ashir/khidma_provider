class TaxModel {
  int? id;
  String? name;
  String? rate;
  String? status;
  String? createdById;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  TaxModel(
      {this.id,
        this.name,
        this.rate,
        this.status,
        this.createdById,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  TaxModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    rate = json['rate']?.toString();
    status = json['status']?.toString();
    createdById = json['created_by_id']?.toString();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['rate'] = rate;
    data['status'] = status;
    data['created_by_id'] = createdById;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    return data;
  }
}
