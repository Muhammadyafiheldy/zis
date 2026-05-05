import 'package:firebase_auth/firebase_auth.dart' as auth;
import '../model/user_model.dart';
import 'firestore_service.dart';

class AuthService {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();

  // 1. Fungsi REGISTER
  Future<String?> register(String nama, String email, String password) async {
    try {
      auth.UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      String uid = userCredential.user!.uid;

      // Default role: 'user'
      User penggunaBaru = User(name: nama, email: email, role: 'user');

      await _firestoreService.addUserWithId(uid, penggunaBaru);
      return "Sukses";
    } on auth.FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return "Terjadi kesalahan: $e";
    }
  }

  // 2. Fungsi LOGIN
  Future<String?> login(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return "Sukses";
    } on auth.FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return "Terjadi kesalahan: $e";
    }
  }

  // 3. Fungsi LOGOUT
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }
}
