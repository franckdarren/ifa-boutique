import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

// API Base URL (à modifier selon ton backend)
const String apiUrl =
    "https://1dbe-154-0-185-15.ngrok-free.app/api"; // Remplace par ton URL

// Provider pour gérer l'authentification
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(),
);

// Classe pour gérer l'état de l'authentification
class AuthState {
  final bool isLoading;
  final String? token;
  final String? error;

  AuthState({this.isLoading = false, this.token, this.error});
}

// Classe pour gérer les appels API
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState());

  // Fonction de connexion
  Future<void> login(String email, String password) async {
    state = AuthState(isLoading: true); // Active le loading

    try {
      final response = await Dio().post(
        '$apiUrl/login', // Route de ton API Laravel
        data: {'email': email, 'password': password},
      );

      final String token = response.data['token'];
      state =
          AuthState(token: token); // Stocke le token après connexion réussie
    } catch (e) {
      state = AuthState(error: "Email ou mot de passe incorrect");
    }
  }
}
