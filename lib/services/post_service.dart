import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/widgets.dart';
import 'package:social_media_chat_flutter/common/const.dart';

class Post {
  static final CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection(K.postsListKey);
  static final _user = FirebaseAuth.instance.currentUser;
  static final _storage = firebase_storage.FirebaseStorage.instance;

  // get a stream of snapshots from a firebase firestore (for loading data in realtime)
  static Stream<QuerySnapshot<Object?>> get streamPosts =>
      _collectionReference.orderBy(K.timestampKey).snapshots();

  static Stream<QuerySnapshot<Object?>> streamChat({required String forId}) =>
      _collectionReference
          .doc(forId)
          .collection(K.chatKey)
          .orderBy(K.timestampKey)
          .snapshots();

  // send post
  static Future<void> sendPost(
      {required String description, required File image}) async {
    late String imageURL;

    // put image file to firebase storage
    await _storage
        .ref("image/${UniqueKey().toString()}.jpeg")
        .putFile(image)
        .then((taskSnapshot) async {
      // get a link to image file
      imageURL = await taskSnapshot.ref.getDownloadURL();
    });

    // add post to collection in firebase firestore
    _collectionReference.add({
      K.uidKey: _user!.uid,
      K.descriptionKey: description,
      K.timestampKey: Timestamp.now(),
      K.usernameKey: _user!.displayName,
      K.imageKey: imageURL,
      K.postIdKey: "await docReference.id",
    }).then(
        (docReference) => docReference.update({K.postIdKey: docReference.id}));
  }

  // add message to chat at the post
  static Future<void> sendChatMessage(
      {required String postId, required String message}) async {
    _collectionReference.doc(postId).collection(K.chatKey).add({
      K.uidKey: _user!.uid,
      K.usernameKey: _user!.displayName,
      K.messageKey: message,
      K.timestampKey: Timestamp.now(),
    });
  }

  static bool isThisUser(String uid) => uid == _user!.uid;
}
