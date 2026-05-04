class LocationModel {
  bool? success;
  Data? data;

  LocationModel({this.success, this.data});

  LocationModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? currentPage;
  String? currentPageUrl;
  List<LocationData>? data;
  String? firstPageUrl;
  int? from;
  Null? nextPageUrl;
  String? path;
  int? perPage;
  Null? prevPageUrl;
  int? to;

  Data(
      {this.currentPage,
      this.currentPageUrl,
      this.data,
      this.firstPageUrl,
      this.from,
      this.nextPageUrl,
      this.path,
      this.perPage,
      this.prevPageUrl,
      this.to});

  Data.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    currentPageUrl = json['current_page_url'];
    if (json['data'] != null) {
      data = <LocationData>[];
      json['data'].forEach((v) {
        data!.add(new LocationData.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = currentPage;
    data['current_page_url'] = currentPageUrl;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = firstPageUrl;
    data['from'] = from;
    data['next_page_url'] = nextPageUrl;
    data['path'] = path;
    data['per_page'] = perPage;
    data['prev_page_url'] = prevPageUrl;
    data['to'] = to;
    return data;
  }
}

class LocationData {
  int? id;
  int? userId;
  Null? serviceId;
  int? isPrimary;
  String? latitude;
  String? longitude;
  String? area;
  String? postalCode;
  int? countryId;
  int? stateId;
  String? city;
  String? address;
  Null? streetAddress;
  String? type;
  Null? alternativeName;
  int? code;
  Null? alternativePhone;
  int? status;
  Null? companyId;
  int? availabilityRadius;

  LocationData(
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
      this.streetAddress,
      this.type,
      this.alternativeName,
      this.code,
      this.alternativePhone,
      this.status,
      this.companyId,
      this.availabilityRadius});

  LocationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    serviceId = json['service_id'];
    isPrimary = json['is_primary'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    area = json['area'];
    postalCode = json['postal_code'];
    countryId = json['country_id'];
    stateId = json['state_id'];
    city = json['city'];
    address = json['address'];
    streetAddress = json['street_address'];
    type = json['type'];
    alternativeName = json['alternative_name'];
    code = json['code'];
    alternativePhone = json['alternative_phone'];
    status = json['status'];
    companyId = json['company_id'];
    availabilityRadius = json['availability_radius'];
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
    data['street_address'] = streetAddress;
    data['type'] = type;
    data['alternative_name'] = alternativeName;
    data['code'] = code;
    data['alternative_phone'] = alternativePhone;
    data['status'] = status;
    data['company_id'] = companyId;
    data['availability_radius'] = availabilityRadius;
    return data;
  }
}
