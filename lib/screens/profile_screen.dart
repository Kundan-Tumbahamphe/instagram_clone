import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/models.dart';
import 'package:instagram_clone/screens/edit_profile_screen.dart';
import 'package:instagram_clone/services/database_service.dart';
import 'package:instagram_clone/utilities/constants.dart';
import 'package:instagram_clone/widgets/post_view.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;
  final String currentUserId;
  final DatabaseService databaseService;

  const ProfileScreen(
      {@required this.userId,
      this.currentUserId,
      @required this.databaseService});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isFollowing = false;
  int _followerCount = 0;
  int _followingCount = 0;
  List<Post> _posts = [];
  int _displayPosts = 0;
  User _profileUser;

  @override
  void initState() {
    super.initState();
    _setupIsFollowing();
    _setupFollowerCount();
    _setupFollowingCount();
    _setupPosts();
    _setupProfileUser();
  }

  _setupIsFollowing() async {
    if (widget.currentUserId != null) {
      bool isFollowingUser = await widget.databaseService.isFollowingUser(
          currentUserId: widget.currentUserId, userId: widget.userId);

      setState(() {
        _isFollowing = isFollowingUser;
      });
    }
  }

  _setupFollowerCount() async {
    int userFollowersCount =
        await widget.databaseService.numFollowers(widget.userId);

    setState(() {
      _followerCount = userFollowersCount;
    });
  }

  _setupFollowingCount() async {
    int userFollowingCount =
        await widget.databaseService.numFollowing(widget.userId);

    setState(() {
      _followingCount = userFollowingCount;
    });
  }

  _setupPosts() async {
    List<Post> posts = await widget.databaseService.getUserPosts(widget.userId);

    setState(() {
      _posts = posts;
    });
  }

  _setupProfileUser() async {
    User profileUser = await widget.databaseService.getUser(widget.userId);

    setState(() {
      _profileUser = profileUser;
    });
  }

  _followOrUnfollow() {
    if (_isFollowing) {
      _unfollowUser();
    } else {
      _followUser();
    }
  }

  _followUser() {
    widget.databaseService
        .followUser(currentUserId: widget.currentUserId, userId: widget.userId);

    setState(() {
      _isFollowing = true;
      _followerCount++;
    });
  }

  _unfollowUser() {
    widget.databaseService.unfollowUser(
        currentUserId: widget.currentUserId, userId: widget.userId);

    setState(() {
      _isFollowing = false;
      _followerCount--;
    });
  }

  _displayButton(User user) {
    return user.id ==
            Provider.of<UserData>(context, listen: false).currentUserID
        ? Container(
            width: double.infinity,
            child: FlatButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => EditProfileScreen(user: user)),
              ),
              child: Text(
                'Edit Profile',
                style: const TextStyle(fontSize: 15.0),
              ),
              color: Colors.blue,
              textColor: Colors.white,
            ),
          )
        : Container(
            width: double.infinity,
            child: FlatButton(
              onPressed: _followOrUnfollow,
              child: Text(
                _isFollowing ? 'Unfollow' : 'Follow',
                style: TextStyle(
                  fontSize: 15.0,
                  color: _isFollowing ? Colors.black : Colors.white,
                ),
              ),
              color: _isFollowing ? Colors.grey[200] : Colors.blue,
              textColor: Colors.white,
            ),
          );
  }

  _buildProfileInfo(User user) {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          width: double.infinity,
          child: Row(
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage: user.profileImageUrl.isEmpty
                    ? AssetImage('assets/images/user_placeholder.jpg')
                    : CachedNetworkImageProvider(user.profileImageUrl),
                radius: 42.0,
              ),
              const SizedBox(width: 40.0),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text(
                              '12',
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Posts',
                              style: const TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              '$_followerCount',
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Followers',
                              style: const TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              '$_followingCount',
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Following',
                              style: const TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    _displayButton(user),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 70.0,
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                user.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                user.bio,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  _buildToggleButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.grid_on),
          onPressed: () {
            setState(() {
              _displayPosts = 0;
            });
          },
          iconSize: 24.0,
          color: _displayPosts == 0 ? Colors.blue : Colors.grey[300],
        ),
        IconButton(
          icon: Icon(Icons.list),
          onPressed: () {
            setState(() {
              _displayPosts = 1;
            });
          },
          iconSize: 26.0,
          color: _displayPosts == 1 ? Colors.blue : Colors.grey[300],
        ),
      ],
    );
  }

  _buildTile(Post post) {
    return GridTile(
      child: GestureDetector(
        onTap: () => {},
        child: Image(
          image: CachedNetworkImageProvider(post.postImageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  _buildDisplayPosts() {
    if (_displayPosts == 0) {
      List<GridTile> tiles = [];
      _posts.forEach(
        (post) => tiles.add(_buildTile(post)),
      );

      return GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        mainAxisSpacing: 2.0,
        crossAxisSpacing: 2.0,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: tiles,
      );
    } else {
      List<PostView> postViews = [];
      _posts.forEach((post) {
        postViews.add(PostView(
          post: post,
          author: _profileUser,
          currentUserId: widget.currentUserId,
        ));
      });
      return Column(children: postViews);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Instagram',
          style: const TextStyle(
            color: Colors.black,
            fontFamily: 'Billabong',
            fontSize: 30.0,
          ),
        ),
      ),
      body: FutureBuilder(
        future: usersRef.document(widget.userId).get(),
        builder: (_, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final user = User.fromSnapshot(snapshot.data);

          return ListView(
            children: <Widget>[
              _buildProfileInfo(user),
              Divider(),
              _buildToggleButtons(),
              Divider(),
              _buildDisplayPosts(),
            ],
          );
        },
      ),
    );
  }
}
