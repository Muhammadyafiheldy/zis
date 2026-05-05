import 'package:flutter/material.dart';

class AdminVerificationScreen extends StatelessWidget {
  const AdminVerificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verifikasi Pembayaran')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: const Color(0xFF1E1E1E),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: const Icon(Icons.pending_actions, color: Colors.orange, size: 36),
              title: const Text('Hamba Allah - Rp 100.000', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text('Bansos Pendidikan\nMenunggu Verifikasi'),
              ),
              isThreeLine: true,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red), 
                    onPressed: () {}
                  ),
                  IconButton(
                    icon: const Icon(Icons.check_circle, color: Color(0xFF00FF7F)), 
                    onPressed: () {}
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}