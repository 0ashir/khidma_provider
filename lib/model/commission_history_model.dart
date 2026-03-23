import 'package:fixit_provider/config.dart';
import 'package:fixit_provider/model/index.dart';

class CommissionHistoryModel {
  List<Histories>? histories;
  double? total;

  CommissionHistoryModel({this.histories, this.total});

  CommissionHistoryModel.fromJson(Map<String, dynamic> json) {
    if (json['histories'] != null) {
      histories = <Histories>[];
      json['histories'].forEach((v) {
        histories!.add(Histories.fromJson(v));
      });
    }
    total = double.parse(json['total'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (histories != null) {
      data['histories'] = histories!.map((v) => v.toJson()).toList();
    }
    data['total'] = total;
    return data;
  }
}

/* class Histories {
  int? id;
  double? adminCommission;
  double? serviceCommission;
  double? providerCommission;
  int? bookingId;
  int? providerId;
  int? categoryId;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  BookingModel? booking;
  ProviderModel? provider;

  Histories(
      {this.id,
      this.adminCommission,
      this.serviceCommission,
      this.providerCommission,
      this.bookingId,
      this.providerId,
      this.categoryId,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.booking,
      this.provider});

  Histories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    adminCommission = double.parse(json['admin_commission'].toString());
    providerCommission = double.parse(json['provider_commission'].toString());
    serviceCommission = json['service_commission'] == null
        ? 0.0
        : double.parse(json['service_commission'].toString());
    bookingId = json['booking_id'];
    providerId = json['provider_id'];
    categoryId = json['category_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    booking =
        json['booking'] != null ? BookingModel.fromJson(json['booking']) : null;
    provider = json['provider'] != null
        ? ProviderModel.fromJson(json['provider'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['admin_commission'] = adminCommission;
    data['service_commission'] = serviceCommission;
    data['provider_commission'] = providerCommission;
    data['booking_id'] = bookingId;
    data['provider_id'] = providerId;
    data['category_id'] = categoryId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    if (booking != null) {
      data['booking'] = booking!.toJson();
    }
    if (provider != null) {
      data['provider'] = provider!.toJson();
    }
    return data;
  }
}
 */

class Histories {
  int? id;
  double? adminCommission;
  double? providerCommission;
  double? providerNetCommission;
  BookingModel? booking;
  List<ServicemanCommission>? servicemanCommissions;
  DateTime? createdAt;

  Histories({
    this.id,
    this.adminCommission,
    this.providerCommission,
    this.providerNetCommission,
    this.booking,
    this.servicemanCommissions,
    this.createdAt,
  });

  factory Histories.fromJson(Map<String, dynamic> json) => Histories(
        id: json["id"],
        adminCommission: json["admin_commission"]?.toDouble(),
        providerCommission: json["provider_commission"]?.toDouble(),
        providerNetCommission: json["provider_net_commission"]?.toDouble(),
        booking: json["booking"] == null
            ? null
            : BookingModel.fromJson(json["booking"]),
        servicemanCommissions: json["serviceman_commissions"] == null
            ? []
            : List<ServicemanCommission>.from(json["serviceman_commissions"]!
                .map((x) => ServicemanCommission.fromJson(x))),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "admin_commission": adminCommission,
        "provider_commission": providerCommission,
        "provider_net_commission": providerNetCommission,
        "booking": booking?.toJson(),
        "serviceman_commissions": servicemanCommissions == null
            ? []
            : List<dynamic>.from(servicemanCommissions!.map((x) => x.toJson())),
        "created_at": createdAt?.toIso8601String(),
      };
}

class ServicemanCommission {
  int? servicemanId;
  String? name;
  double? commission;

  ServicemanCommission({
    this.servicemanId,
    this.name,
    this.commission,
  });

  factory ServicemanCommission.fromJson(Map<String, dynamic> json) =>
      ServicemanCommission(
        servicemanId: json["serviceman_id"],
        name: json["name"],
        commission: json["commission"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "serviceman_id": servicemanId,
        "name": name,
        "commission": commission,
      };
}
