class TotalEarningModel {
  double? totalEarnings;
  List<CategoryEarnings>? categoryEarnings;

  TotalEarningModel({this.totalEarnings, this.categoryEarnings});

  TotalEarningModel.fromJson(Map<String, dynamic> json) {
    totalEarnings = double.parse(json['total_earnings'].toString());
    if (json['category_earnings'] != null) {
      categoryEarnings = <CategoryEarnings>[];
      json['category_earnings'].forEach((v) {
        categoryEarnings!.add(CategoryEarnings.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_earnings'] = totalEarnings;
    if (categoryEarnings != null) {
      data['category_earnings'] =
          categoryEarnings!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CategoryEarnings {
  String? categoryName;
  double? percentage;

  CategoryEarnings({this.categoryName, this.percentage});

  CategoryEarnings.fromJson(Map<String, dynamic> json) {
    categoryName = json['category_name'];
    percentage = json['percentage'] != null
        ? double.parse(json['percentage'].toString())
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category_name'] = categoryName;
    data['percentage'] = percentage;
    return data;
  }
}
