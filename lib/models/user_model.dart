import 'boutique_model.dart';

class User {
  final int id;
  final String name;
  final String email;
  final String role;
  final String abonnement;
  final String profilePhotoUrl;
  final Boutique? boutique;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.abonnement,
    required this.profilePhotoUrl,
    this.boutique,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      abonnement: json['abonnement'],
      profilePhotoUrl: json['profile_photo_url'] ?? '',
      boutique:
          json['boutique'] != null ? Boutique.fromJson(json['boutique']) : null,
    );
  }
}
