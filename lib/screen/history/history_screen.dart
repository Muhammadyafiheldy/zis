import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  // Data Dummy untuk Riwayat Transaksi
  final List<Map<String, dynamic>> riwayatTransaksi = const [
    {
      "id_transaksi": "TRX-20260505-001",
      "kategori": "Zakat Penghasilan",
      "tanggal": "05 Mei 2026",
      "nominal": "Rp 250.000",
      "status": "Berhasil",
      "icon": Icons.clean_hands_rounded,
      "color": Color(0xFF4CAF50), 
    },
    {
      "id_transaksi": "TRX-20260502-089",
      "kategori": "Infaq Pembangunan Masjid",
      "tanggal": "02 Mei 2026",
      "nominal": "Rp 50.000",
      "status": "Berhasil",
      "icon": Icons.mosque_rounded,
      "color": Color(0xFF1565C0), 
    },
    {
      "id_transaksi": "TRX-20260428-102",
      "kategori": "Sedekah Kemanusiaan",
      "tanggal": "28 Apr 2026",
      "nominal": "Rp 100.000",
      "status": "Pending",
      "icon": Icons.volunteer_activism_rounded,
      "color": Color(0xFFE65100), 
    },
  ];

  // ==========================================
  // FUNGSI GENERATE & DOWNLOAD PDF E-KWITANSI
  // ==========================================
  Future<void> _downloadKwitansi(BuildContext context, Map<String, dynamic> item) async {
    // Tampilkan loading snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Menyiapkan dokumen E-Kwitansi...'), duration: Duration(seconds: 1)),
    );

    final pdf = pw.Document();

    // Menggambar desain halaman PDF
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a5, // Ukuran kertas A5 (cocok untuk kwitansi)
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Kop Kwitansi
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

              // Detail Transaksi
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('ID Transaksi:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(item['id_transaksi']),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Tanggal:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(item['tanggal']),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Kategori:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(item['kategori']),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Status:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(item['status'], style: const pw.TextStyle(color: PdfColors.green)),
                ],
              ),
              
              pw.SizedBox(height: 20),
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(color: PdfColors.grey200, borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8))),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('TOTAL PEMBAYARAN', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                    pw.Text(item['nominal'], style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                  ],
                ),
              ),
              
              pw.SizedBox(height: 40),
              
              // Footer & Tanda Tangan
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Text('Mengetahui,'),
                    pw.SizedBox(height: 40), // Spasi untuk stempel/tanda tangan
                    pw.Text('Muhammad Syahril', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, decoration: pw.TextDecoration.underline)),
                    pw.Text('Admin Sistem ZIS', style: const pw.TextStyle(fontSize: 10)),
                  ],
                ),
              ),
              
              pw.Spacer(),
              pw.Center(
                child: pw.Text(
                  'Semoga Allah memberikan pahala atas apa yang engkau berikan.',
                  style: const pw.TextStyle(fontSize: 10, fontStyle: pw.FontStyle.italic),
                  textAlign: pw.TextAlign.center,
                ),
              ),
            ],
          );
        },
      ),
    );

    // Membuka dialog print / save as PDF bawaan sistem HP
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'E-Kwitansi_${item['id_transaksi']}.pdf',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBF7), 
      appBar: AppBar(
        title: const Text('Riwayat Transaksi', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // KARTU RINGKASAN TOTAL
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
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
                    )
                  ],
                ),
                const SizedBox(height: 12),
                const Text('Rp 400.000', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text('Transaksi Terbaru', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
          ),
          const SizedBox(height: 12),

          // LIST RIWAYAT TRANSAKSI
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: riwayatTransaksi.length,
              itemBuilder: (context, index) {
                final item = riwayatTransaksi[index];
                final isBerhasil = item['status'] == 'Berhasil';

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
                        decoration: BoxDecoration(color: item['color'].withOpacity(0.1), shape: BoxShape.circle),
                        child: Icon(item['icon'], color: item['color'], size: 28),
                      ),
                      const SizedBox(width: 16),
                      
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['kategori'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)),
                            const SizedBox(height: 4),
                            Text(item['tanggal'], style: const TextStyle(fontSize: 12, color: Colors.grey)),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: isBerhasil ? const Color(0xFFE8F5E9) : const Color(0xFFFFF3E0),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                item['status'],
                                style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.bold,
                                  color: isBerhasil ? const Color(0xFF2E7D32) : const Color(0xFFE65100),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(item['nominal'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)),
                          const SizedBox(height: 8),
                          if (isBerhasil)
                            InkWell(
                              onTap: () {
                                // Memanggil fungsi download PDF
                                _downloadKwitansi(context, item);
                              },
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(border: Border.all(color: const Color(0xFF4CAF50)), borderRadius: BorderRadius.circular(8)),
                                child: const Icon(Icons.download_rounded, color: Color(0xFF4CAF50), size: 18),
                              ),
                            )
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}