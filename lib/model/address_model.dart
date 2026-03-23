import '../config.dart';

class PrimaryAddress {
  int? id;
  String? userId;
  String? serviceId;
  int? isPrimary;
  String? latitude;
  String? longitude;
  String? area;
  String? postalCode;
  int? countryId;
  int? stateId;
  String? city;
  String? address;
  String? type;
  String? alternativeName;
  String? code;
  int? alternativePhone;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? companyId;
  double? availabilityRadius;
  int? status;
  CountryStateModel? country;
  StateModel? state;

  PrimaryAddress(
      {this.id,
      this.userId,
      this.serviceId,
      this.isPrimary,
      this.latitude,
      this.longitude,
      this.area,
      this.postalCode,
      this.countryId,
      this.stateId,
      this.city,
      this.address,
      this.type,
      this.alternativeName,
      this.code,
      this.alternativePhone,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.companyId,
      this.availabilityRadius,
      this.status,
      this.country,
      this.state});

  PrimaryAddress.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id']?.toString();
    serviceId = json['service_id']?.toString();
    isPrimary = json['is_primary'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    area = json['area'];
    postalCode = json['postal_code'];
    countryId = json['country_id'];
    stateId = json['state_id'];
    city = json['city'];
    address = json['address'];
    type = json['type'];
    alternativeName = json['alternative_name'];
    code = json['code']?.toString();
    alternativePhone = json['alternative_phone'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    companyId = json['company_id'].toString();
    availabilityRadius = json['availability_radius'] != null
        ? double.parse(json['availability_radius'].toString())
        : null;
    status = json['status'];
    country = json['country'] != null
        ? CountryStateModel.fromJson(json['country'])
        : null;
    state = json['state'] != null ? StateModel.fromJson(json['state']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['service_id'] = serviceId;
    data['is_primary'] = isPrimary;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['area'] = area;
    data['postal_code'] = postalCode;
    data['country_id'] = countryId;
    data['state_id'] = stateId;
    data['city'] = city;
    data['address'] = address;
    data['type'] = type;
    data['alternative_name'] = alternativeName;
    data['code'] = code;
    data['alternative_phone'] = alternativePhone;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['company_id'] = companyId;
    data['availability_radius'] = availabilityRadius;
    data['status'] = status;
    if (country != null) {
      data['country'] = country!.toJson();
    }
    if (state != null) {
      data['state'] = state!.toJson();
    }
    return data;
  }
}
