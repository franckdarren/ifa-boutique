import 'dart:convert';
import '../constant.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ArticleService {
  final Dio _dio = Dio(BaseOptions(baseUrl: baseURL));
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  ArticleService() {
    // Ajout d'un intercepteur pour inclure le token dans chaque requête
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _secureStorage.read(key: "auth_token");
          if (token != null) {
            options.headers["Authorization"] = "Bearer $token";
          }
          return handler.next(options);
        },
      ),
    );
  }

  Future<void> createArticle(Map<String, dynamic> articleData) async {
    try {
      final response = await _dio.post(
        '/articles',
        data: jsonEncode(articleData),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        print("Article ajouté avec succès");
      } else {
        throw Exception(
            "Erreur lors de l'ajout de l'article: \${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Erreur lors de l'ajout de l'article: \$e");
    }
  }
}
