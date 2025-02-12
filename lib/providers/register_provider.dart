import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

// Définition de l'état possible de l'inscription
class AuthState {
  final bool isLoading;
  final String? errorMessage;

  AuthState({this.isLoading = false, this.errorMessage});

  // Copier l'état en changeant certaines valeurs
  AuthState copyWith({bool? isLoading, String? errorMessage}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// Le Notifier qui gère l'état d'inscription
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState());

  Future<void> register(String name, String email, String password,
      String passwordConfirmation) async {
    state = state.copyWith(isLoading: true); // Commencer l'état de chargement

    try {
      final dio = Dio();
      final response = await dio.post(
        'https://1dbe-154-0-185-15.ngrok-free.app/api/users', // Remplacer avec votre URL
        data: {
          'name': name,
          'role': 'Boutique',
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );

      if (response.statusCode == 201) {
        state = state.copyWith(isLoading: false, errorMessage: null);
      } else {
        state = state.copyWith(
            isLoading: false,
            errorMessage: 'Erreur: ${response.data['message']}');
      }
    } catch (e) {
      state =
          state.copyWith(isLoading: false, errorMessage: 'Erreur de connexion');
    }
  }
}

// Le Provider pour l'authentification
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
