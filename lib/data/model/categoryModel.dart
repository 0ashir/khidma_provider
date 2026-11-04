class CategoryModel {
  CategoryModel({
    this.id,
    this.name,
    this.translatedName,
    this.categoryImage,
    this.status,
    this.subCategories,
  });

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString() ?? '';
    name = json['name']?.toString() ?? '';
    translatedName = (json['translated_name']?.toString() ?? '').isNotEmpty
        ? json['translated_name'].toString()
        : name;
    categoryImage = json['image']?.toString() ?? '';
    status = json['status']?.toString() ?? '0';
    subCategories = (json['children'] as List?)
        ?.map((e) => CategoryModel.fromJson(Map.from(e)))
        .toList();
  }
  String? id;
  String? name;
  String? translatedName;
  String? categoryImage;
  String? status;
  List<CategoryModel>? subCategories;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['translated_name'] = translatedName;
    data['category_image'] = categoryImage;
    data['status'] = status;
    data['children'] = subCategories?.map((e) => e.toJson()).toList();
    return data;
  }
}
