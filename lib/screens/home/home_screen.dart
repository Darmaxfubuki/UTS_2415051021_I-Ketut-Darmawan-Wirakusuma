import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../widgets/bottom_nav.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/mountain_card.dart';
import '../../widgets/search_bar_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const categories = ['Semua', 'Jawa', 'Bali', 'Lombok', 'Sumatera'];

    final dummyMountains = [
      {
        'name': 'Gunung Batur',
        'location': 'Bali',
        'elevation': 1717,
        'rating': 4.8,
        'imageUrl':
            'https://images.unsplash.com/photo-1544644181-1484b3fdfc62?auto=format&fit=crop&w=800&q=80',
      },
      {
        'name': 'Gunung Rinjani',
        'location': 'Lombok',
        'elevation': 3726,
        'rating': 4.9,
        'imageUrl':
            'https://images.unsplash.com/photo-1579783900882-c0d3dad7b119?auto=format&fit=crop&w=800&q=80',
      },
      {
        'name': 'Gunung Semeru',
        'location': 'Jawa Timur',
        'elevation': 3676,
        'rating': 4.8,
        'imageUrl':
            'https://images.unsplash.com/photo-1588668214407-6ea9a6d8c272?auto=format&fit=crop&w=800&q=80',
      },
      {
        'name': 'Gunung Merbabu',
        'location': 'Jawa Tengah',
        'elevation': 3145,
        'rating': 4.7,
        'imageUrl':
            'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=800&q=80',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      appBar: AppBar(
        title: const Text(
          AppConstants.appName,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, size: 28),
            onPressed: () {},
          ),
        ],
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: 0,
        onTap: (index) {},
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Menentukan jumlah kolom secara dinamis berdasarkan lebar layar
          int crossAxisCount = 1;
          if (constraints.maxWidth >= 1200) {
            crossAxisCount = 4;
          } else if (constraints.maxWidth >= 850) {
            crossAxisCount = 3;
          } else if (constraints.maxWidth >= 600) {
            crossAxisCount = 2;
          }

          final horizontalPadding = constraints.maxWidth >= 600 ? 24.0 : 16.0;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Halo, Darmawan 👋',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  AppConstants.appSubtitle,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 16),
                const SearchBarWidget(),
                const SizedBox(height: 20),
                const Text(
                  'Kategori',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 38,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      return CategoryChip(
                        label: categories[index],
                        isSelected: index == 0,
                        onTap: () {},
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Gunung Populer',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Lihat Semua'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                GridView.builder(
                  itemCount: dummyMountains.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    mainAxisExtent: 260,
                  ),
                  itemBuilder: (context, index) {
                    final item = dummyMountains[index];
                    return MountainCard(
                      name: item['name'] as String,
                      location: item['location'] as String,
                      elevation: item['elevation'] as int,
                      rating: (item['rating'] as num).toDouble(),
                      imageUrl: item['imageUrl'] as String,
                      onTap: () {},
                    );
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}