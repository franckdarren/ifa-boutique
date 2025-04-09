import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/dashboardstats_model.dart';
import '../constant.dart';

class DashboardService {
  final Dio _dio = Dio(BaseOptions(baseUrl: baseURL));
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  DashboardService(); // Constructeur sans paramètres

  Future<DashboardStats> fetchStats(int userId) async {
    try {
      final token = await _secureStorage.read(key: "auth_token");
      if (token == null) {
        throw Exception('Token d\'authentification manquant');
      }

      final response = await _dio.get(
        '/dashboard/stats/$userId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      return DashboardStats.fromJson(response.data);
    } catch (e) {
      throw Exception('Erreur lors de la récupération des statistiques : $e');
    }
  }
}
