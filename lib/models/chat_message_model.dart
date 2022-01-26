import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media_chat_flutter/common/const.dart';

class ChatMessageModel {
  final String userId;
  final String username;
  final String message;
  final Timestamp timestamp;

  ChatMessageModel({
    required this.userId,
    required this.username,
    required this.message,
    required this.timestamp,
  });

  factory ChatMessageModel.fromSnapshot(doc) => ChatMessageModel(
        userId: doc[K.uidKey] as String,
        username: doc[K.usernameKey] as String,
        message: doc[K.messageKey] as String,
        timestamp: doc[K.timestampKey] as Timestamp,
      );
}
