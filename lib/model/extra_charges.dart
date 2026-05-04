class ExtraCharges {
  int? id;
  String? title;
  int? bookingId;
  double? perServiceAmount;
  int? noServiceDone;
  String? paymentMethod;
  String? paymentStatus;
  double? total;
  String? createdAt;
  String? updatedAt;


  ExtraCharges(
      {this.id,
        this.title,
        this.bookingId,
        this.perServiceAmount,
        this.noServiceDone,
        this.paymentMethod,
        this.paymentStatus,
        this.total,
        this.createdAt,
        this.updatedAt});

  ExtraCharges.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    bookingId = json['booking_id'];
    perServiceAmount = json['per_service_amount'] != null ? double.parse(json['per_service_amount'].toString()):null;
    noServiceDone = json['no_service_done'];
    paymentMethod = json['payment_method'];
    paymentStatus = json['payment_status'];
    total = json['total'] != null ? double.parse(json['total'].toString()):null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['booking_id'] = bookingId;
    data['per_service_amount'] = perServiceAmount;
    data['no_service_done'] = noServiceDone;
    data['payment_method'] = paymentMethod;
    data['payment_status'] = paymentStatus;
    data['total'] = total;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}