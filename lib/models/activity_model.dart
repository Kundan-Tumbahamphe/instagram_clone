import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class Activity {
  final String id;
  final String fromUserId;
  final String postId;
  final String postImageUrl;
  final String content;
  final Timestamp timestamp;

  const Activity(
      {this.id,
      @required this.fromUserId,
      @required this.postId,
      @required this.postImageUrl,
      @required this.content,
      @required this.timestamp});

  factory Activity.fromSnapshot(DocumentSnapshot doc) {
    return Activity(
      id: doc.documentID,
      fromUserId: doc['fromUserId'],
      postId: doc['postId'],
      postImageUrl: doc['postImageUrl'],
      content: doc['content'],
      timestamp: doc['timestamp'],
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'fromUserId': fromUserId,
      'postId': postId,
      'postImageUrl': postImageUrl,
      'content': content,
      'timestamp': timestamp,
    };
  }

  @override
  String toString() => '''Activity (
    fromUserId: $fromUserId,
    postId: $postId,
    postImageUrl: $postImageUrl,
    content: $content,
    timestamp: $timestamp,
  )''';
}
