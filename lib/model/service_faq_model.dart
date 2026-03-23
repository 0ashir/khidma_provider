class ServiceFaqModel {
  int? id;
  int? serviceId;
  String? question;
  String? answer;
  String? createdAt;
  String? updatedAt;

  ServiceFaqModel(
      {this.id,
      this.serviceId,
      this.question,
      this.answer,
      this.createdAt,
      this.updatedAt});

  ServiceFaqModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceId = json['service_id'];
    question = json['question'];
    answer = json['answer'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['service_id'] = serviceId;
    data['question'] = question;
    data['answer'] = answer;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
