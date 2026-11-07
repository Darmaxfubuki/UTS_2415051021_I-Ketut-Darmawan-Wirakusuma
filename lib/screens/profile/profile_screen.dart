import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _copyToClipboard(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 1500),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.tealAccent, size: 20),
            const SizedBox(width: 10),
            Text('$label berhasil disalin!'),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Row(
          children: [
            Icon(Icons.info_outline, color: Colors.teal),
            SizedBox(width: 8),
            Text('Tentang Aplikasi'),
          ],
        ),
        content: const Text(
          'Mountain Explorer v1.0.0\n\nAplikasi katalog pendakian dan manajemen rencana pendakian gunung di Indonesia yang mengintegrasikan REST API, Supabase Database, dan Provider State Management.',
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      appBar: AppBar(
        title: const Text('Profil Pengembang'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'Tentang Aplikasi',
            onPressed: () => _showAboutDialog(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 46,
              backgroundColor: Colors.teal,
              child: Icon(Icons.person, size: 54, color: Colors.white),
            ),
            const SizedBox(height: 14),
            const Text(
              'I Ketut Darmawan Wirakusuma',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              'NIM: 2415051021',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 2),
            Text(
              'Pendidikan Teknik Informatika',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.school, color: Colors.teal),
                    title: const Text('Program Studi'),
                    subtitle: const Text('S1 Pendidikan Teknik Informatika'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.terminal, color: Colors.teal),
                    title: const Text('Konsentrasi'),
                    subtitle: const Text('Rekayasa Perangkat Lunak (RPL)'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.code, color: Colors.teal),
                    title: const Text('GitHub Profil'),
                    subtitle: const Text('Darmaxfubuki'),
                    trailing: IconButton(
                      icon: const Icon(Icons.copy, size: 18, color: Colors.grey),
                      tooltip: 'Salin Username GitHub',
                      onPressed: () => _copyToClipboard(
                        context,
                        'https://github.com/Darmaxfubuki',
                        'Tautan GitHub',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}