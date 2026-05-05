import 'package:flutter/material.dart';

// ============================================================================
// 1. HALAMAN MENU DAFTAR SEDEKAH
// ============================================================================
class SedekahMenuScreen extends StatelessWidget {
  SedekahMenuScreen({Key? key}) : super(key: key);

  // Data Dummy ditambahkan Image dan Deskripsi Lengkap
  final List<Map<String, dynamic>> sedekahList = const [
    {
      "id": "subuh",
      "title": "Sedekah Subuh", 
      "desc": "Raih keberkahan pagi dengan sedekah subuh", 
      "full_desc": "Malaikat turun setiap pagi untuk mendoakan orang yang bersedekah. Mari rutinkan sedekah subuh untuk mengawali hari dengan keberkahan. Dana yang terkumpul akan disalurkan untuk berbagai program kebaikan dan kemanusiaan mendesak.",
      "icon": Icons.wb_sunny_rounded,
      "image": "https://picsum.photos/seed/sedekah_subuh/600/400"
    },
    {
      "id": "jumat",
      "title": "Sedekah Jumat Berkah", 
      "desc": "Lipatgandakan pahala di hari jumat", 
      "full_desc": "Hari Jumat adalah sayyidul ayyam (penghulu hari). Sedekah di hari Jumat memiliki keutamaan yang berlipat ganda. Mari berbagi rezeki untuk membahagiakan yatim, dhuafa, dan fisabilillah di hari yang penuh berkah ini.",
      "icon": Icons.event_rounded,
      "image": "https://picsum.photos/seed/sedekah_jumat/600/400"
    },
    {
      "id": "makanan",
      "title": "Sedekah Makanan", 
      "desc": "Berbagi kebahagiaan lewat hidangan bergizi", 
      "full_desc": "Masih banyak saudara kita yang kesulitan mendapatkan makanan bergizi setiap harinya. Melalui program ini, kita akan membagikan paket makanan siap saji dan sembako untuk keluarga prasejahtera, pekerja harian lepas, dan anak jalanan.",
      "icon": Icons.restaurant_rounded,
      "image": "https://picsum.photos/seed/sedekah_makanan/600/400"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBF7),
      appBar: AppBar(
        title: const Text('Pilih Sedekah', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)), 
        backgroundColor: Colors.white, 
        elevation: 0, 
        iconTheme: const IconThemeData(color: Colors.black87),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sedekahList.length,
        itemBuilder: (context, index) {
          final item = sedekahList[index];
          return Card(
            elevation: 2, margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: Colors.white,
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Container(
                padding: const EdgeInsets.all(12),
                // Aksen warna orange agar beda dari Infaq (Biru)
                decoration: BoxDecoration(color: const Color(0xFFFFF3E0), borderRadius: BorderRadius.circular(12)),
                child: Icon(item['icon'], color: const Color(0xFFE65100)),
              ),
              title: Text(item['title'], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(item['desc'], style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xFF4CAF50), size: 16),
              onTap: () {
                // Arahkan ke Halaman Detail Sedekah
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => SedekahDetailScreen(dataSedekah: item)
                ));
              },
            ),
          );
        },
      ),
    );
  }
}

// ============================================================================
// 2. HALAMAN DETAIL & INFORMASI SEDEKAH
// ============================================================================
class SedekahDetailScreen extends StatelessWidget {
  final Map<String, dynamic> dataSedekah;

  const SedekahDetailScreen({Key? key, required this.dataSedekah}) : super(key: key);

  void _showPaymentForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SedekahPaymentForm(title: dataSedekah['title']),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Detail Sedekah', style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto Header
            Image.network(
              dataSedekah['image'],
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: double.infinity, height: 250, color: Colors.grey.shade200,
                child: const Icon(Icons.image, size: 50, color: Colors.grey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dataSedekah['title'],
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9), // Hijau Muda
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('Tujuan Sedekah', style: TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    dataSedekah['full_desc'],
                    style: const TextStyle(fontSize: 15, height: 1.6, color: Colors.black87),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
      // Tombol Bayar di Bawah
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -5))],
        ),
        child: SizedBox(
          height: 55,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50), // Hijau Segar
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => _showPaymentForm(context), // Memanggil form pop-up
            child: const Text('LANJUTKAN SEDEKAH', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// 3. FORM PEMBAYARAN BOTTOM SHEET (Muncul dari bawah)
// ============================================================================
class SedekahPaymentForm extends StatefulWidget {
  final String title;

  const SedekahPaymentForm({Key? key, required this.title}) : super(key: key);

  @override
  _SedekahPaymentFormState createState() => _SedekahPaymentFormState();
}

class _SedekahPaymentFormState extends State<SedekahPaymentForm> {
  final TextEditingController _nominalCtrl = TextEditingController();
  double _nominal = 0;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    
    return Container(
      padding: EdgeInsets.only(
        bottom: mediaQuery.viewInsets.bottom, // Agar tidak tertutup keyboard saat ngetik
        top: 24, left: 24, right: 24
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Masukkan Nominal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                IconButton(icon: const Icon(Icons.close, color: Colors.grey), onPressed: () => Navigator.pop(context)),
              ],
            ),
            const SizedBox(height: 8),
            Text(widget.title, style: const TextStyle(color: Color(0xFF4CAF50), fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            // Input Text Nominal
            TextField(
              controller: _nominalCtrl,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _nominal = double.tryParse(value) ?? 0;
                });
              },
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
              decoration: InputDecoration(
                labelText: 'Nominal Sedekah',
                labelStyle: const TextStyle(color: Color(0xFF2E7D32), fontSize: 16),
                filled: true,
                fillColor: const Color(0xFFF7FBF7),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade300)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade300)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2)),
                prefixText: 'Rp ',
                prefixStyle: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 24),
              ),
            ),

            const SizedBox(height: 30),

            // Tombol Bayar
            Container(
              margin: const EdgeInsets.only(bottom: 24),
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _nominal > 0 ? () {
                  // TODO: Lanjut ke gerbang pembayaran (Payment Gateway)
                  Navigator.pop(context); // Tutup pop up
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Memproses Sedekah Rp ${_nominal.toStringAsFixed(0)}...'),
                      backgroundColor: const Color(0xFF2E7D32),
                    )
                  );
                } : null, // Tombol non-aktif jika nominal 0
                child: const Text('SEDEKAH SEKARANG', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}