import 'dart:convert';
import '../models/form_field_definition.dart';
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

  Future<List<FormFieldDefinition>> fetchFormSchema(String articleType) async {
    try {
      final response = await _dio.get(
        '/form-schema',
        queryParameters: {'type': articleType},
      );

      print("Response data: ${response.data}");

      // Forcer le décodage si nécessaire
      dynamic data;
      if (response.data is String) {
        data = json.decode(response.data);
      } else {
        data = response.data;
      }

      if (response.statusCode == 200) {
        final fieldsData = data['fields'];
        List<dynamic> jsonData;

        if (fieldsData is List) {
          jsonData = fieldsData;
        } else if (fieldsData is Map) {
          // Si c'est une Map, on transforme ses valeurs en liste
          jsonData = fieldsData.values.toList();
        } else {
          throw Exception("Structure de 'fields' inattendue");
        }

        return jsonData
            .map((json) => FormFieldDefinition.fromJson(json))
            .toList();
      } else {
        throw Exception("Erreur: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Erreur lors de la récupération du schéma: $e");
    }
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
