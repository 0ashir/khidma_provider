class CustomPageModel {
  final String id;
  final String slug;
  final String translatedTitle;

  CustomPageModel({
    required this.id,
    required this.slug,
    required this.translatedTitle,
  });

  factory CustomPageModel.fromJson(Map<String, dynamic> json) {
    return CustomPageModel(
      id: json['id']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      translatedTitle: json['translated_title']?.toString() ?? '',
    );
  }
}
