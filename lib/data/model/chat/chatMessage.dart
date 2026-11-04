import 'dart:convert';

import 'package:edemand_partner/app/generalImports.dart';

enum ChatMessageType { textMessage, imageMessage, fileMessage }

enum ChatSenderType {
  admin,
  provider,
  customer,
  handyman;

  static ChatSenderType fromValue(String? value) {
    switch (value) {
      case '0':
        return ChatSenderType.admin;
      case '1':
        return ChatSenderType.provider;
      case '2':
        return ChatSenderType.customer;
      case '3':
        return ChatSenderType.handyman;
      default:
        return ChatSenderType.customer;
    }
  }
}

class MessageDocument {
  final String fileName;
  final int fileSize;
  final String fileType;
  final String fileUrl;

  MessageDocument({
    required this.fileName,
    required this.fileSize,
    required this.fileType,
    required this.fileUrl,
  });

  String get getFileSizeString {
    const suffixes = ["B", "KB", "MB", "GB", "TB"];
    if (fileSize == 0) return '0 ${suffixes[0]}';
    final i = (log(fileSize) / log(1024)).floor();
    return "${(fileSize / pow(1024, i)).toStringAsFixed(0)} ${suffixes[i]}";
  }

  factory MessageDocument.fromJson(Map<String, dynamic> json) {
    return MessageDocument(
      fileName: json['file_name'] ?? '',
      fileSize: json['file_size'] ?? 0,
      fileType: json['file_type'] ?? '',
      fileUrl: json['file'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'file_name': fileName,
      'file_size': fileSize,
      'file_type': fileType,
      'file': fileUrl,
    };
  }

  @override
  String toString() {
    return 'Document(fileName: $fileName, fileSize: $fileSize, fileType: $fileType, fileUrl: $fileUrl)';
  }
}

class SenderDetails {
  final int id;
  final String name;
  final String profile;
  final String role;

  // Separate from `profile` (`image` key): FCM chat payloads carry the
  // sender's photo as `profile_image` instead.
  final String profileImage;

  SenderDetails({
    required this.id,
    required this.name,
    required this.profile,
    required this.role,
    this.profileImage = '',
  });

  factory SenderDetails.fromJson(Map<String, dynamic> json) {
    return SenderDetails(
      id: int.parse((json['id'] ?? "0").toString()),
      name: json['username'] ?? '',
      profile: json['image'] ?? '',
      role: json['role'] ?? '',
      profileImage: json['profile_image']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profile': profile,
      'role': role,
      'profile_image': profileImage,
    };
  }

  @override
  String toString() {
    return 'SenderDetails(id: $id, name: $name, profile: $profile, role: $role, profileImage: $profileImage)';
  }
}

class ChatMessage {
  String id;
  DateTime sendOrReceiveDateTime;
  String senderId;
  String? receiverId;
  bool isLocallyStored;
  String message;
  ChatMessageType messageType;
  List<MessageDocument> files;
  SenderDetails senderDetails;
  ChatSenderType senderType;

  ChatMessage({
    required this.id,
    required this.sendOrReceiveDateTime,
    required this.senderId,
    required this.isLocallyStored,
    required this.message,
    required this.files,
    required this.senderDetails,
    this.receiverId,
    this.messageType = ChatMessageType.textMessage,
    this.senderType = ChatSenderType.customer,
  });

  //this constructor will return proper message type according to the data provided
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    ChatMessageType messageType = ChatMessageType.textMessage;

    final List<MessageDocument> documents = [];
    if (((json["file"] ?? []) as List).isNotEmpty) {
      documents.addAll(
        (json["file"] as List).map((e) => MessageDocument.fromJson(e)).toList(),
      );
      bool isThereAnyFile = false;
      for (int i = 0; i < documents.length; i++) {
        if (!documents[i].fileUrl.isImage()) {
          isThereAnyFile = true;
        }
      }
      if (isThereAnyFile) {
        messageType = ChatMessageType.fileMessage;
      } else {
        messageType = ChatMessageType.imageMessage;
      }
    }

    return ChatMessage(
      files: documents,
      id: json['id']?.toString() ?? "0",
      message: json['message']?.toString() ?? '',
      messageType: messageType,
      sendOrReceiveDateTime:
          DateTime.tryParse(json['created_at']?.toString() ?? '')?.toLocal() ??
          DateTime.now(),
      senderId: json['sender_id']?.toString() ?? "0",
      isLocallyStored: false,
      receiverId: json['receiver_id']?.toString(),
      // FCM chat payloads put sender fields (username/profile_image/...) at
      // the top level instead of nesting them under sender_details like the
      // REST API does.
      senderDetails: SenderDetails.fromJson(json['sender_details'] ?? json),
      senderType: ChatSenderType.fromValue(json['sender_type']?.toString()),
    );
  }

  ChatMessage copyWith({
    String? id,
    DateTime? sendOrReceiveDateTime,
    String? senderId,
    bool? isLocallyStored,
    String? message,
    List<MessageDocument>? files,
    ChatSenderType? senderType,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      sendOrReceiveDateTime:
          sendOrReceiveDateTime ?? this.sendOrReceiveDateTime,
      senderId: senderId ?? this.senderId,
      isLocallyStored: isLocallyStored ?? this.isLocallyStored,
      message: message ?? this.message,
      files: files ?? this.files,
      senderDetails: senderDetails,
      senderType: senderType ?? this.senderType,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'sendOrReceiveDateTime': sendOrReceiveDateTime.millisecondsSinceEpoch,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'is_locally_stored': isLocallyStored,
      'message': message,
      'files': files.map((e) => e.toJson()).toList(),
      'sender_details': senderDetails.toJson(),
      'sender_type': senderType.name,
    };
  }

  String toJsonString() => json.encode(toJson());

  @override
  String toString() {
    return 'ChatMessage(id: $id, sendOrReceiveDateTime: $sendOrReceiveDateTime, senderId: $senderId, isLocallyStored: $isLocallyStored, message: $message, files: $files)';
  }
}
