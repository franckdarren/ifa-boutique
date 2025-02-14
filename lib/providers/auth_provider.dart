import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constant.dart';
import 'package:go_router/go_router.dart'; // Import GoRouter
import 'package:flutter/material.dart';

// API Base URL
const String apiUrl = loginURL;

// Stockage sécurisé
const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

// Provider d'authentification
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(),
);

// Classe pour l'état de l'authentification
class AuthState {
  final bool isLoading;
  final String? token;
  final String? error;
  final int? userId;

  AuthState({this.isLoading = false, this.token, this.error, this.userId});
}

// Classe pour gérer l'authentification
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState());

  // Fonction de connexion
  Future<void> login(
      String email, String password, BuildContext context) async {
    state = AuthState(isLoading: true); // Active le loading

    try {
      final response = await Dio().post(
        loginURL,
        data: {'email': email, 'password': password},
      );

      // Récupérer les données utilisateur
      final String token = response.data['token'];
      final int userId = response.data['user']['id'];

      // Stocker le token de manière sécurisée
      await _secureStorage.write(key: "auth_token", value: token);
      await _secureStorage.write(key: "user_id", value: userId.toString());

      // Mettre à jour l'état avec token et userId
      state = AuthState(token: token, userId: userId);

      // Vérifier la boutique et rediriger
      await checkAndRedirect(userId, token, context);
    } on DioException catch (e) {
      String errorMessage = "Une erreur est survenue";
      if (e.response != null) {
        errorMessage = e.response?.data['message'] ?? "Erreur inconnue";
      }
      state = AuthState(error: errorMessage);
    } catch (e) {
      state = AuthState(error: "Erreur: $e");
    }
  }

  // Récupérer l'ID utilisateur stocké
  Future<int?> getUserId() async {
    final userIdStr = await _secureStorage.read(key: "user_id");
    return userIdStr != null ? int.tryParse(userIdStr) : null;
  }

  // Vérifier si l'utilisateur a une boutique et le rediriger
  Future<void> checkAndRedirect(
      int userId, String token, BuildContext context) async {
    try {
      final response = await Dio().get(
        "$baseURL/check-shop/$userId",
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );

      bool hasShop = response.data[
          'hasShop']; // Suppose que l'API retourne { "hasShop": true/false }

      if (hasShop) {
        GoRouter.of(context).go('/home'); // Rediriger vers /home
      } else {
        GoRouter.of(context)
            .go('/create-boutique'); // Rediriger vers création de boutique
      }
    } catch (e) {
      debugPrint("Erreur lors de la vérification de la boutique: $e");
      GoRouter.of(context)
          .go('/create-shop'); // En cas d'erreur, rediriger vers /create-shop
    }
  }
}
