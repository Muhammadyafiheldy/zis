import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart'; // TAMBAHKAN IMPORT INI

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  // ==========================================
  // HELPER UNTUK ICON & WARNA BERDASARKAN KATEGORI
  // ==========================================
  IconData _getIconByKategori(String kategori) {
    if (kategori.toLowerCase().contains('zakat')) return Icons.clean_hands_rounded;
    if (kategori.toLowerCase().contains('infaq')) return Icons.mosque_rounded;
    if (kategori.toLowerCase().contains('sedekah')) return Icons.volunteer_activism_rounded;
    return Icons.receipt_long_rounded; // Default icon
  }

  Color _getColorByKategori(String kategori) {
    if (kategori.toLowerCase().contains('zakat')) return const Color(0xFF4CAF50);
    if (kategori.toLowerCase().contains('infaq')) return const Color(0xFF1565C0);
    if (kategori.toLowerCase().contains('sedekah')) return const Color(0xFFE65100);
    return const Color(0xFF607D8B); // Default color
  }

  // ==========================================
  // FUNGSI GENERATE & DOWNLOAD PDF E-KWITANSI
  // ==========================================
  Future<void> _downloadKwitansi(BuildContext context, Map<String, dynamic> item) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Menyiapkan dokumen E-Kwitansi...'), duration: Duration(seconds: 1)),
    );

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a5,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text('LEMBAGA AMIL ZAKAT & BANSOS', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 4),
                    pw.Text('Tanda Terima Pembayaran Digital', style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700)),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Divider(thickness: 2),
              pw.SizedBox(height: 20),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [pw.Text('ID Transaksi:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)), pw.Text(item['id_transaksi'])]),
              pw.SizedBox(height: 10),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [pw.Text('Tanggal:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)), pw.Text(item['tanggal'])]),
              pw.SizedBox(height: 10),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [pw.Text('Kategori:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)), pw.Text(item['kategori'])]),
              pw.SizedBox(height: 10),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [pw.Text('Status:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)), pw.Text(item['status'], style: const pw.TextStyle(color: PdfColors.green))]),
              pw.SizedBox(height: 20),
              pw.Container(
                width: double.infinity, padding: const pw.EdgeInsets.all(12),
                decoration: const pw.BoxDecoration(color: PdfColors.grey200, borderRadius: pw.BorderRadius.all(pw.Radius.circular(8))),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('TOTAL PEMBAYARAN', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                    pw.Text(item['nominal'], style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                  ],
                ),
              ),
              pw.SizedBox(height: 40),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Text('Mengetahui,'), pw.SizedBox(height: 40),
                    pw.Text('Baznas Bengkalis', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, decoration: pw.TextDecoration.underline)),
                    pw.Text('a.n. Ketua Baznas', style: const pw.TextStyle(fontSize: 10)),
                  ],
                ),
              ),
              pw.Spacer(),
              pw.Center(child: pw.Text('Semoga Allah memberikan pahala atas apa yang engkau berikan.', style: pw.TextStyle(fontSize: 10, fontStyle: pw.FontStyle.italic), textAlign: pw.TextAlign.center)),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save(), name: 'E-Kwitansi_${item['id_transaksi']}.pdf');
  }

  @override
  Widget build(BuildContext context) {
    // Format mata uang Rupiah
    final currencyFormatter = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: const Color(0xFFF7FBF7),
      appBar: AppBar(
        title: const Text('Riwayat Transaksi', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white, elevation: 0, centerTitle: true,
      ),
      
      // MENGGUNAKAN STREAM BUILDER UNTUK MENGAMBIL DATA DARI FIRESTORE
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('transactions')
            .orderBy('timestamp', descending: true) // Urutkan dari yang terbaru
            .snapshots(),
        builder: (context, snapshot) {
          
          // 1. Tampilkan loading saat data sedang diambil
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF4CAF50)));
          }

          // 2. Jika ada error
          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          }

          // 3. Jika belum ada riwayat transaksi sama sekali
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Belum ada riwayat transaksi.', style: TextStyle(color: Colors.grey)));
          }

          // --- KUNCI UTAMA: AMBIL EMAIL USER YANG LAGI LOGIN ---
          final currentUser = FirebaseAuth.instance.currentUser;
          final userEmail = currentUser?.email ?? '';

          // --- FILTER DATA, HANYA AMBIL YANG EMAILNYA SAMA DENGAN USER ---
          final docs = snapshot.data!.docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return data['email'] == userEmail; // Mencocokkan email di transaksi dengan email user aktif
          }).toList();

          // Jika setelah difilter ternyata kosong (berarti transaksi yang ada milik orang lain)
          if (docs.isEmpty) {
            return const Center(child: Text('Belum ada riwayat transaksi.', style: TextStyle(color: Colors.grey)));
          }

          // Menghitung Total Donasi secara dinamis dari database (yang statusnya Berhasil) KHUSUS akun ini
          double totalDonasi = 0;
          for (var doc in docs) {
            final data = doc.data() as Map<String, dynamic>;
            if (data['status'] == 'Berhasil' || data['status'] == 'Success') {
              totalDonasi += (data['grossAmount'] ?? 0).toDouble();
            }
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // KARTU RINGKASAN TOTAL
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: const Color(0xFF4CAF50).withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Donasi & Zakat Anda', style: TextStyle(color: Colors.white70, fontSize: 14)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                          child: const Text('Tahun Ini', style: TextStyle(color: Colors.white, fontSize: 12)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      currencyFormatter.format(totalDonasi),
                      style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text('Transaksi Terbaru', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
              ),
              const SizedBox(height: 12),

              // LIST RIWAYAT TRANSAKSI DARI FIRESTORE
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    
                    // Parsing data dengan aman
                    String idTransaksi = data['orderId'] ?? data['order_id'] ?? 'TRX-UNKNOWN';
                    String kategori = data['kategori'] ?? 'Donasi Umum';
                    String status = data['status'] ?? 'Pending';
                    double nominal = (data['grossAmount'] ?? data['nominal'] ?? 0).toDouble();
                    
                    // Format Timestamp ke Tanggal
                    String tanggalStr = 'Tanggal tidak diketahui';
                    if (data['timestamp'] != null) {
                      DateTime date = (data['timestamp'] as Timestamp).toDate();
                      tanggalStr = DateFormat('dd MMM yyyy, HH:mm').format(date);
                    }

                    // Tentukan Warna & Icon
                    Color colorKategori = _getColorByKategori(kategori);
                    IconData iconKategori = _getIconByKategori(kategori);
                    bool isBerhasil = (status.toLowerCase() == 'berhasil' || status.toLowerCase() == 'success');

                    // Mapping ulang data untuk dikirim ke generator PDF E-Kwitansi
                    Map<String, dynamic> itemPdf = {
                      "id_transaksi": idTransaksi,
                      "kategori": kategori,
                      "tanggal": tanggalStr,
                      "nominal": currencyFormatter.format(nominal),
                      "status": isBerhasil ? 'Berhasil' : status,
                    };

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: colorKategori.withOpacity(0.1), shape: BoxShape.circle),
                            child: Icon(iconKategori, color: colorKategori, size: 28),
                          ),
                          const SizedBox(width: 16),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(kategori, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87), overflow: TextOverflow.ellipsis),
                                const SizedBox(height: 4),
                                Text(tanggalStr, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: isBerhasil ? const Color(0xFFE8F5E9) : const Color(0xFFFFF3E0),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    isBerhasil ? 'Berhasil' : status,
                                    style: TextStyle(
                                      fontSize: 10, fontWeight: FontWeight.bold,
                                      color: isBerhasil ? const Color(0xFF2E7D32) : const Color(0xFFE65100),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(currencyFormatter.format(nominal), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)),
                              const SizedBox(height: 8),
                              if (isBerhasil)
                                InkWell(
                                  onTap: () {
                                    _downloadKwitansi(context, itemPdf);
                                  },
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(border: Border.all(color: const Color(0xFF4CAF50)), borderRadius: BorderRadius.circular(8)),
                                    child: const Icon(Icons.download_rounded, color: Color(0xFF4CAF50), size: 18),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}