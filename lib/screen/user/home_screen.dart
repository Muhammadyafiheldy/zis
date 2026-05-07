import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'calculator_screen.dart'; 
import 'infaq_menu_screen.dart'; 
import 'sedekah_menu_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  // Fungsi untuk mengambil nama user yang sedang login untuk sapaan
  Future<String> _getUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        return userDoc.data()?['name'] ?? userDoc.data()?['nama'] ?? 'Hamba Allah';
      }
    }
    return 'Hamba Allah';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBF7), 
      body: StreamBuilder<QuerySnapshot>(
        // MENGAMBIL SEMUA PROGRAM DARI DATABASE
        stream: FirebaseFirestore.instance.collection('programs').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF4CAF50)));
          }

          final List<DocumentSnapshot> allDocs = snapshot.data?.docs ?? [];
          
          // FILTER: Program Darurat (Urgent)
          final urgentCampaigns = allDocs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return data['isUrgent'] == true;
          }).toList();

          // FILTER: Program Biasa (Lainnya)
          final regularCampaigns = allDocs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return data['isUrgent'] == false || data['isUrgent'] == null;
          }).toList();

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ==========================================
                // HEADER DENGAN SAPAAN NAMA ASLI
                // ==========================================
                Stack(
                  children: [
                    Container(
                      height: 250, width: double.infinity,
                      decoration: const BoxDecoration(
                        image: DecorationImage(image: AssetImage('assets/images/masjid.jpg'), fit: BoxFit.cover),
                      ),
                    ),
                    Container(
                      height: 250, width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter, end: Alignment.bottomCenter,
                          colors: [Colors.black.withOpacity(0.6), Colors.white.withOpacity(0.2), const Color(0xFFF7FBF7)],
                        ),
                      ),
                    ),
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
                                children: [
                                  const Text("Assalamu'alaikum,", style: TextStyle(color: Colors.white, fontSize: 16)),
                                  const SizedBox(height: 4),
                                  FutureBuilder<String>(
                                    future: _getUserName(),
                                    builder: (context, nameSnapshot) {
                                      return Text(
                                        nameSnapshot.data ?? 'Hamba Allah',
                                        style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              const CircleAvatar(radius: 24, backgroundColor: Colors.white, child: Icon(Icons.person, color: Color(0xFF2E7D32))),
                            ],
                          ),
                          const SizedBox(height: 45), 
                          _buildSearchBar(),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 15), 

                // MENU UTAMA
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
                // BAGIAN: PERLU SEGERA DIBANTU (URGENT)
                // ==========================================
                _buildSectionTitle('Perlu Segera Dibantu'),
                const SizedBox(height: 16),
                
                if (urgentCampaigns.isEmpty)
                   const Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: Text("Belum ada program darurat."))
                else
                  SizedBox(
                    height: 240, 
                    child: ListView.builder(
                      padding: const EdgeInsets.only(left: 20),
                      scrollDirection: Axis.horizontal,
                      itemCount: urgentCampaigns.length,
                      itemBuilder: (context, index) {
                        final data = urgentCampaigns[index].data() as Map<String, dynamic>;
                        return _buildUrgentCard(context, data);
                      },
                    ),
                  ),

                const SizedBox(height: 20),

                // ==========================================
                // BAGIAN: PROGRAM KEBAIKAN LAINNYA (REGULAR)
                // ==========================================
                _buildSectionTitle('Program Kebaikan Lainnya'),
                const SizedBox(height: 16),

                if (regularCampaigns.isEmpty)
                   const Center(child: Padding(padding: EdgeInsets.all(20), child: Text("Belum ada program lainnya.")))
                else
                  ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: regularCampaigns.length,
                    itemBuilder: (context, index) {
                      final data = regularCampaigns[index].data() as Map<String, dynamic>;
                      return _buildRegularCard(context, data);
                    },
                  ),
                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }

  // --- WIDGET HELPERS ---

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
          const Text('Lihat Semua', style: TextStyle(fontSize: 14, color: Color(0xFF4CAF50), fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

 Widget _buildUrgentCard(BuildContext context, Map<String, dynamic> data) {
  return GestureDetector(
    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CampaignDetailScreen(campaign: data))),
    child: Container(
      width: 220, margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: data['imageUrl'] != null && data['imageUrl'] != ''
              ? Image.network(
                  data['imageUrl'], 
                  height: 130, width: double.infinity, fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(height: 130, color: Colors.grey[200], child: const Icon(Icons.broken_image)),
                )
              : Container(height: 130, width: double.infinity, color: Colors.red[50], child: const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 40)),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(data['judul'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 2),
          )
        ],
      ),
    ),
  );
}

  Widget _buildRegularCard(BuildContext context, Map<String, dynamic> data) {
  return GestureDetector(
    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CampaignDetailScreen(campaign: data))),
    child: Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Row(
        children: [
          // --- BAGIAN FOTO ---
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
            child: data['imageUrl'] != null && data['imageUrl'] != ''
                ? Image.network(
                    data['imageUrl'],
                    width: 100, height: 100, fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 100, height: 100, color: Colors.grey[200],
                      child: const Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  )
                : Container(
                    width: 100, height: 100, color: Colors.green[50],
                    child: const Icon(Icons.volunteer_activism, color: Colors.green),
                  ),
          ),
          // --- KONTEN TEKS ---
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data['judul'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 2),
                  const SizedBox(height: 4),
                  Text(data['deskripsi'] ?? '', style: TextStyle(fontSize: 12, color: Colors.grey[600]), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20)], borderRadius: BorderRadius.circular(25)),
      child: const TextField(
        decoration: InputDecoration(
          hintText: 'Cari program...', prefixIcon: Icon(Icons.search),
          filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(25)), borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _buildMenuIcon(BuildContext context, String title, IconData icon, Color bgColor, Color iconColor, Widget target) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => target)),
      child: Column(children: [
        Container(height: 65, width: 65, decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle), child: Icon(icon, color: iconColor, size: 30)),
        const SizedBox(height: 8),
        Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      ]),
    );
  }
}

// ============================================================================
// HALAMAN DETAIL PROGRAM (USER)
// ============================================================================
class CampaignDetailScreen extends StatelessWidget {
  final Map<String, dynamic> campaign;
  const CampaignDetailScreen({Key? key, required this.campaign}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Detail Program'), backgroundColor: Colors.white, elevation: 0, iconTheme: const IconThemeData(color: Colors.black)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 250, width: double.infinity, color: Colors.green.shade50, child: const Icon(Icons.image, size: 100, color: Colors.green)),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(campaign['judul'] ?? '', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Text('Kategori: ${campaign['kategori']?.toUpperCase() ?? '-'}', style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  const Text('Deskripsi Program:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(campaign['deskripsi'] ?? '', style: const TextStyle(fontSize: 15, height: 1.6)),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4CAF50), minimumSize: const Size(double.infinity, 55), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          onPressed: () => showModalBottomSheet(context: context, isScrollControlled: true, builder: (_) => DonasiPaymentForm(campaign: campaign)),
          child: const Text('DONASI SEKARANG', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        ),
      ),
    );
  }
}

// ============================================================================
// BOTTOM SHEET FORM PAYMENT (DENGAN NAMA ASLI)
// ============================================================================
class DonasiPaymentForm extends StatefulWidget {
  final Map<String, dynamic> campaign;
  const DonasiPaymentForm({Key? key, required this.campaign}) : super(key: key);

  @override
  _DonasiPaymentFormState createState() => _DonasiPaymentFormState();
}

class _DonasiPaymentFormState extends State<DonasiPaymentForm> {
  final TextEditingController _nominalCtrl = TextEditingController();
  double _nominalDonasi = 0;

  Future<void> _prosesPembayaranMidtrans() async {
    if (_nominalDonasi < 10000) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Minimal donasi Rp 10.000')));
      return;
    }

    showDialog(context: context, builder: (_) => const Center(child: CircularProgressIndicator()));

    try {
      final user = FirebaseAuth.instance.currentUser;
      String emailAsli = user?.email ?? 'hamba.allah@email.com';
      String namaAsli = 'Hamba Allah';

      if (user != null) {
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        namaAsli = userDoc.data()?['name'] ?? userDoc.data()?['nama'] ?? 'Hamba Allah';
      }

      String orderId = "DONASI-${DateTime.now().millisecondsSinceEpoch}";
      // Masukkan Server Key Sandbox Kamu
      String serverKey = "Mid-server-OQnL4_2OThuaUo0oNJhaDATw"; 

      await FirebaseFirestore.instance.collection('transactions').doc(orderId).set({
        'orderId': orderId,
        'kategori': widget.campaign['judul'],
        'nominal': _nominalDonasi.toInt(),
        'grossAmount': _nominalDonasi.toInt(),
        'status': 'Pending',
        'timestamp': FieldValue.serverTimestamp(),
        'name': namaAsli, 
        'email': emailAsli,
      });

      String basicAuth = 'Basic ${base64Encode(utf8.encode('$serverKey:'))}';
      final response = await http.post(
        Uri.parse('https://app.sandbox.midtrans.com/snap/v1/transactions'),
        headers: {"Accept": "application/json", "Content-Type": "application/json", "Authorization": basicAuth},
        body: jsonEncode({
          "transaction_details": {"order_id": orderId, "gross_amount": _nominalDonasi.toInt()},
          "customer_details": {"first_name": namaAsli, "email": emailAsli}
        }),
      );

      if (!mounted) return;
      Navigator.pop(context); 

      if (response.statusCode == 201) {
        final redirectUrl = jsonDecode(response.body)['redirect_url'];
        if (await canLaunchUrl(Uri.parse(redirectUrl))) {
          await launchUrl(Uri.parse(redirectUrl), mode: LaunchMode.externalApplication);
          if (mounted) Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, top: 24, left: 24, right: 24),
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Masukkan Nominal Donasi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          TextField(
            controller: _nominalCtrl, keyboardType: TextInputType.number,
            onChanged: (v) => setState(() => _nominalDonasi = double.tryParse(v) ?? 0),
            decoration: InputDecoration(prefixText: 'Rp ', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4CAF50), minimumSize: const Size(double.infinity, 50)),
            onPressed: _nominalDonasi >= 10000 ? _prosesPembayaranMidtrans : null,
            child: const Text('BAYAR SEKARANG', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}