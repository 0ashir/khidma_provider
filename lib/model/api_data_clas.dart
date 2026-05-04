class APIDataClass {
  String message;
  bool? isSuccess;
  dynamic data;

  APIDataClass({this.message = "", this.isSuccess, this.data});

  factory APIDataClass.fromJson(Map<String, dynamic> json) {
    return APIDataClass(
        message: json['message'] as String,
        isSuccess: json['isSuccess'] as bool,
        data: json['data'] as dynamic);
  }
}
