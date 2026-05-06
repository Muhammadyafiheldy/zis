import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ============================================================================
// 1. HALAMAN MENU DAFTAR ZAKAT (DINAMIS DARI FIRESTORE)
// ============================================================================
class ZakatMenuScreen extends StatelessWidget {
  const ZakatMenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBF7),
      appBar: AppBar(
        title: const Text('Program Zakat', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white, elevation: 0, centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('programs')
            .where('kategori', isEqualTo: 'zakat')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF4CAF50)));
          }

          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) return const Center(child: Text("Belum ada program zakat tersedia."));

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              return Card(
                elevation: 2, margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                color: Colors.white,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.clean_hands_rounded, color: Color(0xFF2E7D32)),
                  ),
                  title: Text(data['judul'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Tipe: ${data['tipeZakat']?.toUpperCase() ?? "Umum"}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => ZakatDetailScreen(dataZakat: data)
                    ));
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// ============================================================================
// 2. HALAMAN DETAIL & INFORMASI ZAKAT
// ============================================================================
class ZakatDetailScreen extends StatelessWidget {
  final Map<String, dynamic> dataZakat;
  const ZakatDetailScreen({Key? key, required this.dataZakat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Detail Program'), backgroundColor: Colors.white, elevation: 0, iconTheme: const IconThemeData(color: Colors.black)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(height: 200, width: double.infinity, color: Colors.green.shade50, child: const Icon(Icons.clean_hands_rounded, size: 80, color: Colors.green)),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(dataZakat['judul'] ?? '', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Text(dataZakat['deskripsi'] ?? '', style: const TextStyle(fontSize: 15, height: 1.6)),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4CAF50), minimumSize: const Size(double.infinity, 55), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          onPressed: () {
            showModalBottomSheet(
              context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
              builder: (context) => ZakatCalculatorForm(dataZakat: dataZakat),
            );
          },
          child: const Text('HITUNG & BAYAR ZAKAT', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        ),
      ),
    );
  }
}

// ============================================================================
// 3. KALKULATOR BOTTOM SHEET DINAMIS BERDASARKAN TIPE DARI ADMIN
// ============================================================================
class ZakatCalculatorForm extends StatefulWidget {
  final Map<String, dynamic> dataZakat;
  const ZakatCalculatorForm({Key? key, required this.dataZakat}) : super(key: key);

  @override
  _ZakatCalculatorFormState createState() => _ZakatCalculatorFormState();
}

class _ZakatCalculatorFormState extends State<ZakatCalculatorForm> {
  double _totalZakat = 0;
  final TextEditingController _val1Ctrl = TextEditingController();
  final TextEditingController _val2Ctrl = TextEditingController();
  int _jenisPengairan = 0; 

  void _hitungZakat() {
    setState(() {
      double val1 = double.tryParse(_val1Ctrl.text) ?? 0;
      double val2 = double.tryParse(_val2Ctrl.text) ?? 0;
      
      // Ambil Tipe dari Firestore
      String tipe = widget.dataZakat['tipeZakat'] ?? 'penghasilan';

      switch (tipe) {
        case 'fitrah':
          // Jiwa * (Harga Beras * 2.5kg)
          _totalZakat = val1 * (val2 * 2.5);
          break;
        case 'penghasilan':
          // (Gaji + Bonus) * 2.5%
          _totalZakat = (val1 + val2) * 0.025;
          break;
        case 'maal':
        case 'perdagangan':
          // (Harta - Hutang) * 2.5%
          double bersih = val1 - val2;
          _totalZakat = bersih > 0 ? bersih * 0.025 : 0;
          break;
        case 'pertanian':
          // Hasil * (10% tadah hujan atau 5% irigasi)
          _totalZakat = val1 * (_jenisPengairan == 0 ? 0.10 : 0.05);
          break;
        default:
          _totalZakat = val1 * 0.025;
      }
    });
  }

  Future<void> _prosesPembayaranMidtrans() async {
    showDialog(context: context, barrierDismissible: false, builder: (context) => const Center(child: CircularProgressIndicator()));

    try {
      final user = FirebaseAuth.instance.currentUser;
      String emailAsli = user?.email ?? 'hamba.allah@email.com';
      String namaAsli = 'Hamba Allah';

      if (user != null) {
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        namaAsli = userDoc.data()?['name'] ?? userDoc.data()?['nama'] ?? 'Hamba Allah';
      }

      String orderId = "ZIS-${DateTime.now().millisecondsSinceEpoch}";
      String serverKey = "Mid-server-OQnL4_2OThuaUo0oNJhaDATw"; // PASTIIN KEY KAMU BENAR
      String basicAuth = 'Basic ${base64Encode(utf8.encode('$serverKey:'))}';

      await FirebaseFirestore.instance.collection('transactions').doc(orderId).set({
        'orderId': orderId,
        'kategori': widget.dataZakat['judul'],
        'nominal': _totalZakat.toInt(),
        'grossAmount': _totalZakat.toInt(),
        'status': 'Pending',
        'timestamp': FieldValue.serverTimestamp(),
        'name': namaAsli,
        'email': emailAsli,
      });

      final response = await http.post(
        Uri.parse('https://app.sandbox.midtrans.com/snap/v1/transactions'),
        headers: {"Accept": "application/json", "Content-Type": "application/json", "Authorization": basicAuth},
        body: jsonEncode({
          "transaction_details": {"order_id": orderId, "gross_amount": _totalZakat.toInt()},
          "customer_details": {"first_name": namaAsli, "email": emailAsli}
        }),
      );

      Navigator.pop(context); // Tutup loading

      if (response.statusCode == 201) {
        final url = jsonDecode(response.body)['redirect_url'];
        if (await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
          Navigator.pop(context);
        }
      }
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    String tipe = widget.dataZakat['tipeZakat'] ?? 'penghasilan';

    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, top: 24, left: 24, right: 24),
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Kalkulator ${widget.dataZakat['judul']}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            
            // INPUTAN 1
            TextField(
              controller: _val1Ctrl, keyboardType: TextInputType.number,
              onChanged: (_) => _hitungZakat(),
              decoration: InputDecoration(
                labelText: tipe == 'fitrah' ? 'Jumlah Jiwa' : (tipe == 'pertanian' ? 'Hasil Panen (Rp)' : 'Total Harta/Gaji'),
                prefixText: tipe == 'fitrah' ? '' : 'Rp ', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),

            // INPUTAN 2 (Kecuali Pertanian)
            if (tipe != 'pertanian')
            TextField(
              controller: _val2Ctrl, keyboardType: TextInputType.number,
              onChanged: (_) => _hitungZakat(),
              decoration: InputDecoration(
                labelText: tipe == 'fitrah' ? 'Harga Beras/Kg' : 'Hutang/Potongan',
                prefixText: 'Rp ', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),

            // PILIHAN PENGAIRAN (Hanya Pertanian)
            if (tipe == 'pertanian') ...[
              const Text('Jenis Pengairan:', style: TextStyle(fontWeight: FontWeight.bold)),
              RadioListTile(title: const Text('Tadah Hujan (10%)'), value: 0, groupValue: _jenisPengairan, onChanged: (v) => setState(() { _jenisPengairan = v as int; _hitungZakat(); })),
              RadioListTile(title: const Text('Irigasi Berbayar (5%)'), value: 1, groupValue: _jenisPengairan, onChanged: (v) => setState(() { _jenisPengairan = v as int; _hitungZakat(); })),
            ],

            const SizedBox(height: 24),
            Container(
              width: double.infinity, padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  const Text('Total Pembayaran Zakat'),
                  Text('Rp ${_totalZakat.toStringAsFixed(0)}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4CAF50), minimumSize: const Size(double.infinity, 50)),
                    onPressed: _totalZakat > 0 ? _prosesPembayaranMidtrans : null,
                    child: const Text('BAYAR SEKARANG', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}