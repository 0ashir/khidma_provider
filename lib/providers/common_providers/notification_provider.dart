import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import '../../config.dart';
import 'package:http/http.dart' as http;

import '../../helper/navigation_class.dart';

Future<String> downloadAndSaveFile(String url, String fileName) async {
  final Directory directory = await getApplicationDocumentsDirectory();
  final String filePath = '${directory.path}/$fileName';
  final http.Response response = await http.get(Uri.parse(url));
  final File file = File(filePath);
  await file.writeAsBytes(response.bodyBytes);
  return filePath;
}

bool isFlutterLocalNotificationsInitialized = false;

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }

  isFlutterLocalNotificationsInitialized = true;
}

/// Create a [AndroidNotificationChannel] for heads up notifications
AndroidNotificationChannel? channel;

/// Initialize the [FlutterLocalNotificationsPlugin] package.

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class CustomNotificationController {
  AndroidNotificationChannel? channel;

  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotification(context) async {
    debugPrint('initCall');

    //when app in background
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    if (Platform.isIOS) {
      // For iOS, request permissions
      final result = await firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        provisional: true,
        sound: true,
      );
      final bool? result1 = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );

      if (result.authorizationStatus == AuthorizationStatus.authorized) {
        log('FCM: iOS User have granted permission');
        // For handling the received notifications
        await setupListenerCallbacks(context);
      } else {
        log('FCM: iOS User have declined or not accepted permission');
      }
    } else if (Platform.isAndroid) {
      final result = await firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        provisional: true,
        sound: true,
      );
      final bool? result2 = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();

      if (result.authorizationStatus == AuthorizationStatus.authorized) {
        log('FCM: Android User have granted permission');
        // For handling the received notifications
        await setupListenerCallbacks(context);
      } else {
        log('FCM: Android User have declined or not accepted permission');
      }
    } else {
      log("SSSS");
      await setupListenerCallbacks(context);
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool notification = prefs.getBool(session.isNotification) ?? true;

    prefs.setBool(session.isNotification, notification);

    log("initCall :$notification");
    //when app in background
    if (notification) {
      if (!kIsWeb) {
        channel = const AndroidNotificationChannel(
          'fixit_notifications',
          'Fixit Notifications',
          importance: Importance.max,
          playSound: true,
          sound: RawResourceAndroidNotificationSound('notification_sound'),
        );

        await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.createNotificationChannel(channel!);
      }

      //when app is [closed | killed | terminated]
      FirebaseMessaging.instance
          .getInitialMessage()
          .then((RemoteMessage? message) {
        if (message != null) {
          flutterLocalNotificationsPlugin.cancelAll();
          debugPrint("INIIIII:$message");
          showFlutterNotification(message, true, context);
        }
      });

      var initialzationSettingsAndroid =
          const AndroidInitializationSettings('@mipmap/ic_launcher');
      const darwinInitializationSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );
      var initializationSettings = InitializationSettings(
        android: initialzationSettingsAndroid,
        iOS: darwinInitializationSettings,
      );

      flutterLocalNotificationsPlugin.initialize(initializationSettings);

      requestPermissions();
    }
  }

  Future<void> setupListenerCallbacks(context) async {
    //when app in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      showForegroundNotification(message);

      // RemoteNotification notification = message.notification!;
      // log("message::: ${message.data}");
      // log("message::: ${message.notification!.title}");
      // log("message::: ${message.notification!.body}");
      // // showNotification(message);
      // AndroidNotification? android = message.notification?.android;
      //
      // debugPrint("Njdfh :$notification");
      // debugPrint("Njdfh :${message.data["image"]}");
      // if (android != null && !kIsWeb) {
      //   flutterLocalNotificationsPlugin.show(
      //     notification.hashCode,
      //     notification.title,
      //     notification.body,
      //     NotificationDetails(
      //       android: AndroidNotificationDetails(
      //         'default_notification_channel_id',
      //         channel!.name,
      //         channelDescription: channel?.description ?? 'High Importance Notifications',
      //         icon: '@mipmap/ic_launcher',
      //         playSound: true,
      //         importance: Importance.max,
      //         priority: Priority.high,
      //         sound: (message.data['title'] != 'Incoming Audio Call...' ||
      //                 message.data['title'] != 'Incoming Video Call...')
      //             ? null
      //             : const RawResourceAndroidNotificationSound('callsound'),
      //       ),
      //     ),
      //   );
      // }
      // // ignore: unnecessary_null_comparison
      // debugPrint("notification1 : ${message.data}");
      // flutterLocalNotificationsPlugin.cancelAll();
      //
      // showFlutterNotification(message, false, context);
    });

    //when app in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      debugPrint('A new onMessageOpenedApp event was published!');
      debugPrint("onMessageOpenedApp: $message");
      flutterLocalNotificationsPlugin.cancelAll();
      AndroidNotification? android = message.notification?.android;
      if (android != null) {
        showFlutterNotification(message, true, context);
      }
    });
  }

  void showFlutterNotification(RemoteMessage message, isOpen, context) async {
    RemoteNotification? notification = message.notification;
    final isCall = message.data["title"] == "Incoming Video Call..." ||
        message.data["title"] == "Incoming Audio Call...";

    flutterLocalNotificationsPlugin.show(
      message.notification.hashCode,
      message.notification!.title,
      message.notification!.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'fixit_notifications',
          'Fixit Notifications',
          channelDescription: 'Fixit Notifications',
          playSound: true,
          importance: Importance.max,
          priority: Priority.high,
          sound: isCall
              ? const RawResourceAndroidNotificationSound('callsound')
              : const RawResourceAndroidNotificationSound('notification_sound'),
          icon: '@mipmap/ic_launcher',
          fullScreenIntent: true,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          sound: isCall ? 'callsound.wav' : 'notification_sound.aiff',
        ),
      ),
    );
    if (isOpen) {
      if (message.data["type"] == "booking") {
        getBookingDetailById(context, message.data['booking_id']);
      } else if (message.data["type"] == "chat") {
        log("routeName.chat :${message.data}");
        Navigator.pushNamed(
          context,
          routeName.chatHistory,
          arguments: {
            "image": message.data['image'],
            "name": message.data["name"],
            "role": message.data["role"],
            "userId": message.data['pId'],
            "token": message.data['token'],
            "phone": message.data['phone'],
            "code": message.data['code'],
            "bookingId": message.data['bookingId'] ?? "",
          },
        ).then((e) {
          debugPrint("SAVE ");

          saveNotificationApi(context, notification!.body, notification.title,
              message.data['userId'], message.data['image']);

          navigatorKey.currentState!
              .pushNamedAndRemoveUntil(routeName.chatHistory, (route) => false);
        });
      }
    }
    //  log("IKII :${message.data["image"]}");
  }

  requestPermissions() async {
    NotificationSettings settings = await FirebaseMessaging.instance
        .requestPermission(
            announcement: true,
            carPlay: true,
            criticalAlert: true,
            sound: true);
    log("settings.authorizationStatus: ${settings.authorizationStatus}");
  }
}

void showForegroundNotification(RemoteMessage message) async {
  final notification = message.notification;
  if (notification == null) return;

  final imageUrl = message.data["image"] as String?;
  BigPictureStyleInformation? bigPicture;

  if (imageUrl != null && imageUrl.isNotEmpty) {
    try {
      final String filePath = await downloadAndSaveFile(imageUrl, 'big_img.jpg');
      final bigImage = FilePathAndroidBitmap(filePath);
      bigPicture = BigPictureStyleInformation(bigImage,
          contentTitle: notification.title, summaryText: notification.body);
    } catch (_) {}
  }

  flutterLocalNotificationsPlugin.show(
    notification.hashCode,
    notification.title,
    notification.body,
    NotificationDetails(
      android: AndroidNotificationDetails(
        channel?.id ?? 'fixit_notifications',
        channel?.name ?? 'Fixit Notifications',
        channelDescription: channel?.description ?? 'Fixit Notifications',
        icon: '@mipmap/ic_launcher',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        sound: const RawResourceAndroidNotificationSound('notification_sound'),
        styleInformation: bigPicture,
        fullScreenIntent: true,
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        sound: 'notification_sound.aiff',
      ),
    ),
    payload: jsonEncode(message.data),
  );
}

//save notification in database
saveNotificationApi(context, content, title, id, images) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  dynamic userData = pref.getString(session.user);
  userModel = UserModel.fromJson(jsonDecode(userData));
  log("userModel :${userModel}");
  var body = {
    "title": title,
    "message": content,
    "user_id": id,
    "type": "user",
    "images": images
  };
  debugPrint("ASSSIGN BODY : $body");
  try {
    await apiServices
        .postApi(api.saveNotification, body, isToken: true, isData: true)
        .then((value) {
      if (value.isSuccess!) {
        final common = Provider.of<UserDataApiProvider>(context, listen: false);
        common.getNotificationList();
      } else {}
    });
  } catch (e) {
    debugPrint("EEEE saveNotificationApi : $e");
  }
}

//booking detail by id
getBookingDetailById(context, id) async {
  try {
    await apiServices
        .getApi("${api.booking}/$id", [], isToken: true, isData: true)
        .then((value) {
      if (value.isSuccess!) {
        debugPrint("DHRUVU :${value.data}");

        BookingModel bookingModel = BookingModel.fromJson(value.data);
        if (bookingModel.bookingStatus!.slug == translations!.pending) {
          //route.pushNamed(context, routeName.packageBookingScreen);
          Navigator.pushNamed(context, routeName.pendingBooking,
                  arguments: bookingModel.id)
              .then((e) {
            navigatorKey.currentState!.pushNamedAndRemoveUntil(
                routeName.chatHistory, (route) => false);
          });
        } else if (bookingModel.bookingStatus!.slug == translations!.accepted) {
          if (isFreelancer) {
            Navigator.pushNamed(context, routeName.assignBooking,
                    arguments: bookingModel.id)
                .then((e) {
              navigatorKey.currentState!.pushNamedAndRemoveUntil(
                  routeName.chatHistory, (route) => false);
            }).then((e) {
              navigatorKey.currentState!.pushNamedAndRemoveUntil(
                  routeName.chatHistory, (route) => false);
            });
          } else {
            Navigator.pushNamed(context, routeName.acceptedBooking,
                    arguments: bookingModel.id)
                .then((e) {
              navigatorKey.currentState!.pushNamedAndRemoveUntil(
                  routeName.chatHistory, (route) => false);
            });
          }
          /* {"amount": "0", "assign_me": bookingModel.providerId.toString() == userModel!.id.toString()? true: false}*/
        } else if (bookingModel.bookingStatus!.slug ==
            translations!.pendingApproval) {
          Navigator.pushNamed(context, routeName.pendingApprovalBooking,
                  arguments: bookingModel.id)
              .then((e) {
            navigatorKey.currentState!.pushNamedAndRemoveUntil(
                routeName.chatHistory, (route) => false);
          });
        } else if (bookingModel.bookingStatus!.slug == translations!.hold) {
          Navigator.pushNamed(context, routeName.holdBooking,
                  arguments: bookingModel.id)
              .then((e) {
            navigatorKey.currentState!.pushNamedAndRemoveUntil(
                routeName.chatHistory, (route) => false);
          });
        } else if (bookingModel.bookingStatus!.slug == translations!.hold) {
          Navigator.pushNamed(context, routeName.holdBooking,
                  arguments: bookingModel.id)
              .then((e) {
            navigatorKey.currentState!.pushNamedAndRemoveUntil(
                routeName.chatHistory, (route) => false);
          });
        } else if (bookingModel.bookingStatus!.slug ==
                appFonts.onGoing.toLowerCase() ||
            bookingModel.bookingStatus!.slug == appFonts.ontheway ||
            bookingModel.bookingStatus!.slug == appFonts.startAgain ||
            bookingModel.bookingStatus!.slug == appFonts.onHold) {
          Navigator.pushNamed(context, routeName.ongoingBooking,
                  arguments: bookingModel.id)
              .then((e) {
            navigatorKey.currentState!.pushNamedAndRemoveUntil(
                routeName.chatHistory, (route) => false);
          });
        } else if (bookingModel.bookingStatus!.slug ==
            translations!.completed) {
          Navigator.pushNamed(context, routeName.completedBooking,
                  arguments: bookingModel.id)
              .then((e) {
            navigatorKey.currentState!.pushNamedAndRemoveUntil(
                routeName.chatHistory, (route) => false);
          });
        } else if (bookingModel.bookingStatus!.slug == translations!.assigned) {
          Navigator.pushNamed(context, routeName.assignBooking,
                  arguments: bookingModel.id)
              .then((e) {
            navigatorKey.currentState!.pushNamedAndRemoveUntil(
                routeName.chatHistory, (route) => false);
          });
        } else if (bookingModel.bookingStatus!.slug == translations!.cancel) {
          Navigator.pushNamed(context, routeName.cancelledBooking,
                  arguments: bookingModel.id)
              .then((e) {
            navigatorKey.currentState!.pushNamedAndRemoveUntil(
                routeName.chatHistory, (route) => false);
          });
        }
      } else {}
    });
  } catch (e) {}
}

showNotification(RemoteMessage remote) async {
  final String title = remote.notification?.title ?? remote.data['title'] ?? "";
  final String message = remote.notification?.body ?? remote.data['body'] ?? "";
  final bool isCall = remote.data['title'] == 'Incoming Audio Call...' ||
      remote.data['title'] == 'Incoming Video Call...';

  flutterLocalNotificationsPlugin.show(
    0,
    title,
    message,
    NotificationDetails(
      android: AndroidNotificationDetails(
        'fixit_notifications',
        'Fixit Notifications',
        channelDescription: 'Fixit Notifications',
        icon: '@mipmap/ic_launcher',
        playSound: true,
        importance: Importance.max,
        priority: Priority.high,
        sound: isCall
            ? const RawResourceAndroidNotificationSound('callsound')
            : const RawResourceAndroidNotificationSound('notification_sound'),
        fullScreenIntent: true,
      ),
      iOS: DarwinNotificationDetails(
        presentSound: true,
        sound: isCall ? 'callsound.wav' : 'notification_sound.aiff',
      ),
    ),
    payload: remote.data.toString(),
  );
}
