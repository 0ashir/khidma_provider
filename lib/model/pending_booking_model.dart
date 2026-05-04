import '../config.dart';

class PendingBookingModel {
  String? image;
  String? status;
  String? bookingId;
  String? packageId;
  String? title;
  String? rate;
  String? date;
  String? time;
  String? location;
  String? description, assignMe;
  int? requiredServicemen;
  Customer? customer;
  List<ServicemanList>? servicemanList;

  PendingBookingModel(
      {this.image,
      this.status,
      this.bookingId,
      this.title,
      this.rate,
      this.date,
      this.time,
      this.location,
      this.description,
      this.customer,
      this.servicemanList,
      this.packageId,
      this.requiredServicemen,
      this.assignMe});

  PendingBookingModel.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    status = json['status'];
    bookingId = json['bookingId'];
    packageId = json['package_id'];
    assignMe = json['assign_me'];
    title = json['title'];
    rate = json['rate'];
    date = json['date'];
    time = json['time'];
    location = json['location'];
    description = json['description'];
    requiredServicemen = json['required_servicemen'];
    customer =
        json['customer'] != null ? Customer.fromJson(json['customer']) : null;
    if (json['servicemanList'] != null) {
      servicemanList = <ServicemanList>[];
      json['servicemanList'].forEach((v) {
        servicemanList!.add(ServicemanList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['status'] = status;
    data['bookingId'] = bookingId;
    data['package_id'] = packageId;
    data['assign_me'] = assignMe;
    data['title'] = title;
    data['rate'] = rate;
    data['date'] = date;
    data['time'] = time;
    data['location'] = location;
    data['description'] = description;
    data['required_servicemen'] = requiredServicemen;
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
    if (servicemanList != null) {
      data['servicemanList'] = servicemanList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
