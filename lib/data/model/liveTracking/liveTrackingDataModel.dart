class LiveTrackingDataModel {
  final double? handymanLat;
  final double? handymanLng;
  final double orderLat;
  final double orderLng;

  const LiveTrackingDataModel({
    this.handymanLat,
    this.handymanLng,
    required this.orderLat,
    required this.orderLng,
  });

  bool get hasHandymanLocation => handymanLat != null && handymanLng != null;

  factory LiveTrackingDataModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    final handymanLoc = data['handyman_location'] as Map<String, dynamic>?;
    final orderLoc = data['order_location'] as Map<String, dynamic>;
    return LiveTrackingDataModel(
      handymanLat: handymanLoc != null
          ? double.tryParse(handymanLoc['latitude']?.toString() ?? '')
          : null,
      handymanLng: handymanLoc != null
          ? double.tryParse(handymanLoc['longitude']?.toString() ?? '')
          : null,
      orderLat: double.tryParse(orderLoc['latitude']?.toString() ?? '') ?? 0,
      orderLng: double.tryParse(orderLoc['longitude']?.toString() ?? '') ?? 0,
    );
  }
}
