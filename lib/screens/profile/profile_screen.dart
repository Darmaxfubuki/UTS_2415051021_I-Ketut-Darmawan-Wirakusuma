import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      appBar: AppBar(title: const Text('Profil Saya')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.teal,
              child: Icon(Icons.person, size: 45, color: Colors.white),
            ),
            SizedBox(height: 12),
            Text(
              'I Ketut Darmawan Wirakusuma',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '2415051021 - Pendidikan Teknik Informatika',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}