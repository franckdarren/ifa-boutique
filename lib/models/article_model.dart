import 'variation_model.dart';

class ArticleModel {
  final int? id;
  final String nom;
  final String description;
  final int prix;
  final int? prixPromotion;
  final bool isPromotion;
  final int? pourcentageReduction;
  final int boutiqueId;
  final int sousCategorieId;
  final bool madeInGabon;
  final List<VariationModel> variations;

  ArticleModel({
    this.id,
    required this.nom,
    required this.description,
    required this.prix,
    this.prixPromotion,
    required this.isPromotion,
    this.pourcentageReduction,
    required this.boutiqueId,
    required this.sousCategorieId,
    required this.madeInGabon,
    required this.variations,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['id'],
      nom: json['nom'],
      description: json['description'],
      prix: json['prix'],
      prixPromotion: json['prix_promotion'],
      isPromotion: json['is_promotion'] ?? false,
      pourcentageReduction: json['pourcentageReduction'],
      boutiqueId: json['boutique_id'],
      sousCategorieId: json['sous_categorie_id'],
      madeInGabon: json['madeInGabon'] ?? false,
      variations: (json['variations'] as List)
          .map((v) => VariationModel.fromJson(v))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'description': description,
      'prix': prix,
      'prix_promotion': prixPromotion,
      'is_promotion': isPromotion,
      'pourcentageReduction': pourcentageReduction,
      'boutique_id': boutiqueId,
      'sous_categorie_id': sousCategorieId,
      'madeInGabon': madeInGabon,
      'variations': variations.map((v) => v.toJson()).toList(),
    };
  }
}
