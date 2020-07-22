import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagram_clone/models/user_data.dart';
import 'package:instagram_clone/screens/screens.dart';
import 'package:instagram_clone/services/database_service.dart';

import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTab = 0;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: <Widget>[
          FeedScreen(),
          SearchScreen(),
          CreatePostScreen(),
          ActivityScreen(
            currentUserId:
                Provider.of<UserData>(context, listen: false).currentUserID,
          ),
          ProfileScreen(
            userId: Provider.of<UserData>(context, listen: false).currentUserID,
            databaseService:
                Provider.of<DatabaseService>(context, listen: false),
          ),
        ],
        onPageChanged: (int index) {
          setState(() {
            _currentTab = index;
          });
        },
      ),
      bottomNavigationBar: CupertinoTabBar(
          currentIndex: _currentTab,
          onTap: (int index) {
            setState(() {
              _currentTab = index;
            });
            _pageController.animateToPage(
              index,
              duration: Duration(milliseconds: 200),
              curve: Curves.easeIn,
            );
          },
          backgroundColor: Colors.white,
          activeColor: Colors.black,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home)),
            BottomNavigationBarItem(icon: Icon(Icons.search)),
            BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.plusSquare, size: 24.0)),
            BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.heart, size: 24.0)),
            BottomNavigationBarItem(icon: Icon(Icons.account_circle)),
          ]),
    );
  }
}
