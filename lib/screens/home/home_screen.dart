import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/mountain_provider.dart';
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
  final TextEditingController _searchController = TextEditingController();

  static const categories = ['Semua', 'Jawa', 'Bali', 'Lombok', 'Sumatera'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
    final mountainProvider = context.watch<MountainProvider>();
    final displayMountains = mountainProvider.filteredMountains;

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

          return RefreshIndicator(
            color: Colors.teal,
            onRefresh: () async {
              await context.read<MountainProvider>().fetchMountains();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
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
                  SearchBarWidget(
                    controller: _searchController,
                    onChanged: (value) {
                      context.read<MountainProvider>().setSearchQuery(value);
                    },
                  ),
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
                        final category = categories[index];
                        final isSelected = mountainProvider.selectedCategory == category;

                        return CategoryChip(
                          label: category,
                          isSelected: isSelected,
                          onTap: () {
                            context.read<MountainProvider>().setCategory(category);
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        mountainProvider.selectedCategory == 'Semua'
                            ? 'Katalog Gunung'
                            : 'Wilayah: ${mountainProvider.selectedCategory}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      if (mountainProvider.selectedCategory != 'Semua' ||
                          mountainProvider.searchQuery.isNotEmpty)
                        TextButton(
                          onPressed: () {
                            _searchController.clear();
                            context.read<MountainProvider>().setCategory('Semua');
                            context.read<MountainProvider>().setSearchQuery('');
                          },
                          child: const Text('Reset Filter'),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // State Handling REST API
                  if (mountainProvider.isLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 60),
                        child: Column(
                          children: [
                            CircularProgressIndicator(color: Colors.teal),
                            SizedBox(height: 16),
                            Text(
                              'Memuat katalog gunung...',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    )
                  else if (mountainProvider.errorMessage != null)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Column(
                          children: [
                            const Icon(Icons.cloud_off, size: 64, color: Colors.redAccent),
                            const SizedBox(height: 12),
                            Text(
                              mountainProvider.errorMessage!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.red),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                                context.read<MountainProvider>().fetchMountains();
                              },
                              icon: const Icon(Icons.refresh),
                              label: const Text('Coba Lagi'),
                            ),
                          ],
                        ),
                      ),
                    )
                  else if (displayMountains.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 60),
                        child: Column(
                          children: [
                            Icon(Icons.search_off, size: 60, color: Colors.grey.shade400),
                            const SizedBox(height: 8),
                            Text(
                              'Gunung tidak ditemukan',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    GridView.builder(
                      itemCount: displayMountains.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        mainAxisExtent: 260,
                      ),
                      itemBuilder: (context, index) {
                        final item = displayMountains[index];
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
            ),
          );
        },
      ),
    );
  }
}