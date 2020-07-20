import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class Comment {
  final String id;
  final String authorId;
  final String content;
  final Timestamp timestamp;

  const Comment({
    this.id,
    @required this.authorId,
    @required this.content,
    @required this.timestamp,
  });

  factory Comment.fromSnapshot(DocumentSnapshot doc) {
    return Comment(
      id: doc.documentID,
      content: doc['content'],
      authorId: doc['authorId'],
      timestamp: doc['timestamp'],
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'authorId': authorId,
      'content': content,
      'timestamp': timestamp,
    };
  }

  @override
  String toString() => '''Comment (
    id: $id,
    authorId: $authorId,
    content: $content,
    timestamp: $timestamp,
  )''';
}
