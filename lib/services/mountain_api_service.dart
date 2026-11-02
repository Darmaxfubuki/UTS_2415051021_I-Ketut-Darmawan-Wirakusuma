import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/mountain_model.dart';

class MountainApiService {
  // Ditambahkan parameter ?v=2 di akhir URL untuk memotong cache CDN GitHub
  static const String _publicApiUrl =
      'https://raw.githubusercontent.com/Darmaxfubuki/rest-api/refs/heads/main/mountains.json?v=2';

  Future<List<MountainModel>> fetchMountains() async {
    try {
      final response = await http
          .get(Uri.parse(_publicApiUrl))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
        return data
            .map((json) => MountainModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
            'Server merespons dengan status error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Gagal mengambil data dari REST API: $e');
    }
  }
}