import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/mountain_provider.dart';
import '../../widgets/mountain_card.dart';
import 'mountain_detail_screen.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mountainProvider = context.watch<MountainProvider>();
    final favoriteMountains = mountainProvider.favoriteMountains;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      appBar: AppBar(
        title: const Text('Gunung Favorit'),
      ),
      body: favoriteMountains.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 70,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Belum ada gunung favorit',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Buka detail gunung lalu tekan ikon hati untuk menyimpannya.',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                ],
              ),
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = 1;
                if (constraints.maxWidth >= 1200) {
                  crossAxisCount = 4;
                } else if (constraints.maxWidth >= 850) {
                  crossAxisCount = 3;
                } else if (constraints.maxWidth >= 600) {
                  crossAxisCount = 2;
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: favoriteMountains.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    mainAxisExtent: 260,
                  ),
                  itemBuilder: (context, index) {
                    final item = favoriteMountains[index];
                    return MountainCard(
                      name: item.name,
                      location: item.location,
                      elevation: item.elevation,
                      rating: item.rating,
                      imageUrl: item.imageUrl,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MountainDetailScreen(mountain: item),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
    );
  }
}