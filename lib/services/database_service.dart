import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/models/models.dart';

import 'package:instagram_clone/utilities/constants.dart';
import 'package:meta/meta.dart';

class DatabaseService {
  Future<void> updateUser(User user) async {
    await usersRef.document(user.id).updateData(user.toDocument());
  }

  Future<List<User>> searchUsers(String name) async {
    QuerySnapshot usersQuerySnap = await usersRef
        .where('name', isGreaterThanOrEqualTo: name)
        .getDocuments();

    List<User> users = [];
    usersQuerySnap.documents.forEach((doc) {
      User user = User.fromSnapshot(doc);
      users.add(user);
    });
    return users;
  }

  Future<void> createPost(Post post) async {
    await postsRef
        .document(post.authorId)
        .collection('userPost')
        .add(post.toDocument());
  }

  Future<void> followUser(
      {@required String currentUserId, @required String userId}) async {
    await followingRef
        .document(currentUserId)
        .collection('userFollowing')
        .document(userId)
        .setData({});

    await followersRef
        .document(userId)
        .collection('userFollowers')
        .document(currentUserId)
        .setData({});
  }

  Future<void> unfollowUser(
      {@required String currentUserId, @required String userId}) async {
    await followingRef
        .document(currentUserId)
        .collection('userFollowing')
        .document(userId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

    await followersRef
        .document(userId)
        .collection('userFollowers')
        .document(currentUserId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  Future<bool> isFollowingUser(
      {@required String currentUserId, @required String userId}) async {
    DocumentSnapshot doc = await followersRef
        .document(userId)
        .collection('userFollowers')
        .document(currentUserId)
        .get();

    return doc.exists;
  }

  Future<int> numFollowing(String userId) async {
    QuerySnapshot followingQeurySnapshot = await followingRef
        .document(userId)
        .collection('userFollowing')
        .getDocuments();
    return followingQeurySnapshot.documents.length;
  }

  Future<int> numFollowers(String userId) async {
    QuerySnapshot followersQeurySnapshot = await followersRef
        .document(userId)
        .collection('userFollowers')
        .getDocuments();
    return followersQeurySnapshot.documents.length;
  }

  Stream<List<Post>> getFeedPosts(String userId) {
    return feedsRef
        .document(userId)
        .collection('userFeed')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.documents.map((doc) => Post.fromSnapshot(doc)).toList());
  }

  Future<User> getUser(String userId) async {
    DocumentSnapshot userDocSnapshot = await usersRef.document(userId).get();
    return User.fromSnapshot(userDocSnapshot);
  }
}
