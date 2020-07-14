import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String bio;
  final String profileImageUrl;

  const User({
    this.id,
    @required this.name,
    @required this.email,
    @required this.bio,
    @required this.profileImageUrl,
  });

  @override
  String toString() => '''User (
    name: $name,
    email: $email,
    bio: $bio,
    profileImageUrl: $profileImageUrl,
  )''';

  factory User.fromSnapshot(DocumentSnapshot doc) {
    return User(
      id: doc.documentID,
      name: doc['name'],
      email: doc['email'],
      bio: doc['bio'] ?? '',
      profileImageUrl: doc['profileImageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'name': name,
      'email': email,
      'bio': bio,
      'profileImageUrl': profileImageUrl,
    };
  }
}
