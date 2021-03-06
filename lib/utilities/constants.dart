import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final _firestore = Firestore.instance;
final CollectionReference usersRef = _firestore.collection('users');
final CollectionReference postsRef = _firestore.collection('posts');
final CollectionReference followersRef = _firestore.collection('followers');
final CollectionReference followingRef = _firestore.collection('following');
final CollectionReference feedsRef = _firestore.collection('feeds');
final CollectionReference likesRef = _firestore.collection('likes');
final CollectionReference commentsRef = _firestore.collection('comments');
final CollectionReference activitiesRef = _firestore.collection('activities');

final FirebaseStorage _storage = FirebaseStorage.instance;
final StorageReference storageRef = _storage.ref();
