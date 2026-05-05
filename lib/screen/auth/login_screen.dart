import 'package:flutter/material.dart';
import '../dashboard/dashboard_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBF7), // Background putih dengan hint hijau muda
      body: SafeArea(
        child: Center(
          // SingleChildScrollView agar tidak error ketutupan keyboard saat ngetik
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ==========================================
                // LOGO / IKON APLIKASI
                // ==========================================
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9), // Hijau sangat muda
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF4CAF50).withOpacity(0.2),
                          blurRadius: 20,
                          spreadRadius: 5,
                        )
                      ],
                    ),
                    child: const Icon(Icons.volunteer_activism_rounded, size: 70, color: Color(0xFF4CAF50)),
                  ),
                ),
                const SizedBox(height: 32),

                // ==========================================
                // TEKS SAMBUTAN
                // ==========================================
                const Text(
                  'Selamat Datang!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 8),
                Text(
                  'Masuk untuk mulai menyalurkan kebaikanmu hari ini.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 40),

                // ==========================================
                // FORM EMAIL
                // ==========================================
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: const TextStyle(color: Color(0xFF2E7D32)),
                    prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF4CAF50)),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade300)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade300)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2)),
                  ),
                ),
                const SizedBox(height: 16),

                // ==========================================
                // FORM PASSWORD
                // ==========================================
                TextField(
                  obscureText: true,
                  style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: const TextStyle(color: Color(0xFF2E7D32)),
                    prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF4CAF50)),
                    suffixIcon: const Icon(Icons.visibility_off, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade300)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade300)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2)),
                  ),
                ),

                // ==========================================
                // LUPA PASSWORD LINK
                // ==========================================
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // TODO: Arahkan ke halaman lupa password
                    },
                    child: const Text('Lupa Password?', style: TextStyle(color: Color(0xFF4CAF50), fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 16),

                // ==========================================
                // TOMBOL LOGIN
                // ==========================================
                SizedBox(
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      elevation: 5,
                      shadowColor: const Color(0xFF4CAF50).withOpacity(0.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () {
                      // Navigasi ke Dashboard setelah login
                      Navigator.pushReplacement(
                        context, 
                        MaterialPageRoute(builder: (context) => const DashboardScreen())
                      );
                    },
                    child: const Text('MASUK SEKARANG', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
                
                const SizedBox(height: 30),

                // ==========================================
                // LINK DAFTAR AKUN BARU
                // ==========================================
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Belum punya akun?', style: TextStyle(color: Colors.grey.shade600)),
                    TextButton(
                      onPressed: () {
                        // TODO: Arahkan ke halaman Registrasi (register_screen.dart)
                      },
                      child: const Text('Daftar di sini', style: TextStyle(color: Color(0xFF4CAF50), fontWeight: FontWeight.bold)),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}