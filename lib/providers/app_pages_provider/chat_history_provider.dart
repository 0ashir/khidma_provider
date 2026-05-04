import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../config.dart';

class ChatHistoryProvider with ChangeNotifier {
  List chatHistory = [];
  AnimationController? animationController;
  List<NotificationModel> notificationList = [];

  //on page init data fetch
  onReady(context) async {
    log("USER :${userModel?.id}");
    if (userModel != null) {
      await FirebaseFirestore.instance
          .collection(collectionName.users)
          .doc(userModel!.id.toString())
          .collection(collectionName.chats)
          .orderBy("updateStamp", descending: true)
          .get()
          .then((value) {
        chatHistory = [];
        if (value.docs.isNotEmpty) {
          chatHistory = value.docs;
          log("value.docs:::${value.docs[0].data()}");
        }

        notifyListeners();
      });
    }
    log("chatHistory ;${chatHistory.length}");
  }

  //clear chat
  onClearChat(context, sync) {
    final value = Provider.of<DeleteDialogProvider>(context, listen: false);

    value.onDeleteDialog(
      sync,
      context,
      eImageAssets.clearChat,
      appFonts.clearChat,
      appFonts.areYouClearChat,
      () async {
        showLoading(context);
        notifyListeners();
        try {
          await FirebaseFirestore.instance
              .collection(collectionName.users)
              .doc(userModel!.id.toString())
              .collection(collectionName.chats)
              .get()
              .then((value) {
            if (value.docs.isNotEmpty) {
              FirebaseFirestore.instance
                  .collection(collectionName.users)
                  .doc(userModel!.id.toString())
                  .collection(collectionName.messages)
                  .doc(value.docs[0].data()['chatId'])
                  .collection(collectionName.chat)
                  .get()
                  .then((v) {
                for (var d in v.docs) {
                  FirebaseFirestore.instance
                      .collection(collectionName.users)
                      .doc(userModel!.id.toString())
                      .collection(collectionName.messages)
                      .doc(value.docs[0].data()['chatId'])
                      .collection(collectionName.chat)
                      .doc(d.id)
                      .delete();
                }
              }).then((a) {
                FirebaseFirestore.instance
                    .collection(collectionName.users)
                    .doc(userModel!.id.toString())
                    .collection(collectionName.chats)
                    .doc(value.docs[0].id)
                    .delete();
              }).then((value) {
                chatHistory = [];
                hideLoading(context);
              });
            }
            hideLoading(context);
            notifyListeners();
          });
        } catch (e) {
          hideLoading(context);
          notifyListeners();
        }

        onReady(context);
        route.pop(context);
        notifyListeners();
        value.onResetPass(
          context,
          language(context, appFonts.hurrayChatDelete),
          language(context, appFonts.okay),
          () => route.pop(context),
        );
      },
    );
    value.notifyListeners();
  }

  //popup menu option selection
  onTapOption(index, context, sync) {
    if (index == 1) {
      onClearChat(context, sync);
      notifyListeners();
    } else {
      onReady(context);
      scaffoldMessage(context, "${language(context, appFonts.refresh)}...");
    }
  }

  //in back animation dispose
  onBack() {
    if (animationController != null) {
      if (!animationController!.isDismissed) {
        animationController!.dispose();
      }
    }
    notifyListeners();
  }

/*  //click on particular chat redirect to chat detail page
  void onChatClick(context, data) {
    log("Chat data: ${data.data()}");

    // Determine sender and receiver names
    String receiverName =
        data['senderId'].toString() == userModel!.id.toString()
            ? data['receiverName'] // Use receiverName if current user is sender
            : data['senderName']; // Use senderName if current user is receiver
    String senderName = data['senderId'].toString() == userModel!.id.toString()
        ? userModel!.name // Current user's name ("pro")
        : data['senderName'];

    // Ensure receiverName is correct
    if (receiverName == userModel!.name) {
      receiverName = data['senderId'].toString() == userModel!.id
          ? data['senderName']
          : data['receiverName'];
    }

    // Determine receiverId
    dynamic receiverId = data['senderId'].toString() == userModel!.id
        ? data['receiverId']
        : data['senderId'];

    // Determine receiverToken
    String? token = data['senderId'].toString() == userModel!.id
        ? data['receiverToken']
        : data['senderToken'];

    // Determine receiverImage
    String? receiverImage = data['senderId'].toString() == userModel!.id
        ? data['receiverImage'] ??
            'default_image_url' // Use receiverImage if current user is sender
        : data['senderImage'] ??
            'default_image_url'; // Use senderImage if current user is receiver

    log(
      "Navigating to chat: senderName=$senderName, receiverName=$receiverName, receiverId=$receiverId, receiverImage=$receiverImage",
    );

    if ((data.data() as Map<String, dynamic>).containsKey('isOffer') &&
        data['role'] != "serviceman") {
      route.pushNamed(
        context,
        routeName.providerChatScreen,
        arg: {
          "image": receiverImage, // Use computed receiverImage
          "name": receiverName, // Should be "thoms"
          "senderName": senderName, // Should be "pro"
          "role": data['role'],
          "phone": data['senderPhone'],
          "code": data['senderCode'],
          if (data.data().containsKey('bookingId'))
            "bookingId": data['bookingId'],

          "chatId": data['chatId'],
          "userId": receiverId,
          "token": token,
        },
      ).then((e) => onReady(context));
    } else {
      Map<String, dynamic> payload = {
        "image": receiverImage,
        "name": receiverName,
        "senderName": senderName,
        "role": data['role'],
        "userId": receiverId,
        "token": token,
        if (data.data().containsKey('bookingId'))
          "bookingId": data['bookingId'],
        if (data.data().containsKey('bookingNumber'))
          "bookingNumber": data['bookingNumber'],
        "chatId": data['chatId'],
      };

      log("💬 Chat Tap Payload => ${jsonEncode(payload)}");
      route.pushNamed(
        context,
        routeName.chat,
        arg: {
          "image": receiverImage, // Use computed receiverImage
          "name": receiverName, // Should be "thoms"
          "senderName": senderName, // Should be "pro"
          "role": data['role'],
          if (data.data().containsKey('bookingId'))
            "bookingId": data['bookingId'],
          "bookingNumber": data['bookingNumber'],
          "chatId": data['chatId'],
          "userId": receiverId,
          "token": token,
        },
      ).then((e) {
        onReady(context);
      });
    }
  }*/

  // void onChatClick(context, data) {
  //   log("Chat data: ${data.data()}");
  //
  //   // Determine sender and receiver names
  //   String receiverName =
  //       data['senderId'].toString() == userModel!.id.toString()
  //           ? data['receiverName'] // Use receiverName if current user is sender
  //           : data['senderName']; // Use senderName if current user is receiver
  //   String senderName = data['senderId'].toString() == userModel!.id.toString()
  //       ? userModel!.name // Current user's name ("pro")
  //       : data['senderName'];
  //
  //   // Ensure receiverName is correct
  //   if (receiverName == userModel!.name) {
  //     // If receiverName is incorrectly set to sender's name, swap it
  //     receiverName = data['senderId'].toString() == userModel!.id
  //         ? data['senderName']
  //         : data['receiverName'];
  //   }
  //
  //   dynamic receiverId = data['senderId'].toString() == userModel!.id
  //       ? data['receiverId']
  //       : data['senderId'];
  //   String? token = data['senderId'].toString() == userModel!.id
  //       ? data['receiverToken']
  //       : data['senderToken'];
  //
  //   log("Navigating to chat: senderName=$senderName, receiverName=$receiverName, receiverId=$receiverId");
  //
  //   if ((data.data() as Map<String, dynamic>).containsKey('isOffer') &&
  //       data['role'] != "serviceman") {
  //     route.pushNamed(context, routeName.providerChatScreen, arg: {
  //       "image": data['receiverImage'],
  //       "name": receiverName, // Should be "thoms"
  //       "senderName": senderName, // Should be "pro"
  //       "role": data['role'],
  //       "phone": data['senderPhone'],
  //       "code": data['senderCode'],
  //       if (data.data().containsKey('bookingId'))
  //         "bookingId": data['bookingId'],
  //       "chatId": data['chatId'],
  //       "userId": receiverId,
  //       "token": token,
  //     }).then((e) => onReady(context));
  //   } else {
  //     route.pushNamed(context, routeName.chat, arg: {
  //       "image": data['receiverImage'],
  //       "name": receiverName, // Should be "thoms"
  //       "senderName": senderName, // Should be "pro"
  //       "role": data['role'],
  //       if (data.data().containsKey('bookingId'))
  //         "bookingId": data['bookingId'],
  //       "chatId": data['chatId'],
  //       "userId": receiverId,
  //       "token": token,
  //     }).then((e) => onReady(context));
  //   }
  // }
  void onChatClick(BuildContext context, QueryDocumentSnapshot data) async {
    try {
      log("Chat data: ${data.data()}");

      // 1. Extract basic chat info
      final isSender = data['senderId'].toString() == userModel!.id.toString();
      final receiverId = isSender ? data['receiverId'] : data['senderId'];
      final receiverName = isSender ? data['receiverName'] : data['senderName'];
      final receiverImage = isSender ? data['receiverImage'] : data['senderImage'];
      final role = data['role'];
      final existingChatId = data['chatId']; // Always use existing chatId

      // 2. Check for booking info in multiple possible fields
      final dataMap = data.data() as Map<String, dynamic>;
      String? bookingId = '';
      if (dataMap.containsKey('bookingId')) {
        bookingId = data['bookingId']?.toString() ?? '';
      } else if (dataMap.containsKey('BookingId')) {
        bookingId = data['BookingId']?.toString() ?? '';
      }

      String? bookingNumber = dataMap.containsKey('bookingNumber')
          ? data['bookingNumber']?.toString() ?? ''
          : '';

      // 3. If this is a booking chat but missing ID, try to find it
      if ((bookingId == null || bookingId.isEmpty) &&
          existingChatId.toString().contains('booking_')) {
        // Extract booking ID from chatId format: "booking_{id}_{user1}_{user2}"
        final parts = existingChatId.split('_');
        if (parts.length > 1) {
          bookingId = parts[1];
        }
      }

      // 4. Get receiver's FCM token (for notifications)
      String? fcmToken;
      if (bookingId != null && bookingId.isNotEmpty) {
        try {
          showLoading(context);
          final response = await apiServices.getApi(
            "${api.booking}/$bookingId",
            [],
            isToken: true,
            isData: true,
          );

          if (response.isSuccess!) {
            final booking = BookingModel.fromJson(response.data);
            Provider.of<ChatProvider>(context, listen: false).booking = booking;

            // Find the serviceman in booking to get their token
            final serviceman = booking.servicemen?.firstWhere(
                  (s) => s.id.toString() == receiverId.toString(),
              orElse: () => ServicemanModel(),
            );

            fcmToken = serviceman?.fcmToken;
          }
        } catch (e) {
          log("Error fetching booking: $e");
        } finally {
          hideLoading(context);
        }
      }

      // 5. Initialize chat with ALL required data
      Provider.of<ChatProvider>(context, listen: false).initializeChat(
        receiverId: receiverId.toString(),
        receiverName: receiverName,
        receiverImage: receiverImage,
        receiverToken: fcmToken ??
            (isSender ? data["receiverToken"] : data["senderToken"]),
        chatId: existingChatId.toString(),
        // Use existing chatId
        bookingId: bookingId,
        bookingNumber: bookingNumber,
      );

      // 6. Determine route and navigate
      final shouldUseProviderChat = dataMap.containsKey('isOffer') && data['role'] != "serviceman";
      final targetRoute = shouldUseProviderChat ? routeName.providerChatScreen : routeName.chat;

      await route.pushNamed(context, targetRoute, arg: {
        "userId": receiverId.toString(),
        "name": receiverName,
        "image": receiverImage,
        "chatId": existingChatId.toString(),
        "token": fcmToken ??
            (isSender ? data["receiverToken"] : data["senderToken"]),
        "bookingId": bookingId,
        "bookingNumber": bookingNumber,
        "role": role
      }).then((e) => onReady(context));
    } catch (e, s) {
      hideLoading(context);
      log("Error in onChatClick: $e//$s");
    }
  }

/*  // void onChatClick(context, data) async {
  //   log("Chat data: ${data.data()}");
  //
  //   String receiverName =
  //       data['senderId'].toString() == userModel!.id.toString()
  //           ? data['receiverName']
  //           : data['senderName'];
  //   String senderName = data['senderId'].toString() == userModel!.id.toString()
  //       ? userModel!.name
  //       : data['senderName'];
  //
  //   if (receiverName == userModel!.name) {
  //     receiverName = data['senderId'].toString() == userModel!.id
  //         ? data['senderName']
  //         : data['receiverName'];
  //   }
  //
  //   dynamic receiverId = data['senderId'].toString() == userModel!.id
  //       ? data['receiverId']
  //       : data['senderId'];
  //
  //   String? fcmToken;
  //
  //   // 🔽 Step 1: If bookingId is present, fetch booking detail first
  //   if (data.data().containsKey('bookingId')) {
  //     String bookingId = data['bookingId'].toString();
  //     try {
  //       showLoading(context); // optional
  //       log("bookingId::${bookingId}");
  //       var value = await apiServices.getApi(
  //         "${api.booking}/$bookingId",
  //         [],
  //         isToken: true,
  //         isData: true,
  //       );
  //
  //       if (value.isSuccess) {
  //         Provider.of<ChatProvider>(context, listen: false).booking =
  //             BookingModel.fromJson(value.data);
  //
  //         // Find serviceman by userId
  //         int index = Provider.of<ChatProvider>(context, listen: false)
  //             .booking!
  //             .servicemen!
  //             .indexWhere(
  //               (element) => element.id.toString() == receiverId.toString(),
  //             );
  //
  //         if (index >= 0) {
  //           fcmToken = Provider.of<ChatProvider>(context, listen: false)
  //               .booking!
  //               .servicemen![index]
  //               .fcmToken;
  //         }
  //       }
  //     } catch (e) {
  //       log("Error fetching booking detail: $e");
  //     } finally {
  //       hideLoading(context); // optional
  //     }
  //   }
  //
  //   // 🔽 Step 2: Navigate
  //   Map<String, dynamic> args = {
  //     "image": data['receiverImage'],
  //     "name": receiverName,
  //     "senderName": senderName,
  //     "role": data['role'],
  //     "userId": receiverId,
  //     "chatId": data['chatId'],
  //     "token": fcmToken ??
  //         (data['senderId'].toString() == userModel!.id.toString()
  //             ? data["receiverToken"]
  //             : data["senderToken"]),
  //   };
  //
  //   if (data.data().containsKey('bookingId')) {
  //     args["bookingId"] = data['bookingId'];
  //   }
  //
  //   route
  //       .pushNamed(
  //         context,
  //         data.data().containsKey('isOffer') && data['role'] != "serviceman"
  //             ? routeName.providerChatScreen
  //             : routeName.chat,
  //         arg: args,
  //       )
  //       .then((e) => onReady(context));
  // }*/
}
