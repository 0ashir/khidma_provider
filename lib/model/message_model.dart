class DateTimeChip {
  String? time;
  List<MessageModel>? message;

  DateTimeChip({this.time, this.message});

  DateTimeChip.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    if (json['message'] != null) {
      message = <MessageModel>[];
      json['message'].forEach((v) {
        message!.add(MessageModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['time'] = time;
    if (message != null) {
      data['message'] = message!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MessageModel {
  String? senderId,
      senderName,
      receiverId,
      timestamp,
      type,
      bookingId,
      receiverName,
      messageType,
      chatId,
      senderImage,
      receiverImage,
      bookingNumber,
      receiverToken,
      senderToken,
      docId,
      role;
  bool? isSeen;
  bool? isOffer; // Added isOffer field
  dynamic content;

  MessageModel({
    this.senderId,
    this.senderName,
    this.content,
    this.bookingNumber,
    this.timestamp,
    this.type,
    this.chatId,
    this.messageType,
    this.isSeen = false,
    this.isOffer = false, // Default to false
    this.docId,
    this.receiverId,
    this.receiverToken,
    this.senderToken,
    this.receiverImage,
    this.bookingId,
    this.receiverName,
    this.senderImage,
    this.role,
  });

  MessageModel.fromJson(Map<String, dynamic> json) {
    senderId = json["senderId"]?.toString() ?? '';
    senderName = json['senderName'] ?? '';
    receiverId = json['receiverId']?.toString() ?? '';
    content = json['content'] ?? '';
    timestamp = json['timestamp']?.toString() ?? '';
    receiverToken = json['receiverToken'];
    senderToken = json['senderToken'];
    bookingNumber = json['bookingNumber'];
    docId = json['docId'] ?? '';
    type = json['type'] ?? '';
    bookingNumber = json['bookingNumber'] ?? '';
    chatId = json['chatId'] ?? '';
    messageType = json['messageType'] ?? '';
    receiverName = json['receiverName'] ?? '';
    role = json['role'] ?? '';
    receiverImage = json['receiverImage'] ?? '';
    senderImage = json['senderImage'] ?? '';
    isSeen = json['isSeen'] ?? false;
    isOffer = json['isOffer'] ?? false; // Read isOffer from Firestore
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['senderId'] = senderId;
    data['senderName'] = senderName;
    data['receiverId'] = receiverId;
    data['content'] = content;
    data['timestamp'] = timestamp;
    data['bookingNumber'] = bookingNumber;
    data['docId'] = docId;
    data['type'] = type;
    data['chatId'] = chatId;
    data['senderToken'] = senderToken;
    data['messageType'] = messageType;
    data['receiverToken'] = receiverToken;
    data['senderImage'] = senderImage;
    data['receiverImage'] = receiverImage;
    data['receiverName'] = receiverName;
    data['bookingNumber'] = bookingNumber;
    data['role'] = role;
    data['isSeen'] = isSeen;
    data['isOffer'] = isOffer; // Save isOffer to Firestore
    return data;
  }
}

// class MessageModel {
//   String? senderId,
//       senderName,
//       receiverId,
//       timestamp,
//       type,
//       receiverName,
//       messageType,
//       chatId,
//       senderImage,
//       receiverImage,
//       receiverToken,
//       senderToken,
//       docId,
//       role;
//   bool? isSeen;
//   dynamic content;
//
//   MessageModel(
//       {this.senderId,
//       this.senderName,
//       this.content,
//       this.timestamp,
//       this.type,
//       this.chatId,
//       this.messageType,
//       this.isSeen = false,
//       this.docId,
//       this.receiverId,
//       this.receiverToken,
//       this.senderToken,
//       this.receiverImage,
//       this.receiverName,
//       this.senderImage,
//       this.role});
//
//   MessageModel.fromJson(Map<String, dynamic> json) {
//     senderId = json["senderId"].toString();
//     senderName = json['senderName'] ?? '';
//     receiverId = json['receiverId'].toString();
//     content = json['content'] ?? '';
//     timestamp = json['timestamp'];
//     receiverToken = json['receiverToken'];
//     senderToken = json['senderToken'];
//     docId = json['docId'];
//     type = json['type'] ?? '';
//     chatId = json['chatId'] ?? '';
//     messageType = json['messageType'] ?? "";
//     receiverName = json['receiverName'] ?? "";
//     role = json['role'] ?? "";
//     receiverImage = json['receiverImage'] ?? "";
//     senderImage = json['senderImage'] ?? "";
//
//     isSeen = json['isSeen'] ?? false;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['senderId'] = senderId;
//     data['senderName'] = senderName;
//     data['receiverId'] = receiverId;
//     data['content'] = content;
//     data['timestamp'] = timestamp;
//     data['docId'] = docId;
//     data['type'] = type;
//     data['chatId'] = chatId;
//     data['senderToken'] = senderToken;
//     data['messageType'] = messageType;
//     data['receiverToken'] = receiverToken;
//     data['senderImage'] = senderImage;
//     data['receiverImage'] = receiverImage;
//     data['receiverName'] = receiverName;
//     data['role'] = role;
//
//     data['isSeen'] = isSeen;
//
//     return data;
//   }
// }
