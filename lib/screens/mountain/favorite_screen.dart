import 'package:flutter/material.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      appBar: AppBar(title: const Text('Gunung Tersimpan')),
      body: const Center(
        child: Text('Daftar Gunung Favorit Anda'),
      ),
    );
  }
}