class HandymanCustomFieldModel {
  final int id;
  final String fieldLabel;
  final String fieldType;
  final List<dynamic> fileConfig;
  final int required;
  final int sortOrder;
  final String value;

  const HandymanCustomFieldModel({
    required this.id,
    required this.fieldLabel,
    required this.fieldType,
    required this.fileConfig,
    required this.required,
    required this.sortOrder,
    required this.value,
  });

  bool get isFile => fieldType == 'file' || fieldType == 'image';

  factory HandymanCustomFieldModel.fromJson(Map<String, dynamic> json) =>
      HandymanCustomFieldModel(
        id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
        fieldLabel: json['field_label']?.toString() ?? '',
        fieldType: json['field_type']?.toString() ?? '',
        fileConfig: (json['file_config'] as List<dynamic>?) ?? [],
        required: int.tryParse(json['required']?.toString() ?? '0') ?? 0,
        sortOrder: int.tryParse(json['sort_order']?.toString() ?? '0') ?? 0,
        value: json['value']?.toString() ?? '',
      );
}

class HandymanProfileModel {
  final int id;
  final String username;
  final String email;
  final String phone;
  final String countryCode;
  final String image;
  final int partnerId;
  final String address;
  final String salary;
  final String averageRatings;
  final int totalRatings;
  final int isAvailable;
  final List<HandymanCustomFieldModel> customFields;
  final Map<String, String> translations;

  const HandymanProfileModel({
    required this.id,
    required this.username,
    required this.email,
    required this.phone,
    required this.countryCode,
    required this.image,
    required this.partnerId,
    required this.address,
    required this.salary,
    required this.averageRatings,
    required this.totalRatings,
    required this.isAvailable,
    required this.customFields,
    required this.translations,
  });

  bool get available => isAvailable == 1;

  factory HandymanProfileModel.fromJson(
    Map<String, dynamic> json,
  ) => HandymanProfileModel(
    id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
    username: json['username']?.toString() ?? '',
    email: json['email']?.toString() ?? '',
    phone: json['phone']?.toString() ?? '',
    countryCode: json['country_code']?.toString() ?? '',
    image: json['image']?.toString() ?? '',
    partnerId: int.tryParse(json['partner_id']?.toString() ?? '0') ?? 0,
    address: json['address']?.toString() ?? '',
    salary: json['salary']?.toString() ?? '0.00',
    averageRatings: json['average_rating']?.toString() ?? '0.0',
    totalRatings: int.tryParse(json['total_ratings']?.toString() ?? '0') ?? 0,
    isAvailable: int.tryParse(json['is_available']?.toString() ?? '0') ?? 0,
    customFields: (json['custom_fields'] as List<dynamic>? ?? [])
        .map(
          (e) =>
              HandymanCustomFieldModel.fromJson(Map<String, dynamic>.from(e)),
        )
        .toList(),
    translations: (json['translations'] as Map<String, dynamic>? ?? {}).map(
      (k, v) => MapEntry(k, v?.toString() ?? ''),
    ),
  );

  HandymanProfileModel copyWith({
    int? id,
    String? username,
    String? email,
    String? phone,
    String? countryCode,
    String? image,
    int? partnerId,
    String? address,
    String? salary,
    String? averageRatings,
    int? totalRatings,
    int? isAvailable,
    List<HandymanCustomFieldModel>? customFields,
    Map<String, String>? translations,
  }) => HandymanProfileModel(
    id: id ?? this.id,
    username: username ?? this.username,
    email: email ?? this.email,
    phone: phone ?? this.phone,
    countryCode: countryCode ?? this.countryCode,
    image: image ?? this.image,
    partnerId: partnerId ?? this.partnerId,
    address: address ?? this.address,
    salary: salary ?? this.salary,
    averageRatings: averageRatings ?? this.averageRatings,
    totalRatings: totalRatings ?? this.totalRatings,
    isAvailable: isAvailable ?? this.isAvailable,
    customFields: customFields ?? this.customFields,
    translations: translations ?? this.translations,
  );
}
