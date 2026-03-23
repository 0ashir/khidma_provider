import 'media_model.dart';

class PagesModel {
  int? id;
  String? title;
  String? content;
  String? icon;
  String? metaTitle;
  String? metaDescription;
  String? status;
  String? createdById;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  List<Media>? media;

  PagesModel(
      {this.id,
      this.title,
      this.content,
      this.icon,
      this.metaTitle,
      this.metaDescription,
      this.status,
      this.createdById,
      this.createdAt,
      this.updatedAt,
      this.media,
      this.deletedAt});

  PagesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    metaTitle = json['meta_title'];
    metaDescription = json['meta_description'];
    status = json['status']?.toString();
    createdById = json['created_by_id']?.toString();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
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
    data['title'] = title;
    data['content'] = content;
    data['icon'] = icon;
    data['meta_title'] = metaTitle;
    data['meta_description'] = metaDescription;
    data['status'] = status;
    data['created_by_id'] = createdById;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    if (media != null) {
      data['media'] = media!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
