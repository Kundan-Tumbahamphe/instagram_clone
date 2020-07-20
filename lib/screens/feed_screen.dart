import 'package:flutter/material.dart';
import 'package:instagram_clone/models/models.dart';
import 'package:instagram_clone/services/database_service.dart';
import 'package:instagram_clone/widgets/post_view.dart';
import 'package:provider/provider.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    final currentUserId =
        Provider.of<UserData>(context, listen: false).currentUserID;

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
        stream: Provider.of<DatabaseService>(context, listen: false)
            .getFeedPosts(currentUserId),
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
                future: Provider.of<DatabaseService>(context, listen: false)
                    .getUser(post.authorId),
                builder: (_, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return SizedBox.shrink();
                  }

                  User author = snapshot.data;

                  return PostView(
                    post: post,
                    author: author,
                    currentUserId: currentUserId,
                    databaseService:
                        Provider.of<DatabaseService>(context, listen: false),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
