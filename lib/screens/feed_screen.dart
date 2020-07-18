import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/models.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/services/database_service.dart';
import 'package:provider/provider.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  _buildPost(Post post, User author, String currentUserId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProfileScreen(
                userId: post.authorId,
                currentUserId: currentUserId,
                databaseService: Provider.of<DatabaseService>(context),
              ),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14.0,
              vertical: 8.0,
            ),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 18.0,
                  backgroundColor: Colors.grey,
                  backgroundImage: author.profileImageUrl.isEmpty
                      ? AssetImage('assets/images/user_placeholder.jpg')
                      : CachedNetworkImageProvider(author.profileImageUrl),
                ),
                SizedBox(width: 8.0),
                Text(
                  author.name,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: CachedNetworkImageProvider(post.postImageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 2.0,
          ),
          child: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.favorite_border),
                iconSize: 28.0,
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.insert_comment),
                iconSize: 25.0,
                onPressed: () {},
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 14.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '0 likes',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4.0),
              Text(
                '${author.name} ${post.caption}',
                softWrap: true,
              ),
            ],
          ),
        ),
        SizedBox(height: 12.0),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = Provider.of<UserData>(context).currentUserID;

    return Scaffold(
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
      body: StreamBuilder(
        stream:
            Provider.of<DatabaseService>(context).getFeedPosts(currentUserId),
        builder: (_, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return SizedBox.shrink();
          }

          final List<Post> posts = snapshot.data;

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (_, int index) {
              Post post = posts[index];

              return FutureBuilder(
                future: Provider.of<DatabaseService>(context)
                    .getUser(post.authorId),
                builder: (_, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return SizedBox.shrink();
                  }

                  User author = snapshot.data;
                  return _buildPost(post, author, currentUserId);
                },
              );
            },
          );
        },
      ),
    );
  }
}
