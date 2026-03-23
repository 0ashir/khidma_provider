import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:googleapis_auth/auth_io.dart';

import '../config.dart';
import '../providers/app_pages_provider/offer_chat_provider.dart';

class FirebaseApi {
  //save chat in firebase
  Future saveMessageByBooking({
    newChatId,
    pId,
    encrypted,
    MessageType? type,
    dateTime,
    senderId,
    collectionId,
    receiverName,
    receiverImage,
    isSeen = false,
    role,
    bookingNumber,
    bookingId,
  }) async {
    log("bookingId :$bookingId");
    await FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc(senderId.toString())
        .collection(collectionName.chatWith)
        .doc(collectionId.toString())
        .collection(collectionName.booking)
        .doc(bookingId.toString())
        .collection(collectionName.chat)
        .doc(dateTime)
        .set({
      'senderId': userModel!.id,
      'receiverId': pId,
      'content': encrypted,
      "chatId": newChatId,
      'type': type!.name,
      'messageType': "sender",
      "isSeen": isSeen,
      'timestamp': dateTime,
      'senderName': userModel!.name,
      'receiverName': receiverName,
      'bookingId': bookingId,
      'bookingNumber': bookingNumber,
      'role': role,
      'receiverImage': receiverImage,
      'senderImage': userModel!.media != null && userModel!.media!.isNotEmpty
          ? userModel!.media![0].originalUrl!
          : "",
    }, SetOptions(merge: true));
  }

  //save message in user
  saveMessageInUserCollectionByBooking({
    id,
    receiverId,
    newChatId,
    content,
    senderId,
    receiverName,
    receiverImage,
    sToken,
    rToken,
    MessageType? type,
    bookingId,
    bookingNumber,
    role,
  }) async {
    await FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc(id.toString())
        .collection(collectionName.chats)
        .where("chatId", isEqualTo: newChatId)
        .get()
        .then((value) async {
      if (value.docs.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection(collectionName.users)
            .doc(id.toString())
            .collection(collectionName.chats)
            .doc(value.docs[0].id)
            .update({
          "updateStamp": DateTime.now().millisecondsSinceEpoch.toString(),
          "lastMessage": content,
          "senderId": senderId,
          "messageType": type!.name,
          "chatId": newChatId,
          "bookingId": bookingId,
          "bookingNumber": bookingNumber,
          "isSeen": false,
          "senderName": userModel!.name,
          "senderImage":
              userModel!.media != null && userModel!.media!.isNotEmpty
                  ? userModel!.media![0].originalUrl!
                  : null,
          "receiverName": receiverName,
          "receiverImage": receiverImage,
          "receiverToken": rToken,
          "senderToken": sToken,
          "receiverId": receiverId,
          "type": type.name,
          "role": role,
        }).then((value) {});
      } else {
        await FirebaseFirestore.instance
            .collection(collectionName.users)
            .doc(id.toString())
            .collection(collectionName.chats)
            .add({
          "updateStamp": DateTime.now().millisecondsSinceEpoch.toString(),
          "lastMessage": content,
          "senderId": senderId,
          "messageType": type!.name,
          "chatId": newChatId,
          "isSeen": false,
          "senderName": userModel!.name,
          "receiverToken": rToken,
          "senderToken": sToken,
          "bookingId": bookingId,
          "bookingNumber": bookingNumber,
          "senderImage":
              userModel!.media != null && userModel!.media!.isNotEmpty
                  ? userModel!.media![0].originalUrl!
                  : null,
          "receiverName": receiverName,
          "receiverImage": receiverImage,
          "receiverId": receiverId,
          "type": type.name,
          "role": role,
        }).then((value) {});
      }
    }).then((value) {});
  }

  Future saveMessageByOffer({
    newChatId,
    pId,
    encrypted,
    MessageType? type,
    dateTime,
    senderId,
    receiverName,
    receiverImage,
    isSeen = false,
    role,
    offer,
  }) async {
    await FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc(senderId.toString())
        .collection(collectionName.messages)
        .doc(newChatId)
        .collection(collectionName.chat)
        .doc(dateTime)
        .set({
      'senderId': userModel!.id,
      'receiverId': pId,
      'content': encrypted,
      "chatId": newChatId,
      'type': type!.name,
      'messageType': "sender",
      "isSeen": isSeen,
      'timestamp': dateTime,
      'senderName': userModel!.name,
      'receiverName': receiverName,
      'role': role,
      'receiverImage': receiverImage,
      'senderImage': userModel!.media != null && userModel!.media!.isNotEmpty
          ? userModel!.media![0].originalUrl!
          : "",
    }, SetOptions(merge: true));
  }

  Future saveMessage({
    newChatId,
    pId,
    encrypted,
    MessageType? type,
    dateTime,
    senderId,
    bookingNumber,
    receiverName,
    receiverImage,
    isSeen = false,
    role,
  }) async {
    log("=== saveMessage CALLED ===");
    log("chatId: $newChatId");
    log("senderId: $senderId");
    log("receiverId (pId): $pId");
    log("Path: /users/$senderId/messages/$newChatId/chat/$dateTime");
    
    await FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc(senderId.toString())
        .collection(collectionName.messages)
        .doc(newChatId)
        .collection(collectionName.chat)
        .doc(dateTime)
        .set({
      'senderId': userModel!.id,
      'receiverId': pId,
      'content': encrypted,
      "chatId": newChatId,
      'type': type!.name,
      'bookingNumber': bookingNumber,
      'messageType': "sender",
      "isSeen": isSeen,
      'timestamp': dateTime,
      'senderName': userModel!.name,
      'receiverName': receiverName,
      'role': role,
      'receiverImage': receiverImage,
      'senderImage': userModel!.media != null && userModel!.media!.isNotEmpty
          ? userModel!.media![0].originalUrl!
          : "",
    }, SetOptions(merge: true));
    
    log("Message saved successfully to Firebase");
  }

  //save message in user
  saveMessageInUserCollection({
    id,
    receiverId,
    newChatId,
    content,
    senderId,
    receiverName,
    receiverImage,
    token,
    MessageType? type,
    role,
    sToken,
    rToken,
    phone,
    code,
    isOffer = false,
  }) async {
    log("=== saveMessageInUserCollection CALLED ===");
    log("Saving chat summary for user: $id");
    log("chatId: $newChatId");
    log("senderId: $senderId, receiverId: $receiverId");
    
    await FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc(id.toString())
        .collection(collectionName.chats)
        .where("chatId", isEqualTo: newChatId)
        .get()
        .then((value) async {
      log("CHTAII :$newChatId");
      if (value.docs.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection(collectionName.users)
            .doc(id.toString())
            .collection(collectionName.chats)
            .doc(value.docs[0].id)
            .update({
          "updateStamp": DateTime.now().millisecondsSinceEpoch.toString(),
          "lastMessage": content,
          "senderId": senderId,
          "messageType": type!.name,
          "chatId": newChatId,
          "isSeen": false,
          "senderName": userModel!.name,
          "senderImage":
              userModel!.media != null && userModel!.media!.isNotEmpty
                  ? userModel!.media![0].originalUrl!
                  : null,
          "receiverName": receiverName,
          "receiverImage": receiverImage,
          "receiverId": receiverId,
          "type": type.name,
          "role": role,
          "receiverToken": rToken,
          "senderToken": sToken,
          "senderPhone": userModel!.phone,
          "receiverPhone": phone,
          "senderCode": userModel!.code,
          "receiverCode": code,
          "isOffer": isOffer,
        }).then((value) {});
      } else {
        await FirebaseFirestore.instance
            .collection(collectionName.users)
            .doc(id.toString())
            .collection(collectionName.chats)
            .add({
          "updateStamp": DateTime.now().millisecondsSinceEpoch.toString(),
          "lastMessage": content,
          "senderId": senderId,
          "messageType": type!.name,
          "chatId": newChatId,
          "isSeen": false,
          "senderName": userModel!.name,
          "senderImage":
              userModel!.media != null && userModel!.media!.isNotEmpty
                  ? userModel!.media![0].originalUrl!
                  : null,
          "receiverName": receiverName,
          "receiverImage": receiverImage,
          "receiverId": receiverId,
          "type": type.name,
          "role": role,
          "receiverToken": rToken,
          "senderToken": sToken,
          "senderPhone": userModel!.phone,
          "receiverPhone": phone,
          "senderCode": userModel!.code,
          "receiverCode": code,
          "isOffer": isOffer,
        }).then((value) {});
      }
    }).then((value) {});
  }

  //save message in user
  Future saveMessageInUserCollectionByOffer({
    id,
    receiverId,
    newChatId,
    content,
    senderId,
    receiverName,
    receiverImage,
    token,
    MessageType? type,
    role,
    sToken,
    rToken,
    phone,
    code,
    isOffer = false,
  }) async {
    log("dkghdfkuyg :${rToken} //$sToken");
    await FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc(id.toString())
        .collection(collectionName.chats)
        .where("chatId", isEqualTo: newChatId)
        .get()
        .then((value) async {
      log("CHTAII :$newChatId");
      if (value.docs.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection(collectionName.users)
            .doc(id.toString())
            .collection(collectionName.chats)
            .doc(value.docs[0].id)
            .update({
          "updateStamp": DateTime.now().millisecondsSinceEpoch.toString(),
          "lastMessage": content,
          "senderId": senderId,
          "messageType": type!.name,
          "chatId": newChatId,
          "isSeen": false,
          "senderName": userModel!.name,
          "senderImage":
              userModel!.media != null && userModel!.media!.isNotEmpty
                  ? userModel!.media![0].originalUrl!
                  : null,
          "receiverName": receiverName,
          "receiverImage": receiverImage,
          "receiverId": receiverId,
          "type": type.name,
          "role": role,
          "receiverToken": rToken,
          "senderToken": sToken,
          "senderPhone": userModel!.phone,
          "receiverPhone": phone,
          "senderCode": userModel!.code,
          "receiverCode": code,
          "isOffer": isOffer,
        }).then((value) {});
      } else {
        await FirebaseFirestore.instance
            .collection(collectionName.users)
            .doc(id.toString())
            .collection(collectionName.chats)
            .add({
          "updateStamp": DateTime.now().millisecondsSinceEpoch.toString(),
          "lastMessage": content,
          "senderId": senderId,
          "messageType": type!.name,
          "chatId": newChatId,
          "isSeen": false,
          "senderName": userModel!.name,
          "senderImage":
              userModel!.media != null && userModel!.media!.isNotEmpty
                  ? userModel!.media![0].originalUrl!
                  : null,
          "receiverName": receiverName,
          "receiverImage": receiverImage,
          "receiverId": receiverId,
          "type": type.name,
          "role": role,
          "receiverToken": rToken,
          "senderToken": sToken,
          "senderPhone": userModel!.phone,
          "receiverPhone": phone,
          "senderCode": userModel!.code,
          "receiverCode": code,
          "isOffer": isOffer,
        }).then((value) {});
      }
    }).then((value) {});
  }

  getLocalMessage(ChatProvider chatCtrl) {
    log("chatCtrl");
    List<QueryDocumentSnapshot<Object?>> message = chatCtrl.allMessages;
    List reveredList = message.reversed.toList();
    chatCtrl.localMessage = [];

    reveredList.asMap().entries.forEach((element) {
      MessageModel messageModel = MessageModel(
        chatId: element.value.data()["chatId"],
        content: element.value.data()["content"],
        docId: element.value.id,
        isSeen: element.value.data()["isSeen"],
        messageType: element.value.data()["messageType"],
        receiverId: element.value.data()["receiverId"].toString(),
        senderId: element.value.data()["senderId"].toString(),
        senderName: element.value.data()["senderName"],
        receiverName: element.value.data()["receiverName"],
        receiverImage: element.value.data()["receiverImage"],
        senderImage: element.value.data()["senderImage"],
        timestamp: element.value.data()["timestamp"],
        role: element.value.data()["role"],
        type: element.value.data()["type"],
      );
      if (getDate(element.value.id) == "Today") {
        bool isEmpty = chatCtrl.localMessage
            .where((element) => element.time == "Today")
            .isEmpty;
        if (isEmpty) {
          List<MessageModel>? message = [];
          if (message.isNotEmpty) {
            message.add(MessageModel.fromJson(element.value.data()));
            message[0].docId = element.value.id;
          } else {
            message = [MessageModel.fromJson(element.value.data())];
            message[0].docId = element.value.id;
          }
          DateTimeChip dateTimeChip = DateTimeChip(
            time: getDate(element.value.id),
            message: message,
          );
          chatCtrl.localMessage.add(dateTimeChip);
        } else {
          int index = chatCtrl.localMessage.indexWhere(
            (element) => element.time == "Today",
          );

          if (!chatCtrl.localMessage[index].message!.contains(messageModel)) {
            chatCtrl.localMessage[index].message!.add(messageModel);
          }
        }
      }

      if (getDate(element.value.id) == "Yesterday") {
        bool isEmpty = chatCtrl.localMessage
            .where((element) => element.time == "Yesterday")
            .isEmpty;
        if (isEmpty) {
          List<MessageModel>? message = [];
          if (message.isNotEmpty) {
            message.add(MessageModel.fromJson(element.value.data()));
            message[0].docId = element.value.id;
          } else {
            message = [MessageModel.fromJson(element.value.data())];
            message[0].docId = element.value.id;
          }
          DateTimeChip dateTimeChip = DateTimeChip(
            time: getDate(element.value.id),
            message: message,
          );
          chatCtrl.localMessage.add(dateTimeChip);
        } else {
          int index = chatCtrl.localMessage.indexWhere(
            (element) => element.time == "Yesterday",
          );

          if (!chatCtrl.localMessage[index].message!.contains(messageModel)) {
            chatCtrl.localMessage[index].message!.add(messageModel);
          }
        }
      }

      if (getDate(element.value.id).contains("-other")) {
        bool isEmpty = chatCtrl.localMessage
            .where((element) => element.time!.contains("-other"))
            .isEmpty;
        if (isEmpty) {
          List<MessageModel>? message = [];
          if (message.isNotEmpty) {
            message.add(MessageModel.fromJson(element.value.data()));
            message[0].docId = element.value.id;
          } else {
            message = [MessageModel.fromJson(element.value.data())];
            message[0].docId = element.value.id;
          }
          DateTimeChip dateTimeChip = DateTimeChip(
            time: getDate(element.value.id),
            message: message,
          );
          chatCtrl.localMessage.add(dateTimeChip);
        } else {
          int index = chatCtrl.localMessage.indexWhere(
            (element) => element.time!.contains("-other"),
          );

          if (!chatCtrl.localMessage[index].message!.contains(messageModel)) {
            chatCtrl.localMessage[index].message!.add(messageModel);
          }
        }
      }
    });

    chatCtrl.notifyListeners();
  }

  getLocalMessageOffer(context) {
    final chatCtrl = Provider.of<OfferChatProvider>(context, listen: false);
    List<QueryDocumentSnapshot<Object?>> message = chatCtrl.allMessages;
    List reveredList = message.reversed.toList();
    chatCtrl.localMessage = [];

    reveredList.asMap().entries.forEach((element) {
      MessageModel messageModel = MessageModel(
        chatId: element.value.data()["chatId"],
        content: element.value.data()["content"],
        docId: element.value.id,
        isSeen: element.value.data()["isSeen"],
        messageType: element.value.data()["messageType"],
        receiverId: element.value.data()["receiverId"].toString(),
        senderId: element.value.data()["senderId"].toString(),
        senderName: element.value.data()["senderName"],
        receiverName: element.value.data()["receiverName"],
        receiverImage: element.value.data()["receiverImage"],
        senderImage: element.value.data()["senderImage"],
        timestamp: element.value.data()["timestamp"],
        role: element.value.data()["role"],
        type: element.value.data()["type"],
      );
      if (getDate(element.value.id) == "Today") {
        bool isEmpty = chatCtrl.localMessage
            .where((element) => element.time == "Today")
            .isEmpty;
        if (isEmpty) {
          List<MessageModel>? message = [];
          if (message.isNotEmpty) {
            message.add(MessageModel.fromJson(element.value.data()));
            message[0].docId = element.value.id;
          } else {
            message = [MessageModel.fromJson(element.value.data())];
            message[0].docId = element.value.id;
          }
          DateTimeChip dateTimeChip = DateTimeChip(
            time: getDate(element.value.id),
            message: message,
          );
          chatCtrl.localMessage.add(dateTimeChip);
        } else {
          int index = chatCtrl.localMessage.indexWhere(
            (element) => element.time == "Today",
          );

          if (!chatCtrl.localMessage[index].message!.contains(messageModel)) {
            chatCtrl.localMessage[index].message!.add(messageModel);
          }
        }
      }

      if (getDate(element.value.id) == "Yesterday") {
        bool isEmpty = chatCtrl.localMessage
            .where((element) => element.time == "Yesterday")
            .isEmpty;
        if (isEmpty) {
          List<MessageModel>? message = [];
          if (message.isNotEmpty) {
            message.add(MessageModel.fromJson(element.value.data()));
            message[0].docId = element.value.id;
          } else {
            message = [MessageModel.fromJson(element.value.data())];
            message[0].docId = element.value.id;
          }
          DateTimeChip dateTimeChip = DateTimeChip(
            time: getDate(element.value.id),
            message: message,
          );
          chatCtrl.localMessage.add(dateTimeChip);
        } else {
          int index = chatCtrl.localMessage.indexWhere(
            (element) => element.time == "Yesterday",
          );

          if (!chatCtrl.localMessage[index].message!.contains(messageModel)) {
            chatCtrl.localMessage[index].message!.add(messageModel);
          }
        }
      }

      if (getDate(element.value.id).contains("-other")) {
        bool isEmpty = chatCtrl.localMessage
            .where((element) => element.time!.contains("-other"))
            .isEmpty;
        if (isEmpty) {
          List<MessageModel>? message = [];
          if (message.isNotEmpty) {
            message.add(MessageModel.fromJson(element.value.data()));
            message[0].docId = element.value.id;
          } else {
            message = [MessageModel.fromJson(element.value.data())];
            message[0].docId = element.value.id;
          }
          DateTimeChip dateTimeChip = DateTimeChip(
            time: getDate(element.value.id),
            message: message,
          );
          chatCtrl.localMessage.add(dateTimeChip);
        } else {
          int index = chatCtrl.localMessage.indexWhere(
            (element) => element.time!.contains("-other"),
          );

          if (!chatCtrl.localMessage[index].message!.contains(messageModel)) {
            chatCtrl.localMessage[index].message!.add(messageModel);
          }
        }
      }
    });

    chatCtrl.notifyListeners();
  }

  Future<String> getAccessToken() async {
    String url = 'https://www.googleapis.com/auth/firebase.messaging';
    //log("JSONG :${appSettingModel!.firebase!.serviceJson!.toJson()}");
    final client = await clientViaServiceAccount(
      ServiceAccountCredentials.fromJson(
        appSettingModel!.firebase!.serviceJson!.toJson(),
      ),
      [url],
    );
    log("client :$client");
    final accessToken = client.credentials.accessToken.data;

    return accessToken;
  }

  //send notification
  Future<void> sendNotification({
    title,
    msg,
    token,
    image,
    dataTitle,
    chatId,
    groupId,
    pId,
    name,
    bookingId,
    bookingNumber,
    phone,
    code,
  }) async {
    final access = await getAccessToken();
    // log("access:$access");
    final data = {
      "message": {
        "token": "$token",
        "notification": {"body": msg, "title": title},
        "data": {
          "click_action": "FLUTTER_NOTIFICATION_CLICK",
          "title": title,
          "alertMessage": 'true',
          "chatId": chatId,
          "pId": userModel!.id.toString(),
          "image": image,
          "type": "chat",
          "name": name,
          "role": isServiceman ? "serviceman" : "provider",
          "phone": phone,
          "code": code,
          "token": token,
        },
      },
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization': 'Bearer $access',
    };

    log("BOOOOO :$data");

    BaseOptions options = BaseOptions(
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers: headers,
    );

    FirebaseApp? app = Firebase.app();
    String k98 = app.options.projectId;

    try {
      final response = await Dio(options).post(
        'https://fcm.googleapis.com/v1/projects/$k98/messages:send',
        data: data,
      );
      debugPrint('NOTIFICATION RES $response');
      if (response.statusCode == 200) {
        debugPrint('Alert push notification send');
      } else {
        debugPrint('notification sending failed');
      }
    } catch (e) {
      if (e is DioException) {
        if (e.type == DioExceptionType.badResponse) {
          final response = e.response;
          log("RES :${response!.data}");
        } else {
          final response = e.response;
          log("RESs :${response!.data}");
        }
      } else {}
    }
  }

  //active status change
  onlineActiveStatusChange(isOffline) async {
    if (userModel != null) {
      await FirebaseFirestore.instance
          .collection(collectionName.users)
          .doc(userModel!.id.toString())
          .set({"status": isOffline ? "Offline" : "Online"});
    }
  }

  //seen all message
  seenMessage(context) async {
    final chatCtrl = Provider.of<ChatProvider>(context, listen: false);
    await FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc(userModel!.id.toString())
        .collection(collectionName.messages)
        .doc(chatCtrl.chatId)
        .collection(collectionName.chat)
        .where("receiverId", isEqualTo: userModel!.id.toString())
        .get()
        .then((value) {
      value.docs.asMap().entries.forEach((element) async {
        await FirebaseFirestore.instance
            .collection(collectionName.users)
            .doc(userModel!.id.toString())
            .collection(collectionName.messages)
            .doc(chatCtrl.chatId)
            .collection(collectionName.chat)
            .doc(element.value.id)
            .update({"isSeen": true});
      });
    });

    await FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc(userModel!.id.toString())
        .collection(collectionName.chats)
        .where("chatId", isEqualTo: chatCtrl.chatId)
        .get()
        .then((value) async {
      if (value.docs.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection(collectionName.users)
            .doc(userModel!.id.toString())
            .collection(collectionName.chats)
            .doc(value.docs[0].id)
            .update({"isSeen": true});
      }
    });

    await FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc(chatCtrl.userId.toString())
        .collection(collectionName.messages)
        .doc(chatCtrl.chatId)
        .collection(collectionName.chat)
        .where("receiverId", isEqualTo: userModel!.id.toString())
        .get()
        .then((value) {
      value.docs.asMap().entries.forEach((element) async {
        await FirebaseFirestore.instance
            .collection(collectionName.users)
            .doc(chatCtrl.userId.toString())
            .collection(collectionName.messages)
            .doc(chatCtrl.chatId)
            .collection(collectionName.chat)
            .doc(element.value.id)
            .update({"isSeen": true});
      });
    });
    await FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc(chatCtrl.userId.toString())
        .collection(collectionName.chats)
        .where("chatId", isEqualTo: chatCtrl.chatId)
        .get()
        .then((value) async {
      if (value.docs.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection(collectionName.users)
            .doc(chatCtrl.userId.toString())
            .collection(collectionName.chats)
            .doc(value.docs[0].id)
            .update({"isSeen": true});
      }
    });
    chatCtrl.notifyListeners();
  }

  //clear chat
  clearChat(context) async {
    final chatCtrl = Provider.of<ChatProvider>(context, listen: false);
    try {
      if (chatCtrl.chatId != null && chatCtrl.chatId != "0") {
        chatCtrl.messageSub = null;
        chatCtrl.messageSub = null;
        chatCtrl.allMessages = [];
        chatCtrl.localMessage = [];
        await FirebaseFirestore.instance
            .collection(collectionName.users)
            .doc(userModel!.id.toString())
            .collection(collectionName.messages)
            .doc(chatCtrl.chatId)
            .collection(collectionName.chat)
            .get()
            .then((value) {
          if (value.docs.isNotEmpty) {
            for (var a in value.docs) {
              FirebaseFirestore.instance
                  .collection(collectionName.users)
                  .doc(userModel!.id.toString())
                  .collection(collectionName.messages)
                  .doc(chatCtrl.chatId)
                  .collection(collectionName.chat)
                  .doc(a.id)
                  .delete();
            }
          }
        }).then((value) async {
          await FirebaseFirestore.instance
              .collection(collectionName.users)
              .doc(userModel!.id.toString())
              .collection(collectionName.chats)
              .where("chatId", isEqualTo: chatCtrl.chatId)
              .get()
              .then((v) {
            if (v.docs.isNotEmpty) {
              for (var d in v.docs) {
                FirebaseFirestore.instance
                    .collection(collectionName.users)
                    .doc(userModel!.id.toString())
                    .collection(collectionName.chats)
                    .doc(d.id)
                    .delete()
                    .then((value) {
                  hideLoading(context);
                  chatCtrl.notifyListeners();
                  chatCtrl.getChatData(context);
                });
              }
            }
          });
        });
      } else if (chatCtrl.bookingId != "") {
        chatCtrl.messageSub = null;
        chatCtrl.messageSub = null;
        chatCtrl.allMessages = [];
        chatCtrl.localMessage = [];
        await FirebaseFirestore.instance
            .collection(collectionName.users)
            .doc(userModel!.id.toString())
            .collection(collectionName.chatWith)
            .doc(chatCtrl.userId.toString())
            .collection(collectionName.booking)
            .doc(chatCtrl.chatId.toString())
            .collection(collectionName.chat)
            .get()
            .then((value) {
          if (value.docs.isNotEmpty) {
            for (var a in value.docs) {
              FirebaseFirestore.instance
                  .collection(collectionName.users)
                  .doc(userModel!.id.toString())
                  .collection(collectionName.chatWith)
                  .doc(chatCtrl.userId.toString())
                  .collection(collectionName.booking)
                  .doc(chatCtrl.chatId.toString())
                  .collection(collectionName.chat)
                  .doc(a.id)
                  .delete();
            }
          }
        }).then((value) async {
          await FirebaseFirestore.instance
              .collection(collectionName.users)
              .doc(userModel!.id.toString())
              .collection(collectionName.chats)
              .where("bookingId", isEqualTo: chatCtrl.bookingId)
              .get()
              .then((v) {
            if (v.docs.isNotEmpty) {
              for (var d in v.docs) {
                FirebaseFirestore.instance
                    .collection(collectionName.users)
                    .doc(userModel!.id.toString())
                    .collection(collectionName.chats)
                    .doc(d.id)
                    .delete()
                    .then((value) {
                  hideLoading(context);
                  chatCtrl.notifyListeners();
                  chatCtrl.getChatData(context);
                });
              }
            }
          });
        });
      } else {
        hideLoading(context);
        chatCtrl.notifyListeners();
        chatCtrl.getChatData(context);
      }
    } catch (e) {
      hideLoading(context);
      chatCtrl.notifyListeners();
    }
  }
}
