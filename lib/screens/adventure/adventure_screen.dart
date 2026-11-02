import 'package:flutter/material.dart';

class AdventureScreen extends StatelessWidget {
  const AdventureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      appBar: AppBar(title: const Text('Jelajah Jalur')),
      body: const Center(
        child: Text('Katalog & Eksplorasi Jalur Pendakian'),
      ),
    );
  }
}