class NotificationDataModel {
  static bool isSubscriptionType(String? type) =>
      type?.toLowerCase().startsWith('subscription_') ?? false;

  bool get isSubscription => isSubscriptionType(type);

  String? id;
  String? title;
  String? message;
  String? type;
  String? typeId;
  String? image;
  String? orderId;
  String? isRead;
  String? url;
  DateTime dateSent;
  String? duration;
  String? customJobRequestId;

  NotificationDataModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.typeId,
    required this.image,
    required this.orderId,
    required this.isRead,
    required this.url,
    required this.dateSent,
    required this.duration,
    this.customJobRequestId,
  });

  factory NotificationDataModel.fromJson(final Map<String, dynamic> map) =>
      NotificationDataModel(
        id: map["id"]?.toString() ?? '',
        title: map["title"]?.toString() ?? '',
        message: map["message"]?.toString() ?? '',
        type: map["type"]?.toString() ?? '',
        typeId: map["type_id"]?.toString() ?? '',
        image: map["image"]?.toString() ?? '',
        orderId: map["order_id"]?.toString() ?? '',
        url: map["url"]?.toString() ?? '',
        isRead: map["is_readed"]?.toString() ?? '',
        dateSent: DateTime.parse(map["date_sent"]?.toString() ?? ''),
        duration: map["duration"]?.toString() ?? '',
        customJobRequestId: map["custom_job_request_id"]?.toString(),
      );

  /// Converts this notification model to the data map format
  /// expected by NotificationService.handleNotificationRedirection()
  Map<String, dynamic> toRedirectionData() => {
    'type': type ?? '',
    'type_id': typeId ?? '',
    'order_id': orderId ?? '',
    'booking_id': orderId ?? '',
    'url': url ?? '',
    'body': message ?? '',
    'title': title ?? '',
    'service_id': typeId ?? '',
    'custom_job_request_id': customJobRequestId ?? typeId ?? '',
  };

  /// Returns true if this notification type supports navigation
  /// and should show an arrow indicator
  bool get isNavigable {
    if (type == null || type!.isEmpty) return false;

    final String lowerType = type!.toLowerCase();

    // Types that have navigation in the provider app
    // Note: 'general' and 'personal' are NOT navigable from notifications screen
    // as they redirect to notifications screen itself (only useful for push notifications)
    return lowerType == 'order' ||
        lowerType == 'booking_status' ||
        lowerType == 'new_booking_received_for_provider' ||
        lowerType == 'url' ||
        lowerType == 'chat' ||
        lowerType == 'new_message' ||
        lowerType == 'user_reported' ||
        lowerType == 'user_blocked' ||
        lowerType == 'withdraw_request' ||
        lowerType == 'withdraw_request_approved' ||
        lowerType == 'withdraw_request_disapproved' ||
        lowerType == 'payment_settlement' ||
        lowerType == 'provider_request_status' ||
        lowerType == 'provider_approved' ||
        lowerType == 'provider_disapproved' ||
        lowerType == 'service_approved' ||
        lowerType == 'service_disapproved' ||
        lowerType == 'new_rating_given_by_customer' ||
        lowerType == 'cash_collection_by_provider' ||
        lowerType == 'new_custom_job_request' ||
        lowerType == 'job_notification' ||
        lowerType == 'new_category_available' ||
        lowerType == 'category_removed' ||
        lowerType == 'promo_code_added' ||
        lowerType == 'subscription_expired' ||
        lowerType == 'subscription_payment_successful' ||
        lowerType == 'subscription_payment_failed' ||
        lowerType == 'subscription_payment_pending' ||
        lowerType == 'subscription_changed' ||
        lowerType == 'subscription_removed' ||
        lowerType == 'privacy_policy_changed' ||
        lowerType == 'terms_and_conditions_changed';
  }
}
