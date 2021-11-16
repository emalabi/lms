import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:lms/models/userModel.dart';
import 'package:lms/service/database.dart';

class Auth {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseMessaging _fcm;

  Future<String> signOut() async {
    String retVal = "error";

    try {
      await _auth.signOut();
      retVal = "success";
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<String> signUpUser({UserModel user}) async {
    String retVal = "error";
    try {
      UserCredential _authResult = await _auth.createUserWithEmailAndPassword(
          email: user.email.trim(), password: user.password);
      UserModel _user = UserModel(
        uid: _authResult.user.uid,
        email: _authResult.user.email,
        username: user.username,
        role: user.role,
        imageUrl: user.imageUrl,
        createdAt: Timestamp.now(),
        notifToken: await _fcm.getToken(),
      );
      String _returnString =
          await Database(uid: _user.uid).updateUserData(_user);
      if (_returnString == "success") {
        retVal = "success";
      }
    } on PlatformException catch (e) {
      retVal = e.message;
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> loginUserWithEmail({String email, String password}) async {
    String retVal = "error";

    try {
      await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password);
    } on PlatformException catch (e) {
      retVal = e.message;
    } catch (e) {
      print(e);
    }

    return retVal;
  }
}
