import '../config.dart';

class CommissionInfoModel {
  String? title;
  String? commission;
  List<Media>? media;

  CommissionInfoModel({this.title, this.commission, this.media});

  CommissionInfoModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    commission = json['commission'];
    if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media!.add( Media.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['commission'] = commission;
    if (media != null) {
      data['media'] = media!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
