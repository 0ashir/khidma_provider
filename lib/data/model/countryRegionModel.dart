class CountryModel {
  const CountryModel({required this.id, required this.name, this.flag});

  final String id;
  final String name;
  final String? flag;

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      flag: json['flag']?.toString(),
    );
  }
}

class RegionModel {
  const RegionModel({required this.id, required this.name});

  final String id;
  final String name;

  factory RegionModel.fromJson(Map<String, dynamic> json) {
    return RegionModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }
}
