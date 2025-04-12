class Variation {
  String couleur;
  String taille;
  int stock;
  int? prix; // Prix nullable, peut être null si non spécifié

  Variation({
    required this.couleur,
    required this.taille,
    required this.stock,
    this.prix,
  });

  // Méthode pour convertir l'objet Variation en Map pour l'API
  Map<String, dynamic> toJson() {
    return {
      'couleur': couleur,
      'taille': taille,
      'stock': stock,
      'prix': prix,
    };
  }
}
