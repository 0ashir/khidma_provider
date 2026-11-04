class BlockedUserModel {
  final String? id;
  final String? username;
  final String? email;
  final String? phone;
  final String? image;
  final String? reason;
  final String? additionalInfo;
  final String? blockedDate;

  BlockedUserModel({
    this.id,
    this.username,
    this.email,
    this.phone,
    this.image,
    this.reason,
    this.additionalInfo,
    this.blockedDate,
  });

  BlockedUserModel.fromJson(Map<String, dynamic> json)
    : id = json['id']?.toString() ?? '',
      username = json['username']?.toString() ?? '',
      email = json['email']?.toString() ?? '',
      phone = json['phone']?.toString() ?? '',
      image = json['image']?.toString() ?? '',
      reason = json['reason']?.toString() ?? '',
      additionalInfo = json['additional_info']?.toString() ?? '',
      blockedDate = json['blocked_date']?.toString() ?? '';

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'email': email,
    'phone': phone,
    'image': image,
    'reason': reason,
    'additional_info': additionalInfo,
    'blocked_date': blockedDate,
  };
}
