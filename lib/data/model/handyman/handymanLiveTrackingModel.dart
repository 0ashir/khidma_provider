class HandymanLiveTrackingModel {
  final String status;
  final String serverTimestamp;

  const HandymanLiveTrackingModel({
    required this.status,
    required this.serverTimestamp,
  });

  factory HandymanLiveTrackingModel.fromJson(Map<String, dynamic> json) =>
      HandymanLiveTrackingModel(
        status: json['status']?.toString() ?? '',
        serverTimestamp: json['server_timestamp']?.toString() ?? '',
      );

  Map<String, dynamic> toJson() => {
    'status': status,
    'server_timestamp': serverTimestamp,
  };

  bool get isSuccess => status == 'success';
}
