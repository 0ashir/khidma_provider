import 'package:fixit_provider/config.dart';

class ServiceAvailabilities {
  int? id;
  String? companyId;
  String? addressId;
  String? userId;
  String? serviceId;
  String? createdAt;
  String? updatedAt;
  String? company;
  PrimaryAddress? address;

  ServiceAvailabilities(
      {this.id,
      this.companyId,
      this.addressId,
      this.userId,
      this.serviceId,
      this.createdAt,
      this.updatedAt,
      this.company,
      this.address});

  ServiceAvailabilities.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    addressId = json['address_id'];
    userId = json['user_id'];
    serviceId = json['service_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    company = json['company'];
    address = json['address'] != null
        ? PrimaryAddress.fromJson(json['address'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['company_id'] = companyId;
    data['address_id'] = addressId;
    data['user_id'] = userId;
    data['service_id'] = serviceId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['company'] = company;
    if (address != null) {
      data['address'] = address!.toJson();
    }
    return data;
  }
}
