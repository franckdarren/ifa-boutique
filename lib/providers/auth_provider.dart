import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constant.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';

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
  final User? user;

  AuthState({
    this.isLoading = false,
    this.token,
    this.error,
    this.userId,
    this.user,
  });
}

// Classe pour gérer l'authentification
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState());

  // Fonction de connexion
  Future<void> login(
      String email, String password, BuildContext context) async {
    state = AuthState(isLoading: true); // Active le chargement

    try {
      final response = await Dio().post(
        loginURL,
        data: {'email': email, 'password': password},
      );

      // Récupérer les données utilisateur
      final String token = response.data['token'];
      final int userId = response.data['user']['id'];

      final Map<String, dynamic> userJson = response.data['user'];
      final User user = User.fromJson(userJson);

      // Stocker le token de manière sécurisée
      await _secureStorage.write(key: "auth_token", value: token);
      await _secureStorage.write(key: "user_id", value: userId.toString());

      // Mettre à jour l'état avec token et userId
      state = AuthState(
        token: token,
        userId: userId,
        user: user,
      );

      // Vérifier la boutique et rediriger
      await checkAndRedirect(userId, token, context);
    } on DioException catch (e) {
      String errorMessage =
          "Une erreur est survenue. Veuillez vous connectez à internet";
      if (e.response != null) {
        // Si le status code est 401, on considère que c'est une erreur d'email ou de mot de passe
        if (e.response!.statusCode == 401) {
          errorMessage = "Email ou mot de passe incorrect";
        } else {
          errorMessage = e.response?.data['message'] ?? "Erreur inconnue";
        }
      }
      state = AuthState(error: errorMessage);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      final errorMessage = "Erreur: $e";
      state = AuthState(error: errorMessage);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  // Méthode de déconnexion
  Future<void> logout(BuildContext context) async {
    try {
      // Supprimer les données du stockage sécurisé
      await _secureStorage.delete(key: "auth_token");
      await _secureStorage.delete(key: "user_id");

      // Réinitialiser l'état
      state = AuthState();

      // Rediriger vers la page de connexion
      GoRouter.of(context).go('/login');
    } catch (e) {
      debugPrint("Erreur lors de la déconnexion : $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de la déconnexion")),
      );
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

      bool hasShop = response.data['hasShop'];

      if (hasShop) {
        GoRouter.of(context).go('/home');
      } else {
        GoRouter.of(context).go('/create-boutique');
      }
    } catch (e) {
      debugPrint("Erreur lors de la vérification de la boutique: $e");
      GoRouter.of(context).go('/login');
    }
  }
}
