import 'package:edemand_partner/app/generalImports.dart';

class LocalAwesomeNotification {
  static const String soundNotificationChannel = "soundNotification";
  static const String normalNotificationChannel = "fixit_notifications";
  static String chatNotificationChannel = "chat_notification";

  static AwesomeNotifications notification = AwesomeNotifications();

  static Future<void> init(final BuildContext context) async {
    await initializeChannels();
    await requestPermission();
    await NotificationService.init(context);
    await setupAwesomeNotificationListeners(context);
  }

  static Future<void> initializeChannels() async {
    await notification.initialize('resource://drawable/ic_stat_khidma', [
      NotificationChannel(
        channelKey: soundNotificationChannel,
        channelName: 'Khidma Provider notifications',
        channelDescription: 'Khidma Provider booking and account updates',
        importance: NotificationImportance.High,
        playSound: true,
        soundSource: Platform.isIOS
            ? "callsound.wav"
            : "resource://raw/callsound",
        ledColor: const Color(0xFF5465FF),
      ),
      NotificationChannel(
        channelKey: normalNotificationChannel,
        channelName: 'Khidma Provider notifications',
        channelDescription: 'Khidma Provider booking and account updates',
        importance: NotificationImportance.High,
        playSound: true,
        soundSource: Platform.isIOS
            ? 'notification_sound.aiff'
            : 'resource://raw/notification_sound',
        ledColor: const Color(0xFF5465FF),
      ),
      NotificationChannel(
        channelKey: chatNotificationChannel,
        channelName: "Chat notifications",
        channelDescription: "Notification related to chat",
        vibrationPattern: mediumVibrationPattern,
        importance: NotificationImportance.High,
      ),
    ], channelGroups: []);
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(ReceivedAction event) async {
    if (Platform.isAndroid) {
      final data = event.payload;
      if (data != null) {
        NotificationService.handleNotificationRedirection(data);
      }
    }
  }

  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
    ReceivedNotification receivedNotification,
  ) async {
    // Your code goes here
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
    ReceivedNotification receivedNotification,
  ) async {
    // Your code goes here
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    // Your code goes here
  }

  @pragma('vm:entry-point')
  static Future<void> setupAwesomeNotificationListeners(
    BuildContext context,
  ) async {
    notification.setListeners(
      onActionReceivedMethod: LocalAwesomeNotification.onActionReceivedMethod,
      onNotificationCreatedMethod:
          LocalAwesomeNotification.onNotificationCreatedMethod,
      onNotificationDisplayedMethod:
          LocalAwesomeNotification.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod:
          LocalAwesomeNotification.onDismissActionReceivedMethod,
    );
  }

  Future<void> createNotification({
    required RemoteMessage notificationData,
    required bool isLocked,
    required bool playCustomSound,
  }) async {
    try {
      await notification.createNotification(
        content: NotificationContent(
          id: Random().nextInt(5000),
          title:
              notificationData.data["title"] ??
              notificationData.notification?.title ??
              '',
          locked: isLocked,
          payload: Map.from(notificationData.data),
          body:
              notificationData.data["body"] ??
              notificationData.notification?.body ??
              '',
          color: const Color(0xFF5465FF),
          wakeUpScreen: true,
          channelKey: playCustomSound
              ? soundNotificationChannel
              : normalNotificationChannel,
          notificationLayout: NotificationLayout.BigText,
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createImageNotification({
    required RemoteMessage notificationData,
    required bool isLocked,
    required bool playCustomSound,
  }) async {
    try {
      await notification.createNotification(
        content: NotificationContent(
          id: Random().nextInt(5000),
          title:
              notificationData.data["title"] ??
              notificationData.notification?.title ??
              '',
          locked: isLocked,
          payload: Map.from(notificationData.data),
          autoDismissible: true,
          body:
              notificationData.data["body"] ??
              notificationData.notification?.body ??
              '',
          color: const Color(0xFF5465FF),
          wakeUpScreen: true,
          largeIcon: notificationData.data["image"],
          bigPicture: notificationData.data["image"],
          notificationLayout: NotificationLayout.BigPicture,
          channelKey: playCustomSound
              ? soundNotificationChannel
              : normalNotificationChannel,
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createSoundNotification({
    required RemoteMessage notificationData,
  }) async {
    try {
      notification.createNotification(
        content: NotificationContent(
          id: Random().nextInt(5000),
          title:
              notificationData.data["title"] ??
              notificationData.notification?.title ??
              '',
          locked: false,
          payload: Map.from(notificationData.data),
          body:
              notificationData.data["body"] ??
              notificationData.notification?.body ??
              '',
          color: const Color(0xFF5465FF),
          wakeUpScreen: true,
          largeIcon: notificationData.data["image"],
          bigPicture: notificationData.data["image"],
          notificationLayout: NotificationLayout.BigPicture,
          channelKey: soundNotificationChannel,
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> requestPermission() async {
    final NotificationSettings notificationSettings = await FirebaseMessaging
        .instance
        .getNotificationSettings();

    if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.notDetermined) {
      await FirebaseMessaging.instance.requestPermission();

      if (notificationSettings.authorizationStatus ==
              AuthorizationStatus.authorized ||
          notificationSettings.authorizationStatus ==
              AuthorizationStatus.provisional) {}
    } else if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.denied) {
      return;
    }
  }
}
