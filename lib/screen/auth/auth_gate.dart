import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zis/screen/admin/admin_dashboard_screen.dart';
// Import halaman Login
import '../auth/login_page.dart';

// 1. Tambahkan import untuk halaman Dashboard User
import 'package:zis/screen/user/dashboard_screen.dart';

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
                // TODO: Ganti dengan AdminDashboard() jika file-nya sudah kamu buat nanti
               return const AdminDashboardScreen();
              } else {
                // 2. Arahkan user biasa langsung ke DashboardScreen aslinya
                return const DashboardScreen();
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
