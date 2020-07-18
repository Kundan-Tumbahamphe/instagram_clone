import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class Post {
  final String id;
  final String postImageUrl;
  final String caption;
  final int likeCount;
  final String authorId;
  final Timestamp timestamp;

  const Post({
    this.id,
    @required this.postImageUrl,
    @required this.caption,
    @required this.likeCount,
    @required this.authorId,
    @required this.timestamp,
  });

  @override
  String toString() => '''Post (
    id: $id,
    postImageUrl: $postImageUrl,
    caption: $caption,
    likeCount: $likeCount,
    authorId: $authorId,
    timestamp: $timestamp,
  )''';

  factory Post.fromSnapshot(DocumentSnapshot doc) {
    return Post(
      id: doc.documentID,
      postImageUrl: doc['postImageUrl'],
      caption: doc['caption'],
      likeCount: doc['likeCount'] ?? 0,
      authorId: doc['authorId'],
      timestamp: doc['timestamp'],
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'postImageUrl': postImageUrl,
      'caption': caption,
      'likeCount': likeCount,
      'authorId': authorId,
      'timestamp': timestamp,
    };
  }
}
