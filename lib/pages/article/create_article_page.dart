import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/article_model.dart';
import '../../models/variation_model.dart';
import '../../services/article_service.dart';
import '../../providers/article_provider.dart';

class ArticleCreatePage extends ConsumerStatefulWidget {
  const ArticleCreatePage({super.key});

  @override
  ConsumerState<ArticleCreatePage> createState() => _ArticleCreatePageState();
}

class _ArticleCreatePageState extends ConsumerState<ArticleCreatePage> {
  final _formKey = GlobalKey<FormState>();

  // Champs article
  final nomController = TextEditingController();
  final descriptionController = TextEditingController();
  final prixController = TextEditingController();
  final prixPromoController = TextEditingController();
  final pourcentageController = TextEditingController();

  bool isPromotion = false;
  bool madeInGabon = false;

  int boutiqueId = 1; // Tu peux rendre ça dynamique
  int sousCategorieId = 1;

  // Variations
  List<VariationModel> variations = [];

  void addVariationDialog() {
    final couleurController = TextEditingController();
    final codeCouleurController = TextEditingController();
    final tailleController = TextEditingController();
    final quantiteController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Ajouter une variation"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: couleurController,
                decoration: InputDecoration(labelText: 'Couleur')),
            TextField(
                controller: codeCouleurController,
                decoration: InputDecoration(labelText: 'Code Couleur')),
            TextField(
                controller: tailleController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Taille')),
            TextField(
                controller: quantiteController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Quantité')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (couleurController.text.isNotEmpty &&
                  codeCouleurController.text.isNotEmpty &&
                  tailleController.text.isNotEmpty &&
                  quantiteController.text.isNotEmpty) {
                setState(() {
                  variations.add(VariationModel(
                    couleur: couleurController.text,
                    codeCouleur: codeCouleurController.text,
                    taille: int.parse(tailleController.text),
                    quantite: int.parse(quantiteController.text),
                  ));
                });
                Navigator.of(context).pop();
              }
            },
            child: const Text("Ajouter"),
          )
        ],
      ),
    );
  }

  void submit() async {
    if (!_formKey.currentState!.validate()) return;

    final article = ArticleModel(
      nom: nomController.text,
      description: descriptionController.text,
      prix: int.parse(prixController.text),
      prixPromotion: prixPromoController.text.isNotEmpty
          ? int.parse(prixPromoController.text)
          : null,
      isPromotion: isPromotion,
      pourcentageReduction: pourcentageController.text.isNotEmpty
          ? int.parse(pourcentageController.text)
          : null,
      madeInGabon: madeInGabon,
      boutiqueId: boutiqueId,
      sousCategorieId: sousCategorieId,
      variations: variations,
    );

    try {
      await ref.read(articleServiceProvider).createArticle(article);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Article créé !')));
      Navigator.pop(context);
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erreur : $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Créer un article')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                  controller: nomController,
                  decoration: const InputDecoration(labelText: 'Nom'),
                  validator: (v) => v!.isEmpty ? 'Requis' : null),
              TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  validator: (v) => v!.isEmpty ? 'Requis' : null),
              TextFormField(
                  controller: prixController,
                  decoration: const InputDecoration(labelText: 'Prix'),
                  keyboardType: TextInputType.number,
                  validator: (v) => v!.isEmpty ? 'Requis' : null),
              TextFormField(
                  controller: prixPromoController,
                  decoration: const InputDecoration(labelText: 'Prix Promo'),
                  keyboardType: TextInputType.number),
              TextFormField(
                  controller: pourcentageController,
                  decoration: const InputDecoration(labelText: 'Réduction (%)'),
                  keyboardType: TextInputType.number),
              SwitchListTile(
                title: const Text("Promotion"),
                value: isPromotion,
                onChanged: (val) => setState(() => isPromotion = val),
              ),
              SwitchListTile(
                title: const Text("Fabriqué au Gabon"),
                value: madeInGabon,
                onChanged: (val) => setState(() => madeInGabon = val),
              ),
              const SizedBox(height: 20),
              const Text("Variations",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              for (var v in variations)
                ListTile(
                  title: Text('${v.couleur} | ${v.taille} | ${v.quantite}'),
                  subtitle: Text('Code couleur : ${v.codeCouleur}'),
                ),
              TextButton.icon(
                onPressed: addVariationDialog,
                icon: const Icon(Icons.add),
                label: const Text("Ajouter une variation"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: submit,
                child: const Text("Enregistrer l'article"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
