import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/models/user_model.dart';
import 'package:instagram_clone/utilities/constants.dart';

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
}
