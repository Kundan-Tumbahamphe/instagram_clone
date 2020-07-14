import 'package:instagram_clone/models/user_data.dart';
import 'package:provider/provider.dart';

import 'services/services.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/home_screen.dart';
import 'package:instagram_clone/screens/login_screen.dart';

void main() => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<UserData>(
            create: (_) => UserData(),
          ),
          Provider<AuthService>(
            create: (_) => AuthService(),
          ),
          Provider<DatabaseService>(
            create: (_) => DatabaseService(),
          ),
          Provider<StorageService>(
            create: (_) => StorageService(),
          )
        ],
        child: MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Instagram Clone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryIconTheme:
            Theme.of(context).primaryIconTheme.copyWith(color: Colors.black),
      ),
      home: _getScreen(context),
    );
  }

  _getScreen(BuildContext context) {
    return StreamBuilder(
      stream: Provider.of<AuthService>(context, listen: false).user,
      builder: (_, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          Provider.of<UserData>(context, listen: false).currentUserID =
              snapshot.data.uid;
          return HomeScreen();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
