import 'dart:async';
import 'dart:convert' show jsonDecode;
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import '../../config.dart';
import '../../firebase/firebase_api.dart';

class ChatProvider with ChangeNotifier {
  List<ChatModel> chatList = [];
  XFile? imageFile;
  final TextEditingController controller = TextEditingController();
  final FocusNode focus = FocusNode();
  final ScrollController scrollController = ScrollController();
  String? chatId, image, name, role, token, phone, code;
  List<QueryDocumentSnapshot<Map<String, dynamic>>> allMessages = [];
  List<DateTimeChip> localMessage = [];
  String? userId;
  BookingModel? booking;
  String activeStatus = "Offline", bookingId = "", bookingNumber = "";
  QuerySnapshot<Map<String, dynamic>>? agoraData;
  StreamSubscription? messageSub;

  // Build combined chatId for bookings: booking_{bookingId}_{user1}_{user2}
  String buildChatId({required String bookingId, required String partnerId}) {
    if (bookingId.isEmpty) return chatId ?? "";

    List<String> ids = [userModel!.id.toString(), partnerId.toString()];
    ids.sort(); // Ensure consistent order regardless of who initiates

    return "${ids[0]}_${bookingId}_${ids[1]}";
  }

  //on page init data fetch
  onReady(context) async {
    dynamic data = ModalRoute.of(context)!.settings.arguments ?? "";
    log("onReady data :$data");

    if (data != "") {
      String? newUserId = data['userId']?.toString();
      String? newBookingId =
          (data['bookingId'] != null) ? data['bookingId'].toString() : "";
      String? newChatId =
          (data['chatId'] != null) ? data['chatId'].toString() : null;

      // Only clear if the chat session has actually changed
      if (userId != newUserId || (newChatId != null && chatId != newChatId)) {
        log("New chat detected. Clearing old messages.");
        allMessages = [];
        localMessage = [];
      } else {
        log("Same chat detected in onReady. Preserving existing messages.");
        if (allMessages.isNotEmpty) {
          hideLoading(context);
          return;
        }
      }

      hideLoading(context); // Dismiss any stale loaders from previous screens
      notifyListeners();
      userId = data['userId']?.toString();
      name = data['name'];
      image = data['image'];
      role = data['role'];
      token = data['token'];
      phone = data['phone']?.toString();
      code = data['code'];

      log("=== onReady: Navigation Arguments ===");
      log("userId (chat partner): $userId");
      log("name: $name");
      log("role: $role");
      log("Current logged in user: ${userModel!.id}");

      bookingId =
          (data['bookingId'] != null) ? data['bookingId'].toString() : "";
      bookingNumber = (data['bookingNumber'] != null)
          ? data['bookingNumber'].toString()
          : "";
      chatId = (data['chatId'] != null) ? data['chatId'].toString() : null;

      try {
        await Future.wait([
          getBookingDetailBy(context),
          getChatData(context),
          getActiveStatus(),
        ]);
      } catch (e) {
        hideLoading(context);
        log("Error in onReady operations: $e");
      }
    }

    final chatCtrl = Provider.of<ChatProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FirebaseApi().getLocalMessage(chatCtrl);
    });

    try {
      final value = await FirebaseFirestore.instance
          .collection(collectionName.agora)
          .get();
      agoraData = value;
    } catch (e) {
      log("Error fetching agora data: $e");
    }

    notifyListeners();
  }

  //booking detail by id
  Future getBookingDetailBy(context) async {
    if (bookingId == "") {
      hideLoading(context);
      return;
    }
    try {
      await apiServices
          .getApi("${api.booking}/$bookingId", [], isToken: true, isData: true)
          .then((value) {
        hideLoading(context);
        if (value.isSuccess!) {
          booking = BookingModel.fromJson(value.data);
          notifyListeners();
        }
        int index = booking!.servicemen!.indexWhere(
          (element) => element.id.toString() == userId.toString(),
        );
        if (index >= 0) {
          phone = booking!.servicemen![index].phone.toString();
          token = booking!.servicemen![index].fcmToken;
          code = booking!.servicemen![index].code;
        }
        notifyListeners();
      });
      log("STATYS L $booking");
    } catch (e) {
      hideLoading(context);
      notifyListeners();
    }
  }

  //user active status
  Future<void> getActiveStatus() async {
    await FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc(userId.toString())
        .get()
        .then((value) {
      if (value.exists) {
        activeStatus = value.data()!['status'];
      }
    });
    notifyListeners();
  }

  //get chat data
  Future getChatData(context) async {
    try {
      messageSub?.cancel();
      allMessages = [];
      localMessage = [];
      notifyListeners();

      log("=== getChatData CALLED ===");
      log("Current User (logged in): ${userModel!.id}");
      log("Chat Partner (userId): $userId");
      log("bookingId: $bookingId");
      log("chatId: $chatId");

      if (bookingId != "") {
        chatId = buildChatId(bookingId: bookingId, partnerId: userId!);
        log("Unified Booking chatId generated: $chatId");
      }

      if (bookingId != "") {
        log("BOOKING CHAT MODE");
        log("userModel!.id: ${userModel!.id}");
        log("chatId: $chatId, $bookingId");
        messageSub = FirebaseFirestore.instance
            .collection(collectionName.users)
            .doc(userModel!.id.toString()) // user id -3
            .collection(collectionName.chatWith)
            .doc(userId.toString())
            .collection(collectionName.booking)
            .doc(bookingId.toString())
            .collection(collectionName.chat)
            .snapshots()
            .listen((event) async {
          allMessages = event.docs;
          notifyListeners();
          final chatCtrl = Provider.of<ChatProvider>(context, listen: false);
          FirebaseApi().getLocalMessage(chatCtrl);
          log("allMessages :${event.docs.length}");
          notifyListeners();
        });
      }

      // / chat mate
      else if (chatId != "") {
        log("hjsfgsuyfgsjghbsjg");
        messageSub = FirebaseFirestore.instance
            .collection(collectionName.users)
            .doc(userModel!.id.toString())
            .collection(collectionName.messages)
            .doc(chatId.toString())
            .collection(collectionName.chat)
            .snapshots()
            .listen((event) async {
          allMessages = event.docs;
          notifyListeners();
          final chatCtrl = Provider.of<ChatProvider>(context, listen: false);
          FirebaseApi().getLocalMessage(chatCtrl);

          notifyListeners();
        });
      } else {
        // No chatId provided - need to find existing or create new
        chatId = null;
        log("Searching for existing chat between ${userModel!.id} and $userId");

        try {
          final chatDocs = await FirebaseFirestore.instance
              .collection(collectionName.users)
              .doc(userModel!.id.toString())
              .collection(collectionName.chats)
              .get();

          if (chatDocs.docs.isNotEmpty) {
            // Search for existing chat with THIS specific user
            for (var d in chatDocs.docs) {
              final data = d.data();
              final senderId = data['senderId']?.toString();
              final receiverId = data['receiverId']?.toString();

              log("Checking chat: senderId=$senderId, receiverId=$receiverId");

              // Check if this chat is between current user and target user
              bool isMatch = (senderId == userModel!.id.toString() &&
                      receiverId == userId) ||
                  (receiverId == userModel!.id.toString() &&
                      senderId == userId);

              if (isMatch) {
                chatId = data['chatId'];
                log("Found existing chatId: $chatId for conversation with $userId");
                break;
              }
            }
          }

          // If no existing chat found, generate new unique chatId
          if (chatId == null || chatId == "") {
            chatId = DateTime.now().microsecondsSinceEpoch.toString();
            log("No existing chat found. Generated new chatId: $chatId");
          }

          // Now subscribe to messages with the correct chatId
          if (chatId != null && chatId != "" && chatId != "0") {
            log("Subscribing to messages for chatId: $chatId");
            messageSub = FirebaseFirestore.instance
                .collection(collectionName.users)
                .doc(userModel!.id.toString())
                .collection(collectionName.messages)
                .doc(chatId.toString())
                .collection(collectionName.chat)
                .snapshots()
                .listen((event) async {
              allMessages = event.docs;
              log("Received ${event.docs.length} messages for chatId: $chatId");
              notifyListeners();
              final chatCtrl =
                  Provider.of<ChatProvider>(context, listen: false);
              FirebaseApi().getLocalMessage(chatCtrl);
              notifyListeners();
            });
          } else {
            // New conversation with no messages yet
            log("New conversation - no messages yet");
            messageSub = null;
            allMessages = [];
            localMessage = [];
          }
        } catch (e) {
          log("Error in getChatData else block: $e");
          chatId = DateTime.now().microsecondsSinceEpoch.toString();
          log("Error occurred, generated fallback chatId: $chatId");
        }

        notifyListeners();
      }

      notifyListeners();
    } catch (e) {
      log("EEE: getChatDat :$e");
    }
  }

  //seen all message
  seenMessage(context) async {
    await FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc(userModel!.id.toString())
        .collection(collectionName.messages)
        .doc(chatId ?? bookingId)
        .collection(collectionName.chat)
        .where("receiverId", isEqualTo: userModel!.id.toString())
        .get()
        .then((value) {
      value.docs.asMap().entries.forEach((element) async {
        await FirebaseFirestore.instance
            .collection(collectionName.users)
            .doc(userModel!.id.toString())
            .collection(collectionName.messages)
            .doc(chatId ?? bookingId)
            .collection(collectionName.chat)
            .doc(element.value.id)
            .update({"isSeen": true});
      });
    });

    await FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc(userModel!.id.toString())
        .collection(collectionName.chats)
        .where("chatId", isEqualTo: chatId ?? bookingId)
        .get()
        .then((value) async {
      if (value.docs.isNotEmpty) {
        if (value.docs[0].data()['receiverId'] == userModel!.id.toString()) {
          await FirebaseFirestore.instance
              .collection(collectionName.users)
              .doc(userModel!.id.toString())
              .collection(collectionName.chats)
              .doc(value.docs[0].id)
              .update({"isSeen": true});
        }
      }
    });

    await FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc(userId.toString())
        .collection(collectionName.messages)
        .doc(chatId ?? bookingId)
        .collection(collectionName.chat)
        .where("receiverId", isEqualTo: userModel!.id.toString())
        .get()
        .then((value) {
      value.docs.asMap().entries.forEach((element) async {
        await FirebaseFirestore.instance
            .collection(collectionName.users)
            .doc(userId.toString())
            .collection(collectionName.messages)
            .doc(chatId ?? bookingId)
            .collection(collectionName.chat)
            .doc(element.value.id)
            .update({"isSeen": true});
      });
    });
    await FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc(userId.toString())
        .collection(collectionName.chats)
        .where("chatId", isEqualTo: chatId ?? bookingId)
        .get()
        .then((value) async {
      if (value.docs.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection(collectionName.users)
            .doc(userId.toString())
            .collection(collectionName.chats)
            .doc(value.docs[0].id)
            .update({"isSeen": true});
      }
    });
    notifyListeners();
  }

  onBack(context, isBack) {
    messageSub?.cancel();
    messageSub = null;
    allMessages = [];
    localMessage = [];
    bookingId = "";
    chatId = "";
    notifyListeners();
    if (isBack) {
      route.pop(context);
    }
  }

// Function to pick and upload files (images or videos)
  Future pickAndUploadFile(BuildContext context, ImageSource source,
      {bool isVideo = false}) async {
    try {
      final ImagePicker picker = ImagePicker();
      XFile? pickedFile;

      // Pick image or video based on the flag
      if (isVideo) {
        pickedFile = await picker.pickVideo(
            source: source, maxDuration: const Duration(minutes: 2));
      } else {
        pickedFile = await picker.pickImage(source: source, imageQuality: 70);
      }

      if (pickedFile != null) {
        log("Picked file path: ${pickedFile.path}");

        // Notify listeners (if required in your state management)
        notifyListeners();

        // Upload the file
        await uploadFile(context, pickedFile,
            isVideo: pickedFile.name.contains(".mp4") ? true : false);
      } else {
        log("No file selected.");
      }
    } catch (e) {
      log("Error picking file: $e");
      snackBarMessengers(
        context,
        color: appColor(context).appTheme.red,
        message: "Error picking file: $e",
      );
    }
  }

  Future uploadFile(BuildContext context, XFile file,
      {bool isVideo = false}) async {
    try {
      showLoading(context);
      notifyListeners();
      FocusScope.of(context).unfocus();

      final fileName = "${DateTime.now().millisecondsSinceEpoch}_${file.name}";
      final ref = FirebaseStorage.instance.ref().child(fileName);
      final uploadTask = ref.putFile(File(file.path));
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      log("Uploaded: $downloadUrl");

      await setMessage(
        downloadUrl,
        isVideo ? MessageType.video : MessageType.image,
        context,
      );

      imageFile = null;
      notifyListeners();
    } catch (e) {
      log("Upload error: $e");
      hideLoading(context);
      snackBarMessengers(
        context,
        color: appColor(context).appTheme.red,
        message: "Failed to upload file",
      );
    } finally {
      // 🔥 GUARANTEED TO EXECUTE
      hideLoading(context);
    }
  }

  // // UPLOAD SELECTED IMAGE TO FIREBASE
  // Future uploadFile(context) async {
  //   try {
  //     showLoading(context);
  //     notifyListeners();
  //     FocusScope.of(context).requestFocus(FocusNode());

  //     // String fileName = DateTime.now().millisecondsSinceEpoch.toString();
  //     final fileName =
  //         "${DateTime.now().millisecondsSinceEpoch}_${imageFile.name}";
  //     Reference reference = FirebaseStorage.instance.ref().child(fileName);
  //     var file = File(imageFile!.path);

  //     UploadTask uploadTask = reference.putFile(file);
  //     TaskSnapshot snapshot = await uploadTask;
  //     String downloadUrl = await snapshot.ref.getDownloadURL();

  //     imageFile = null;
  //     notifyListeners();

  //     await setMessage(downloadUrl, MessageType.image, context);
  //   } catch (e) {
  //     log("Upload error: $e");
  //     hideLoading(context);
  //     notifyListeners();
  //   }
  // }

  // showLayout(context, cartCtrl) async {
  //   showDialog(
  //     context: context,
  //     builder: (context1) {
  //       return AlertDialog(
  //         shape: const RoundedRectangleBorder(
  //           borderRadius: BorderRadius.all(Radius.circular(AppRadius.r12)),
  //         ),
  //         content: Consumer<LanguageProvider>(
  //           builder: (context, value, child) {
  //             return Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Text(
  //                       language(context, translations!.selectOne),
  //                       style: appCss.dmDenseBold18.textColor(
  //                         appColor(context).appTheme.darkText,
  //                       ),
  //                     ),
  //                     const Icon(
  //                       CupertinoIcons.multiply,
  //                     ).inkWell(onTap: () => route.pop(context)),
  //                   ],
  //                 ),
  //                 const VSpace(Sizes.s20),
  //                 ...appArray.selectList.asMap().entries.map(
  //                       (e) => SelectOptionLayout(
  //                         data: e.value,
  //                         index: e.key,
  //                         list: appArray.selectList,
  //                         onTap: () {
  //                           log("dsf :${e.key}");
  //                           if (e.key == 0) {
  //                             getImage(context1, ImageSource.gallery);
  //                           } else {
  //                             getImage(context1, ImageSource.camera);
  //                           }
  //                         },
  //                       ),
  //                     ),
  //               ],
  //             );
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }

  showLayout(BuildContext context, cartCtrl) async {
    showDialog(
      context: context,
      builder: (context1) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppRadius.r12)),
          ),
          content: Consumer<LanguageProvider>(
            builder: (valContext, value, child) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        language(context, translations!.selectOne),
                        style: appCss.dmDenseBold18.textColor(
                          appColor(context).appTheme.darkText,
                        ),
                      ),
                      Icon(CupertinoIcons.multiply).inkWell(
                        onTap: () => Navigator.pop(context1),
                      ),
                    ],
                  ),
                  const VSpace(Sizes.s20),
                  ...appArray.selectList.asMap().entries.map(
                        (e) => SelectOptionLayout(
                          data: e.value,
                          index: e.key,
                          list: appArray.selectList,
                          onTap: () {
                            Navigator.pop(context1);

                            if (e.key == 0) {
                              pickAndUploadFile(context, ImageSource.gallery);
                            } else {
                              pickAndUploadFile(context, ImageSource.camera);
                            }
                          },
                        ),
                      ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  //chat list time layout
  Widget timeLayout(context) {
    return Column(
      children: localMessage.reversed.toList().asMap().entries.map((a) {
        List<MessageModel> newMessageList = a.value.message!.toList();

        return Column(
          children: [
            Text(
              a.value.time!.contains("-other")
                  ? a.value.time!.split("-other")[0]
                  : a.value.time!,
              style: appCss.dmDenseMedium14.textColor(
                appColor(context).appTheme.lightText,
              ),
            ).marginSymmetric(vertical: Insets.i5),
            ...newMessageList.reversed.toList().asMap().entries.map((e) {
              return buildItem(
                e.key,
                e.value,
                e.value.docId,
                a.value.time!.contains("-other")
                    ? a.value.time!.split("-other")[0]
                    : a.value.time!,
              );
            }),
          ],
        );
      }).toList(),
    );
  }

  // BUILD ITEM MESSAGE BOX FOR RECEIVER AND SENDER BOX DESIGN
  Widget buildItem(int index, MessageModel document, documentId, title) {
    if (document.senderId.toString() == userModel!.id.toString()) {
      return ChatLayout(document: document, isSentByMe: true);
    } else if (document.senderId != userModel!.id.toString()) {
      // RECEIVER MESSAGE
      return ChatLayout(document: document, isSentByMe: false);
    } else {
      return Container();
    }
  }

  //call tap
  onTapPhone(context) {
    launchCall(context, phone);
    notifyListeners();
  }

  String? senderName; // Sender's name
  void initializeChat({
    dynamic receiverId,
    String? receiverName,
    String? senderName,
    String? receiverImage,
    String? receiverToken,
    String? receiverPhone,
    String? receiverCode,
    String? chatId,
    String? bookingId,
    String? bookingNumber,
  }) {
    log("initializeChat CALLED. Current userId: $userId, New receiverId: $receiverId");
    log("Current chatId: ${this.chatId}, New chatId: $chatId");

    // Only clear state if it's a DIFFERENT chat
    if (userId.toString() != receiverId.toString() ||
        (chatId != null && this.chatId != chatId)) {
      log("Different chat detected. Resetting chat state.");
      allMessages = [];
      localMessage = [];
    } else {
      log("Same chat detected. Keeping chat state.");
    }

    userId = receiverId;
    name = receiverName; // Set receiver's name
    this.senderName = senderName; // Set sender's name
    image = receiverImage;
    token = receiverToken;
    phone = receiverPhone;
    code = receiverCode;
    this.chatId = chatId;
    this.bookingId = bookingId ?? ""; // Reset or set bookingId
    this.bookingNumber = bookingNumber ?? ''; // Reset or set bookingNumber

    log("After assignment - userId: $userId");
    notifyListeners();
  }

  // SEND MESSAGE CLICK
  Future<void> setMessage(
    String content,
    MessageType type,
    BuildContext context,
  ) async {
    log("==== MESSAGE SEND BUTTON PRESSED ====");
    log("Content: $content");
    log("MessageType: ${type.name}");
    log("Receiver ID: $userId");
    log("Receiver Name: $name");
    log("Receiver Image: $image");
    log("Sender ID: ${userModel?.id}");
    log("Sender Name: ${userModel?.name}");
    log("Sender Image: ${userModel?.media?.isNotEmpty == true ? userModel?.media![0].originalUrl : 'null'}");
    log("Role: ${userModel?.role}");
    log("Booking ID: $bookingId");
    log("Booking Number: $bookingNumber");
    log("Token: $token");
    log("Phone: $phone");
    log("Country Code: $code");

    try {
      if (content.isNotEmpty) {
        final now = DateTime.now();
        String time = now.millisecondsSinceEpoch.toString();

        log("Current chatId BEFORE generation: $chatId");
        log("bookingId: $bookingId");

        if (bookingId.isNotEmpty) {
          chatId = buildChatId(bookingId: bookingId, partnerId: userId!);
        } else if (chatId == null || chatId == "" || chatId == "0") {
          chatId = now.microsecondsSinceEpoch.toString();
        }

        log("Final chatId being used for message: $chatId");
        // // Use existing chatId if available, otherwise use bookingId or generate new
        // if (chatId == null || chatId == "0") {
        //   chatId = bookingId.isNotEmpty
        //       ? bookingId
        //       : now.microsecondsSinceEpoch.toString();
        // }

        // Create MessageModel with correct sender and receiver names
        MessageModel messageModel = MessageModel(
          chatId: chatId,
          content: content,
          docId: time,
          messageType: "sender",
          receiverId: userId!, // Receiver's ID
          senderId: userModel!.id.toString(), // Sender's ID
          timestamp: time,
          type: type.name,
          bookingNumber: bookingNumber,
          receiverImage: image, // Receiver's image
          receiverName: name, // Receiver's name
          senderImage: userModel!.media?.isNotEmpty == true
              ? userModel!.media![0].originalUrl!
              : null,
          senderName: userModel!.name, // Sender's name
          role: userModel!.role,
        );

        // Update localMessage list
        bool isEmpty =
            localMessage.where((element) => element.time == "Today").isEmpty;
        if (isEmpty) {
          List<MessageModel> message = [messageModel];
          DateTimeChip dateTimeChip = DateTimeChip(
            time: getDate(time),
            message: message,
          );
          localMessage.add(dateTimeChip);
        } else {
          int index = localMessage.indexWhere(
            (element) => element.time == "Today",
          );
          localMessage[index].message =
              localMessage[index].message!.reversed.toList();
          if (!localMessage[index].message!.contains(messageModel)) {
            localMessage[index].message!.add(messageModel);
          }
          localMessage[index].message =
              localMessage[index].message!.reversed.toList();
        }

        hideLoading(context);
        FocusScope.of(context).unfocus();
        notifyListeners();
        log("USER:::${chatId}/////${bookingId}");
        // Save message to Firebase
        if (bookingId.isNotEmpty) {
          await FirebaseApi().saveMessageByBooking(
            role: role,
            receiverName: name,
            type: type,
            dateTime: time,
            encrypted: content,
            isSeen: false,
            newChatId: chatId,
            collectionId: userId.toString(),
            bookingNumber: bookingNumber,
            pId: userId.toString(),
            bookingId: bookingId,
            receiverImage: image,
            senderId: userModel!.id,
          );

          await FirebaseApi().saveMessageByBooking(
            role: "provider",
            receiverName: userModel!.name,
            type: type,
            collectionId: userModel!.id.toString(),
            bookingId: bookingId,
            dateTime: time,
            encrypted: content,
            isSeen: false,
            bookingNumber: bookingNumber,
            newChatId: chatId,
            pId: userId.toString(),
            receiverImage: userModel!.media?.isNotEmpty == true
                ? userModel!.media![0].originalUrl
                : null,
            senderId: userId.toString(),
          );

          await FirebaseApi().saveMessageInUserCollectionByBooking(
            senderId: userModel!.id.toString(),
            rToken: token,
            sToken: userModel!.fcmToken,
            receiverImage: image,
            newChatId: chatId,
            type: type,
            receiverName: name,
            bookingNumber: bookingNumber,
            bookingId: bookingId,
            content: content,
            receiverId: userId.toString(),
            id: userModel!.id.toString(),
            role: role,
          );

          await FirebaseApi().saveMessageInUserCollectionByBooking(
            senderId: userModel!.id.toString(),
            receiverImage: userModel!.media?.isNotEmpty == true
                ? userModel!.media![0].originalUrl
                : null,
            newChatId: chatId,
            rToken: token,
            bookingNumber: bookingNumber,
            sToken: userModel!.fcmToken,
            type: type,
            bookingId: bookingId,
            receiverName: userModel!.name,
            content: content,
            receiverId: userModel!.id.toString(),
            id: userId.toString(),
            role: "provider",
          );
        } else {
          // Normal chat (non-booking)
          await FirebaseApi().saveMessage(
            role: role,
            receiverName: name,
            type: type,
            dateTime: time,
            encrypted: content,
            isSeen: false,
            newChatId: chatId,
            bookingNumber: bookingNumber,
            pId: userId.toString(),
            receiverImage: image,
            senderId: userModel!.id,
          );

          await FirebaseApi().saveMessage(
            role: "provider",
            receiverName: userModel!.name,
            type: type,
            dateTime: time,
            encrypted: content,
            isSeen: false,
            newChatId: chatId,
            bookingNumber: bookingNumber,
            pId: userModel!.id.toString(),
            receiverImage: userModel!.media?.isNotEmpty == true
                ? userModel!.media![0].originalUrl
                : null,
            senderId: userId.toString(),
          );

          await FirebaseApi().saveMessageInUserCollection(
            senderId: userModel!.id.toString(),
            rToken: token,
            sToken: userModel!.fcmToken,
            receiverImage: image,
            newChatId: chatId,
            type: type,
            receiverName: name,
            content: content,
            receiverId: userId.toString(),
            id: userModel!.id.toString(),
            role: role,
            phone: phone,
            code: code,
          );

          await FirebaseApi().saveMessageInUserCollection(
            senderId: userModel!.id.toString(),
            receiverImage: userModel!.media?.isNotEmpty == true
                ? userModel!.media![0].originalUrl
                : null,
            newChatId: chatId,
            rToken: token,
            sToken: userModel!.fcmToken,
            type: type,
            receiverName: userModel!.name,
            content: content,
            receiverId: userModel!.id.toString(),
            id: userId.toString(),
            role: "provider",
            phone: userModel!.phone.toString(),
            code: userModel!.code,
          );
        }

        // Common post-save logic
        controller.text = "";
        notifyListeners();

        if (token?.isNotEmpty == true) {
          await FirebaseApi().sendNotification(
            title: "${userModel!.name} sent you a message",
            msg: content,
            chatId: chatId,
            token: token,
            bookingNumber: bookingNumber,
            pId: userId.toString(),
            image: image ?? "",
            name: userModel!.name,
            phone: phone,
            code: code,
            bookingId: bookingId.isNotEmpty ? bookingId : chatId,
          );
        }
        log("Sent message: $content");
      }
    } catch (e) {
      log("Error sending message: $e");
    } finally {
      hideLoading(context);
      notifyListeners();
    }
  }

  //on clear chat
  onClearChat(context, sync, chatCtrl) {
    showLoading(context);
    notifyListeners();
    final value = Provider.of<DeleteDialogProvider>(context, listen: false);

    value.onDeleteDialog(
      sync,
      context,
      eImageAssets.clearChat,
      translations!.clearChat,
      translations!.areYouClearChat,
      () async {
        route.pop(context);
        await FirebaseApi().clearChat(context);
        value.onResetPass(
          context,
          language(context, translations!.hurrayChatDelete),
          language(context, translations!.okay),
          () => Navigator.pop(context),
        );
      },
    );
    hideLoading(context);
    value.notifyListeners();
  }
}

// import 'dart:async';
// import 'dart:convert' show jsonDecode;
// import 'dart:developer';
// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/cupertino.dart';
// import '../../config.dart';
// import '../../firebase/firebase_api.dart';
//
// class ChatProvider with ChangeNotifier {
//   List<ChatModel> chatList = [];
//   XFile? imageFile;
//   final TextEditingController controller = TextEditingController();
//   final FocusNode focus = FocusNode();
//   final ScrollController scrollController = ScrollController();
//   String? chatId, image, name, role, token, phone, code;
//   List<QueryDocumentSnapshot<Map<String, dynamic>>> allMessages = [];
//   List<DateTimeChip> localMessage = [];
//   String? userId;
//   BookingModel? booking;
//   String activeStatus = "Offline", bookingId = "";
//   QuerySnapshot<Map<String, dynamic>>? agoraData;
//   StreamSubscription? messageSub;
//
//   //on page init data fetch
//   onReady(context) async {
//     dynamic data = ModalRoute.of(context)!.settings.arguments ?? "";
//     log("data :$data");
//     if (data != "") {
//       userId = data['userId'].toString();
//       name = data['name'];
//       image = data['image'];
//       role = data['role'];
//       token = data['token'];
//       phone = data['phone']?.toString();
//       code = data['code'];
//       if (data['bookingId'] != null) {
//         bookingId = data['bookingId'];
//       }
//       if (data['chatId'] != null) {
//         print("chatIdchatIdsdf:${data['chatId']}");
//         chatId = data['chatId'];
//       } else {
//         chatId = null;
//       }
//       await Future.wait([
//         getBookingDetailBy(context),
//         getChatData(context),
//         getActiveStatus()
//       ]);
//     }
//
//     await FirebaseFirestore.instance
//         .collection(collectionName.agora)
//         .get()
//         .then(
//       (value) {
//         agoraData = value;
//       },
//     );
//
//     notifyListeners();
//   }
//
//   //booking detail by id
//   Future getBookingDetailBy(context) async {
//     try {
//       await apiServices
//           .getApi("${api.booking}/$bookingId", [], isToken: true, isData: true)
//           .then((value) {
//         //debugPrint("BOOKING DATA : ${value.data}");
//         hideLoading(context);
//         if (value.isSuccess!) {
//           booking = BookingModel.fromJson(value.data);
//           notifyListeners();
//         }
//         int index = booking!.servicemen!.indexWhere(
//             (element) => element.id.toString() == userId.toString());
//         if (index >= 0) {
//           phone = booking!.servicemen![index].phone.toString();
//           token = booking!.servicemen![index].fcmToken;
//           code = booking!.servicemen![index].code;
//         }
//         notifyListeners();
//       });
//       log("STATYS L $booking");
//     } catch (e) {
//       hideLoading(context);
//       notifyListeners();
//     }
//   }
//
//   //user active status
//   Future<void> getActiveStatus() async {
//     await FirebaseFirestore.instance
//         .collection(collectionName.users)
//         .doc(userId.toString())
//         .get()
//         .then((value) {
//       if (value.exists) {
//         activeStatus = value.data()!['status'];
//       }
//     });
//     notifyListeners();
//   }
//
//   //get chat data
//   Future getChatData(context) async {
//     try {
//       log("bookingId:$bookingId");
//       if (bookingId != "") {
//         chatId = bookingId;
//       }
//
//       if (bookingId != "") {
//         log("userModel!.id :${userModel!.id}");
//         log("userModel!.id :$chatId");
//         messageSub = FirebaseFirestore.instance
//             .collection(collectionName.users)
//             .doc(userModel!.id.toString())
//             .collection(collectionName.chatWith)
//             .doc(userId.toString())
//             .collection(collectionName.booking)
//             .doc(chatId.toString())
//             .collection(collectionName.chat)
//             .snapshots()
//             .listen((event) async {
//           allMessages = event.docs;
//           notifyListeners();
//
//           FirebaseApi().getLocalMessage(context);
//           log("allMessages :${event.docs.length}");
//           notifyListeners();
//         });
//       } else if (chatId != "") {
//         messageSub = FirebaseFirestore.instance
//             .collection(collectionName.users)
//             .doc(userModel!.id.toString())
//             .collection(collectionName.messages)
//             .doc(chatId.toString())
//             .collection(collectionName.chat)
//             .snapshots()
//             .listen((event) async {
//           allMessages = event.docs;
//           notifyListeners();
//
//           FirebaseApi().getLocalMessage(context);
//
//           notifyListeners();
//         });
//       } else {
//         FirebaseFirestore.instance
//             .collection(collectionName.users)
//             .doc(userModel!.id.toString())
//             .collection(collectionName.chats)
//             .get()
//             .then((value) {
//           if (value.docs.isNotEmpty) {
//             for (var d in value.docs) {
//               log("dkjgh :${(d.data()['senderId'].toString() == userModel!.id.toString() && d.data()['receiverId'].toString() == userId) || (d.data()['receiverId'].toString() == userModel!.id.toString() && d.data()['senderId'].toString() == userId)}");
//
//               if ((d.data()['senderId'].toString() ==
//                           userModel!.id.toString() &&
//                       d.data()['receiverId'].toString() == userId) ||
//                   (d.data()['receiverId'].toString() ==
//                           userModel!.id.toString() &&
//                       d.data()['senderId'].toString() == userId)) {
//                 log("dkjgh :df${(d.data())}");
//                 chatId = d.data()['chatId'];
//               }
//             }
//             log("NEW CHAT :$chatId");
//             if (chatId != "") {
//               messageSub = FirebaseFirestore.instance
//                   .collection(collectionName.users)
//                   .doc(userModel!.id.toString())
//                   .collection(collectionName.messages)
//                   .doc(chatId.toString())
//                   .collection(collectionName.chat)
//                   .snapshots()
//                   .listen((event) async {
//                 allMessages = event.docs;
//                 notifyListeners();
//
//                 FirebaseApi().getLocalMessage(context);
//
//                 notifyListeners();
//               });
//             }
//             notifyListeners();
//           } else {
//             chatId = "0";
//             messageSub = null;
//             allMessages = [];
//             localMessage = [];
//           }
//         });
//       }
//
//       notifyListeners();
//     } catch (e) {
//       log("EEE: getChatDat :$e");
//     }
//   }
//
//   //seen all message
//   seenMessage(context) async {
//     await FirebaseFirestore.instance
//         .collection(collectionName.users)
//         .doc(userModel!.id.toString())
//         .collection(collectionName.messages)
//         .doc(chatId ?? bookingId)
//         .collection(collectionName.chat)
//         .where("receiverId", isEqualTo: userModel!.id.toString())
//         .get()
//         .then((value) {
//       value.docs.asMap().entries.forEach((element) async {
//         await FirebaseFirestore.instance
//             .collection(collectionName.users)
//             .doc(userModel!.id.toString())
//             .collection(collectionName.messages)
//             .doc(chatId ?? bookingId)
//             .collection(collectionName.chat)
//             .doc(element.value.id)
//             .update({"isSeen": true});
//       });
//     });
//
//     await FirebaseFirestore.instance
//         .collection(collectionName.users)
//         .doc(userModel!.id.toString())
//         .collection(collectionName.chats)
//         .where("chatId", isEqualTo: chatId ?? bookingId)
//         .get()
//         .then((value) async {
//       if (value.docs.isNotEmpty) {
//         if (value.docs[0].data()['receiverId'] == userModel!.id.toString()) {
//           await FirebaseFirestore.instance
//               .collection(collectionName.users)
//               .doc(userModel!.id.toString())
//               .collection(collectionName.chats)
//               .doc(value.docs[0].id)
//               .update({"isSeen": true});
//         }
//       }
//     });
//
//     await FirebaseFirestore.instance
//         .collection(collectionName.users)
//         .doc(userId.toString())
//         .collection(collectionName.messages)
//         .doc(chatId ?? bookingId)
//         .collection(collectionName.chat)
//         .where("receiverId", isEqualTo: userModel!.id.toString())
//         .get()
//         .then((value) {
//       value.docs.asMap().entries.forEach((element) async {
//         await FirebaseFirestore.instance
//             .collection(collectionName.users)
//             .doc(userId.toString())
//             .collection(collectionName.messages)
//             .doc(chatId ?? bookingId)
//             .collection(collectionName.chat)
//             .doc(element.value.id)
//             .update({"isSeen": true});
//       });
//     });
//     await FirebaseFirestore.instance
//         .collection(collectionName.users)
//         .doc(userId.toString())
//         .collection(collectionName.chats)
//         .where("chatId", isEqualTo: chatId ?? bookingId)
//         .get()
//         .then((value) async {
//       if (value.docs.isNotEmpty) {
//         await FirebaseFirestore.instance
//             .collection(collectionName.users)
//             .doc(userId.toString())
//             .collection(collectionName.chats)
//             .doc(value.docs[0].id)
//             .update({"isSeen": true});
//       }
//     });
//     notifyListeners();
//   }
//
// // GET IMAGE FROM GALLERY
//   Future getImage(context, source) async {
//     final ImagePicker picker = ImagePicker();
//     imageFile = (await picker.pickImage(source: source, imageQuality: 70));
//     notifyListeners();
//     if (imageFile != null) {
//       uploadFile(context);
//       route.pop(context);
//     }
//   }
//
//   onBack(context, isBack) {
//     chatId = "0";
//     messageSub = null;
//     allMessages = [];
//     localMessage = [];
//     bookingId = "";
//     chatId = "";
//     notifyListeners();
//     if (isBack) {
//       route.pop(context);
//     }
//   }
//
// // UPLOAD SELECTED IMAGE TO FIREBASE
//   Future uploadFile(context) async {
//     showLoading(context);
//     notifyListeners();
//     FocusScope.of(context).requestFocus(FocusNode());
//     String fileName = DateTime.now().millisecondsSinceEpoch.toString();
//     Reference reference = FirebaseStorage.instance.ref().child(fileName);
//     var file = File(imageFile!.path);
//     UploadTask uploadTask = reference.putFile(file);
//     uploadTask.then((res) {
//       res.ref.getDownloadURL().then((downloadUrl) {
//         String imageUrl = downloadUrl;
//         imageFile = null;
//
//         notifyListeners();
//         setMessage(imageUrl, MessageType.image, context);
//       }, onError: (err) {
//         hideLoading(context);
//         notifyListeners();
//       });
//     });
//   }
//
//   showLayout(context, cartCtrl) async {
//     showDialog(
//         context: context,
//         builder: (context1) {
//           return AlertDialog(
//               shape: const RoundedRectangleBorder(
//                   borderRadius:
//                       BorderRadius.all(Radius.circular(AppRadius.r12))),
//               content:
//                   Consumer<LanguageProvider>(builder: (context, value, child) {
//                 return Column(mainAxisSize: MainAxisSize.min, children: [
//                   Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(language(context, translations!.selectOne),
//                             style: appCss.dmDenseBold18.textColor(
//                                 appColor(context).appTheme.darkText)),
//                         const Icon(CupertinoIcons.multiply)
//                             .inkWell(onTap: () => route.pop(context))
//                       ]),
//                   const VSpace(Sizes.s20),
//                   ...appArray.selectList
//                       .asMap()
//                       .entries
//                       .map((e) => SelectOptionLayout(
//                           data: e.value,
//                           index: e.key,
//                           list: appArray.selectList,
//                           onTap: () {
//                             log("dsf :${e.key}");
//                             if (e.key == 0) {
//                               getImage(context, ImageSource.gallery);
//                             } else {
//                               getImage(context, ImageSource.camera);
//                             }
//                           }))
//                 ]);
//               }));
//         });
//   }
//
//   //chat list time layout
//   Widget timeLayout(context) {
//     return Column(
//         children: localMessage.reversed.toList().asMap().entries.map((a) {
//       List<MessageModel> newMessageList = a.value.message!.toList();
//
//       return Column(children: [
//         Text(
//                 a.value.time!.contains("-other")
//                     ? a.value.time!.split("-other")[0]
//                     : a.value.time!,
//                 style: appCss.dmDenseMedium14
//                     .textColor(appColor(context).appTheme.lightText))
//             .marginSymmetric(vertical: Insets.i5),
//         ...newMessageList.reversed.toList().asMap().entries.map((e) {
//           return buildItem(
//               e.key,
//               e.value,
//               e.value.docId,
//               a.value.time!.contains("-other")
//                   ? a.value.time!.split("-other")[0]
//                   : a.value.time!);
//         })
//       ]);
//     }).toList());
//   }
//
// // BUILD ITEM MESSAGE BOX FOR RECEIVER AND SENDER BOX DESIGN
//   Widget buildItem(int index, MessageModel document, documentId, title) {
//     if (document.senderId.toString() == userModel!.id.toString()) {
//       return ChatLayout(document: document, isSentByMe: true);
//     } else if (document.senderId != userModel!.id.toString()) {
//       // RECEIVER MESSAGE
//       return ChatLayout(document: document, isSentByMe: false);
//     } else {
//       return Container();
//     }
//   }
//
//   //call tap
//   onTapPhone(context) {
//     launchCall(context, phone);
//     notifyListeners();
//   }
//
//   Widget buildOfferContent(BuildContext context, String content) {
//     try {
//       final Map<String, dynamic> offerData = jsonDecode(content);
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             offerData['title'] ?? 'Offer',
//             style: appCss.dmDenseBold14
//                 .textColor(appColor(context).appTheme.darkText),
//           ),
//           SizedBox(height: 5),
//           Text(
//             offerData['description'] ?? '',
//             style: appCss.dmDenseRegular14
//                 .textColor(appColor(context).appTheme.darkText),
//           ),
//           SizedBox(height: 5),
//           Text(
//             'Price: \$${offerData['price']?.toStringAsFixed(2) ?? '0.00'}',
//             style: appCss.dmDenseMedium12
//                 .textColor(appColor(context).appTheme.primary),
//           ),
//           Text(
//             'Duration: ${offerData['duration']} ${offerData['duration_unit']}',
//             style: appCss.dmDenseMedium12
//                 .textColor(appColor(context).appTheme.darkText),
//           ),
//           Text(
//             'From: ${offerData['started_at']} to ${offerData['ended_at']}',
//             style: appCss.dmDenseMedium12
//                 .textColor(appColor(context).appTheme.darkText),
//           ),
//           if (offerData['is_servicemen_required'] == true)
//             Text(
//               'Servicemen: ${offerData['required_servicemen']}',
//               style: appCss.dmDenseMedium12
//                   .textColor(appColor(context).appTheme.darkText),
//             ),
//         ],
//       );
//     } catch (e) {
//       log("Error parsing offer content: $e");
//       return Text(
//         'Invalid offer data',
//         style: appCss.dmDenseRegular14.textColor(Colors.red),
//       );
//     }
//   }
//
//   String? senderName; // Sender's name
//   void initializeChat({
//     required String receiverId,
//     required String receiverName,
//     required String senderName,
//     required String? receiverImage,
//     required String? receiverToken,
//     required String? receiverPhone,
//     required String? receiverCode,
//     required String? chatId,
//     required String? bookingId,
//   }) {
//     this.userId = receiverId;
//     this.name = receiverName; // Set receiver's name
//     this.senderName = senderName; // Set sender's name
//     this.image = receiverImage;
//     this.token = receiverToken;
//     this.phone = receiverPhone;
//     this.code = receiverCode;
//     this.chatId = chatId;
//     this.bookingId = bookingId!; // Set bookingId if available
//     notifyListeners();
//   }
//
//   // SEND MESSAGE CLICK
//   void setMessage(
//       String content, MessageType type, BuildContext context) async {
//     try {
//       if (content.isNotEmpty) {
//         controller.text = "";
//         final now = DateTime.now();
//         String? newChatId = chatId ?? now.microsecondsSinceEpoch.toString();
//         chatId = newChatId;
//         String time = now.millisecondsSinceEpoch.toString();
//
//         // Create MessageModel with correct sender and receiver names
//         MessageModel messageModel = MessageModel(
//           chatId: chatId,
//           content: content,
//           docId: time,
//           messageType: "sender",
//           receiverId: userId!, // Receiver's ID
//           senderId: userModel!.id.toString(), // Sender's ID
//           timestamp: time,
//           type: type.name,
//           receiverImage: image, // Receiver's image
//           receiverName: name, // Receiver's name
//           senderImage: userModel!.media?.isNotEmpty == true
//               ? userModel!.media![0].originalUrl!
//               : null,
//           senderName: userModel!.name, // Sender's name
//           role: userModel!.role,
//         );
//
//         // Update localMessage list
//         bool isEmpty =
//             localMessage.where((element) => element.time == "Today").isEmpty;
//         if (isEmpty) {
//           List<MessageModel> message = [messageModel];
//           DateTimeChip dateTimeChip =
//               DateTimeChip(time: getDate(time), message: message);
//           localMessage.add(dateTimeChip);
//         } else {
//           int index =
//               localMessage.indexWhere((element) => element.time == "Today");
//           localMessage[index].message =
//               localMessage[index].message!.reversed.toList();
//           if (!localMessage[index].message!.contains(messageModel)) {
//             localMessage[index].message!.add(messageModel);
//           }
//           localMessage[index].message =
//               localMessage[index].message!.reversed.toList();
//         }
//
//         hideLoading(context);
//         notifyListeners();
//
//         // Save message to Firebase
//         if (role == "user") {
//           await FirebaseApi()
//               .saveMessageByBooking(
//             role: role,
//             receiverName: name, // Receiver's name
//             type: type,
//             dateTime: time,
//             encrypted: content,
//             isSeen: false,
//             newChatId: chatId,
//             collectionId: userId.toString(),
//             pId: userId.toString(),
//             bookingId: chatId,
//             receiverImage: image,
//             senderId: userModel!.id,
//           )
//               .then((value) async {
//             await FirebaseApi()
//                 .saveMessageByBooking(
//               role: role,
//               receiverName: name,
//               type: type,
//               collectionId: userModel!.id.toString(),
//               bookingId: chatId,
//               dateTime: time,
//               encrypted: content,
//               isSeen: false,
//               newChatId: chatId,
//               pId: userId.toString(),
//               receiverImage: image,
//               senderId: userId.toString(),
//             )
//                 .then((snap) async {
//               await FirebaseApi().saveMessageInUserCollectionByBooking(
//                 senderId: userModel!.id.toString(),
//                 rToken: token,
//                 sToken: userModel!.fcmToken,
//                 receiverImage: image,
//                 newChatId: chatId,
//                 type: type,
//                 receiverName: name, // Receiver's name
//                 bookingId: chatId,
//                 content: content,
//                 receiverId: userId.toString(),
//                 id: userModel!.id.toString(),
//                 role: role,
//               );
//               await FirebaseApi().saveMessageInUserCollectionByBooking(
//                 senderId: userModel!.id.toString(),
//                 receiverImage: image,
//                 newChatId: chatId,
//                 rToken: token,
//                 sToken: userModel!.fcmToken,
//                 type: type,
//                 bookingId: chatId,
//                 receiverName: name, // Receiver's name
//                 content: content,
//                 receiverId: userId.toString(),
//                 id: userId.toString(),
//                 role: role,
//               );
//             });
//           }).then((value) async {
//             controller.text = "";
//             notifyListeners();
//             getChatData(context);
//
//             if (token?.isNotEmpty == true) {
//               await FirebaseApi().sendNotification(
//                 title: "${userModel!.name} sent you a message",
//                 msg: content,
//                 chatId: chatId,
//                 token: token,
//                 pId: userId.toString(),
//                 image: image ?? "",
//                 name: userModel!.name, // Sender's name
//                 phone: phone,
//                 code: code,
//                 bookingId: chatId,
//               );
//             }
//             log("Sent message: $content");
//           });
//         } else {
//           // Similar logic for non-user role
//           log("Sent message: $content");
//           // ... (rest of the method)
//         }
//       }
//     } catch (e) {
//       log("Error sending message: $e");
//       hideLoading(context);
//     }
//   }
//   // void setMessage(String content, MessageType type, context) async {
//   //   // isLoading = true;
//   //   log("content :$role $chatId");
//   //   notifyListeners();
//   //   try {
//   //     if (content != '') {
//   //       controller.text = "";
//   //       log("hdhfjhd");
//   //       final now = DateTime.now();
//   //       String? newChatId = chatId ?? now.microsecondsSinceEpoch.toString();
//   //       chatId = newChatId;
//   //       log("chatId :$chatId");
//   //       notifyListeners();
//   //       String time = DateTime.now().millisecondsSinceEpoch.toString();
//   //       MessageModel messageModel = MessageModel(
//   //         chatId: chatId,
//   //         content: content,
//   //         docId: time,
//   //         messageType: "sender",
//   //         receiverId: userId!.toString(),
//   //         senderId: userModel!.id!.toString(),
//   //         timestamp: time,
//   //         type: type.name,
//   //         receiverImage: image,
//   //         receiverName: name,
//   //         senderImage: userModel!.media != null && userModel!.media!.isNotEmpty
//   //             ? userModel!.media![0].originalUrl!
//   //             : null,
//   //         senderName: userModel!.name,
//   //         role: userModel!.role,
//   //       );
//   //       bool isEmpty =
//   //           localMessage.where((element) => element.time == "Today").isEmpty;
//   //       if (isEmpty) {
//   //         List<MessageModel>? message = [];
//   //         if (message.isNotEmpty) {
//   //           message.add(messageModel);
//   //           message[0].docId = time;
//   //         } else {
//   //           message = [messageModel];
//   //           message[0].docId = time;
//   //         }
//   //         DateTimeChip dateTimeChip =
//   //             DateTimeChip(time: getDate(time), message: message);
//   //         localMessage.add(dateTimeChip);
//   //       } else {
//   //         int index =
//   //             localMessage.indexWhere((element) => element.time == "Today");
//   //         localMessage[index].message =
//   //             localMessage[index].message!.reversed.toList();
//   //         if (!localMessage[index].message!.contains(messageModel)) {
//   //           localMessage[index].message!.add(messageModel);
//   //         }
//   //         localMessage[index].message =
//   //             localMessage[index].message!.reversed.toList();
//   //       }
//   //       hideLoading(context);
//   //       notifyListeners();
//   //       if (role == "user") {
//   //         await FirebaseApi()
//   //             .saveMessageByBooking(
//   //                 role: role,
//   //                 receiverName: name,
//   //                 type: type,
//   //                 dateTime: DateTime.now().millisecondsSinceEpoch.toString(),
//   //                 encrypted: content,
//   //                 isSeen: false,
//   //                 newChatId: chatId,
//   //                 collectionId: userId.toString(),
//   //                 pId: userId.toString(),
//   //                 bookingId: chatId,
//   //                 receiverImage: image,
//   //                 senderId: userModel!.id)
//   //             .then((value) async {
//   //           await FirebaseApi()
//   //               .saveMessageByBooking(
//   //                   role: role,
//   //                   receiverName: name,
//   //                   type: type,
//   //                   collectionId: userModel!.id.toString(),
//   //                   bookingId: chatId,
//   //                   dateTime: DateTime.now().millisecondsSinceEpoch.toString(),
//   //                   encrypted: content,
//   //                   isSeen: false,
//   //                   newChatId: chatId,
//   //                   pId: userId.toString(),
//   //                   receiverImage: image,
//   //                   senderId: userId.toString())
//   //               .then((snap) async {
//   //             await FirebaseApi().saveMessageInUserCollectionByBooking(
//   //                 senderId: userModel!.id,
//   //                 rToken: token,
//   //                 sToken: userModel!.fcmToken,
//   //                 receiverImage: image,
//   //                 newChatId: chatId,
//   //                 type: type,
//   //                 receiverName: name,
//   //                 bookingId: chatId,
//   //                 content: content,
//   //                 receiverId: userId.toString(),
//   //                 id: userModel!.id,
//   //                 role: role);
//   //             await FirebaseApi().saveMessageInUserCollectionByBooking(
//   //                 senderId: userModel!.id,
//   //                 receiverImage: image,
//   //                 newChatId: chatId,
//   //                 rToken: token,
//   //                 sToken: userModel!.fcmToken,
//   //                 type: type,
//   //                 bookingId: chatId,
//   //                 receiverName: name,
//   //                 content: content,
//   //                 receiverId: userId.toString(),
//   //                 id: userId.toString(),
//   //                 role: role);
//   //           });
//   //         }).then((value) async {
//   //           controller.text = "";
//   //           notifyListeners();
//   //           getChatData(context);
//   //
//   //           if (token != "" && token != null) {
//   //             FirebaseApi().sendNotification(
//   //                 title: "${userModel!.name} send you message",
//   //                 msg: content,
//   //                 chatId: chatId,
//   //                 token: token,
//   //                 pId: userId.toString(),
//   //                 image: image ?? "",
//   //                 name: userModel!.name,
//   //                 phone: phone,
//   //                 code: code,
//   //                 bookingId: chatId);
//   //           }
//   //           log("Send message :$content");
//   //         });
//   //       } else {
//   //         log("Send message :$content");
//   //         await FirebaseApi()
//   //             .saveMessage(
//   //                 role: role,
//   //                 receiverName: name,
//   //                 type: type,
//   //                 dateTime: DateTime.now().millisecondsSinceEpoch.toString(),
//   //                 encrypted: content,
//   //                 isSeen: false,
//   //                 newChatId: chatId,
//   //                 pId: userId.toString(),
//   //                 receiverImage: image,
//   //                 senderId: userId.toString())
//   //             .then((value) async {
//   //           await FirebaseApi()
//   //               .saveMessage(
//   //                   role: role,
//   //                   receiverName: name,
//   //                   type: type,
//   //                   dateTime: DateTime.now().millisecondsSinceEpoch.toString(),
//   //                   encrypted: content,
//   //                   isSeen: false,
//   //                   newChatId: chatId,
//   //                   pId: userId.toString(),
//   //                   receiverImage: image,
//   //                   senderId: userModel!.id.toString())
//   //               .then((snap) async {
//   //             await FirebaseApi().saveMessageInUserCollection(
//   //                 senderId: userModel!.id,
//   //                 receiverImage: image,
//   //                 newChatId: chatId,
//   //                 type: type,
//   //                 receiverName: name,
//   //                 content: content,
//   //                 receiverId: userId.toString(),
//   //                 id: userModel!.id,
//   //                 role: role,
//   //                 rToken: token,
//   //                 sToken: userModel!.fcmToken,
//   //                 phone: phone,
//   //                 code: code);
//   //             await FirebaseApi().saveMessageInUserCollection(
//   //                 senderId: userModel!.id,
//   //                 receiverImage: image,
//   //                 newChatId: chatId,
//   //                 type: type,
//   //                 receiverName: name,
//   //                 content: content,
//   //                 receiverId: userId.toString(),
//   //                 id: userId.toString(),
//   //                 role: role,
//   //                 rToken: token,
//   //                 sToken: userModel!.fcmToken,
//   //                 phone: phone,
//   //                 code: code);
//   //           });
//   //         }).then((value) async {
//   //           getChatData(context);
//   //           //FirebaseApi().getLocalMessage(context);
//   //           log("token :$token");
//   //           if (token != "" && token != null) {
//   //             FirebaseApi().sendNotification(
//   //                 title: "${userModel!.name} send you message",
//   //                 msg: content,
//   //                 chatId: chatId,
//   //                 token: token,
//   //                 pId: userId.toString(),
//   //                 image: image ?? "",
//   //                 name: userModel!.name,
//   //                 phone: phone,
//   //                 code: code);
//   //           }
//   //           //await saveNotificationApi(context, content, userId);
//   //         });
//   //       }
//   //     }
//   //   } catch (e) {
//   //     log("Send :$e");
//   //   }
//   // }
//
//   //on clear chat
//   onClearChat(context, sync, chatCtrl) {
//     showLoading(context);
//     notifyListeners();
//     final value = Provider.of<DeleteDialogProvider>(context, listen: false);
//
//     value.onDeleteDialog(sync, context, eImageAssets.clearChat,
//         translations!.clearChat, translations!.areYouClearChat, () async {
//       route.pop(context);
//       await FirebaseApi().clearChat(context);
//       value.onResetPass(
//           context,
//           language(context, translations!.hurrayChatDelete),
//           language(context, translations!.okay),
//           () => Navigator.pop(context));
//     });
//     hideLoading(context);
//     value.notifyListeners();
//   }
// }
