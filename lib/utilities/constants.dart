import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final _firestore = Firestore.instance;
final CollectionReference usersRef = _firestore.collection('users');

final FirebaseStorage _storage = FirebaseStorage.instance;
final StorageReference storageRef = _storage.ref();
