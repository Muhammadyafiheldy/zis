import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

// PASTIKAN IMPORT INI SESUAI DENGAN LOKASI FILE KAMU
import 'package:zis/model/program.dart'; 
import 'package:zis/service/firestore_service.dart';

// ============================================================================
// 1. MENU UTAMA ADMIN DASHBOARD
// ============================================================================
class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  void _logout(BuildContext context) {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F4),
      appBar: AppBar(
        title: const Text('Admin Dashboard', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white, 
        elevation: 0, 
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.logout_rounded, color: Colors.red), onPressed: () => _logout(context)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('transactions').snapshots(),
              builder: (context, snapshot) {
                double totalDonasi = 0;
                int totalPending = 0;

                if (snapshot.hasData) {
                  for (var doc in snapshot.data!.docs) {
                    final data = doc.data() as Map<String, dynamic>;
                    if (data['status'] == 'Berhasil' || data['status'] == 'Success') {
                      totalDonasi += (data['grossAmount'] ?? data['nominal'] ?? 0).toDouble();
                    } else if (data['status'] == 'Pending') {
                      totalPending++;
                    }
                  }
                }

                return Container(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 5))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 24,
                            backgroundColor: Color(0xFFE8F5E9),
                            child: Icon(Icons.admin_panel_settings_rounded, color: Color(0xFF2E7D32), size: 28),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Selamat Datang,', style: TextStyle(fontSize: 13, color: Colors.grey)),
                              Text('Administrator', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
                            begin: Alignment.topLeft, end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [BoxShadow(color: const Color(0xFF4CAF50).withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Total Donasi & Zakat', style: TextStyle(color: Colors.white70, fontSize: 13)),
                                const SizedBox(height: 4),
                                Text(currencyFormatter.format(totalDonasi), style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const Icon(Icons.account_balance_wallet_rounded, color: Colors.white, size: 28),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      const Text('Transaksi', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
                      const SizedBox(height: 12),
                      _buildListMenu(
                        context, 
                        'Konfirmasi Pembayaran', 
                        Icons.receipt_long_rounded, 
                        const Color(0xFFE65100), 
                        const Color(0xFFFFF3E0), 
                        const AdminTransactionScreen(), 
                        badge: '$totalPending Pending'
                      ),
                    ],
                  ),
                );
              }
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Manajemen Program', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
                  const SizedBox(height: 12),
                  _buildListMenu(context, 'Kelola Zakat', Icons.clean_hands_rounded, const Color(0xFF2E7D32), const Color(0xFFE8F5E9), const AdminCampaignScreen(kategori: 'zakat')),
                  _buildListMenu(context, 'Kelola Infaq', Icons.mosque_rounded, const Color(0xFF2E7D32), const Color(0xFFE8F5E9), const AdminCampaignScreen(kategori: 'infaq')),
                  _buildListMenu(context, 'Kelola Sedekah', Icons.volunteer_activism_rounded, const Color(0xFF2E7D32), const Color(0xFFE8F5E9), const AdminCampaignScreen(kategori: 'sedekah')),
                  const SizedBox(height: 40),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildListMenu(BuildContext context, String title, IconData icon, Color iconColor, Color bgColor, Widget? targetScreen, {String? badge}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (badge != null && !badge.startsWith('0')) 
              Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFFFF3E0), borderRadius: BorderRadius.circular(20)),
                child: Text(badge, style: const TextStyle(color: Color(0xFFE65100), fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            const Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey, size: 16),
          ],
        ),
        onTap: () {
          if (targetScreen != null) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => targetScreen));
          }
        },
      ),
    );
  }
}

// ============================================================================
// 2. HALAMAN KELOLA TRANSAKSI
// ============================================================================
class AdminTransactionScreen extends StatefulWidget {
  const AdminTransactionScreen({Key? key}) : super(key: key);

  @override
  State<AdminTransactionScreen> createState() => _AdminTransactionScreenState();
}

class _AdminTransactionScreenState extends State<AdminTransactionScreen> {
  final currencyFormatter = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);

  void _konfirmasiPembayaran(String docId) async {
    try {
      await FirebaseFirestore.instance.collection('transactions').doc(docId).update({'status': 'Berhasil'});
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pembayaran dikonfirmasi!'), backgroundColor: Color(0xFF2E7D32)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal: $e'), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F4),
      appBar: AppBar(title: const Text('Konfirmasi Pembayaran'), backgroundColor: Colors.white, elevation: 0),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('transactions').orderBy('timestamp', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return const Center(child: Text("Belum ada transaksi."));

          final docs = snapshot.data!.docs;
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final isPending = data['status'] == 'Pending';
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: ListTile(
                  title: Text(data['kategori'] ?? 'Umum', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${data['name'] ?? 'Hamba Allah'}\n${currencyFormatter.format(data['grossAmount'] ?? 0)}'),
                  trailing: isPending 
                    ? ElevatedButton(onPressed: () => _konfirmasiPembayaran(docs[index].id), child: const Text('Konfirmasi'))
                    : const Icon(Icons.check_circle, color: Colors.green),
                ),
              );
            },
          );
        }
      ),
    );
  }
}

// ============================================================================
// 3. HALAMAN KELOLA PROGRAM (ZAKAT / INFAQ / SEDEKAH)
// ============================================================================
class AdminCampaignScreen extends StatefulWidget {
  final String kategori;
  const AdminCampaignScreen({Key? key, required this.kategori}) : super(key: key);

  @override
  State<AdminCampaignScreen> createState() => _AdminCampaignScreenState();
}

class _AdminCampaignScreenState extends State<AdminCampaignScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  void _showAddEditForm({ProgramZis? program}) {
    final judulController = TextEditingController(text: program?.judul ?? '');
    final deskripsiController = TextEditingController(text: program?.deskripsi ?? '');
    
    // VARIABEL STATE UNTUK MODAL
    bool localIsUrgent = program?.isUrgent ?? false;
    String? localTipeZakat = program?.tipeZakat; 

    showModalBottomSheet(
      context: context, 
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return StatefulBuilder( // Agar UI Modal Update saat Dropdown/Switch diklik
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, top: 24, left: 24, right: 24),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(program == null ? 'Tambah Program ${widget.kategori.toUpperCase()}' : 'Edit Program', 
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    
                    TextField(
                      controller: judulController,
                      decoration: const InputDecoration(labelText: 'Judul Program', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 16),

                    // --- DROPDOWN TIPE ZAKAT (HANYA MUNCUL JIKA KATEGORI ZAKAT) ---
                    if (widget.kategori.toLowerCase() == 'zakat') ...[
                      DropdownButtonFormField<String>(
                        value: localTipeZakat,
                        decoration: const InputDecoration(labelText: 'Tipe Rumus Zakat', border: OutlineInputBorder()),
                        items: const [
                          DropdownMenuItem(value: 'fitrah', child: Text('Zakat Fitrah (Jiwa)')),
                          DropdownMenuItem(value: 'penghasilan', child: Text('Zakat Penghasilan (Gaji)')),
                          DropdownMenuItem(value: 'maal', child: Text('Zakat Maal (Harta)')),
                          DropdownMenuItem(value: 'perdagangan', child: Text('Zakat Perdagangan')),
                          DropdownMenuItem(value: 'pertanian', child: Text('Zakat Pertanian')),
                        ],
                        onChanged: (val) {
                          setModalState(() => localTipeZakat = val);
                        },
                      ),
                      const SizedBox(height: 16),
                    ],

                    TextField(
                      controller: deskripsiController,
                      maxLines: 3,
                      decoration: const InputDecoration(labelText: 'Deskripsi Lengkap', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 16),
                    
                    SwitchListTile(
                      title: const Text("Status Darurat (Urgent)"),
                      subtitle: const Text("Tampilkan di 'Perlu Segera Dibantu'"),
                      value: localIsUrgent,
                      activeColor: Colors.red,
                      onChanged: (val) => setModalState(() => localIsUrgent = val),
                    ),
                    
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity, height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4CAF50)),
                        onPressed: () {
                          if (judulController.text.isEmpty) return;

                          final pBaru = ProgramZis(
                            judul: judulController.text.trim(),
                            deskripsi: deskripsiController.text.trim(),
                            kategori: widget.kategori.toLowerCase(),
                            isUrgent: localIsUrgent,
                            tipeZakat: localTipeZakat, // SIMPAN TIPE RUMUS
                          );

                          if (program == null) {
                            _firestoreService.addProgram(pBaru); 
                          } else {
                            _firestoreService.updateProgram(program.id!, pBaru); 
                          }
                          Navigator.pop(context);
                        },
                        child: const Text('SIMPAN', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            );
          }
        );
      }
    );
  }

  void _deleteProgram(String id) {
    _firestoreService.deleteProgram(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F4),
      appBar: AppBar(title: Text('Kelola ${widget.kategori.toUpperCase()}'), backgroundColor: Colors.white, elevation: 0),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditForm(),
        backgroundColor: const Color(0xFF4CAF50),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: StreamBuilder<List<ProgramZis>>(
        stream: _firestoreService.getPrograms(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          final filtered = snapshot.data?.where((p) => p.kategori == widget.kategori.toLowerCase()).toList() ?? [];
          if (filtered.isEmpty) return const Center(child: Text("Belum ada data."));

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final program = filtered[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(program.judul, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Tipe: ${program.tipeZakat ?? "Standard"}\nStatus: ${program.isUrgent ? "URGENT" : "Normal"}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _showAddEditForm(program: program)),
                      IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _deleteProgram(program.id!)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}