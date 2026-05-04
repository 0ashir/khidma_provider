import '../config.dart';

class ProviderDocumentModel {
  int? id;
  int? userId;
  String? documentId;
  String? status;
  String? notes;
  String? identityNo;
  String? deletedAt;
  String? createdAt;
  bool? isVerified;
  String? updatedAt;
  // DocumentModel? document;
  String? document;
  List<Media>? media;

  ProviderDocumentModel(
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

  ProviderDocumentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    documentId = json['document_id']?.toString();
    status = json['status'];
    notes = json['notes'];
    identityNo = json['identity_no'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    isVerified = json['is_verified'];
    updatedAt = json['updated_at'];
    document = json['document'];
    // document = json['document'] != null
    //     ? DocumentModel.fromJson(json['document'])
    //     : null;
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
    data['document'] = document;
   /* if (document != null) {
      data['document'] = document!.toJson();
    }*/
    if (media != null) {
      data['media'] = media!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
