import 'package:flutter/material.dart';
import '../models/mountain_model.dart';
import '../models/saved_mountain_model.dart';
import '../repositories/mountain_repository.dart';

class MountainProvider extends ChangeNotifier {
  final MountainRepository _repository;

  List<MountainModel> _mountains = [];
  bool _isLoading = false;
  String? _errorMessage;

  String _selectedCategory = 'Semua';
  String _searchQuery = '';

  final List<SavedMountainModel> _savedMountains = [];

  // Getters
  List<MountainModel> get mountains => _mountains;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  List<SavedMountainModel> get savedMountains => _savedMountains;

  List<MountainModel> get filteredMountains {
    return _mountains.where((mountain) {
      final matchesCategory = _selectedCategory == 'Semua' ||
          mountain.location.toLowerCase().contains(_selectedCategory.toLowerCase());

      final matchesSearch = mountain.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          mountain.location.toLowerCase().contains(_searchQuery.toLowerCase());

      return matchesCategory && matchesSearch;
    }).toList();
  }

  MountainProvider({MountainRepository? repository})
      : _repository = repository ?? MountainRepository() {
    fetchMountains();
  }

  Future<void> fetchMountains() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _mountains = await _repository.getMountains();
      _isLoading = false;
      _errorMessage = null;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Gagal memuat katalog gunung: ${e.toString()}';
    }
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  bool isMountainSaved(String mountainId) {
    return _savedMountains.any((item) => item.mountainId == mountainId);
  }

  bool toggleSaveMountain(MountainModel mountain, {String note = 'Rencana pendakian saya'}) {
    final index = _savedMountains.indexWhere((item) => item.mountainId == mountain.id);

    if (index >= 0) {
      _savedMountains.removeAt(index);
      notifyListeners();
      return false;
    } else {
      _savedMountains.add(
        SavedMountainModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          mountainId: mountain.id,
          mountainName: mountain.name,
          userNote: note,
          personalRating: mountain.rating.round(),
          createdAt: DateTime.now(),
        ),
      );
      notifyListeners();
      return true;
    }
  }

  void removeSavedMountain(String id) {
    _savedMountains.removeWhere((item) => item.id == id);
    notifyListeners();
  }
}