import '../config.dart';

class UserDocuments {
  int? id;
  String? userId;
  String? documentId;
  String? status;
  String? notes;
  String? identityNo;
  String? deletedAt;
  String? createdAt;
  String? isVerified;
  String? updatedAt;
  Document? document;
  List<Media>? media;

  UserDocuments(
      {this.id,
        this.userId,
        this.documentId,
        this.status,
        this.notes,
        this.identityNo,
        this.deletedAt,
        this.createdAt,
        this.isVerified,
        this.updatedAt,
        this.document,
        this.media});

  UserDocuments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id']?.toString();
    documentId = json['document_id']?.toString();
    status = json['status']?.toString();
    notes = json['notes'];
    identityNo = json['identity_no']?.toString();
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    isVerified = json['is_verified']?.toString();
    updatedAt = json['updated_at'];
    document = json['document'] != null
        ? Document.fromJson(json['document'])
        : null;
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
    data['user_id'] = userId;
    data['document_id'] = documentId;
    data['status'] = status;
    data['notes'] = notes;
    data['identity_no'] = identityNo;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['is_verified'] = isVerified;
    data['updated_at'] = updatedAt;
    if (document != null) {
      data['document'] = document!.toJson();
    }
    if (media != null) {
      data['media'] = media!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Document {
  int? id;
  String? title;
  String? status;
  String? isRequired;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  Document(
      {this.id,
        this.title,
        this.status,
        this.isRequired,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  Document.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    status = json['status']?.toString();
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
