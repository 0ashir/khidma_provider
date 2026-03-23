import 'package:fixit_provider/config.dart';

class Reviews {
  int? id;
  int? serviceId;
  int? consumerId;
  int? providerId;
  int? servicemanId;
  int? rating;
  String? description;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  List<Media>? media;
  UserModel? consumer;
  Services? service;
  ServicemanModel? serviceman;
  ProviderModel? provider;

  Reviews(
      {this.id,
      this.serviceId,
      this.consumerId,
      this.providerId,
      this.servicemanId,
      this.rating,
      this.description,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.media,
      this.consumer,
      this.service,
      this.serviceman,
      this.provider});

  Reviews.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceId = json['service_id'];
    consumerId = json['consumer_id'];
    providerId = json['provider_id'];
    servicemanId = json['serviceman_id'];
    rating = json['rating'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media!.add(Media.fromJson(v));
      });
    }
    consumer =
        json['consumer'] != null ? UserModel.fromJson(json['consumer']) : null;
    service =
        json['service'] != null ? Services.fromJson(json['service']) : null;
    serviceman = json['serviceman'] != null
        ? ServicemanModel.fromJson(json['serviceman'])
        : null;
    provider = json['provider'] != null
        ? ProviderModel.fromJson(json['provider'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['service_id'] = serviceId;
    data['consumer_id'] = consumerId;
    data['provider_id'] = providerId;
    data['serviceman_id'] = servicemanId;
    data['rating'] = rating;
    data['description'] = description;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    if (media != null) {
      data['media'] = media!.map((v) => v.toJson()).toList();
    }
    if (consumer != null) {
      data['consumer'] = consumer!.toJson();
    }
    if (service != null) {
      data['service'] = service!.toJson();
    }
    if (serviceman != null) {
      data['serviceman'] = serviceman!.toJson();
    }
    if (provider != null) {
      data['provider'] = provider!.toJson();
    }
    return data;
  }
}
