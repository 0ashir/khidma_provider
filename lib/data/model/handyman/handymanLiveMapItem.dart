class HandymanLiveMapItem {
  final String orderId;
  final double latitude;
  final double longitude;
  final String updatedAt;
  final String handymanId;
  final String handymanName;
  final String handymanImage;
  final String averageRating;
  final int totalReviews;

  const HandymanLiveMapItem({
    required this.orderId,
    required this.latitude,
    required this.longitude,
    required this.updatedAt,
    required this.handymanId,
    required this.handymanName,
    required this.handymanImage,
    required this.averageRating,
    required this.totalReviews,
  });

  factory HandymanLiveMapItem.fromJson(Map<String, dynamic> json) {
    return HandymanLiveMapItem(
      orderId: json['order_id']?.toString() ?? '',
      latitude: double.tryParse(json['latitude']?.toString() ?? '') ?? 0.0,
      longitude: double.tryParse(json['longitude']?.toString() ?? '') ?? 0.0,
      updatedAt: json['updated_at']?.toString() ?? '',
      handymanId: json['handyman_id']?.toString() ?? '',
      handymanName: json['handyman_name']?.toString() ?? '',
      handymanImage: json['handyman_image']?.toString() ?? '',
      averageRating: json['average_rating']?.toString() ?? '0',
      totalReviews: int.tryParse(json['total_reviews']?.toString() ?? '') ?? 0,
    );
  }
}
