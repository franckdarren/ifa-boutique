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
  final TextEditingController _categorieController = TextEditingController();

  bool _madeInGabon = false; // Ajout du champ pour "Made in Gabon"

  final List<Variation> variations = [];
  final FlutterSecureStorage _storage = FlutterSecureStorage();

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
    return await _storage.read(
        key: 'auth_token'); // Remplace 'auth_token' par la clé que tu utilises
  }

  // Méthode pour récupérer le token depuis FlutterSecureStorage
  Future<String?> _getBoutiqueId() async {
    return await _storage.read(
        key: 'boutique_id'); // Remplace 'auth_token' par la clé que tu utilises
  }

  // Méthode pour soumettre l'article avec ses variations
  void _submitArticle() async {
    if (_nomController.text.isEmpty ||
        _prixController.text.isEmpty ||
        _categorieController
            .text.isEmpty || // Assurez-vous que la catégorie est remplie
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
        categorie: _categorieController
            .text, // La catégorie est maintenant correctement définie
        variations: variations,
        boutiqueId: int.parse(boutique_id!),
        prixPromotion:
            _isPromotion ? int.tryParse(_prixPromotionController.text) ?? 0 : 0,
        pourcentageReduction: int.tryParse(_prixPromotionController.text) ?? 0,
        isPromotion: _isPromotion,
        madeInGabon: _madeInGabon, // Ajout du champ madeInGabon
      );

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Token non trouvé, veuillez vous reconnecter')));
        return;
      }

      // print('Token: $token'); // Afficher le token
      // print('Catégorie saisie: ${_categorieController.text}');
      // print(
      // 'Article Data: ${article.toJson()}'); // Afficher les données de l'article

      final response = await Dio().post(
        '$baseURL/articles',
        data: article.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token', // Ajouter le token dans l'en-tête
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
        _categorieController.clear();

        // Réinitialisation de l'état des cases à cocher et des listes
        setState(() {
          _isPromotion = false;
          _madeInGabon = false;
          variations.clear();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text('Erreur lors de la création: ${response.statusCode}')));
      }
    } catch (e) {
      if (e is DioError) {
        // DioError fournit des informations détaillées sur l'erreur
        // print('DioError: ${e.response?.data}');
        // print('DioError message: ${e.message}');
        // print('DioError type: ${e.type}');
        // print('DioError status code: ${e.response?.statusCode}');

        // Afficher l'erreur dans le Snackbar
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur de connexion: ${e.message}')));
      } else {
        // Si ce n'est pas une DioError, afficher l'erreur générique
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
                decoration: InputDecoration(labelText: 'Nom de l\'article'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              TextField(
                controller: _prixController,
                decoration: InputDecoration(labelText: 'Prix'),
                keyboardType: TextInputType.number,
              ),
              Text('En promotion'),
              Checkbox(
                value: _isPromotion,
                onChanged: (bool? value) {
                  setState(() {
                    _isPromotion = value!;
                  });
                },
              ),
              // Champ prix promotion
              if (_isPromotion)
                TextFormField(
                  controller: _prixPromotionController,
                  decoration: InputDecoration(labelText: 'Prix promotionnel'),
                  keyboardType: TextInputType.number,
                ),
              // Champ pourcentage réduction
              if (_isPromotion)
                TextFormField(
                  controller: _pourcentageReductionController,
                  decoration:
                      InputDecoration(labelText: 'Pourcentage de réduction'),
                  keyboardType: TextInputType.number,
                ),
              TextField(
                controller: _categorieController,
                decoration: InputDecoration(labelText: 'Catégorie'),
              ),
              SizedBox(height: 20),
              // Ajout du champ pour "Made in Gabon"
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
              SizedBox(height: 20),
              ...variations
                  .map((variation) => _buildVariationForm(variation))
                  .toList(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addVariation,
                child: Text('Ajouter une Variation'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitArticle,
                child: Text('Soumettre l\'article'),
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
      margin: EdgeInsets.symmetric(vertical: 10),
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
