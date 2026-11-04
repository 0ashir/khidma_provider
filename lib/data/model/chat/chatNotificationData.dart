import 'dart:convert';

import 'package:edemand_partner/data/model/chat/chatMessage.dart';
import 'package:edemand_partner/data/model/chat/chatUser.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/*
this is a general data model to get data of chat message or user when a notification arrives
this model is not connected to any API response
it's internally used, currently used to stream it's instances when a chat notification arrives
also useful to get data of notifications that came while in background
*/
class ChatNotificationData {
  ChatMessage receivedMessage;
  ChatUser fromUser;
  ChatNotificationData(this.receivedMessage, this.fromUser);

  factory ChatNotificationData.fromRemoteMessage({
    required RemoteMessage remoteMessage,
  }) {
    final data = remoteMessage.data;
    final receivedMessage = ChatMessage.fromJson(
      jsonDecode(data['chat_message'].toString()) ?? {},
    );

    final String? fallbackBookingId = (data['booking_id'] ?? data['bookingId'])
        ?.toString();
    final bool hasTopLevelBookingId =
        fallbackBookingId != null &&
        fallbackBookingId.isNotEmpty &&
        fallbackBookingId != '0';

    final ChatUser fromUser = !(data['chat_user']?.isEmpty ?? true)
        ? ChatUser.fromJson(jsonDecode(data['chat_user'].toString()) ?? {})
        : hasTopLevelBookingId
        ? ChatUser.fromJson({
            'booking_id': fallbackBookingId,
            'customer_id': data['sender_id'] ?? data['senderId'],
            'customer_name': receivedMessage.senderDetails.name,
            'image': receivedMessage.senderDetails.profileImage.isNotEmpty
                ? receivedMessage.senderDetails.profileImage
                : receivedMessage.senderDetails.profile,
          })
        : ChatUser(
            customerId: '0',
            customerName: "customerSupport",
            unReadChats: 0,
            bookingId: null,
            chatUserType: ChatUserType.adminSupport,
            image: '',
          );

    return ChatNotificationData(receivedMessage, fromUser);
  }

  ChatNotificationData copyWith({
    ChatMessage? receivedMessage,
    ChatUser? fromUser,
  }) {
    return ChatNotificationData(
      receivedMessage ?? this.receivedMessage,
      fromUser ?? this.fromUser,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'chat_message': receivedMessage.toJson(),
      'chat_user': fromUser.toJson(),
    };
  }

  factory ChatNotificationData.fromMap(Map<String, dynamic> map) {
    return ChatNotificationData(
      ChatMessage.fromJson(map['chat_message'] as Map<String, dynamic>),
      ChatUser.fromJson(map['chat_user'] as Map<String, dynamic>),
    );
  }

  String toJson() {
    return json.encode(toMap());
  }

  factory ChatNotificationData.fromJson(String source) =>
      ChatNotificationData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ChatNotificationData(receivedMessage: $receivedMessage, fromUser: $fromUser)';
}
