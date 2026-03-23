class ProfileModel {
  String? title;
  List<Data>? data;

  ProfileModel({this.title, this.data});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? icon;
  String? title;
  bool? isArrow;

  Data({this.icon, this.title, this.isArrow});

  Data.fromJson(Map<String, dynamic> json) {
    icon = json['icon'];
    title = json['title'];
    isArrow = json['isArrow'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['icon'] = icon;
    data['title'] = title;
    data['isArrow'] = isArrow;
    return data;
  }
}
