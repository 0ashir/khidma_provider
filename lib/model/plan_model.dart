class PlanModel {
  String? price;
  String? type;
  String? planType;
  List<String>? benefits;

  PlanModel({this.price, this.type, this.planType, this.benefits});

  PlanModel.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    type = json['type'];
    planType = json['plan_type'];
    benefits = json['benefits'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['price'] = price;
    data['type'] = type;
    data['plan_type'] = planType;
    data['benefits'] = benefits;
    return data;
  }
}
