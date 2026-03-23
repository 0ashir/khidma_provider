import 'package:fixit_provider/config.dart';

class BankDetailModel {
  int? id;
  int? userId;
  String? bankName;
  String? holderName;
  int? accountNumber;
  String? branchName;
  String? ifscCode;
  String? swiftCode;
  String? createdAt;
  String? updatedAt;
  List<Media>? media;

  BankDetailModel(
      {this.id,
      this.userId,
      this.bankName,
      this.holderName,
      this.accountNumber,
      this.branchName,
      this.ifscCode,
      this.swiftCode,
      this.createdAt,
      this.updatedAt,
      this.media});

  BankDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    bankName = json['bank_name'];
    holderName = json['holder_name'];
    accountNumber = json['account_number'];
    branchName = json['branch_name'];
    ifscCode = json['ifsc_code'];
    swiftCode = json['swift_code'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media!.add(Media.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['bank_name'] = bankName;
    data['holder_name'] = holderName;
    data['account_number'] = accountNumber;
    data['branch_name'] = branchName;
    data['ifsc_code'] = ifscCode;
    data['swift_code'] = swiftCode;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (media != null) {
      data['media'] = media!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
