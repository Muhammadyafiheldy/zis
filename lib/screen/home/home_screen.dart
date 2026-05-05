import 'package:flutter/material.dart';
import '../zakat/calculator_screen.dart'; 
import '../infaq/infaq_menu_screen.dart'; 
import '../sedekah/sedekah_menu_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  // Data Dummy Horizontal
  final List<Map<String, dynamic>> urgentCampaigns = const [
    {
      "judul": "Bantu Beasiswa Mahasiswa Kurang Mampu",
      "penyelenggara": "Lembaga Zakat Riau",
      "gambar": "https://picsum.photos/seed/zakat1/600/400",
      "deskripsi": "Mari bantu saudara kita yang sedang berjuang menuntut ilmu namun terkendala biaya. Donasi Anda akan disalurkan langsung untuk pembayaran UKT."
    },
    {
      "judul": "[DARURAT] Bangun Lagi Rumah Sakit",
      "penyelenggara": "Kemanusiaan ID",
      "gambar": "https://picsum.photos/seed/zakat2/600/400",
      "deskripsi": "Rumah sakit utama di wilayah terdampak bencana mengalami kerusakan parah. Ribuan pasien membutuhkan tempat perawatan yang layak."
    },
  ];

  // Data Dummy Vertical
  final List<Map<String, dynamic>> regularCampaigns = const [
    {
      "judul": "Sedekah Air Bersih untuk Pelosok Desa",
      "penyelenggara": "Bantu Warga",
      "gambar": "https://picsum.photos/seed/sedekah1/600/400",
      "deskripsi": "Alirkan pahala jariyah dengan membangun sumur air bersih untuk warga pelosok."
    },
    {
      "judul": "Infaq Pembangunan Masjid Terpencil",
      "penyelenggara": "Yayasan Masjid Nusantara",
      "gambar": "https://picsum.photos/seed/infaq1/600/400",
      "deskripsi": "Mari bersama membangun rumah Allah di daerah terpencil yang belum memiliki fasilitas ibadah."
    },
    {
      "judul": "Bantuan Pangan Pejuang Jalanan",
      "penyelenggara": "Dompet Berbagi",
      "gambar": "https://picsum.photos/seed/sedekah2/600/400",
      "deskripsi": "Sedekah paket makanan bergizi untuk para pekerja kasar dan pejuang nafkah di jalanan."
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBF7), 
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==========================================
            // HEADER DENGAN EFEK KABUT & FOTO LOKAL
            // ==========================================
            Stack(
              children: [
                // 1. Layer Foto Masjid/Grafis (LOCAL ASSET)
                Container(
                  height: 250, 
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      // MENGGUNAKAN FOTO DARI FOLDER ASSETS
                      // Pastikan nama dan format file sesuai dengan yang kamu simpan!
                      image: AssetImage('assets/images/masjid.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                
                // 2. Layer Kabut (Gradient)
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.0, 0.5, 1.0],
                      colors: [
                        Colors.black.withOpacity(0.6), 
                        Colors.white.withOpacity(0.2), 
                        const Color(0xFFF7FBF7),       
                      ],
                    ),
                  ),
                ),

                // 3. Layer Konten (Teks & Search Bar)
                Padding(
                  padding: const EdgeInsets.only(top: 60, left: 24, right: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text("Assalamu'alaikum,", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                              SizedBox(height: 4),
                              Text("Hamba Allah", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                            child: const CircleAvatar(
                              backgroundColor: Color(0xFFE8F5E9),
                              radius: 24,
                              child: Icon(Icons.person, color: Color(0xFF2E7D32), size: 28),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 45), 
                      
                      // SEARCH BAR MELAYANG
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 10))
                          ],
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: TextField(
                          textInputAction: TextInputAction.search,
                          onSubmitted: (value) {
                            if (value.isNotEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Mencari program: "$value"'),
                                  backgroundColor: const Color(0xFF2E7D32),
                                )
                              );
                            }
                          },
                          decoration: InputDecoration(
                            hintText: 'Cari program donasi...',
                            hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                            prefixIcon: const Icon(Icons.search, color: Colors.grey),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 15), 

            // ==========================================
            // MENU UTAMA (Zakat, Infaq, Sedekah)
            // ==========================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildMenuIcon(context, 'Zakat', Icons.clean_hands_rounded, const Color(0xFFE8F5E9), const Color(0xFF2E7D32), ZakatMenuScreen()),
                  _buildMenuIcon(context, 'Infaq', Icons.mosque_rounded, const Color(0xFFE3F2FD), const Color(0xFF1565C0), InfaqMenuScreen()),
                  _buildMenuIcon(context, 'Sedekah', Icons.volunteer_activism_rounded, const Color(0xFFFFF3E0), const Color(0xFFE65100), SedekahMenuScreen()),
                ],
              ),
            ),

            const SizedBox(height: 35),

            // ==========================================
            // DAFTAR PROGRAM MENDESAK
            // ==========================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Perlu Segera Dibantu', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                  Text('Lihat Semua', style: TextStyle(fontSize: 14, color: Color(0xFF4CAF50), fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            SizedBox(
              height: 230, 
              child: ListView.builder(
                padding: const EdgeInsets.only(left: 20),
                scrollDirection: Axis.horizontal,
                itemCount: urgentCampaigns.length,
                itemBuilder: (context, index) {
                  final item = urgentCampaigns[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CampaignDetailScreen(campaign: item)));
                    },
                    child: Container(
                      width: 220,
                      margin: const EdgeInsets.only(right: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                child: Image.network(
                                  item['gambar'], 
                                  height: 130, width: double.infinity, fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    height: 130, width: double.infinity, color: Colors.grey.shade200,
                                    child: const Icon(Icons.broken_image, color: Colors.grey, size: 40),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 8, left: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(color: Colors.red.shade600, borderRadius: BorderRadius.circular(8)),
                                  child: const Text('DARURAT', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item['judul'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, height: 1.3), maxLines: 2, overflow: TextOverflow.ellipsis),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.verified, color: Color(0xFF4CAF50), size: 14),
                                    const SizedBox(width: 4),
                                    Expanded(child: Text(item['penyelenggara'], style: const TextStyle(fontSize: 12, color: Colors.grey), overflow: TextOverflow.ellipsis)),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // ==========================================
            // PROGRAM KEBAIKAN LAINNYA
            // ==========================================
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text('Program Kebaikan Lainnya', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
            ),
            const SizedBox(height: 16),

            ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: regularCampaigns.length,
              itemBuilder: (context, index) {
                final item = regularCampaigns[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CampaignDetailScreen(campaign: item)));
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start, 
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
                          child: Image.network(
                            item['gambar'], 
                            height: 125, width: 110, fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              height: 125, width: 110, color: Colors.grey.shade200,
                              child: const Icon(Icons.broken_image, color: Colors.grey),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item['judul'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 2, overflow: TextOverflow.ellipsis),
                                const SizedBox(height: 6),
                                Text(item['penyelenggara'], style: const TextStyle(fontSize: 11, color: Colors.grey), overflow: TextOverflow.ellipsis),
                                const SizedBox(height: 8),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: SizedBox(
                                    height: 30,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF4CAF50),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      ),
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => CampaignDetailScreen(campaign: item)));
                                      },
                                      child: const Text('Donasi', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuIcon(BuildContext context, String title, IconData icon, Color bgColor, Color iconColor, Widget destinationScreen) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => destinationScreen));
      },
      child: Column(
        children: [
          Container(
            height: 65,
            width: 65,
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 30),
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87)),
        ],
      ),
    );
  }
}

// ============================================================================
// HALAMAN DETAIL PROGRAM 
// ============================================================================
class CampaignDetailScreen extends StatelessWidget {
  final Map<String, dynamic> campaign;
  const CampaignDetailScreen({Key? key, required this.campaign}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Detail Program', style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              campaign['gambar'], width: double.infinity, height: 250, fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: double.infinity, height: 250, color: Colors.grey.shade200,
                child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(campaign['judul'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.verified, color: Color(0xFF4CAF50), size: 18),
                      const SizedBox(width: 8),
                      Text(campaign['penyelenggara'], style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text('Informasi Program', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                  const SizedBox(height: 12),
                  Text(campaign['deskripsi'], style: const TextStyle(fontSize: 15, height: 1.6, color: Colors.black87)),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
        ),
        child: SizedBox(
          height: 55,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {}, 
            child: const Text('DONASI SEKARANG', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ),
      ),
    );
  }
}