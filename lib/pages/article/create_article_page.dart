import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../models/article_model.dart';
import '../../models/variation_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../constant.dart';

class ArticleCreatePage extends StatefulWidget {
  @override
  _ArticleCreatePageState createState() => _ArticleCreatePageState();
}

class _ArticleCreatePageState extends State<ArticleCreatePage> {
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _prixController = TextEditingController();
  final TextEditingController _prixPromotionController =
      TextEditingController();
  final TextEditingController _pourcentageReductionController =
      TextEditingController();

  bool _isPromotion = false;
  bool _madeInGabon = false; // Champ pour "Made in Gabon"

  final List<Variation> variations = [];
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  // Liste des catégories disponibles et variable pour la sélection
  List<String> categories = ['Vêtements', 'Électronique', 'Maison', 'Sports'];
  String? _selectedCategory;

  // Ajoute une variation
  void _addVariation() {
    setState(() {
      variations.add(Variation(
        couleur: '',
        taille: '',
        stock: 0,
        prix: null,
      ));
    });
  }

  // Méthode pour récupérer le token depuis FlutterSecureStorage
  Future<String?> _getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  // Méthode pour récupérer l'id de boutique depuis FlutterSecureStorage
  Future<String?> _getBoutiqueId() async {
    return await _storage.read(key: 'boutique_id');
  }

  // Méthode pour soumettre l'article avec ses variations
  void _submitArticle() async {
    if (_nomController.text.isEmpty ||
        _prixController.text.isEmpty ||
        _selectedCategory == null ||
        variations.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Veuillez remplir tous les champs')));
      return;
    }

    try {
      final token = await _getToken(); // Récupérer le token
      final boutique_id = await _getBoutiqueId();

      final article = Article(
        nom: _nomController.text,
        description: _descriptionController.text,
        prix: int.parse(_prixController.text),
        categorie:
            _selectedCategory!, // Utilisation de la catégorie sélectionnée
        variations: variations,
        boutiqueId: int.parse(boutique_id!),
        prixPromotion:
            _isPromotion ? int.tryParse(_prixPromotionController.text) ?? 0 : 0,
        // Correction : Utilisation du controller pour le pourcentage de réduction
        pourcentageReduction: _isPromotion
            ? int.tryParse(_pourcentageReductionController.text) ?? 0
            : 0,
        isPromotion: _isPromotion,
        madeInGabon: _madeInGabon,
      );

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Token non trouvé, veuillez vous reconnecter')));
        return;
      }

      final response = await Dio().post(
        '$baseURL/articles',
        data: article.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token', // Ajout du token dans l'en-tête
          },
        ),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Article créé avec succès')));

        // Réinitialisation des champs texte
        _nomController.clear();
        _descriptionController.clear();
        _prixController.clear();
        _prixPromotionController.clear();
        _pourcentageReductionController.clear();

        // Réinitialisation des cases à cocher, du dropdown et des variations
        setState(() {
          _isPromotion = false;
          _madeInGabon = false;
          _selectedCategory = null;
          variations.clear();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text('Erreur lors de la création: ${response.statusCode}')));
      }
    } catch (e) {
      if (e is DioError) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur de connexion: ${e.message}')));
      } else {
        print('Erreur inconnue: $e');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Erreur de connexion')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Créer un Article')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _nomController,
                decoration: InputDecoration(
                  labelText: 'Nom de l\'article',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _prixController,
                decoration: InputDecoration(
                  labelText: 'Prix',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              Text('En promotion'),
              Checkbox(
                value: _isPromotion,
                onChanged: (bool? value) {
                  setState(() {
                    _isPromotion = value!;
                  });
                },
              ),
              if (_isPromotion)
                TextFormField(
                  controller: _prixPromotionController,
                  decoration: InputDecoration(
                    labelText: 'Prix promotionnel',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              const SizedBox(height: 20),
              if (_isPromotion)
                TextFormField(
                  controller: _pourcentageReductionController,
                  decoration: InputDecoration(
                    labelText: 'Pourcentage de réduction',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Catégorie',
                  border: OutlineInputBorder(),
                ),
                items: categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                validator: (value) => value == null
                    ? 'Veuillez sélectionner une catégorie'
                    : null,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Checkbox(
                    value: _madeInGabon,
                    onChanged: (bool? value) {
                      setState(() {
                        _madeInGabon = value!;
                      });
                    },
                  ),
                  Text('Fabriqué au Gabon')
                ],
              ),
              const SizedBox(height: 20),
              ...variations
                  .map((variation) => _buildVariationForm(variation))
                  .toList(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addVariation,
                child: Text('Ajouter une Variation'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitArticle,
                child: Text('Soumettre l\'article'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: couleurPrimaire,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15),
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVariationForm(Variation variation) {
    final index = variations.indexOf(variation);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  variation.couleur = value;
                });
              },
              decoration: InputDecoration(labelText: 'Couleur'),
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  variation.taille = value;
                });
              },
              decoration: InputDecoration(labelText: 'Taille'),
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  variation.stock = int.parse(value);
                });
              },
              decoration: InputDecoration(labelText: 'Stock'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  variation.prix = value.isNotEmpty ? int.parse(value) : null;
                });
              },
              decoration: InputDecoration(labelText: 'Prix'),
              keyboardType: TextInputType.number,
            ),
            IconButton(
              icon: Icon(Icons.remove_circle),
              onPressed: () {
                setState(() {
                  variations.removeAt(index);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
