class ServiceAddOnsGetModel1 {
  bool? success;
  ServiceAddOnsGetModel? data;

  ServiceAddOnsGetModel1({this.success, this.data});

  ServiceAddOnsGetModel1.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null
        ? new ServiceAddOnsGetModel.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ServiceAddOnsGetModel {
  int? id;
  String? title;
  int? price;
  int? parentId;
  int? userId;
  int? status;
  String? createdAt;
  List<Media>? media;

  ServiceAddOnsGetModel(
      {this.id,
      this.title,
      this.price,
      this.parentId,
      this.userId,
      this.status,
      this.createdAt,
      this.media});

  ServiceAddOnsGetModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    price = json['price'];
    parentId = json['parent_id'];
    userId = json['user_id'];
    status = json['status'];
    createdAt = json['created_at'];
    if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media!.add(new Media.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['price'] = this.price;
    data['parent_id'] = this.parentId;
    data['user_id'] = this.userId;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    if (this.media != null) {
      data['media'] = this.media!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Media {
  int? id;
  String? collectionName;
  String? originalUrl;

  Media({this.id, this.collectionName, this.originalUrl});

  Media.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    collectionName = json['collection_name'];
    originalUrl = json['original_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['collection_name'] = this.collectionName;
    data['original_url'] = this.originalUrl;
    return data;
  }
}
