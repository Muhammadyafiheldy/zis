import 'package:flutter/material.dart';

// ============================================================================
// 1. HALAMAN MENU DAFTAR INFAQ
// ============================================================================
class InfaqMenuScreen extends StatelessWidget {
  InfaqMenuScreen({Key? key}) : super(key: key);

  // Data Dummy ditambahkan Image dan Deskripsi Lengkap
  final List<Map<String, dynamic>> infaqList = const [
    {
      "id": "masjid",
      "title": "Infaq Pembangunan Masjid", 
      "desc": "Bantu bangun dan renovasi rumah Allah", 
      "full_desc": "Mari bersama membangun dan merenovasi masjid-masjid di daerah terpencil yang belum memiliki fasilitas ibadah yang layak. Infaq yang Anda berikan akan disalurkan untuk pembelian material bangunan, fasilitas tempat wudhu, dan perlengkapan shalat.",
      "icon": Icons.mosque,
      "image": "https://picsum.photos/seed/infaq_masjid/600/400"
    },
    {
      "id": "pendidikan",
      "title": "Infaq Pendidikan", 
      "desc": "Dukung pendidikan anak yatim dan dhuafa", 
      "full_desc": "Banyak anak berprestasi yang terancam putus sekolah karena kendala biaya. Infaq pendidikan ini bertujuan untuk memberikan beasiswa, perlengkapan sekolah, dan fasilitas belajar yang memadai bagi anak yatim dan dhuafa.",
      "icon": Icons.school,
      "image": "https://picsum.photos/seed/infaq_sekolah/600/400"
    },
    {
      "id": "kesehatan",
      "title": "Infaq Kesehatan", 
      "desc": "Bantu biaya pengobatan pasien dhuafa", 
      "full_desc": "Berikan harapan sembuh bagi saudara kita yang sedang berjuang melawan penyakit parah namun tidak memiliki biaya untuk berobat. Dana infaq akan digunakan untuk biaya rumah sakit, tebus obat, dan operasional ambulans gratis.",
      "icon": Icons.local_hospital,
      "image": "https://picsum.photos/seed/infaq_sehat/600/400"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBF7), // Putih hint hijau
      appBar: AppBar(
        title: const Text('Pilih Infaq', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)), 
        backgroundColor: Colors.white, 
        elevation: 0, 
        iconTheme: const IconThemeData(color: Colors.black87),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: infaqList.length,
        itemBuilder: (context, index) {
          final item = infaqList[index];
          return Card(
            elevation: 2, margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: Colors.white,
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Container(
                padding: const EdgeInsets.all(12),
                // Tema Hijau untuk Icon
                decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(12)),
                child: Icon(item['icon'], color: const Color(0xFF2E7D32)),
              ),
              title: Text(item['title'], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(item['desc'], style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xFF4CAF50), size: 16),
              onTap: () {
                // Arahkan ke Halaman Detail Infaq
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => InfaqDetailScreen(dataInfaq: item)
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
// 2. HALAMAN DETAIL & INFORMASI INFAQ
// ============================================================================
class InfaqDetailScreen extends StatelessWidget {
  final Map<String, dynamic> dataInfaq;

  const InfaqDetailScreen({Key? key, required this.dataInfaq}) : super(key: key);

  void _showPaymentForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => InfaqPaymentForm(title: dataInfaq['title']),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Detail Infaq', style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold)),
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
              dataInfaq['image'],
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
                    dataInfaq['title'],
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9), // Hijau Muda
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('Tujuan Infaq', style: TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    dataInfaq['full_desc'],
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
            child: const Text('LANJUTKAN PEMBAYARAN', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// 3. FORM PEMBAYARAN BOTTOM SHEET (Muncul dari bawah)
// ============================================================================
class InfaqPaymentForm extends StatefulWidget {
  final String title;

  const InfaqPaymentForm({Key? key, required this.title}) : super(key: key);

  @override
  _InfaqPaymentFormState createState() => _InfaqPaymentFormState();
}

class _InfaqPaymentFormState extends State<InfaqPaymentForm> {
  final TextEditingController _nominalCtrl = TextEditingController();
  double _nominal = 0;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    
    return Container(
      padding: EdgeInsets.only(
        bottom: mediaQuery.viewInsets.bottom, // Agar tidak tertutup keyboard
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
                labelText: 'Nominal Infaq',
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
                      content: Text('Memproses Infaq Rp ${_nominal.toStringAsFixed(0)}...'),
                      backgroundColor: const Color(0xFF2E7D32),
                    )
                  );
                } : null, // Tombol non-aktif jika nominal 0
                child: const Text('BAYAR SEKARANG', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}