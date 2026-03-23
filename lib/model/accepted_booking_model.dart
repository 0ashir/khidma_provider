class AcceptedBookingModel {
  String? image;
  String? status;
  String? bookingId;
  String? title;
  String? rate;
  String? date;
  String? time;
  String? location;
  String? description;
  Customer? customer;
  List<ServicemanList>? servicemanList;

  AcceptedBookingModel(
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
        this.servicemanList});

  AcceptedBookingModel.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    status = json['status'];
    bookingId = json['bookingId'];
    title = json['title'];
    rate = json['rate'];
    date = json['date'];
    time = json['time'];
    location = json['location'];
    description = json['description'];
    customer = json['customer'] != null
        ? Customer.fromJson(json['customer'])
        : null;
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
    data['title'] = title;
    data['rate'] = rate;
    data['date'] = date;
    data['time'] = time;
    data['location'] = location;
    data['description'] = description;
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
    if (servicemanList != null) {
      data['servicemanList'] =
          servicemanList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Customer {
  String? image;
  String? title;

  Customer({this.image, this.title});

  Customer.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['title'] = title;
    return data;
  }
}

class ServicemanList {
  String? image;
  String? title;
  String? rate;
  String? experience;

  ServicemanList({this.image, this.title, this.rate, this.experience});

  ServicemanList.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    title = json['title'];
    rate = json['rate'];
    experience = json['experience'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['title'] = title;
    data['rate'] = rate;
    data['experience'] = experience;
    return data;
  }
}
