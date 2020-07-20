import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/models.dart';
import 'package:instagram_clone/services/database_service.dart';
import 'package:instagram_clone/utilities/constants.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommentScreen extends StatefulWidget {
  final Post post;

  const CommentScreen({@required this.post});

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final _commentController = TextEditingController();
  bool _isCommenting = false;

  _buildComment(Comment comment) {
    return FutureBuilder(
      future: Provider.of<DatabaseService>(context, listen: false)
          .getUser(comment.authorId),
      builder: (_, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return SizedBox.shrink();
        }

        User author = snapshot.data;
        return ListTile(
          leading: CircleAvatar(
            radius: 22.0,
            backgroundColor: Colors.grey,
            backgroundImage: author.profileImageUrl.isEmpty
                ? AssetImage('assets/images/user_placeholder.jpg')
                : CachedNetworkImageProvider(author.profileImageUrl),
          ),
          title: Text(author.name,
              style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(comment.content, style: TextStyle(fontSize: 13.0)),
              SizedBox(height: 5.0),
              Text(DateFormat.yMd().add_jm().format(comment.timestamp.toDate()),
                  style: TextStyle(fontSize: 12.0)),
            ],
          ),
        );
      },
    );
  }

  _buildCommentTF() {
    return Container(
      margin: EdgeInsets.only(left: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _commentController,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (comment) {
                setState(() {
                  _isCommenting = comment.trim().length > 0;
                });
              },
              decoration:
                  InputDecoration.collapsed(hintText: 'Add a comment...'),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.send,
              color: _isCommenting ? Colors.blue : Colors.grey[400],
            ),
            onPressed: () {
              if (_isCommenting) {
                Provider.of<DatabaseService>(context, listen: false)
                    .commentOnPost(
                  currentUserId: Provider.of<UserData>(context, listen: false)
                      .currentUserID,
                  post: widget.post,
                  content: _commentController.text,
                );
                _commentController.clear();
                setState(() {
                  _isCommenting = false;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Comments',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.0,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          StreamBuilder(
            stream: commentsRef
                .document(widget.post.id)
                .collection('postComments')
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (_, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return SizedBox.shrink();
              }

              return Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (_, int index) {
                    final comment =
                        Comment.fromSnapshot(snapshot.data.documents[index]);

                    return _buildComment(comment);
                  },
                ),
              );
            },
          ),
          Divider(height: 1.0),
          _buildCommentTF(),
        ],
      ),
    );
  }
}
