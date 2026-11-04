class HandymanBookingServiceItem {
  final String serviceId;
  final String image;
  final String title;
  final int quantity;
  final String price;

  const HandymanBookingServiceItem({
    required this.serviceId,
    required this.image,
    required this.title,
    required this.quantity,
    required this.price,
  });

  factory HandymanBookingServiceItem.fromJson(Map<String, dynamic> json) {
    return HandymanBookingServiceItem(
      serviceId: json['service_id']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      quantity: int.tryParse(json['quantity']?.toString() ?? '') ?? 1,
      price: json['price']?.toString() ?? '',
    );
  }
}
