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

  Future<List<Post>> getUserPosts(String userId) async {
    QuerySnapshot userPostsQuerySnapshot = await postsRef
        .document(userId)
        .collection('userPost')
        .orderBy('timestamp', descending: true)
        .getDocuments();

    List<Post> posts = userPostsQuerySnapshot.documents
        .map((doc) => Post.fromSnapshot(doc))
        .toList();
    return posts;
  }

  Future<User> getUser(String userId) async {
    DocumentSnapshot userDocSnapshot = await usersRef.document(userId).get();
    return User.fromSnapshot(userDocSnapshot);
  }

  Future<void> likePost(
      {@required String currentUserId, @required Post post}) async {
    DocumentReference postDocRef = postsRef
        .document(post.authorId)
        .collection('userPost')
        .document(post.id);

    await postDocRef.get().then((doc) async {
      int likeCount = doc.data['likeCount'] ?? 0;
      postDocRef.updateData({'likeCount': likeCount + 1});

      await likesRef
          .document(post.id)
          .collection('postLikes')
          .document(currentUserId)
          .setData({});
    });
  }

  Future<void> unlikePost(
      {@required String currentUserId, @required Post post}) async {
    DocumentReference postDocRef = postsRef
        .document(post.authorId)
        .collection('userPost')
        .document(post.id);

    await postDocRef.get().then((doc) async {
      int likeCount = doc.data['likeCount'] ?? 0;
      postDocRef.updateData({'likeCount': likeCount - 1});

      await likesRef
          .document(post.id)
          .collection('postLikes')
          .document(currentUserId)
          .get()
          .then((doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      });
    });
  }

  Future<bool> didLikePost(
      {@required String currentUserId, @required Post post}) async {
    DocumentSnapshot doc = await likesRef
        .document(post.id)
        .collection('postLikes')
        .document(currentUserId)
        .get();

    return doc.exists;
  }

  Future<void> commentOnPost(
      {@required String currentUserId,
      @required Post post,
      @required String content}) async {
    final comment = Comment(
      authorId: currentUserId,
      content: content,
      timestamp: Timestamp.fromDate(DateTime.now()),
    );
    await commentsRef
        .document(post.id)
        .collection('postComments')
        .add(comment.toDocument());
  }
}
