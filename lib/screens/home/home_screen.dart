import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../models/mountain_model.dart';
import '../../widgets/bottom_nav.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/mountain_card.dart';
import '../../widgets/search_bar_widget.dart';
import '../adventure/adventure_screen.dart';
import '../mountain/favorite_screen.dart';
import '../mountain/mountain_detail_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNavIndex = 0;
  int _selectedCategoryIndex = 0;

  static const categories = ['Semua', 'Jawa', 'Bali', 'Lombok', 'Sumatera'];

  static final List<MountainModel> dummyMountains = [
    const MountainModel(
      id: '1',
      name: 'Gunung Batur',
      location: 'Bali',
      elevation: 1717,
      rating: 4.8,
      imageUrl:
          'https://images.unsplash.com/photo-1544644181-1484b3fdfc62?auto=format&fit=crop&w=800&q=80',
      description:
          'Gunung Batur adalah gunung berapi aktif di Kintamani, Bali. Terkenal dengan pemandangan matahari terbitnya yang spektakuler di atas kaldera dan Danau Batur.',
      estimatedTime: '2 - 3 Jam',
      difficulty: 'Mudah - Sedang',
    ),
    const MountainModel(
      id: '2',
      name: 'Gunung Rinjani',
      location: 'Lombok',
      elevation: 3726,
      rating: 4.9,
      imageUrl:
          'https://images.unsplash.com/photo-1579783900882-c0d3dad7b119?auto=format&fit=crop&w=800&q=80',
      description:
          'Gunung Rinjani merupakan gunung berapi kedua tertinggi di Indonesia dengan pemandangan Danau Segara Anak yang ikonik dan jalur savana Sembalun.',
      estimatedTime: '3 - 4 Hari',
      difficulty: 'Menantang',
    ),
    const MountainModel(
      id: '3',
      name: 'Gunung Semeru',
      location: 'Jawa Timur',
      elevation: 3676,
      rating: 4.8,
      imageUrl:
          'https://images.unsplash.com/photo-1588668214407-6ea9a6d8c272?auto=format&fit=crop&w=800&q=80',
      description:
          'Puncak tertinggi di Pulau Jawa (Mahameru). Menawarkan keindahan Ranu Kumbolo dan Oro-oro Ombo yang mempesona para pendaki nusantara.',
      estimatedTime: '3 - 4 Hari',
      difficulty: 'Sangat Menantang',
    ),
    const MountainModel(
      id: '4',
      name: 'Gunung Merbabu',
      location: 'Jawa Tengah',
      elevation: 3145,
      rating: 4.7,
      imageUrl:
          'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=800&q=80',
      description:
          'Gunung Merbabu terkenal dengan padang sabananya yang hijau dan luas serta pemandangan gagah Gunung Merapi dari puncaknya.',
      estimatedTime: '7 - 9 Jam',
      difficulty: 'Menengah',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screens = [
      _buildHomeContent(),
      const FavoriteScreen(),
      const AdventureScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      bottomNavigationBar: BottomNav(
        currentIndex: _currentNavIndex,
        onTap: (index) {
          setState(() {
            _currentNavIndex = index;
          });
        },
      ),
      body: screens[_currentNavIndex],
    );
  }

  Widget _buildHomeContent() {
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
            onPressed: () {
              setState(() {
                _currentNavIndex = 3;
              });
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
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
                        isSelected: _selectedCategoryIndex == index,
                        onTap: () {
                          setState(() {
                            _selectedCategoryIndex = index;
                          });
                        },
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
                      name: item.name,
                      location: item.location,
                      elevation: item.elevation,
                      rating: item.rating,
                      imageUrl: item.imageUrl,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MountainDetailScreen(mountain: item),
                          ),
                        );
                      },
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