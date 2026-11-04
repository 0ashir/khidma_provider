import '../booking/assignedHandymanModel.dart';

class HandymanBookingListItem {
  final String id;
  final String customer;
  final String customerId;
  final String customerNo;
  final String customerEmail;
  final String profileImage;
  final String address;
  final String dateOfService;
  final String startingTime;
  final String endingTime;
  final String finalTotal;
  final String paymentMethod;
  // order_status comes from orders.status
  final String orderStatus;
  // handyman_status comes from booking_handymen.status
  final String handymanStatus;
  final bool isLead;
  final List<AssignedHandymanModel> assignedHandymen;
  final double? latitude;
  final double? longitude;
  final bool isAtStore;
  final String? transalatedOrderStatus;
  final String? transalatedHandymanStatus;
  final String? invoiceNo;

  /// Symbol saved on the booking (not the global currency); empty → system.
  final String currency;
  final int? currencyDecimalPlaces;

  const HandymanBookingListItem({
    required this.id,
    required this.customer,
    required this.customerId,
    required this.customerNo,
    required this.customerEmail,
    required this.profileImage,
    required this.address,
    required this.dateOfService,
    required this.startingTime,
    required this.endingTime,
    required this.finalTotal,
    required this.paymentMethod,
    required this.orderStatus,
    required this.handymanStatus,
    required this.isLead,
    this.assignedHandymen = const [],
    this.latitude,
    this.longitude,
    required this.isAtStore,
    this.transalatedOrderStatus,
    this.transalatedHandymanStatus,
    this.invoiceNo,
    this.currency = '',
    this.currencyDecimalPlaces,
  });

  factory HandymanBookingListItem.fromJson(Map<String, dynamic> json) {
    final rawHandymen = json['assigned_handymen'];
    final List<AssignedHandymanModel> handymen = rawHandymen is List
        ? rawHandymen
              .map(
                (e) => AssignedHandymanModel.fromJson(
                  Map<String, dynamic>.from(e),
                ),
              )
              .toList()
        : [];
    return HandymanBookingListItem(
      id: json['order_id']?.toString() ?? '',
      customer:
          json['customer_name']?.toString() ??
          json['customer']?.toString() ??
          '',
      customerId: json['customer_id']?.toString() ?? '',
      customerNo:
          json['customer_phone']?.toString() ??
          json['customer_no']?.toString() ??
          '',
      customerEmail: json['customer_email']?.toString() ?? '',
      profileImage: json['profile_image']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      dateOfService: json['date_of_service']?.toString() ?? '',
      startingTime: json['starting_time']?.toString() ?? '',
      endingTime: json['ending_time']?.toString() ?? '',
      finalTotal: json['final_total']?.toString() ?? '',
      paymentMethod: json['payment_method']?.toString() ?? '',
      orderStatus: json['order_status']?.toString() ?? '',
      handymanStatus: json['handyman_status']?.toString() ?? '',
      isLead: json['is_lead'] == true || json['is_lead']?.toString() == '1',
      assignedHandymen: handymen,
      latitude: double.tryParse(json['latitude']?.toString() ?? ''),
      longitude: double.tryParse(json['longitude']?.toString() ?? ''),
      isAtStore:
          json['is_at_store'] == true ||
          json['is_at_store']?.toString() == '1' ||
          json['is_at_store'] == 1,
      transalatedOrderStatus: json['translated_order_status']?.toString() ?? '',
      transalatedHandymanStatus:
          json['translated_handyman_status']?.toString() ?? '',
      invoiceNo: json['invoice_no']?.toString() ?? '',
      currency: json['currency']?.toString() ?? '',
      currencyDecimalPlaces: int.tryParse(
        json['currency_decimal_places']?.toString() ?? '',
      ),
    );
  }

  HandymanBookingListItem copyWith({
    String? handymanStatus,
    String? orderStatus,
    String? transalatedOrderStatus,
    String? transalatedHandymanStatus,
  }) {
    return HandymanBookingListItem(
      id: id,
      customer: customer,
      customerId: customerId,
      customerNo: customerNo,
      customerEmail: customerEmail,
      profileImage: profileImage,
      address: address,
      dateOfService: dateOfService,
      startingTime: startingTime,
      endingTime: endingTime,
      finalTotal: finalTotal,
      paymentMethod: paymentMethod,
      orderStatus: orderStatus ?? this.orderStatus,
      handymanStatus: handymanStatus ?? this.handymanStatus,
      isLead: isLead,
      assignedHandymen: assignedHandymen,
      latitude: latitude,
      longitude: longitude,
      isAtStore: isAtStore,
      transalatedOrderStatus:
          transalatedOrderStatus ?? this.transalatedOrderStatus,
      transalatedHandymanStatus:
          transalatedHandymanStatus ?? this.transalatedHandymanStatus,
      invoiceNo: invoiceNo,
      currency: currency,
      currencyDecimalPlaces: currencyDecimalPlaces,
    );
  }

  bool get isScheduledToday {
    try {
      final date = DateTime.parse(dateOfService);
      final now = DateTime.now();
      return date.year == now.year &&
          date.month == now.month &&
          date.day == now.day;
    } catch (_) {
      return false;
    }
  }
}
