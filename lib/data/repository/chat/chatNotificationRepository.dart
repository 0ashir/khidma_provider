import 'package:edemand_partner/data/model/chat/chatNotificationData.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatNotificationsRepository {
  String chatNotificationsBackgroundItemKey = "chatNotificationsBackgroundItem";

  Future<void> setBackgroundChatNotificationData({
    required List<ChatNotificationData> data,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    prefs.setStringList(
      chatNotificationsBackgroundItemKey,
      data.map((e) => e.toJson()).toList(),
    );
  }

  Future<List<ChatNotificationData>> getBackgroundChatNotificationData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    return prefs
            .getStringList(chatNotificationsBackgroundItemKey)
            ?.map((e) => ChatNotificationData.fromJson(e))
            .toList() ??
        [];
  }
}
