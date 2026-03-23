/* class ServiceAddOnsModel {
  bool? success;
  List<Data>? data;

  ServiceAddOnsModel({this.success, this.data});

  ServiceAddOnsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
} */

class ServiceAddOnsModel {
  int? id;
  String? title;
  int? price;
  int? parentId;
  int? userId;
  dynamic createdAt;
  List<Media>? media;

  ServiceAddOnsModel(
      {this.id,
      this.title,
      this.price,
      this.parentId,
      this.userId,
      this.createdAt,
      this.media});

  ServiceAddOnsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    price = json['price'];
    parentId = json['parent_id'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media!.add(new Media.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['price'] = price;
    data['parent_id'] = parentId;
    data['user_id'] = userId;
    data['created_at'] = createdAt;
    if (media != null) {
      data['media'] = media!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['collection_name'] = collectionName;
    data['original_url'] = originalUrl;
    return data;
  }
}
