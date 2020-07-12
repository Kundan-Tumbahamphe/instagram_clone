import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:instagram_clone/screens/screens.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  _getScreen() {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (_, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return FeedScreen();
        } else {
          return LoginScreen();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Instagram Clone',
      debugShowCheckedModeBanner: false,
      routes: {
        LoginScreen.id: (context) => LoginScreen(),
        SignupScreen.id: (context) => SignupScreen(),
        FeedScreen.id: (context) => FeedScreen(),
      },
      home: _getScreen(),
    );
  }
}
