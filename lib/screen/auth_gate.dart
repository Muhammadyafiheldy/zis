import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    // Memantau status login secara real-time
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Jika belum login, tampilkan Halaman Login
        if (!snapshot.hasData) {
          return const LoginPage();
        }

        // Jika sudah login, ambil role dari Firestore
        final User currentUser = snapshot.data!;

        return FutureBuilder<DocumentSnapshot>(
          future:
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(currentUser.uid)
                  .get(),
          builder: (context, firestoreSnapshot) {
            // Saat proses mengambil data role
            if (firestoreSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (firestoreSnapshot.hasData && firestoreSnapshot.data!.exists) {
              String role = firestoreSnapshot.data!.get('role');

              if (role == 'admin') {
                // return const AdminDashboard(); // Uncomment nanti
                return const Scaffold(
                  body: Center(child: Text("Halaman Admin")),
                );
              } else {
                // return const UserHomePage(); // Uncomment nanti
                return const Scaffold(
                  body: Center(child: Text("Halaman User Biasa")),
                );
              }
            }

            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Data Pengguna Tidak Ditemukan di Database"),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Tombol darurat untuk logout agar bisa kembali ke halaman Login
                        FirebaseAuth.instance.signOut();
                      },
                      child: const Text('Keluar (Logout)'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
