import 'package:dio/dio.dart';
import '../models/article_model.dart';
import '../constant.dart';
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

  Future<List<Article>> getArticles() async {
    final response = await _dio.get('/articles');
    return (response.data as List).map((e) => Article.fromJson(e)).toList();
  }

  Future<Article> getArticleById(int id) async {
    final response = await _dio.get('/articles/$id');
    return Article.fromJson(response.data);
  }

  Future<void> createArticle(Article article) async {
    await _dio.post('/articles', data: article.toJson());
  }

  Future<void> updateArticle(int id, Article article) async {
    await _dio.put('/articles/$id', data: article.toJson());
  }

  Future<void> deleteArticle(int id) async {
    await _dio.delete('/articles/$id');
  }

  Future<List<Article>> getArticlesByBoutique(int boutiqueId) async {
    final response = await _dio.get('/articles-boutique/$boutiqueId');
    return (response.data as List).map((e) => Article.fromJson(e)).toList();
  }
}
