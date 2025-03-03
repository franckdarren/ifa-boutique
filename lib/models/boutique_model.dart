import 'package:flutter/foundation.dart';

class Boutique {
  final int? id;
  final String adresse;
  final String nom;
  final String phone;
  final String urlLogo;
  final String heureOuverture;
  final String heureFermeture;
  final String description;
  final int userId;

  Boutique({
    this.id,
    required this.adresse,
    required this.nom,
    required this.phone,
    required this.urlLogo,
    required this.heureOuverture,
    required this.heureFermeture,
    required this.description,
    required this.userId,
  });

  // Fonction statique pour convertir une chaîne en entier si possible, sinon retourne 0
  static int _parseInt(dynamic value) {
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return value as int? ?? 0;
  }

  // Fonction statique pour récupérer une valeur String, ou une chaîne vide si null
  static String _parseString(dynamic value) {
    return value as String? ?? '';
  }

  factory Boutique.fromJson(Map<String, dynamic> json) {
    // Imprimer les données pour vérification
    // debugPrint("Données reçues : $json");

    return Boutique(
      id: json['id'] as int?, // id peut être nul
      adresse: _parseString(json['adresse']),
      nom: _parseString(json['nom']),
      phone: _parseString(json['phone']),
      urlLogo: _parseString(json['url_logo']),
      heureOuverture: _parseString(json['heure_ouverture']),
      heureFermeture: _parseString(json['heure_fermeture']),
      description: _parseString(json['description']),
      userId: _parseInt(json['user_id']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'adresse': adresse,
      'nom': nom,
      'phone': phone,
      'url_logo': urlLogo,
      'heure_ouverture': heureOuverture,
      'heure_fermeture': heureFermeture,
      'description': description,
      'user_id': userId,
    };
  }
}
