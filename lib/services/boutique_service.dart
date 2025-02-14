import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/boutique_model.dart';
import '../constant.dart';
import 'package:flutter/foundation.dart';

class BoutiqueService {
  final Dio _dio = Dio(BaseOptions(baseUrl: baseURL));
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  BoutiqueService() {
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

  Future<List<Boutique>> getBoutiques() async {
    final response = await _dio.get("/boutiques");
    return (response.data as List).map((b) => Boutique.fromJson(b)).toList();
  }

  Future<Boutique> getBoutique(int id) async {
    final response = await _dio.get("/boutiques/$id");
    return Boutique.fromJson(response.data);
  }

  Future<Boutique> createBoutique(Boutique boutique, File logoFile) async {
    // Construire le FormData sans remplacer les valeurs null
    FormData formData = FormData.fromMap({
      'nom': boutique.nom,
      'adresse': boutique.adresse,
      'phone': boutique.phone,
      'heure_ouverture': boutique.heureOuverture,
      'heure_fermeture': boutique.heureFermeture,
      'description': boutique.description,
      'user_id': boutique.userId,
      'url_logo':
          await MultipartFile.fromFile(logoFile.path, filename: "logo.jpg"),
    });

    final response = await _dio.post("/boutiques", data: formData);
    return Boutique.fromJson(response.data);
  }

  Future<Boutique> updateBoutique(int id, Boutique boutique,
      {File? logoFile}) async {
    FormData formData = FormData.fromMap({
      'nom': boutique.nom,
      'adresse': boutique.adresse,
      'phone': boutique.phone,
      'heure_ouverture': boutique.heureOuverture,
      'heure_fermeture': boutique.heureFermeture,
      'description': boutique.description,
      'user_id': boutique.userId,
    });

    if (logoFile != null) {
      formData.files.add(
        MapEntry(
          'url_logo',
          await MultipartFile.fromFile(logoFile.path, filename: "logo.jpg"),
        ),
      );
    }

    final response = await _dio.put("/boutiques/$id", data: formData);
    return Boutique.fromJson(response.data);
  }

  Future<void> deleteBoutique(int id) async {
    await _dio.delete("/boutiques/$id");
  }
}
