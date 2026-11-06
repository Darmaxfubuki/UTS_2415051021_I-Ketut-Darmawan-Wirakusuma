import 'package:flutter/material.dart';
import '../models/mountain_model.dart';
import '../repositories/mountain_repository.dart';

class MountainProvider with ChangeNotifier {
  final MountainRepository _repository = MountainRepository();

  List<MountainModel> _mountains = [];
  bool _isLoading = false;
  String? _errorMessage;

  String _selectedCategory = 'Semua';
  String _searchQuery = '';
  final Set<String> _favoriteIds = {};

  List<MountainModel> get mountains => _mountains;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  MountainProvider() {
    fetchMountains();
  }

  Future<void> fetchMountains() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _mountains = await _repository.getMountains();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  List<MountainModel> get filteredMountains {
    return _mountains.where((mountain) {
      final matchesCategory = _selectedCategory == 'Semua' ||
          mountain.location.toLowerCase().contains(_selectedCategory.toLowerCase());
      final matchesSearch = mountain.name
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  // --- LOGIKA FITUR FAVORIT ---
  List<MountainModel> get favoriteMountains =>
      _mountains.where((m) => _favoriteIds.contains(m.id)).toList();

  bool isFavorite(String id) => _favoriteIds.contains(id);

  void toggleFavorite(String id) {
    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
    } else {
      _favoriteIds.add(id);
    }
    notifyListeners();
  }
}