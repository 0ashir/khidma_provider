class SubscriptionPlanModel {
  String? title;
  String? subtext;
  List<String>? benefits;

  SubscriptionPlanModel({this.title, this.subtext, this.benefits});

  SubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    subtext = json['subtext'];
    benefits = json['benefits'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['subtext'] = subtext;
    data['benefits'] = benefits;
    return data;
  }
}

class SubscriptionModel {
  int? id;
  String? name;
  String? maxServices;
  String? maxAddresses;
  String? maxServicemen;
  String? maxServicePackages;
  double? price;
  String? duration;
  String? description;
  int? status;
  int? createdBy;
  String? productId;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  List<String>? benefits;

  SubscriptionModel(
      {this.id,
      this.name,
      this.maxServices,
      this.maxAddresses,
      this.maxServicemen,
      this.maxServicePackages,
      this.price,
      this.duration,
      this.description,
      this.status,
      this.createdBy,
      this.productId,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.benefits});

  SubscriptionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    maxServices = json['max_services']?.toString();
    maxAddresses = json['max_addresses']?.toString();
    maxServicemen = json['max_servicemen']?.toString();
    maxServicePackages = json['max_service_packages']?.toString();
    description = json['description'];
    price =  json['price'] != null ? double.parse( json['price'].toString()):null;
    duration = json['duration'];
    description = json['description'];
    status = json['status'] != null ? int.parse(json['status'].toString()):null;
    createdBy = json['created_by'] != null ? int.parse(json['created_by'].toString()):null;

    productId = json['product_id'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['benefits'] != null) {
      json['benefits'].forEach((v) {
        benefits!.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['max_services'] = maxServices;
    data['max_addresses'] = maxAddresses;
    data['max_servicemen'] = maxServicemen;
    data['max_service_packages'] = maxServicePackages;
    data['price'] = price;
    data['duration'] = duration;
    data['product_id'] = productId;
    data['description'] = description;
    data['status'] = status;
    data['created_by'] = createdBy;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (benefits != null) {
      data['benefits'] = benefits!.map((v) => v).toList();
    }
    return data;
  }
}
