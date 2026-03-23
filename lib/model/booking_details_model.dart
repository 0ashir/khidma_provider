/*
import '../config.dart';

class BookingDetailsModel {
  String? package;
  String? bookingId;
  String? date;
  String? address;
  String? time;
  String? description;
  CustomerDetails? customerDetails;
  List<ServiceMenDetails>? serviceMenDetails;
  CommissionHistoryModel? commissionHistory;

  BookingDetailsModel(
      {this.package,
        this.bookingId,
        this.date,
        this.address,
        this.time,
        this.description,
        this.customerDetails,
        this.serviceMenDetails,
        this.commissionHistory});

  BookingDetailsModel.fromJson(Map<String, dynamic> json) {
    package = json['package'];
    bookingId = json['booking_id'];
    date = json['date'];
    address = json['address'];
    time = json['time'];
    description = json['description'];
    customerDetails = json['customerDetails'] != null
        ? CustomerDetails.fromJson(json['customerDetails'])
        : null;
    commissionHistory = json['commission_history'] != null
        ?  CommissionHistoryModel.fromJson(json['commission_history'])
        : null;
    if (json['serviceMenDetails'] != null) {
      serviceMenDetails = <ServiceMenDetails>[];
      json['serviceMenDetails'].forEach((v) {
        serviceMenDetails!.add(ServiceMenDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['package'] = package;
    data['booking_id'] = bookingId;
    data['date'] = date;
    data['address'] = address;
    data['time'] = time;
    data['description'] = description;
    if (customerDetails != null) {
      data['customerDetails'] = customerDetails!.toJson();
    }
    if (serviceMenDetails != null) {
      data['serviceMenDetails'] =
          serviceMenDetails!.map((v) => v.toJson()).toList();
    }
    if (commissionHistory != null) {
      data['commission_history'] = commissionHistory!.toJson();
    }
    return data;
  }
}

class CustomerDetails {
  String? title;
  String? phone;
  String? email;
  String? location;
  List<Media>? media;

  CustomerDetails({this.title, this.media});

  CustomerDetails.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    email = json['email'];
    location = json['location'];
    phone = json['phone'];
    if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media!.add(Media.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['phone'] = phone;
    data['email'] = email;
    data['location'] = location;
    if (media != null) {
      data['media'] = media!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class ServiceMenDetails {
  String? name;
  List<Media>? media;

  ServiceMenDetails({this.name, this.media});

  ServiceMenDetails.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media!.add(Media.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    if (media != null) {
      data['media'] = media!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CommissionHistoryModel {
  String? totalReceivedAmount;
  String? adminCommission;
  String? servicemenCommission;
  String? platformFees;
  String? yourCommission;

  CommissionHistoryModel(
      {this.totalReceivedAmount,
        this.adminCommission,
        this.servicemenCommission,
        this.platformFees,
        this.yourCommission});

  CommissionHistoryModel.fromJson(Map<String, dynamic> json) {
    totalReceivedAmount = json['total_received_amount'];
    adminCommission = json['admin_commission'];
    servicemenCommission = json['servicemen_commission'];
    platformFees = json['platform_fees'];
    yourCommission = json['your_commission'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_received_amount'] = totalReceivedAmount;
    data['admin_commission'] = adminCommission;
    data['servicemen_commission'] = servicemenCommission;
    data['platform_fees'] = platformFees;
    data['your_commission'] = yourCommission;
    return data;
  }
}
*/
