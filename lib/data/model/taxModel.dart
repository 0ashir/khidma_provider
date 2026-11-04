class Taxes {
  Taxes({this.id, this.title, this.percentage, this.translatedTitle});

  factory Taxes.fromJson(Map<String, dynamic> json) {
    return Taxes(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      translatedTitle: json['translated_title']?.toString().isEmpty ?? true
          ? null
          : json['translated_title'].toString(),
      percentage: json['percentage']?.toString() ?? '',
    );
  }

  final String? id;
  final String? title;
  final String? percentage;
  final String? translatedTitle;

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'percentage': percentage,
    'translated_title': translatedTitle,
  };
}
