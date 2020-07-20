import 'dart:async';

import 'package:animator/animator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/models.dart';
import 'package:instagram_clone/screens/comment_screen.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/services/database_service.dart';
import 'package:provider/provider.dart';

class PostView extends StatefulWidget {
  final Post post;
  final User author;
  final String currentUserId;
  final DatabaseService databaseService;

  const PostView({
    @required this.post,
    @required this.author,
    @required this.currentUserId,
    @required this.databaseService,
  });

  @override
  _PostViewState createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  int _likeCount = 0;
  bool _isLiked = false;
  bool _heartAnimate = false;

  @override
  void initState() {
    super.initState();
    _likeCount = widget.post.likeCount;
    _initPostLiked();
  }

  @override
  void didUpdateWidget(PostView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.post.likeCount != widget.post.likeCount) {
      _likeCount = widget.post.likeCount;
      _initPostLiked();
    }
  }

  _initPostLiked() async {
    bool isLiked = await widget.databaseService
        .didLikePost(currentUserId: widget.currentUserId, post: widget.post);
    if (mounted) {
      setState(() {
        _isLiked = isLiked;
      });
    }
  }

  _likePost() {
    if (_isLiked) {
      widget.databaseService
          .unlikePost(currentUserId: widget.currentUserId, post: widget.post);

      setState(() {
        _isLiked = false;
        _likeCount = _likeCount - 1;
      });
    } else {
      widget.databaseService
          .likePost(currentUserId: widget.currentUserId, post: widget.post);

      setState(() {
        _isLiked = true;
        _likeCount = _likeCount + 1;
        _heartAnimate = true;
      });
      Timer(Duration(milliseconds: 350), () {
        setState(() {
          _heartAnimate = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProfileScreen(
                userId: widget.post.authorId,
                currentUserId: widget.currentUserId,
                databaseService:
                    Provider.of<DatabaseService>(context, listen: false),
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
                  backgroundImage: widget.author.profileImageUrl.isEmpty
                      ? AssetImage('assets/images/user_placeholder.jpg')
                      : CachedNetworkImageProvider(
                          widget.author.profileImageUrl),
                ),
                SizedBox(width: 8.0),
                Text(
                  widget.author.name,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: _likePost,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(widget.post.postImageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              _heartAnimate
                  ? Animator(
                      duration: Duration(milliseconds: 300),
                      tween: Tween(begin: 0.5, end: 1.4),
                      curve: Curves.elasticOut,
                      builder: (_, anim, __) => Transform.scale(
                        scale: anim.value,
                        child: Icon(
                          Icons.favorite,
                          size: 100.0,
                          color: Colors.red[400],
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 2.0,
          ),
          child: Row(
            children: <Widget>[
              IconButton(
                icon: _isLiked
                    ? Icon(
                        Icons.favorite,
                        color: Colors.red,
                      )
                    : Icon(Icons.favorite_border),
                iconSize: 28.0,
                onPressed: _likePost,
              ),
              IconButton(
                icon: Icon(Icons.insert_comment),
                iconSize: 25.0,
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => CommentScreen(post: widget.post))),
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
                '${_likeCount.toString()} likes',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4.0),
              Text(
                '${widget.author.name} ${widget.post.caption}',
                softWrap: true,
              ),
            ],
          ),
        ),
        SizedBox(height: 12.0),
      ],
    );
  }
}
