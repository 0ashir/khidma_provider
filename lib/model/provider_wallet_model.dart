import 'package:fixit_provider/config.dart';

class ProviderWalletModel {
  int? id;
  int? providerId;
  double? balance;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  Transactions? transactions;

  ProviderWalletModel(
      {this.id,
      this.providerId,
      this.balance,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.transactions});

  ProviderWalletModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    providerId = json['provider_id'];
    balance = double.parse(json['balance'].toString());
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    transactions = json['transactions'] != null
        ? Transactions.fromJson(json['transactions'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['provider_id'] = providerId;
    data['balance'] = balance;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    if (transactions != null) {
      data['transactions'] = transactions!.toJson();
    }
    return data;
  }
}

class ServicemanWalletModel {
  int? id;
  int? providerId;
  double? balance;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  Transactions? transactions;

  ServicemanWalletModel(
      {this.id,
      this.providerId,
      this.balance,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.transactions});

  ServicemanWalletModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    providerId = json['provider_id'];
    balance = double.parse(json['balance'].toString());
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    transactions = json['transactions'] != null
        ? Transactions.fromJson(json['transactions'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['provider_id'] = providerId;
    data['balance'] = balance;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    if (transactions != null) {
      data['transactions'] = transactions!.toJson();
    }
    return data;
  }
}

class Transactions {
  int? currentPage;
  List<PaymentHistoryModel>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Links>? links;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  Transactions(
      {this.currentPage,
      this.data,
      this.firstPageUrl,
      this.from,
      this.lastPage,
      this.lastPageUrl,
      this.links,
      this.nextPageUrl,
      this.path,
      this.perPage,
      this.prevPageUrl,
      this.to,
      this.total});

  Transactions.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <PaymentHistoryModel>[];
      json['data'].forEach((v) {
        data!.add(PaymentHistoryModel.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(Links.fromJson(v));
      });
    }
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = currentPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = firstPageUrl;
    data['from'] = from;
    data['last_page'] = lastPage;
    data['last_page_url'] = lastPageUrl;
    if (links != null) {
      data['links'] = links!.map((v) => v.toJson()).toList();
    }
    data['next_page_url'] = nextPageUrl;
    data['path'] = path;
    data['per_page'] = perPage;
    data['prev_page_url'] = prevPageUrl;
    data['to'] = to;
    data['total'] = total;
    return data;
  }
}

class PaymentHistoryModel {
  int? id;
  int? providerWalletId;
  int? providerId;
  int? bookingId;
  double? amount;
  String? type;
  String? detail;
  int? from;
  String? createdAt;
  BookingModel? booking;

  PaymentHistoryModel(
      {this.id,
      this.providerWalletId,
      this.providerId,
      this.bookingId,
      this.amount,
      this.type,
      this.detail,
      this.from,
      this.createdAt,
      this.booking});

  PaymentHistoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    providerWalletId = json['provider_wallet_id'];
    providerId = json['provider_id'];
    bookingId = json['booking_id'];
    amount = double.parse(json['amount'].toString());
    type = json['type'];
    detail = json['detail'];
    from = json['from'];
    createdAt = json['created_at'];
    booking =
        json['booking'] != null ? BookingModel.fromJson(json['booking']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['provider_wallet_id'] = providerWalletId;
    data['provider_id'] = providerId;
    data['booking_id'] = bookingId;
    data['amount'] = amount;
    data['type'] = type;
    data['detail'] = detail;
    data['from'] = from;
    data['created_at'] = createdAt;
    if (booking != null) {
      data['booking'] = booking!.toJson();
    }
    return data;
  }
}

class Links {
  String? url;
  String? label;
  bool? active;

  Links({this.url, this.label, this.active});

  Links.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['label'] = label;
    data['active'] = active;
    return data;
  }
}
