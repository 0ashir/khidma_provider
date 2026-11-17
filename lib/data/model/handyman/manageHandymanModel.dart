/// Models for the provider-side "Manage Handymen" CRUD feature.
///
/// These are intentionally separate from the placeholder dashboard
/// [HandymanProfileModel]: this represents handymen a provider manages
/// (get_handymen / store_handyman / update_handyman responses).

/// A single handyman row returned by `get_handymen`.
class HandymanModel {
  final String id;
  final String username;
  final String phone;
  final String countryCode;
  final String email;
  final String image;
  final int active;
  final int isAvailable;

  /// 1 when the handyman is on a job right now (on the way / arrived / started).
  final int isBusy;
  final String address;
  final String salary;
  final String averageRating;
  final int totalRatings;
  final List<HandymanCustomFieldValue> customFields;
  final List<HandymanTranslation> translations;

  const HandymanModel({
    required this.id,
    required this.username,
    required this.phone,
    required this.countryCode,
    required this.email,
    required this.image,
    required this.active,
    required this.isAvailable,
    this.isBusy = 0,
    required this.address,
    this.salary = '',
    this.averageRating = '0',
    this.totalRatings = 0,
    required this.customFields,
    required this.translations,
  });

  bool get isActive => active == 1;
  bool get available => isAvailable == 1;
  bool get busy => isBusy == 1;

  factory HandymanModel.fromJson(Map<String, dynamic> json) {
    return HandymanModel(
      id: json['id']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      countryCode: json['country_code']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      active: int.tryParse(json['active']?.toString() ?? '0') ?? 0,
      isAvailable: int.tryParse(json['is_available']?.toString() ?? '1') ?? 1,
      isBusy: int.tryParse(json['is_busy']?.toString() ?? '0') ?? 0,
      address: json['address']?.toString() ?? '',
      salary: json['salary']?.toString() ?? '',
      averageRating: json['average_rating']?.toString() ?? '0',
      totalRatings: int.tryParse(json['total_ratings']?.toString() ?? '0') ?? 0,
      customFields:
          (json['custom_fields'] as List<dynamic>?)
              ?.map(
                (e) => HandymanCustomFieldValue.fromJson(
                  Map<String, dynamic>.from(e),
                ),
              )
              .toList() ??
          <HandymanCustomFieldValue>[],
      translations:
          (json['translations'] as List<dynamic>?)
              ?.map(
                (e) =>
                    HandymanTranslation.fromJson(Map<String, dynamic>.from(e)),
              )
              .toList() ??
          <HandymanTranslation>[],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'phone': phone,
      'country_code': countryCode,
      'email': email,
      'image': image,
      'active': active,
      'is_available': isAvailable,
      'is_busy': isBusy,
      'address': address,
      'salary': salary,
      'average_rating': averageRating,
      'total_ratings': totalRatings,
      'custom_fields': customFields.map((e) => e.toJson()).toList(),
      'translations': translations.map((e) => e.toJson()).toList(),
    };
  }

  HandymanModel copyWith({
    String? id,
    String? username,
    String? phone,
    String? countryCode,
    String? email,
    String? image,
    int? active,
    int? isAvailable,
    int? isBusy,
    String? address,
    String? salary,
    String? averageRating,
    int? totalRatings,
    List<HandymanCustomFieldValue>? customFields,
    List<HandymanTranslation>? translations,
  }) {
    return HandymanModel(
      id: id ?? this.id,
      username: username ?? this.username,
      phone: phone ?? this.phone,
      countryCode: countryCode ?? this.countryCode,
      email: email ?? this.email,
      image: image ?? this.image,
      active: active ?? this.active,
      isAvailable: isAvailable ?? this.isAvailable,
      isBusy: isBusy ?? this.isBusy,
      address: address ?? this.address,
      salary: salary ?? this.salary,
      averageRating: averageRating ?? this.averageRating,
      totalRatings: totalRatings ?? this.totalRatings,
      customFields: customFields ?? this.customFields,
      translations: translations ?? this.translations,
    );
  }

  /// Username for a given language code, falling back to the default value.
  String usernameForLanguage(String languageCode) {
    for (final t in translations) {
      if (t.languageCode == languageCode && (t.username?.isNotEmpty ?? false)) {
        return t.username!;
      }
    }
    return username;
  }
}

/// A resolved custom field value attached to a handyman.
class HandymanCustomFieldValue {
  final int id;
  final String fieldLabel;
  final String fieldType;
  final String? value;

  const HandymanCustomFieldValue({
    required this.id,
    required this.fieldLabel,
    required this.fieldType,
    required this.value,
  });

  bool get isFile => fieldType == 'file';

  factory HandymanCustomFieldValue.fromJson(Map<String, dynamic> json) {
    return HandymanCustomFieldValue(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      fieldLabel: json['field_label']?.toString() ?? '',
      fieldType: json['field_type']?.toString() ?? 'text',
      value: json['value']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'field_label': fieldLabel,
      'field_type': fieldType,
      'value': value,
    };
  }
}

/// Per-language username translation entry.
class HandymanTranslation {
  final int languageId;
  final String languageCode;
  final String? username;

  const HandymanTranslation({
    required this.languageId,
    required this.languageCode,
    required this.username,
  });

  factory HandymanTranslation.fromJson(Map<String, dynamic> json) {
    return HandymanTranslation(
      languageId: int.tryParse(json['language_id']?.toString() ?? '0') ?? 0,
      languageCode: json['language_code']?.toString() ?? '',
      username: json['username']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'language_id': languageId,
      'language_code': languageCode,
      'username': username,
    };
  }
}

/// Form payload for `store_handyman` / `update_handyman`.
class CreateHandymanModel {
  /// Present only when editing.
  final String? handymanId;

  /// languageCode -> username. The default language entry is required.
  final Map<String, String> usernameByLang;
  final String phone;
  final String countryCode;

  /// Create only. Ignored by update_handyman.
  final String? password;
  final String? email;
  final String? address;

  /// Handyman's salary, sent as `salary`. Omitted when null.
  final String? salary;

  /// 1 = active, 0 = inactive.
  final int status;

  /// Local file path of the chosen profile image. Required on create,
  /// optional on update (omitted keeps existing image).
  final String? profileImagePath;

  /// custom_field_id -> value. For file fields the value is a local file path.
  final Map<String, dynamic> customFieldValues;

  const CreateHandymanModel({
    this.handymanId,
    required this.usernameByLang,
    required this.phone,
    required this.countryCode,
    this.password,
    this.email,
    this.address,
    this.salary,
    this.status = 1,
    this.profileImagePath,
    this.customFieldValues = const {},
  });

  bool get isEditing => handymanId != null && handymanId!.isNotEmpty;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (isEditing) {
      data['handyman_id'] = handymanId;
    }

    // Username: flat string when single language, otherwise username[<lang>].
    if (usernameByLang.length == 1) {
      data['username'] = usernameByLang.values.first;
    } else {
      usernameByLang.forEach((lang, value) {
        if (value.trim().isNotEmpty) {
          data['username[$lang]'] = value;
        }
      });
    }

    data['phone'] = phone;
    data['country_code'] = countryCode;
    if (password != null && password!.isNotEmpty) {
      data['password'] = password;
    }
    if (email != null) data['email'] = email;
    if (address != null) data['address'] = address;
    if (salary != null) data['salary'] = salary;
    data['status'] = status;

    if (profileImagePath != null && profileImagePath!.isNotEmpty) {
      data['profile_image'] = profileImagePath;
    }

    customFieldValues.forEach((id, value) {
      if (value != null && value.toString().trim().isNotEmpty) {
        data['cf_$id'] = value;
      }
    });

    return data;
  }
}
