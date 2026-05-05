class User {
  final String?
  id; // Dibuat nullable (?) karena saat create/addUser, ID belum ada (di-generate Firestore)
  final String name;
  final String email;
  final String role; // Ini yang membedakan User biasa dan Admin

  User({this.id, required this.name, required this.email, required this.role});

  // Fungsi untuk mengubah data dari Firestore menjadi objek User
  factory User.fromMap(Map<String, dynamic> data, String documentId) {
    return User(
      id: documentId,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? 'user', // Jika kosong, setel default sebagai 'user'
    );
  }

  // Fungsi untuk membungkus objek User menjadi Map sebelum dikirim ke Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'role': role,
      'created_at': DateTime.now(), // Opsional: untuk tahu kapan akun dibuat
    };
  }
}
