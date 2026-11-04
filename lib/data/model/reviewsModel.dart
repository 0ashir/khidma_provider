class ReviewsModel {
  ReviewsModel({
    this.id,
    this.partnerId,
    this.partnerName,
    this.userName,
    this.profileImage,
    this.userId,
    this.serviceId,
    this.rating,
    this.comment,
    this.ratedOn,
    this.rateUpdatedOn,
    this.service_name,
    this.images,
  });

  ReviewsModel.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString() ?? '';
    partnerId = json['partner_id']?.toString() ?? '';
    partnerName = json['partner_name']?.toString() ?? '';
    userName = json['user_name']?.toString() ?? '';
    profileImage = json['profile_image']?.toString() ?? '';
    userId = json['user_id']?.toString() ?? '';
    serviceId = json['service_id']?.toString() ?? '';
    rating = json['rating']?.toString() ?? '';
    comment = json['comment']?.toString() ?? '';
    ratedOn = json['rated_on']?.toString() ?? '';
    rateUpdatedOn = json['rate_updated_on']?.toString() ?? '';
    service_name = json['service_name']?.toString() ?? '';
    images = json['images'].cast<String>();
  }
  String? id;
  String? partnerId;
  String? partnerName;
  String? userName;
  String? profileImage;
  String? userId;
  String? serviceId;
  String? rating;
  String? comment;
  String? ratedOn;
  String? rateUpdatedOn;
  String? service_name;
  List<String>? images;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['partner_id'] = partnerId;
    data['partner_name'] = partnerName;
    data['user_name'] = userName;
    data['profile_image'] = profileImage;
    data['user_id'] = userId;
    data['service_id'] = serviceId;
    data['rating'] = rating;
    data['comment'] = comment;
    data['rated_on'] = ratedOn;
    data['rate_updated_on'] = rateUpdatedOn;
    data['images'] = images;
    data['service_name'] = service_name;
    return data;
  }
}
