import '../models/mountain_model.dart';
import '../services/mountain_api_service.dart';

class MountainRepository {
  final MountainApiService _apiService;

  MountainRepository({MountainApiService? apiService})
      : _apiService = apiService ?? MountainApiService();

  Future<List<MountainModel>> getMountains() async {
    return await _apiService.fetchMountains();
  }
}