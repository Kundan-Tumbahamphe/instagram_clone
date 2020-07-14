import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instagram_clone/models/models.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;

  Future<void> signup(
      {@required BuildContext context,
      @required String name,
      @required String email,
      @required String password}) async {
    try {
      AuthResult authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      FirebaseUser signedInUser = authResult.user;
      if (signedInUser != null) {
        final user =
            User(name: name, email: email, bio: null, profileImageUrl: null);

        await _firestore
            .collection('users')
            .document(signedInUser.uid)
            .setData(user.toDocument());

        Navigator.pop(context);
      }
    } on PlatformException catch (err) {
      print(err.message);
    }
  }

  Future<void> login(
      {@required String email, @required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on PlatformException catch (err) {
      print(err.message);
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Stream<FirebaseUser> get user => _auth.onAuthStateChanged;
}
