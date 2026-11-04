import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:edemand_partner/data/model/chat/chatNotificationData.dart';
import 'package:edemand_partner/data/model/chat/chatUser.dart';
import 'package:edemand_partner/data/repository/chat/chatNotificationRepository.dart';
import 'package:edemand_partner/utils/notification/awsomeNotification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class ChatNotificationsUtils {
  static int? currentChattingUserHashCode;

  static StreamController<ChatNotificationData>? notificationStreamController;

  static Future<void> initialize() async {
    //remove old data when initializing to remove terminated state data
    ChatNotificationsRepository().setBackgroundChatNotificationData(data: []);
    notificationStreamController = StreamController.broadcast();
  }

  static void dispose() {
    notificationStreamController?.close();
    notificationStreamController = null;
  }

  //foreground chat notification handler
  static void addChatStreamAndShowNotification({
    required RemoteMessage message,
  }) {
    final chatNotification = ChatNotificationData.fromRemoteMessage(
      remoteMessage: message,
    );

    notificationStreamController?.add(chatNotification);
    if (currentChattingUserHashCode != chatNotification.fromUser.hashCode &&
        Platform.isAndroid) {
      createChatNotification(chatData: chatNotification, message: message);
    }
  }

  static void addChatStreamValue({required ChatNotificationData chatData}) {
    notificationStreamController?.add(chatData);
  }

  static Future<void> createChatNotification({
    required ChatNotificationData chatData,
    required RemoteMessage message,
  }) async {
    String title = '';
    String body = '';
    if (message.notification != null) {
      title = message.notification?.title ?? '';
      body = message.notification?.body ?? '';
    } else {
      title = message.data["title"] ?? '';
      body = message.data["body"] ?? '';
    }

    LocalAwesomeNotification.notification.createNotification(
      content: NotificationContent(
        id: Random().nextInt(5000),
        groupKey: chatData.fromUser.hashCode.toString(),
        autoDismissible: true,
        title: chatData.fromUser.chatUserType != ChatUserType.providerBooking
            ? chatData.fromUser.userName
            : "${chatData.fromUser.userName} (Booking: ${chatData.fromUser.bookingId})",
        body: body,
        locked: false,
        wakeUpScreen: true,
        largeIcon: chatData.fromUser.image,
        payload: Map.from(message.data),
        channelKey: "chat_notification",
        summary: title,
        notificationLayout: NotificationLayout.Messaging,
        category: NotificationCategory.Message,
      ),
    );
  }
}
