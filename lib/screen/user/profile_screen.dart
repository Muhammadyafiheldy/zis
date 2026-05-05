import 'package:flutter/material.dart';

// ============================================================================
// 1. HALAMAN PROFIL UTAMA (Tetap sama, tidak ada yang diubah)
// ============================================================================
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Konfirmasi Logout', style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text('Apakah Anda yakin ingin keluar dari akun ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), 
              child: const Text('Batal', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                Navigator.pop(context); 
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Berhasil Logout'))
                );
              },
              child: const Text('Ya, Keluar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBF7), 
      appBar: AppBar(
        title: const Text('Profil Saya', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5))
                ],
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFF4CAF50), width: 3),
                          image: const DecorationImage(
                            image: NetworkImage('https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0, right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4CAF50),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('Hamba Allah', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
                  const SizedBox(height: 4),
                  Text('hamba.allah@email.com', style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.verified, color: Color(0xFF4CAF50), size: 16),
                        SizedBox(width: 6),
                        Text('Donatur Aktif', style: TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Akun & Keamanan', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 16)),
                  const SizedBox(height: 12),
                  _buildMenuCard([
                    _buildListTile(
                      icon: Icons.lock_outline, 
                      title: 'Ganti Password', 
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangePasswordScreen()))
                    ),
                  ]),
                  
                  const SizedBox(height: 24),
                  
                  const Text('Bantuan & Informasi', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 16)),
                  const SizedBox(height: 12),
                  _buildMenuCard([
                    _buildListTile(
                      icon: Icons.help_outline, 
                      title: 'Pusat Bantuan (FAQ)', 
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FaqScreen()))
                    ),
                    _buildDivider(),
                    _buildListTile(
                      icon: Icons.description_outlined, 
                      title: 'Syarat & Ketentuan', 
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TermsScreen()))
                    ),
                    _buildDivider(),
                    _buildListTile(
                      icon: Icons.info_outline, 
                      title: 'Tentang Aplikasi', 
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutScreen()))
                    ),
                  ]),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red.shade600,
                        side: BorderSide(color: Colors.red.shade200, width: 1.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () => _showLogoutDialog(context),
                      icon: const Icon(Icons.logout_rounded),
                      label: const Text('Keluar (Logout)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 40), 
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildListTile({required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: const Color(0xFFF7FBF7), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: const Color(0xFF4CAF50), size: 22),
      ),
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Divider(height: 1, color: Colors.grey.shade200),
    );
  }
}

// ============================================================================
// 2. HALAMAN GANTI PASSWORD (Dipercantik)
// ============================================================================
class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBF7),
      appBar: AppBar(
        title: const Text('Ganti Password', style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white, elevation: 0, iconTheme: const IconThemeData(color: Colors.black87),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Ilustrasi Gembok
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: const Color(0xFF4CAF50).withOpacity(0.2), blurRadius: 20, spreadRadius: 5)],
              ),
              child: const Icon(Icons.lock_person_rounded, size: 80, color: Color(0xFF4CAF50)),
            ),
            const SizedBox(height: 24),
            const Text(
              'Buat Password Baru',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Text(
              'Pastikan password baru Anda kuat dan tidak mudah ditebak oleh orang lain.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 32),

            // Form Fields dibungkus Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 5))],
              ),
              child: Column(
                children: [
                  _buildPasswordField('Password Lama'),
                  const SizedBox(height: 16),
                  _buildPasswordField('Password Baru'),
                  const SizedBox(height: 16),
                  _buildPasswordField('Konfirmasi Password Baru'),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity, height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  elevation: 5,
                  shadowColor: const Color(0xFF4CAF50).withOpacity(0.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password berhasil diubah!')));
                  Navigator.pop(context);
                },
                child: const Text('SIMPAN PASSWORD', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField(String label) {
    return TextField(
      obscureText: true,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF2E7D32)),
        filled: true, fillColor: const Color(0xFFF7FBF7),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2)),
        suffixIcon: const Icon(Icons.visibility_off, color: Colors.grey),
      ),
    );
  }
}

// ============================================================================
// 3. HALAMAN PUSAT BANTUAN (Dipercantik)
// ============================================================================
class FaqScreen extends StatelessWidget {
  const FaqScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBF7),
      appBar: AppBar(
        title: const Text('Pusat Bantuan', style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white, elevation: 0, iconTheme: const IconThemeData(color: Colors.black87),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Banner Bantuan
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Halo, ada yang bisa kami bantu?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 16),
                // Fake Search Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(color: const Color(0xFFF7FBF7), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Colors.grey),
                      const SizedBox(width: 12),
                      Text('Cari kendala kamu...', style: TextStyle(color: Colors.grey.shade500)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // List FAQ
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 8, bottom: 12),
                  child: Text('Pertanyaan Populer', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
                ),
                _buildFaqItem('Bagaimana cara berdonasi?', 'Anda dapat memilih menu Zakat, Infaq, atau Sedekah di halaman Beranda. Pilih program yang ingin dibantu, isi nominal, lalu klik tombol Lanjutkan Pembayaran.'),
                _buildFaqItem('Apakah donasi saya aman?', 'Insya Allah aman. Kami bekerja sama dengan lembaga amil zakat resmi dan memiliki transparansi laporan yang bisa diunduh di menu Riwayat.'),
                _buildFaqItem('Metode pembayaran apa saja yang didukung?', 'Saat ini kami mendukung Transfer Bank (BCA, Mandiri, BSI, dll) dan dompet digital (GoPay, OVO, Dana, ShopeePay).'),
                _buildFaqItem('Bagaimana cara mengunduh E-Kwitansi?', 'Buka menu Riwayat di navigasi bawah. Jika status transaksi Anda sudah "Berhasil", tombol unduh berbentuk PDF akan muncul di sebelah kanan nominal.'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent), // Hilangkan garis bawaan ExpansionTile
        child: ExpansionTile(
          title: Text(question, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
          iconColor: const Color(0xFF4CAF50),
          collapsedIconColor: Colors.grey,
          childrenPadding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
          children: [
            Text(answer, style: TextStyle(color: Colors.grey.shade700, fontSize: 13, height: 1.5)),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// 4. HALAMAN SYARAT & KETENTUAN (Dipercantik)
// ============================================================================
class TermsScreen extends StatelessWidget {
  const TermsScreen({Key? key}) : super(key: key);

  final List<Map<String, String>> termsData = const [
    {
      "title": "Pendahuluan",
      "content": "Selamat datang di Aplikasi ZIS. Dengan mengakses dan menggunakan aplikasi ini, Anda setuju untuk mematuhi semua syarat dan ketentuan yang berlaku."
    },
    {
      "title": "Transparansi Dana",
      "content": "Kami berkomitmen menyalurkan 100% dana zakat sesuai dengan asnaf yang berhak menerimanya. Dana operasional hanya diambil dari alokasi dana amil yang telah ditetapkan syariat."
    },
    {
      "title": "Metode Pembayaran",
      "content": "Pengguna wajib memastikan nominal yang ditransfer sesuai dengan angka yang tertera di aplikasi (termasuk kode unik jika ada) agar sistem dapat melakukan verifikasi secara otomatis."
    },
    {
      "title": "Pembatalan Transaksi",
      "content": "Donasi atau zakat yang sudah berstatus 'Berhasil' tidak dapat dibatalkan, ditarik kembali, atau di-refund karena dana akan segera disalurkan ke penerima manfaat."
    },
    {
      "title": "Privasi & Keamanan Data",
      "content": "Kami menjaga kerahasiaan data pribadi Anda dengan standar keamanan tinggi. Data hanya digunakan untuk pelaporan donasi dan tidak akan disebarkan ke pihak ketiga tanpa izin Anda."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBF7),
      appBar: AppBar(
        title: const Text('Syarat & Ketentuan', style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white, elevation: 0, iconTheme: const IconThemeData(color: Colors.black87),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: termsData.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 30, height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(8)),
                  child: Text('${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2E7D32))),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(termsData[index]['title']!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                      const SizedBox(height: 8),
                      Text(termsData[index]['content']!, style: TextStyle(fontSize: 14, color: Colors.grey.shade700, height: 1.5)),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

// ============================================================================
// 5. HALAMAN TENTANG APLIKASI (Dipercantik)
// ============================================================================
class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBF7),
      appBar: AppBar(
        title: const Text('Tentang Aplikasi', style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white, elevation: 0, iconTheme: const IconThemeData(color: Colors.black87),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Aplikasi
              Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: const Color(0xFF4CAF50).withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 10))],
                ),
                child: const Icon(Icons.volunteer_activism_rounded, color: Color(0xFF4CAF50), size: 90),
              ),
              const SizedBox(height: 24),
              const Text('ZIS App', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32))),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(20)),
                child: const Text('Versi 1.0.0', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32))),
              ),
              
              const SizedBox(height: 40),
              
              // Card Deskripsi Singkat
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 5))],
                ),
                child: Text(
                  'Aplikasi manajemen Zakat, Infaq, dan Sedekah untuk mempermudah umat dalam menyalurkan kebaikan dan memberdayakan masyarakat secara transparan, aman, dan tepat sasaran.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700, height: 1.6),
                ),
              ),

              const SizedBox(height: 40),
              
              // Tombol Sosial Media (Hanya Visual)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialBtn(Icons.language),
                  const SizedBox(width: 16),
                  _buildSocialBtn(Icons.email_outlined),
                  const SizedBox(width: 16),
                  _buildSocialBtn(Icons.share),
                ],
              ),
              
              const SizedBox(height: 40),
              Text('© 2026 ZIS Dev Team. All Rights Reserved.', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialBtn(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade300)),
      child: Icon(icon, color: const Color(0xFF4CAF50), size: 24),
    );
  }
}