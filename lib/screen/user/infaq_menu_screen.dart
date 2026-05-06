import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ============================================================================
// 1. HALAMAN MENU DAFTAR INFAQ (DINAMIS DARI FIREBASE)
// ============================================================================
class InfaqMenuScreen extends StatelessWidget {
  const InfaqMenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBF7),
      appBar: AppBar(
        title: const Text('Program Infaq', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)), 
        backgroundColor: Colors.white, 
        elevation: 0, 
        iconTheme: const IconThemeData(color: Colors.black87),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        // FILTER: Hanya ambil kategori 'infaq' yang dibuat oleh Admin
        stream: FirebaseFirestore.instance
            .collection('programs')
            .where('kategori', isEqualTo: 'infaq')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF4CAF50)));
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(
              child: Text("Belum ada program infaq tersedia.", style: TextStyle(color: Colors.grey)),
            );
          }

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
                    decoration: BoxDecoration(color: const Color(0xFFE3F2FD), borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.mosque_rounded, color: Color(0xFF1565C0)),
                  ),
                  title: Text(data['judul'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(data['deskripsi'] ?? '', maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xFF4CAF50), size: 16),
                  onTap: () {
                    // Pindah ke detail infaq
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => InfaqDetailScreen(dataInfaq: data)
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
      builder: (context) => InfaqPaymentForm(title: dataInfaq['judul']),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Detail Infaq', style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white, elevation: 0, iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Placeholder Image (Bisa diganti jika admin sudah bisa upload image)
            Container(
              height: 250, width: double.infinity, color: const Color(0xFFE3F2FD),
              child: const Icon(Icons.mosque, size: 80, color: Color(0xFF1565C0)),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(dataInfaq['judul'] ?? '', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(8)),
                    child: const Text('Tujuan Infaq', style: TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 12),
                  Text(dataInfaq['deskripsi'] ?? '', style: const TextStyle(fontSize: 15, height: 1.6, color: Colors.black87)),
                  const SizedBox(height: 40),
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
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -5))],
        ),
        child: SizedBox(
          height: 55,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => _showPaymentForm(context),
            child: const Text('LANJUTKAN PEMBAYARAN', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// 3. FORM PEMBAYARAN BOTTOM SHEET (INFAQ)
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

  Future<void> _prosesPembayaranMidtrans() async {
    if (_nominal < 10000) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Minimal infaq adalah Rp 10.000'), backgroundColor: Colors.orange));
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator(color: Color(0xFF4CAF50))),
    );

    try {
      final user = FirebaseAuth.instance.currentUser;
      String emailAsli = user?.email ?? 'hamba.allah@email.com';
      String namaAsli = 'Hamba Allah';

      // AMBIL NAMA ASLI DARI DATABASE users
      if (user != null) {
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          namaAsli = userDoc.data()?['name'] ?? userDoc.data()?['nama'] ?? user.displayName ?? 'Hamba Allah';
        }
      }

      String orderId = "INFAQ-${DateTime.now().millisecondsSinceEpoch}";
      // PASTIIN PAKAI SERVER KEY SANDBOX KAMU BRO
      String serverKey = "Mid-server-OQnL4_2OThuaUo0oNJhaDATw"; 
      String basicAuth = 'Basic ${base64Encode(utf8.encode('$serverKey:'))}';

      // 1. Simpan ke Firestore (Status Pending)
      await FirebaseFirestore.instance.collection('transactions').doc(orderId).set({
        'orderId': orderId,
        'kategori': widget.title,
        'nominal': _nominal.toInt(),
        'grossAmount': _nominal.toInt(),
        'status': 'Pending',
        'timestamp': FieldValue.serverTimestamp(),
        'name': namaAsli, 
        'email': emailAsli,
      });

      // 2. Setup Parameter Midtrans
      final Map<String, dynamic> body = {
        "transaction_details": {
          "order_id": orderId,
          "gross_amount": _nominal.toInt()
        },
        "customer_details": {
          "first_name": namaAsli,
          "email": emailAsli,
        },
        "item_details": [
          {
            "id": "ITEM-INFAQ",
            "price": _nominal.toInt(),
            "quantity": 1,
            "name": widget.title.length > 50 ? widget.title.substring(0, 47) + "..." : widget.title
          }
        ]
      };

      // 3. Tembak API Midtrans
      final response = await http.post(
        Uri.parse('https://app.sandbox.midtrans.com/snap/v1/transactions'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": basicAuth,
        },
        body: jsonEncode(body),
      );

      if (!mounted) return;
      Navigator.pop(context); // Tutup loading

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final String redirectUrl = data['redirect_url'];

        final Uri url = Uri.parse(redirectUrl);
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
          if (mounted) Navigator.pop(context); // Tutup bottom sheet
        } else {
          throw 'Tidak dapat membuka halaman pembayaran Midtrans.';
        }
      } else {
        throw 'Error Midtrans: ${response.body}';
      }
    } catch (e) {
      if (!mounted) return;
      if (Navigator.canPop(context)) Navigator.pop(context); 
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    
    return Container(
      padding: EdgeInsets.only(
        bottom: mediaQuery.viewInsets.bottom,
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
                labelText: 'Nominal (Minimal Rp 10.000)',
                labelStyle: const TextStyle(color: Color(0xFF2E7D32), fontSize: 14),
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

            Container(
              margin: const EdgeInsets.only(bottom: 24),
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _nominal >= 10000 ? _prosesPembayaranMidtrans : null, 
                child: const Text('BAYAR SEKARANG', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}