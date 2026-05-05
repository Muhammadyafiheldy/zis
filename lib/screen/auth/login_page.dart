import 'package:flutter/material.dart';
import 'package:zis/service/auth_service.dart';
import 'register_page.dart'; // Pastikan nama file ini sesuai dengan punyamu

// KITA KEMBALIKAN MENJADI STATEFUL WIDGET AGAR BISA MEMPROSES DATA
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // 1. Panggil ulang Controller dan Service Firebase
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  final AuthService _authService = AuthService();

  // 2. Fungsi Login dikembalikan
  void _login() async {
    setState(() {
      _isLoading = true;
    });

    String? hasil = await _authService.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    // Hindari error jika widget sudah ditutup
    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (hasil == "Sukses") {
      // TIDAK PERLU NAVIGATOR. PUSH DI SINI. 
      // AuthGate akan otomatis mendeteksi dan memindahkan ke Dashboard
      print("Login berhasil!");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(hasil ?? "Gagal login"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBF7), 
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // LOGO
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
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

                // TEKS SAMBUTAN
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

                // FORM EMAIL
                TextField(
                  controller: _emailController, // JANGAN LUPA PASANG CONTROLLER
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

                // FORM PASSWORD
                TextField(
                  controller: _passwordController, // JANGAN LUPA PASANG CONTROLLER
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

                // LUPA PASSWORD
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text('Lupa Password?', style: TextStyle(color: Color(0xFF4CAF50), fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 16),

                // TOMBOL LOGIN (DENGAN ANIMASI LOADING)
                SizedBox(
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      elevation: 5,
                      shadowColor: const Color(0xFF4CAF50).withOpacity(0.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    // Jika loading, matikan tombol (null). Jika tidak, jalankan _login
                    onPressed: _isLoading ? null : _login, 
                    child: _isLoading 
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('MASUK SEKARANG', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
                
                const SizedBox(height: 30),

                // LINK DAFTAR
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Belum punya akun?', style: TextStyle(color: Colors.grey.shade600)),
                    TextButton(
                      onPressed: () {
                        // Arahkan ke halaman Registrasi
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RegisterPage()),
                        );
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