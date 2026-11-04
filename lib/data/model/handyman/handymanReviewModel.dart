class HandymanReviewModel {
  final String id;
  final String orderId;
  final String userId;
  final double rating;
  final String review;
  final List<String> images;
  final String createdAt;
  final String customerName;
  final String customerImage;

  const HandymanReviewModel({
    required this.id,
    required this.orderId,
    required this.userId,
    required this.rating,
    required this.review,
    required this.images,
    required this.createdAt,
    required this.customerName,
    required this.customerImage,
  });

  factory HandymanReviewModel.fromJson(Map<String, dynamic> json) =>
      HandymanReviewModel(
        id: json['id']?.toString() ?? '',
        orderId: json['order_id']?.toString() ?? '',
        userId: json['user_id']?.toString() ?? '',
        rating: double.tryParse(json['rating']?.toString() ?? '0') ?? 0,
        review: json['review']?.toString() ?? '',
        images: List<String>.from(json['images'] as List? ?? []),
        createdAt: json['created_at']?.toString() ?? '',
        customerName: json['customer_name']?.toString() ?? '',
        customerImage: json['customer_image']?.toString() ?? '',
      );
}
