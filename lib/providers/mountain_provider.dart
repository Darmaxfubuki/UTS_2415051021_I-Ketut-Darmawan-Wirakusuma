import 'package:flutter/material.dart';
import '../models/mountain_model.dart';
import '../models/saved_mountain_model.dart';

class MountainProvider extends ChangeNotifier {
  // State data katalog
  List<MountainModel> _mountains = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Shared state: Daftar rencana pendakian / favorit
  final List<SavedMountainModel> _savedMountains = [];

  // Getters
  List<MountainModel> get mountains => _mountains;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<SavedMountainModel> get savedMountains => _savedMountains;

  MountainProvider() {
    loadInitialMountains();
  }

  // Inisialisasi data awal
  void loadInitialMountains() {
    _isLoading = true;
    notifyListeners();

    try {
      _mountains = [
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
      _isLoading = false;
      _errorMessage = null;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  // Cek apakah gunung sudah disimpan
  bool isMountainSaved(String mountainId) {
    return _savedMountains.any((item) => item.mountainId == mountainId);
  }

  // Tambah / Simpan ke rencana pendakian
  bool toggleSaveMountain(MountainModel mountain, {String note = 'Rencana pendakian saya'}) {
    final index = _savedMountains.indexWhere((item) => item.mountainId == mountain.id);

    if (index >= 0) {
      _savedMountains.removeAt(index);
      notifyListeners();
      return false; // Dihapus dari favorit
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
      return true; // Berhasil disimpan
    }
  }

  // Hapus dari favorit
  void removeSavedMountain(String id) {
    _savedMountains.removeWhere((item) => item.id == id);
    notifyListeners();
  }
}