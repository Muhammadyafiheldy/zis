import 'package:cloud_firestore/cloud_firestore.dart';

// PASTIKAN IMPORT INI SESUAI DENGAN LOKASI FILE MODEL KAMU
import 'package:zis/model/user_model.dart'; // Diambil dari kodemu yang sebelumnya
import 'package:zis/model/program.dart';

class FirestoreService {
  // ==========================================
  // 1. DATABASE UNTUK USER (AKUN & ROLE)
  // ==========================================
  final CollectionReference<Map<String, dynamic>> userCollection =
      FirebaseFirestore.instance.collection('users');

  // Fungsi menambahkan user dengan ID spesifik (UID dari Firebase Auth saat Register)
  Future<void> addUserWithId(String uid, User user) {
    return userCollection.doc(uid).set(user.toMap());
  }

  // Fungsi menambahkan user (create)
  Future<void> addUser(User user) {
    return userCollection.add(user.toMap());
  }

  // Fungsi membaca user (read)
  Stream<List<User>> getUsers() {
    return userCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        // Casting as Map<String, dynamic> untuk memastikan tipe data terbaca dengan benar
        return User.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // Fungsi memperbarui user (update)
  Future<void> updateUser(String id, User user) {
    return userCollection.doc(id).update(user.toMap());
  }

  // Fungsi menghapus user (delete)
  Future<void> deleteUser(String id) {
    return userCollection.doc(id).delete();
  }

  // ==========================================
  // 2. DATABASE UNTUK PROGRAM ZIS (ADMIN CRUD)
  // ==========================================
  final CollectionReference<Map<String, dynamic>> programCollection =
      FirebaseFirestore.instance.collection('programs');

  // CREATE: Tambah program baru ke database
  Future<void> addProgram(ProgramZis program) {
    return programCollection.add(program.toMap());
  }

  // READ: Mengambil semua data program secara langsung (Real-time)
  Stream<List<ProgramZis>> getPrograms() {
    return programCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ProgramZis.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  // UPDATE: Mengubah data program yang sudah ada
  Future<void> updateProgram(String id, ProgramZis program) {
    return programCollection.doc(id).update(program.toMap());
  }

  // DELETE: Menghapus program dari database
  Future<void> deleteProgram(String id) {
    return programCollection.doc(id).delete();
  }
}