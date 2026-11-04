/// Flat handyman profile payload returned by the login endpoint when
/// `user_type=handyman`. Distinct from [ProviderDetails] and from the
/// placeholder dashboard [HandymanProfileModel].
class HandymanLoginModel {
  final String id;
  final String username;
  final String email;
  final String phone;
  final String countryCode;
  final String image;
  final String fcmId;
  final String partnerId;
  final String ratings;
  final String numberOfRatings;
  final int isAvailable;
  final String address;

  const HandymanLoginModel({
    required this.id,
    required this.username,
    required this.email,
    required this.phone,
    required this.countryCode,
    required this.image,
    required this.fcmId,
    required this.partnerId,
    required this.ratings,
    required this.numberOfRatings,
    required this.isAvailable,
    required this.address,
  });

  bool get available => isAvailable == 1;

  factory HandymanLoginModel.fromJson(Map<String, dynamic> json) {
    return HandymanLoginModel(
      id: json['id']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      countryCode: json['country_code']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      fcmId: json['fcm_id']?.toString() ?? '',
      partnerId: json['partner_id']?.toString() ?? '',
      ratings: json['ratings']?.toString() ?? '0',
      numberOfRatings: json['number_of_ratings']?.toString() ?? '0',
      isAvailable: int.tryParse(json['is_available']?.toString() ?? '0') ?? 0,
      address: json['address']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'phone': phone,
      'country_code': countryCode,
      'image': image,
      'fcm_id': fcmId,
      'partner_id': partnerId,
      'ratings': ratings,
      'number_of_ratings': numberOfRatings,
      'is_available': isAvailable,
      'address': address,
    };
  }

  HandymanLoginModel copyWith({
    String? id,
    String? username,
    String? email,
    String? phone,
    String? countryCode,
    String? image,
    String? fcmId,
    String? partnerId,
    String? ratings,
    String? numberOfRatings,
    int? isAvailable,
    String? address,
  }) {
    return HandymanLoginModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      countryCode: countryCode ?? this.countryCode,
      image: image ?? this.image,
      fcmId: fcmId ?? this.fcmId,
      partnerId: partnerId ?? this.partnerId,
      ratings: ratings ?? this.ratings,
      numberOfRatings: numberOfRatings ?? this.numberOfRatings,
      isAvailable: isAvailable ?? this.isAvailable,
      address: address ?? this.address,
    );
  }
}
