import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/user_model.dart';

class FirestoreService {
  final CollectionReference<Map<String, dynamic>> userCollection =
      FirebaseFirestore.instance.collection('users');

  // fungsi menambahkan user dengan ID spesifik (UID dari Firebase Auth)
  Future<void> addUserWithId(String uid, User user) {
    return userCollection.doc(uid).set(user.toMap());
  }

  // fungsi menambahkan user (create)
  Future<void> addUser(User user) {
    return userCollection.add(user.toMap());
  }

  // fungsi membaca user (read)
  Stream<List<User>> getUsers() {
    return userCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return User.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // fungsi memperbarui user (update)
  Future<void> updateUser(String id, User user) {
    return userCollection.doc(id).update(user.toMap());
  }

  // fungsi menghapus user (delete)
  Future<void> deleteUser(String id) {
    return userCollection.doc(id).delete();
  }
}
