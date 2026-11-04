class SeoSettingsData {
  final String title;
  final String description;
  final String keywords;
  final String schemaMarkup;
  final String image;
  final Map<String, Map<String, String>> translations;

  SeoSettingsData({
    required this.title,
    required this.description,
    required this.keywords,
    required this.schemaMarkup,
    required this.image,
    required this.translations,
  });

  factory SeoSettingsData.fromJson(Map<String, dynamic> json) {
    final seo = json['seo'] as Map<String, dynamic>? ?? {};
    final rawTranslations = json['translations'] as Map<String, dynamic>? ?? {};

    final translations = <String, Map<String, String>>{};
    rawTranslations.forEach((langCode, value) {
      if (value is Map<String, dynamic>) {
        translations[langCode] = value.map(
          (k, v) => MapEntry(k, v?.toString() ?? ''),
        );
      }
    });

    return SeoSettingsData(
      title: seo['title']?.toString() ?? '',
      description: seo['description']?.toString() ?? '',
      keywords: seo['keywords']?.toString() ?? '',
      schemaMarkup: seo['schema_markup']?.toString() ?? '',
      image: seo['image']?.toString() ?? '',
      translations: translations,
    );
  }
}
