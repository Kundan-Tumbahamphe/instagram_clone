const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.onFollowUser = functions.firestore.document('/followers/{userId}/userFollowers/{followerId}').onCreate(
  async (snapshot, context) => {
    const userId = context.params.userId;
    const followerId = context.params.followerId;

    const followedUserPostRef = admin.firestore().collection('posts').doc(userId).collection('userPost');

    const followerUserFeedRef = admin.firestore().collection('feeds').doc(followerId).collection('userFeed');

    const followedUserPostQuerySnapshot = await followedUserPostRef.get();
    followedUserPostQuerySnapshot.forEach(
      doc => {
        if (doc.exists) {
          followerUserFeedRef.doc(doc.id).set(doc.data());
        }
      }
    );
  }
);

exports.onUnfollowUser = functions.firestore.document('/followers/{userId}/userFollowers/{followerId}').onDelete(
  async (snapshot, context) => {
    const userId = context.params.userId;
    const followerId = context.params.followerId;

    const followerUserFeedRef = admin.firestore().collection('feeds').doc(followerId).collection('userFeed').where('authorId', '==', userId);

    const followerUserPostQuerySnapshot = await followerUserFeedRef.get();
    followerUserPostQuerySnapshot.forEach(
      doc => {
        if (doc.exists) {
          doc.ref.delete();
        }
      }
    );
  }
);

exports.onUploadPost = functions.firestore.document('/posts/{userId}/userPost/{postId}').onCreate(
  async (snapshot, context) => {
    const userId = context.params.userId;
    const postId = context.params.postId;

    const userFollowersRef = admin.firestore().collection('followers').doc(userId).collection('userFollowers');

    const userFollowersQuerySnapshot = await userFollowersRef.get();
    userFollowersQuerySnapshot.forEach(
      doc => {
        admin.firestore().collection('feeds').doc(doc.id).collection('userFeed').doc(postId).set(snapshot.data());
      }
    );
  }
);


