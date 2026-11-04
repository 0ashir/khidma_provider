class ServiceCategoryModel {
  ServiceCategoryModel({
    this.id,
    this.name,
    this.translatedName,
    this.categoryImage,
    this.subCategories,
  });

  ServiceCategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString() ?? '';
    name = json['name']?.toString() ?? '';
    translatedName = json['translated_name']?.toString() ?? '';
    categoryImage = json['image']?.toString() ?? '';
    subCategories = (json['children'] as List?)
        ?.map((final e) => ServiceCategoryModel.fromJson(Map.from(e)))
        .toList();
  }
  String? id;
  String? name;
  String? translatedName;
  String? categoryImage;
  List<ServiceCategoryModel>? subCategories;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['translated_name'] = translatedName;
    data['category_image'] = categoryImage;
    data['sub_categories'] = subCategories;
    return data;
  }
}
