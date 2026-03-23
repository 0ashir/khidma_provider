import '../config.dart';

class ServiceProofs {
  int? id;
  String? bookingId;
  String? title;
  String? description;
  String? createdAt;
  String? updatedAt;
  List<Media>? media;

  ServiceProofs(
      {this.id,
        this.bookingId,
        this.title,
        this.description,
        this.createdAt,
        this.updatedAt,
        this.media});

  ServiceProofs.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookingId = json['booking_id']?.toString();
    title = json['title'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
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
    data['booking_id'] = bookingId;
    data['title'] = title;
    data['description'] = description;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (media != null) {
      data['media'] = media!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}