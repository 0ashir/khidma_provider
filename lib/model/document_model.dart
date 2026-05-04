class DocumentModel {
  int? id;
  String? title;
  String? createdAt;
  int? status;
  String? isRequired;
  String? updatedAt;
  String? deletedAt;

  DocumentModel(
      {this.id,
      this.title,
      this.status,
      this.isRequired,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  DocumentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    status = json['status'];
    isRequired = json['is_required']?.toString();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['status'] = status;
    data['is_required'] = isRequired;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    return data;
  }
}
