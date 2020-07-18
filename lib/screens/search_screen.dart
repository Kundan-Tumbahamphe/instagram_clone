import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/models.dart';

import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/services/database_service.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  List<User> _users = [];
  bool _isLoading = false;

  _clearSearch() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _searchController.clear());
    setState(() {
      _users = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
            border: InputBorder.none,
            hintText: 'Search',
            prefixIcon: Icon(
              Icons.search,
              size: 30.0,
            ),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear),
              onPressed: _clearSearch,
            ),
            filled: true,
          ),
          onSubmitted: (input) async {
            if (input.trim().isNotEmpty) {
              setState(() => _isLoading = true);

              List<User> users =
                  await Provider.of<DatabaseService>(context, listen: false)
                      .searchUsers(input);

              setState(() {
                _users = users;
                _isLoading = false;
              });
            }
          },
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: ListView.builder(
                itemCount: _users.length,
                itemBuilder: (_, index) {
                  User user = _users[index];

                  return ListTile(
                    title: Text(user.name),
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: user.profileImageUrl.isEmpty
                          ? AssetImage('assets/images/user_placeholder.jpg')
                          : CachedNetworkImageProvider(user.profileImageUrl),
                      radius: 20.0,
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProfileScreen(
                          userId: user.id,
                          currentUserId:
                              Provider.of<UserData>(context, listen: false)
                                  .currentUserID,
                          databaseService: Provider.of<DatabaseService>(context,
                              listen: false),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
