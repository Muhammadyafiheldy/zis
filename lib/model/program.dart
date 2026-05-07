class ProgramZis {
  String? id;
  String judul;
  String deskripsi;
  String kategori;
  String? tipeZakat;
  String? imageUrl; // Tambahkan ini
  bool isUrgent;

  ProgramZis({
    this.id,
    required this.judul,
    required this.deskripsi,
    required this.kategori,
    this.tipeZakat,
    this.imageUrl,
    this.isUrgent = false,
  });

  factory ProgramZis.fromMap(Map<String, dynamic> data, String documentId) {
    return ProgramZis(
      id: documentId,
      judul: data['judul'] ?? '',
      deskripsi: data['deskripsi'] ?? '',
      kategori: data['kategori'] ?? 'infaq',
      tipeZakat: data['tipeZakat'],
      imageUrl: data['imageUrl'], // Ambil link foto
      isUrgent: data['isUrgent'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'judul': judul,
      'deskripsi': deskripsi,
      'kategori': kategori,
      'tipeZakat': tipeZakat,
      'imageUrl': imageUrl, // Simpan link foto
      'isUrgent': isUrgent,
      'created_at': DateTime.now(),
    };
  }
}