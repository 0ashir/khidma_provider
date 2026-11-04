class CountryCodeModel {
  final String id;
  final String countryName;
  final String callingCode;
  final String countryCode;
  final String flagImage;
  final String isDefault;
  final String? createdAt;
  final String? updatedAt;

  const CountryCodeModel({
    required this.id,
    required this.countryName,
    required this.callingCode,
    required this.countryCode,
    required this.flagImage,
    required this.isDefault,
    this.createdAt,
    this.updatedAt,
  });

  factory CountryCodeModel.fromJson(Map<String, dynamic> json) {
    return CountryCodeModel(
      id: json['id']?.toString() ?? '',
      countryName: json['country_name']?.toString() ?? '',
      callingCode: json['calling_code']?.toString() ?? '',
      countryCode: json['country_code']?.toString() ?? '',
      flagImage: json['flag_image']?.toString() ?? '',
      isDefault: json['is_default']?.toString() ?? '0',
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  // For backward compatibility with existing code
  String get name => countryName;
  String get flag => flagImage;

  // Check if this is the default country
  bool get isDefaultCountry => isDefault == '1';
}
