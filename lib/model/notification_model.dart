class NotificationModel {
  String? id;
  String? type;
  String? notifiableType;
  String? notifiableId;
  NotificationData? data;
  String? readAt;
  String? createdAt;
  String? updatedAt;

  NotificationModel(
      {this.id,
      this.type,
      this.notifiableType,
      this.notifiableId,
      this.data,
      this.readAt,
      this.createdAt,
      this.updatedAt});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    notifiableType = json['notifiable_type'];
    notifiableId = json['notifiable_id']?.toString();
    data =
        json['data'] != null ? NotificationData.fromJson(json['data']) : null;
    readAt = json['read_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['notifiable_type'] = notifiableType;
    data['notifiable_id'] = notifiableId;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['read_at'] = readAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class NotificationData {
  String? title;
  String? message;
  int? providerId;
  int? bookingId;
  int? serviceId;
  String? type;
  String? thumbnail;
  String? image;

  NotificationData(
      {this.title,
      this.message,
      this.providerId,
      this.type,
      this.image,
      this.thumbnail,
      this.bookingId,
      this.serviceId});

  NotificationData.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    message = json['message'];
    providerId = json['provider_id'];
    serviceId = json['service_id'];
    bookingId = json['booking_id'];
    type = json['type'];
    thumbnail = json['thumbnail'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['message'] = message;
    data['provider_id'] = providerId;
    data['booking_id'] = bookingId;
    data['service_id'] = serviceId;
    data['type'] = type;
    data['thumbnail'] = thumbnail;
    data['image'] = image;

    return data;
  }
}
