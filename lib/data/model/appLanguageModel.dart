class AppLanguage {
  const AppLanguage({
    this.languageCode = "",
    this.languageName = "",
    this.imageURL = "",
    this.id,
    this.isRtl,
    this.isDefault = false,
    this.updatedAt,
  });

  final String languageName;
  final String languageCode;
  final String imageURL;
  final String? id;
  final String? isRtl;
  final bool isDefault;
  final String? updatedAt;

  factory AppLanguage.fromJson(
    Map<String, dynamic> json, {
    bool isDefault = false,
  }) {
    return AppLanguage(
      id: json['id']?.toString(),
      languageCode: json['code']?.toString() ?? "",
      languageName: (json['language'] ?? json['name'])?.toString() ?? "",
      imageURL: json['image']?.toString() ?? "",
      isRtl: json['is_rtl']?.toString(),
      isDefault: isDefault,
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'language': languageName,
      'code': languageCode,
      'is_rtl': isRtl,
      'image': imageURL,
      'is_default': isDefault,
      'updated_at': updatedAt,
    };
  }

  AppLanguage copyWith({
    String? id,
    String? languageName,
    String? languageCode,
    String? imageURL,
    String? isRtl,
    bool? isDefault,
    String? updatedAt,
  }) {
    return AppLanguage(
      id: id ?? this.id,
      languageName: languageName ?? this.languageName,
      languageCode: languageCode ?? this.languageCode,
      imageURL: imageURL ?? this.imageURL,
      isRtl: isRtl ?? this.isRtl,
      isDefault: isDefault ?? this.isDefault,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class LanguageListModel {
  LanguageListModel({this.languageList, this.defaultLanguage});

  List<AppLanguage>? languageList;
  AppLanguage? defaultLanguage;

  LanguageListModel.fromJson(Map<String, dynamic> json) {
    AppLanguage? defaultLang;

    if (json['data'] != null) {
      languageList = <AppLanguage>[];
      for (var v in json['data']) {
        final lang = AppLanguage.fromJson(v);
        languageList!.add(lang);

        if (json['default_language'] != null &&
            json['default_language'] is Map &&
            json['default_language']['code']?.toString() ==
                v['code']?.toString()) {
          defaultLang = lang.copyWith(isDefault: true);
        }
      }
    }

    if (defaultLang == null &&
        json['default_language'] != null &&
        json['default_language'] is Map) {
      defaultLang = AppLanguage.fromJson(
        json['default_language'],
        isDefault: true,
      );
    }

    defaultLanguage = defaultLang;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (languageList != null) {
      data['data'] = languageList!.map((v) => v.toJson()).toList();
    }
    if (defaultLanguage != null) {
      data['default_language'] = defaultLanguage!.toJson();
    }
    return data;
  }
}
