import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/mountain_model.dart';
import '../../providers/mountain_provider.dart';

class MountainDetailScreen extends StatelessWidget {
  final MountainModel mountain;

  const MountainDetailScreen({
    super.key,
    required this.mountain,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MountainProvider>();
    final isSaved = provider.isMountainSaved(mountain.id);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                mountain.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black54,
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
              background: Image.network(
                mountain.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey.shade300,
                  alignment: Alignment.center,
                  child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.teal, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            mountain.location,
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.amber.shade200),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              mountain.rating.toString(),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(Icons.terrain, '${mountain.elevation} mdpl', 'Ketinggian'),
                        Container(height: 35, width: 1, color: Colors.grey.shade200),
                        _buildStatItem(Icons.timer, mountain.estimatedTime, 'Estimasi Waktu'),
                        Container(height: 35, width: 1, color: Colors.grey.shade200),
                        _buildStatItem(Icons.speed, mountain.difficulty, 'Tingkat Kesulitan'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Tentang Destinasi',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    mountain.description,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700, height: 1.6),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSaved ? Colors.red.shade400 : Colors.teal,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        final saved = context.read<MountainProvider>().toggleSaveMountain(mountain);
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              saved
                                  ? 'Berhasil menyimpan ${mountain.name} ke rencana pendakian!'
                                  : 'Menghapus ${mountain.name} dari rencana pendakian.',
                            ),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: saved ? Colors.teal : Colors.grey.shade800,
                          ),
                        );
                      },
                      icon: Icon(isSaved ? Icons.bookmark_remove : Icons.bookmark_add_outlined),
                      label: Text(
                        isSaved ? 'Hapus dari Rencana' : 'Simpan ke Rencana Pendakian',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.teal, size: 22),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
        ),
      ],
    );
  }
}