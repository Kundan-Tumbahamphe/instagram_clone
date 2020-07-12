import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;
  static final _firestore = Firestore.instance;

  static void signup(
      {@required BuildContext context,
      @required String name,
      @required String email,
      @required String password}) async {
    try {
      AuthResult authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      FirebaseUser signedInUser = authResult.user;
      if (signedInUser != null) {
        await _firestore.collection('users').document(signedInUser.uid).setData(
          {
            'name': name,
            'email': email,
            'profileImageUrl': '',
          },
        );

        Navigator.pop(context);
      }
    } on PlatformException catch (err) {
      print(err.message);
    }
  }

  static void login({@required String email, @required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on PlatformException catch (err) {
      print(err.message);
    }
  }

  static void logout() async {
    await _auth.signOut();
  }
}
