import 'package:edemand_partner/data/model/chat/chatMessage.dart';

enum ChatUserType { adminSupport, providerBooking, providerEnquiry }

class ChatUser {
  final String customerId;
  final String customerName;
  final String? image;
  final ChatMessage? lastMessage;
  int unReadChats;
  final String? bookingId;
  final String? bookingStatus;
  final String? bookingTranslatedStatus;
  final ChatUserType chatUserType;

  ChatUser({
    required this.customerId,
    required this.customerName,
    required this.image,
    required this.unReadChats,
    required this.chatUserType,
    this.bookingId,
    this.bookingStatus,
    this.bookingTranslatedStatus,
    this.lastMessage,
  });

  int get unreadNotificationsCount => unReadChats;

  bool get hasUnreadMessages => unreadNotificationsCount != 0;

  String get userName => customerName;

  String get avatar => image ?? '';

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    // Determine chat user type
    String? bookingIdStr = json["booking_id"]?.toString();
    if (bookingIdStr == 'null' ||
        bookingIdStr == '0' ||
        bookingIdStr?.isEmpty == true) {
      bookingIdStr = null;
    }

    // A handyman's chat partner is the provider (partner_id/partner_name),
    // while a provider's chat partner is the customer (customer_id/customer_name).
    // Push payloads use whichever shape matches the viewer, so fall back between them.
    String? customerIdStr = (json["customer_id"] ?? json["partner_id"])
        ?.toString();
    if (customerIdStr == 'null' ||
        customerIdStr == '0' ||
        customerIdStr?.isEmpty == true) {
      customerIdStr = null;
    }

    ChatUserType type = ChatUserType.adminSupport;
    if (bookingIdStr != null) {
      type = ChatUserType.providerBooking;
    } else if (customerIdStr != null) {
      type = ChatUserType.providerEnquiry;
    }

    return ChatUser(
      customerId: customerIdStr ?? "0",
      customerName: json["customer_name"] ?? json["partner_name"] ?? '',
      image: json["image"] ?? json["profile_image"] ?? '',
      lastMessage: json['last_message'] != null
          ? ChatMessage.fromJson(json['last_message'])
          : null,
      unReadChats: int.tryParse(json['un_read_chats']?.toString() ?? '0') ?? 0,
      bookingId: bookingIdStr,
      bookingStatus: json["booking_status"] ?? json["order_status"] ?? '',
      bookingTranslatedStatus:
          json["translated_booking_status"] ??
          json["translated_order_status"] ??
          '',
      chatUserType: type,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customer_id': customerId,
      'customer_name': customerName,
      'image': image,
      'last_message': lastMessage?.toJson(),
      'un_read_chats': unReadChats,
      'booking_id': bookingId,
      'booking_status': bookingStatus,
      'translated_booking_status': bookingTranslatedStatus,
      'chat_user_type': chatUserType.name,
    };
  }

  ChatUser copyWith({
    String? customerId,
    String? customerName,
    String? image,
    ChatMessage? lastMessage,
    int? unReadChats,
    String? bookingId,
    String? bookingStatus,
    String? bookingTranslatedStatus,
    ChatUserType? chatUserType,
  }) {
    return ChatUser(
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      image: image ?? this.image,
      lastMessage: lastMessage ?? this.lastMessage,
      unReadChats: unReadChats ?? this.unReadChats,
      bookingId: bookingId ?? this.bookingId,
      bookingStatus: bookingStatus ?? this.bookingStatus,
      bookingTranslatedStatus:
          bookingTranslatedStatus ?? this.bookingTranslatedStatus,
      chatUserType: chatUserType ?? this.chatUserType,
    );
  }

  @override
  bool operator ==(covariant ChatUser other) {
    if (chatUserType != other.chatUserType) {
      return false;
    }

    if (chatUserType == ChatUserType.providerBooking) {
      return bookingId == other.bookingId;
    } else if (chatUserType == ChatUserType.providerEnquiry) {
      return customerId == other.customerId;
    } else if (chatUserType == ChatUserType.adminSupport) {
      return true; // Any admin support is equal to another admin support
    }

    return false;
  }

  @override
  int get hashCode {
    if (chatUserType == ChatUserType.providerBooking) {
      return bookingId.hashCode;
    } else if (chatUserType == ChatUserType.providerEnquiry) {
      return customerId.hashCode;
    } else if (chatUserType == ChatUserType.adminSupport) {
      return chatUserType.hashCode;
    }

    return super.hashCode;
  }
}
