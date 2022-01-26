import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:social_media_chat_flutter/common/const.dart';

part "auth_state.dart";

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static Stream<User?> get streamAuth => _auth.userChanges();
  static bool get emailVerified => _auth.currentUser?.emailVerified ?? false;

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      emit(AuthSignedIn());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(AuthError('No user found for that email.'));
      } else if (e.code == 'wrong-password') {
        emit(AuthError('Wrong password provided for that user.'));
      }
    } catch (e) {
      emit(AuthError("An error has occured...\n${e.toString()}"));
    }
  }

  Future<void> signUpWithEmail({
    required String username,
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());

    try {
      // 1. create user
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 2. update DisplayName
      userCredential.user!.updateDisplayName(username);
      // 2.1 send email verification (uncomment it in release)
      userCredential.user!.sendEmailVerification();

      // 3. Write user to users collection
      await _firestore
          .collection(K.usersListKey)
          .doc(userCredential.user!.uid)
          .set({
        K.emailKey: email,
        K.usernameKey: username,
      });

      emit(AuthSignedUp());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(AuthError('The password provided is too weak.'));
      } else if (e.code == 'email-already-in-use') {
        emit(AuthError('The account already exists for that email.'));
      }
    } catch (e) {
      emit(AuthError("An error has occured...\n${e.toString()}"));
      log(e.toString());
    }
  }

  void signOut({required BuildContext context}) {
    emit(AuthLoading());
    _auth.signOut();
    emit(AuthSignOut());
  }
}
