import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/models.dart';
import 'package:instagram_clone/models/user_data.dart';
import 'package:instagram_clone/screens/comment_screen.dart';
import 'package:instagram_clone/services/database_service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ActivityScreen extends StatefulWidget {
  final String currentUserId;

  const ActivityScreen({@required this.currentUserId});

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  _buildActivity(Activity activity) {
    return FutureBuilder(
      future: Provider.of<DatabaseService>(context, listen: false)
          .getUser(activity.fromUserId),
      builder: (_, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return SizedBox.shrink();
        }

        User user = snapshot.data;

        return ListTile(
          leading: CircleAvatar(
            radius: 18.0,
            backgroundColor: Colors.grey,
            backgroundImage: user.profileImageUrl.isEmpty
                ? AssetImage('assets/images/user_placeholder.jpg')
                : CachedNetworkImageProvider(user.profileImageUrl),
          ),
          title: activity.content != null
              ? Text('${user.name} commented: "${activity.content}"')
              : Text('${user.name} liked your post.'),
          subtitle: Text(
            DateFormat.yMd().add_jm().format(activity.timestamp.toDate()),
          ),
          trailing: CachedNetworkImage(
            imageUrl: activity.postImageUrl,
            height: 38.0,
            width: 38.0,
            fit: BoxFit.cover,
          ),
          onTap: () async {
            Post post =
                await Provider.of<DatabaseService>(context, listen: false)
                    .getUserPost(
              userId:
                  Provider.of<UserData>(context, listen: false).currentUserID,
              postId: activity.postId,
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CommentScreen(post: post),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
            .getActivities(widget.currentUserId),
        builder: (_, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return SizedBox.shrink();
          }

          List<Activity> activities = snapshot.data;

          return ListView.builder(
            itemCount: activities.length,
            itemBuilder: (_, int index) {
              Activity activity = activities[index];
              return _buildActivity(activity);
            },
          );
        },
      ),
    );
  }
}
