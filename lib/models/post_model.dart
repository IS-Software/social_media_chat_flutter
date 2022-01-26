import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media_chat_flutter/common/const.dart';

class PostModel {
  final String postId;
  final String userId;
  final String username;
  final Timestamp timestamp;
  final String imageURL;
  final String description;

  PostModel({
    required this.postId,
    required this.userId,
    required this.username,
    required this.timestamp,
    required this.imageURL,
    required this.description,
  });

  factory PostModel.fromSnapshot(doc) => PostModel(
        postId: doc[K.postIdKey] as String,
        userId: doc[K.uidKey] as String,
        username: doc[K.usernameKey] as String,
        timestamp: doc[K.timestampKey] as Timestamp,
        imageURL: doc[K.imageKey] as String,
        description: doc[K.descriptionKey] as String,
      );
}
