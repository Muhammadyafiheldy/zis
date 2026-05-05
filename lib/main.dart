import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screen/auth_gate.dart'; // Sesuaikan lokasi import-mu

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Zakat',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const AuthGate(), // Mulai dari Penjaga Gerbang
    );
  }
}
