import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart'; // Pour debugPrint
import '../models/boutique_model.dart';
import '../services/boutique_service.dart';

/// Provider du service boutique
final boutiqueServiceProvider = Provider<BoutiqueService>((ref) {
  return BoutiqueService();
});

/// State représentant l'état des boutiques et de leur chargement
class BoutiqueState {
  final bool isLoading;
  final List<Boutique> boutiques;

  BoutiqueState({
    this.isLoading = false,
    this.boutiques = const [],
  });

  BoutiqueState copyWith({
    bool? isLoading,
    List<Boutique>? boutiques,
  }) {
    return BoutiqueState(
      isLoading: isLoading ?? this.isLoading,
      boutiques: boutiques ?? this.boutiques,
    );
  }
}

/// Provider de gestion de la liste des boutiques
final boutiqueListProvider =
    StateNotifierProvider<BoutiqueNotifier, BoutiqueState>((ref) {
  final service = ref.watch(boutiqueServiceProvider);
  return BoutiqueNotifier(service);
});

/// Notifier pour gérer les boutiques
class BoutiqueNotifier extends StateNotifier<BoutiqueState> {
  final BoutiqueService _service;

  BoutiqueNotifier(this._service) : super(BoutiqueState()) {
    fetchBoutiques(); // Charger automatiquement les boutiques
  }

  /// Récupérer la liste des boutiques
  Future<void> fetchBoutiques() async {
    try {
      state = state.copyWith(isLoading: true); // Mettre isLoading à true
      final boutiques = await _service.getBoutiques();
      state = state.copyWith(isLoading: false, boutiques: boutiques);
    } catch (e) {
      debugPrint("Erreur lors de la récupération des boutiques : $e");
      state = state.copyWith(isLoading: false);
    }
  }

  /// Ajouter une nouvelle boutique
  Future<void> addBoutique(Boutique boutique, File logoFile) async {
    try {
      state = state.copyWith(isLoading: true); // Mettre isLoading à true
      final newBoutique = await _service.createBoutique(boutique, logoFile);
      state = state.copyWith(
        isLoading: false,
        boutiques: [...state.boutiques, newBoutique],
      );
    } catch (e) {
      debugPrint("Erreur lors de la création de la boutique : $e");
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  /// Mettre à jour une boutique
  Future<void> updateBoutique(int id, Boutique boutique,
      {File? logoFile}) async {
    try {
      state = state.copyWith(isLoading: true); // Mettre isLoading à true
      final updatedBoutique =
          await _service.updateBoutique(id, boutique, logoFile: logoFile);
      state = state.copyWith(
        isLoading: false,
        boutiques: state.boutiques
            .map((b) => b.id == id ? updatedBoutique : b)
            .toList(),
      );
    } catch (e) {
      debugPrint("Erreur lors de la mise à jour de la boutique : $e");
      state = state.copyWith(isLoading: false);
    }
  }

  /// Supprimer une boutique
  Future<void> deleteBoutique(int id) async {
    try {
      state = state.copyWith(isLoading: true); // Mettre isLoading à true
      await _service.deleteBoutique(id);
      state = state.copyWith(
        isLoading: false,
        boutiques: state.boutiques.where((b) => b.id != id).toList(),
      );
    } catch (e) {
      debugPrint("Erreur lors de la suppression de la boutique : $e");
      state = state.copyWith(isLoading: false);
    }
  }
}

/// Provider pour obtenir une boutique spécifique par ID.
/// On lit simplement le provider de la liste et on en extrait la boutique correspondante.
final boutiqueProvider = Provider.family<Boutique?, int>((ref, id) {
  final boutiques = ref.watch(boutiqueListProvider).boutiques;
  return boutiques.firstWhere(
    (b) => b.id == id,
    orElse: () => Boutique(
      id: id,
      nom: '',
      adresse: '',
      heureOuverture: '',
      heureFermeture: '',
      phone: '',
      urlLogo: '',
      description: '',
      userId: 0,
    ),
  );
});
