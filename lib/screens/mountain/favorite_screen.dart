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
    final favoriteMountains = mountainProvider.mountains
        .where((m) => mountainProvider.isFavorite(m.id))
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      appBar: AppBar(
        title: const Text('Gunung Favorit'),
        elevation: 0,
      ),
      body: favoriteMountains.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border_rounded,
                      size: 72,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Belum Ada Gunung Favorit',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Tandai gunung impianmu dengan ikon hati di halaman detail.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = 1;
                double childAspectRatio = 1.25;

                if (constraints.maxWidth >= 1200) {
                  crossAxisCount = 4;
                  childAspectRatio = 1.05;
                } else if (constraints.maxWidth >= 850) {
                  crossAxisCount = 3;
                  childAspectRatio = 1.1;
                } else if (constraints.maxWidth >= 600) {
                  crossAxisCount = 2;
                  childAspectRatio = 1.15;
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: favoriteMountains.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: childAspectRatio,
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