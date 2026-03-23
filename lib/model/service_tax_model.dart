class Tax {
  int? id;
  String? name;
  int? rate;
  int? status;
  int? createdById;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;

  Tax(
      {this.id,
      this.name,
      this.rate,
      this.status,
      this.createdById,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  Tax.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    rate = json['rate'];
    status = json['status'];
    createdById = json['created_by_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['rate'] = this.rate;
    data['status'] = this.status;
    data['created_by_id'] = this.createdById;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}
