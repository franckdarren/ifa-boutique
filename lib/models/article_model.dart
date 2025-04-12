import 'variation_model.dart';

class Article {
  String nom;
  String description;
  int prix;
  int boutiqueId;
  int prixPromotion;
  int pourcentageReduction;
  bool isPromotion;
  String categorie;
  bool madeInGabon;

  List<Variation> variations;

  Article({
    required this.nom,
    required this.description,
    required this.prix,
    required this.boutiqueId,
    required this.prixPromotion,
    required this.pourcentageReduction,
    required this.isPromotion,
    required this.categorie,
    required this.variations,
    required this.madeInGabon,
  });

  // Méthode pour convertir l'objet Article en Map pour l'API
  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'description': description,
      'prix': prix,
      'prixPromotion': prixPromotion,
      'pourcentageReduction': pourcentageReduction,
      'isPromotion': isPromotion,
      'boutique_id': boutiqueId,
      'categorie': categorie,
      'madeInGabon': madeInGabon,
      'variations': variations.map((v) => v.toJson()).toList(),
    };
  }
}
