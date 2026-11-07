import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/mountain_model.dart';
import '../../providers/mountain_provider.dart';
import '../plan/create_plan_screen.dart';

class MountainDetailScreen extends StatelessWidget {
  final MountainModel mountain;

  const MountainDetailScreen({super.key, required this.mountain});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(mountain.name),
        actions: [
          Consumer<MountainProvider>(
            builder: (context, provider, child) {
              final isFav = provider.isFavorite(mountain.id);
              return IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? Colors.red : null,
                ),
                tooltip: isFav ? 'Hapus dari Favorit' : 'Tambah ke Favorit',
                onPressed: () {
                  provider.toggleFavorite(mountain.id);
                  final isNowFav = provider.isFavorite(mountain.id);

                  // Hapus antrean snackbar sebelumnya agar tidak menumpuk
                  ScaffoldMessenger.of(context).clearSnackBars();

                  // Tampilkan snackbar mengambang selama 1.5 detik
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(milliseconds: 1500),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      content: Row(
                        children: [
                          Icon(
                            isNowFav ? Icons.favorite : Icons.favorite_border,
                            color: isNowFav ? Colors.redAccent : Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              isNowFav
                                  ? '${mountain.name} ditambahkan ke Favorit'
                                  : '${mountain.name} dihapus dari Favorit',
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              mountain.imageUrl,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 250,
                color: Colors.grey.shade300,
                child: const Icon(Icons.landscape, size: 60),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        mountain.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            mountain.rating.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${mountain.location} • ${mountain.elevation} mdpl',
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                  ),
                  const Divider(height: 32),
                  const Text(
                    'Deskripsi',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    mountain.description,
                    style: const TextStyle(fontSize: 14, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Chip(
                        avatar: const Icon(Icons.timer, size: 16),
                        label: Text(mountain.estimatedTime),
                      ),
                      const SizedBox(width: 8),
                      Chip(
                        avatar: const Icon(Icons.terrain, size: 16),
                        label: Text(mountain.difficulty),
                      ),
                    ],
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreatePlanScreen(mountain: mountain),
              ),
            );
          },
          icon: const Icon(Icons.add_task),
          label: const Text(
            'Buat Rencana Pendakian',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}