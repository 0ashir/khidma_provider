class WithdrawalModel {
  WithdrawalModel({
    this.id,
    this.userId,
    this.partnerName,
    this.userType,
    this.paymentAddress,
    this.amount,
    this.remarks,
    this.status,
    this.translatedStatus,
    this.createdAt,
    this.operations,
    this.accountNumber,
    this.bankDetails,
  });

  WithdrawalModel.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString() ?? '';
    userId = json['user_id']?.toString() ?? '';
    partnerName = json['partner_name']?.toString() ?? '';
    userType = json['user_type']?.toString() ?? '';
    paymentAddress = json['payment_address']?.toString() ?? '';
    amount = json['amount']?.toString() ?? '';
    remarks = json['remarks']?.toString() ?? '';
    status = json['status']?.toString() ?? '';
    translatedStatus = json['translated_status']?.toString() ?? '';
    createdAt = json['created_at']?.toString() ?? '';
    operations = json['operations']?.toString() ?? '';
    accountNumber = json['account_number']?.toString() ?? '';
    bankDetails = json['bank_details']?.toString() ?? '';
  }
  String? id;
  String? userId;
  String? partnerName;
  String? userType;
  String? paymentAddress;
  String? amount;
  String? remarks;
  String? status;
  String? translatedStatus;
  String? createdAt;
  String? operations;
  String? accountNumber;
  String? bankDetails;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['partner_name'] = partnerName;
    data['user_type'] = userType;
    data['payment_address'] = paymentAddress;
    data['amount'] = amount;
    data['remarks'] = remarks;
    data['status'] = status;
    data['translated_status'] = translatedStatus;
    data['created_at'] = createdAt;
    data['operations'] = operations;
    data['account_number'] = accountNumber;
    data['bank_details'] = bankDetails;
    return data;
  }
}
