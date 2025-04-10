class VariationModel {
  final String couleur;
  final String codeCouleur;
  final int taille;
  final int quantite;

  VariationModel({
    required this.couleur,
    required this.codeCouleur,
    required this.taille,
    required this.quantite,
  });

  factory VariationModel.fromJson(Map<String, dynamic> json) {
    return VariationModel(
      couleur: json['couleur'],
      codeCouleur: json['code_couleur'],
      taille: json['taille'],
      quantite: json['stock']['quantite'], // attention à la structure du JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'couleur': couleur,
      'code_couleur': codeCouleur,
      'taille': taille,
      'quantite': quantite,
    };
  }
}
