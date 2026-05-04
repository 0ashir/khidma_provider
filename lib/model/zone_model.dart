class ZoneModel {
  int? id;
  String? name;
  String? status;
  String? createdById;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  ZoneModel(
      {this.id,
      this.name,
      this.status,
      this.createdById,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  ZoneModel.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id'].toString()) ?? 0;
    name = json['name'];
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
    data['status'] = status;
    data['created_by_id'] = createdById;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    return data;
  }
}
