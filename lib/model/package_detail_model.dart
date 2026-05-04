import '../config.dart';

class PackageDetailModel {
  String? package;
  String? price;
  String? startDate;
  String? endDate;
  String? reqServicemen;
  String? description;
  ProviderList? provider;
  List<IncludedServices>? includedServices;

  PackageDetailModel(
      {this.package,
        this.price,
        this.startDate,
        this.endDate,
        this.reqServicemen,
        this.description,
        this.provider,
        this.includedServices});

  PackageDetailModel.fromJson(Map<String, dynamic> json) {
    package = json['package'];
    price = json['price'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    reqServicemen = json['req_servicemen'];
    description = json['description'];
    provider = json['provider'] != null
        ? ProviderList.fromJson(json['provider'])
        : null;
    if (json['includedServices'] != null) {
      includedServices = <IncludedServices>[];
      json['includedServices'].forEach((v) {
        includedServices!.add(IncludedServices.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['package'] = package;
    data['price'] = price;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['req_servicemen'] = reqServicemen;
    data['description'] = description;
    if (provider != null) {
      data['provider'] = provider!.toJson();
    }
    if (includedServices != null) {
      data['includedServices'] =
          includedServices!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProviderList {
  String? name;
  List<Media>? media;
  String? reviewRating;

  ProviderList({this.name, this.media, this.reviewRating});

  ProviderList.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media!.add(Media.fromJson(v));
      });
    }
    reviewRating = json['reviewRating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    if (media != null) {
      data['media'] = media!.map((v) => v.toJson()).toList();
    }
    data['reviewRating'] = reviewRating;
    return data;
  }
}

class IncludedServices {
  String? title;
  String? price;
  String? reviewRating;
  String? duration;
  String? requiredServicemen;
  String? description;
  List<Media>? media;

  IncludedServices(
      {this.title,
        this.price,
        this.reviewRating,
        this.duration,
        this.requiredServicemen,
        this.description,
        this.media});

  IncludedServices.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    price = json['price'];
    reviewRating = json['reviewRating'];
    duration = json['duration'];
    requiredServicemen = json['requiredServicemen'];
    description = json['description'];
    if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media!.add(Media.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['price'] = price;
    data['reviewRating'] = reviewRating;
    data['duration'] = duration;
    data['requiredServicemen'] = requiredServicemen;
    data['description'] = description;
    if (media != null) {
      data['media'] = media!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
