import 'package:flutter/material.dart';

// ============================================================================
// 1. HALAMAN MENU DAFTAR ZAKAT 
// ============================================================================
class ZakatMenuScreen extends StatelessWidget {
  ZakatMenuScreen({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> listZakat = [
    {
      'id': 'penghasilan',
      'title': 'Zakat Penghasilan (Profesi)',
      'image': 'https://images.unsplash.com/photo-1579621970563-ebec7560ff3e?ixlib=rb-4.0.3&auto=format&fit=crop&w=600&q=80',
      'short_desc': 'Zakat dari pendapatan rutin (gaji/honor).',
      'full_desc': 'Zakat penghasilan atau profesi adalah zakat yang wajib dikeluarkan saat menerima gaji jika total pendapatan setahun mencapai nishab.\n\nNishab setara dengan 85 gram emas. Jika sudah mencapai nishab, maka wajib mengeluarkan zakat sebesar 2.5% dari total pendapatan kotor.',
    },
    {
      'id': 'maal',
      'title': 'Zakat Maal (Harta)',
      'image': 'https://images.unsplash.com/photo-1611125832047-1d7ad1e8e48f?ixlib=rb-4.0.3&auto=format&fit=crop&w=600&q=80',
      'short_desc': 'Zakat dari simpanan harta yang mengendap 1 tahun.',
      'full_desc': 'Zakat Maal dikenakan atas harta seperti tabungan, uang kas, emas, atau investasi yang sudah mengendap selama 1 tahun (haul).\n\nNishab setara dengan 85 gram emas. Kadar zakat yang dikeluarkan adalah 2.5% dari (kas + tabungan + investasi - hutang jatuh tempo).',
    },
    {
      'id': 'perdagangan',
      'title': 'Zakat Perdagangan',
      'image': 'https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?ixlib=rb-4.0.3&auto=format&fit=crop&w=600&q=80',
      'short_desc': 'Zakat dari aset dan keuntungan usaha niaga.',
      'full_desc': 'Zakat yang wajib dikeluarkan dari harta niaga atau usaha perdagangan.\n\nKadar zakat perdagangan adalah 2.5% yang dihitung dari: (Modal yang diputar + Piutang lancar + Laba) dikurangi Hutang jatuh tempo.',
    },
    {
      'id': 'pertanian',
      'title': 'Zakat Pertanian',
      'image': 'https://images.unsplash.com/photo-1500382017468-9049fed747ef?ixlib=rb-4.0.3&auto=format&fit=crop&w=600&q=80',
      'short_desc': 'Zakat dari hasil panen pertanian/perkebunan.',
      'full_desc': 'Zakat yang dikeluarkan setiap kali panen apabila hasilnya telah mencapai nishab (653 kg gabah atau 520 kg beras).\n\nKadar zakat dibedakan berdasarkan jenis pengairan:\n• 10% untuk tadah hujan (tanpa biaya air).\n• 5% untuk irigasi/pengairan berbayar.',
    },
    {
      'id': 'fitrah',
      'title': 'Zakat Fitrah',
      'image': 'https://images.unsplash.com/photo-1507675914619-7984cd123eb4?ixlib=rb-4.0.3&auto=format&fit=crop&w=600&q=80',
      'short_desc': 'Zakat wajib bagi setiap muslim di bulan Ramadhan.',
      'full_desc': 'Zakat Fitrah adalah zakat yang wajib ditunaikan oleh setiap jiwa muslim pada bulan Ramadhan sebelum shalat Idul Fitri.\n\nKadar Zakat Fitrah adalah 2.5 kg atau 3.5 liter beras/makanan pokok per orang. Nilai uang tunai disesuaikan dengan harga beras yang biasa dikonsumsi sehari-hari oleh individu tersebut.',
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBF7), 
      appBar: AppBar(
        title: const Text('Pilih Jenis Zakat', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: listZakat.length,
        itemBuilder: (context, index) {
          final zakat = listZakat[index];
          return Card(
            color: Colors.white,
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => ZakatDetailScreen(dataZakat: zakat),
                ));
              },
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
                    child: Image.network(
                      zakat['image'],
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 100, height: 100, color: Colors.grey.shade200,
                        child: const Icon(Icons.image, color: Colors.grey),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(zakat['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF2E7D32))),
                          const SizedBox(height: 6),
                          Text(zakat['short_desc'], style: TextStyle(fontSize: 12, color: Colors.grey.shade600), maxLines: 2, overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Icon(Icons.arrow_forward_ios, color: Color(0xFF4CAF50), size: 16),
                  )
                ],
              ),
            ),
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

  void _showCalculator(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ZakatCalculatorForm(zakatId: dataZakat['id'], title: dataZakat['title']),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(dataZakat['title'], style: const TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              dataZakat['image'],
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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('Informasi & Panduan', style: TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    dataZakat['full_desc'],
                    style: const TextStyle(fontSize: 15, height: 1.6, color: Colors.black87),
                  ),
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
            onPressed: () => _showCalculator(context), 
            child: const Text('HITUNG & BAYAR ZAKAT', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// 3. KALKULATOR BOTTOM SHEET BERDASARKAN RUMUS BAZNAS
// ============================================================================
class ZakatCalculatorForm extends StatefulWidget {
  final String zakatId;
  final String title;

  const ZakatCalculatorForm({Key? key, required this.zakatId, required this.title}) : super(key: key);

  @override
  _ZakatCalculatorFormState createState() => _ZakatCalculatorFormState();
}

class _ZakatCalculatorFormState extends State<ZakatCalculatorForm> {
  double _totalZakat = 0;

  // Controllers
  final TextEditingController _val1Ctrl = TextEditingController();
  final TextEditingController _val2Ctrl = TextEditingController();
  
  int _jenisPengairan = 0; 

  void _hitungZakat() {
    setState(() {
      double val1 = double.tryParse(_val1Ctrl.text) ?? 0;
      double val2 = double.tryParse(_val2Ctrl.text) ?? 0;

      if (widget.zakatId == 'penghasilan') {
        _totalZakat = (val1 + val2) * 0.025; 
      } 
      else if (widget.zakatId == 'maal') {
        double bersih = val1 - val2;
        _totalZakat = bersih > 0 ? bersih * 0.025 : 0; 
      } 
      else if (widget.zakatId == 'perdagangan') {
        double bersih = val1 - val2;
        _totalZakat = bersih > 0 ? bersih * 0.025 : 0; 
      }
      else if (widget.zakatId == 'pertanian') {
        double persentase = _jenisPengairan == 0 ? 0.10 : 0.05;
        _totalZakat = val1 * persentase;
      }
      // UPDATE LOGIKA ZAKAT FITRAH DI SINI
      else if (widget.zakatId == 'fitrah') {
        // Zakat Fitrah = Jumlah Jiwa * (Harga Beras per Kg * 2.5 Kg)
        _totalZakat = val1 * (val2 * 2.5);
      }
    });
  }

  Widget _buildTextField(String label, TextEditingController controller, {IconData? suffixIcon, String? prefixText}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        onChanged: (value) => _hitungZakat(),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFF2E7D32)),
          filled: true,
          fillColor: const Color(0xFFF7FBF7),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2)),
          prefixText: prefixText ?? 'Rp ',
          prefixStyle: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
          suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: const Color(0xFF4CAF50)) : null,
        ),
      ),
    );
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
                Text('Kalkulator ${widget.title}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                IconButton(icon: const Icon(Icons.close, color: Colors.grey), onPressed: () => Navigator.pop(context)),
              ],
            ),
            const SizedBox(height: 20),

            // FORM INPUT SESUAI JENIS ZAKAT
            if (widget.zakatId == 'penghasilan') ...[
              _buildTextField('Total Pendapatan / Gaji per Bulan', _val1Ctrl),
              _buildTextField('Pendapatan Lain (Bonus/THR)', _val2Ctrl),
            ] 
            else if (widget.zakatId == 'maal') ...[
              _buildTextField('Kas + Tabungan + Investasi', _val1Ctrl),
              _buildTextField('Hutang Jatuh Tempo', _val2Ctrl),
            ] 
            else if (widget.zakatId == 'perdagangan') ...[
              _buildTextField('Modal + Piutang Lancar + Laba', _val1Ctrl),
              _buildTextField('Hutang Jatuh Tempo', _val2Ctrl),
            ]
            else if (widget.zakatId == 'pertanian') ...[
              _buildTextField('Estimasi Nilai Hasil Panen', _val1Ctrl),
              const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text('Jenis Pengairan:', style: TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.bold)),
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () { setState(() { _jenisPengairan = 0; _hitungZakat(); }); },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _jenisPengairan == 0 ? const Color(0xFF4CAF50) : Colors.white,
                          border: Border.all(color: const Color(0xFF4CAF50)),
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
                        ),
                        child: Text('Tadah Hujan (10%)', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: _jenisPengairan == 0 ? Colors.white : const Color(0xFF4CAF50))),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () { setState(() { _jenisPengairan = 1; _hitungZakat(); }); },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _jenisPengairan == 1 ? const Color(0xFF4CAF50) : Colors.white,
                          border: Border.all(color: const Color(0xFF4CAF50)),
                          borderRadius: const BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8)),
                        ),
                        child: Text('Irigasi Berbayar (5%)', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: _jenisPengairan == 1 ? Colors.white : const Color(0xFF4CAF50))),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ]
            // FORM ZAKAT FITRAH YANG BARU
            else if (widget.zakatId == 'fitrah') ...[
              _buildTextField('Jumlah Jiwa / Anggota Keluarga', _val1Ctrl, suffixIcon: Icons.person, prefixText: ''),
              _buildTextField('Harga Beras/Makanan Pokok (per Kg)', _val2Ctrl),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  '*Sistem akan otomatis mengalikan harga beras per Kg dengan standar Zakat Fitrah yaitu 2.5 Kg untuk tiap jiwa.', 
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontStyle: FontStyle.italic)
                ),
              ),
            ],

            const SizedBox(height: 10),

            // KOTAK HASIL & LANJUTKAN PEMBAYARAN
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF4CAF50).withOpacity(0.5)),
              ),
              child: Column(
                children: [
                  const Text('Total Zakat yang harus dibayar', style: TextStyle(color: Color(0xFF2E7D32), fontSize: 14)),
                  const SizedBox(height: 8),
                  Text(
                    'Rp ${_totalZakat.toStringAsFixed(0)}',
                    style: const TextStyle(color: Color(0xFF2E7D32), fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: _totalZakat > 0 ? () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Memproses Zakat Rp ${_totalZakat.toStringAsFixed(0)}...'),
                            backgroundColor: const Color(0xFF2E7D32),
                          )
                        );
                      } : null,
                      child: const Text('LANJUTKAN PEMBAYARAN', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}