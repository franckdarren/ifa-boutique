import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/article_provider.dart';
import '../../models/form_field_definition.dart';
import '../../services/article_service.dart'; // Service pour envoyer l'article
import 'package:go_router/go_router.dart';

class CreateArticlePage extends ConsumerStatefulWidget {
  const CreateArticlePage({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateArticlePage> createState() => _CreateArticlePageState();
}

class _CreateArticlePageState extends ConsumerState<CreateArticlePage> {
  final _formKey = GlobalKey<FormState>();

  String? selectedType;
  bool _isMadeInGabon = false;
  bool _isPromotion = false;

  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _prixController = TextEditingController();
  final TextEditingController _prixPromotionController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Créer un article"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (GoRouter.of(context).canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),
                // Champ Nom
                TextFormField(
                  controller: _nomController,
                  decoration: const InputDecoration(
                    labelText: "Nom de l'article",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Veuillez entrer le nom'
                      : null,
                ),
                const SizedBox(height: 20),

                // Champ Description
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Veuillez entrer une description'
                      : null,
                ),
                const SizedBox(height: 20),

                // Champ Prix
                TextFormField(
                  controller: _prixController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Prix',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Veuillez entrer le prix'
                      : null,
                ),
                const SizedBox(height: 20),

                // Checkbox En promotion ?
                CheckboxListTile(
                  title: const Text('En promotion ?'),
                  value: _isPromotion,
                  onChanged: (bool? newValue) {
                    setState(() {
                      _isPromotion = newValue ?? false;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                const SizedBox(height: 10),

                // Champ Prix promotion (Désactivé si pas en promo)
                TextFormField(
                  controller: _prixPromotionController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Prix promotion',
                    border: OutlineInputBorder(),
                  ),
                  enabled: _isPromotion,
                ),
                const SizedBox(height: 20),

                // Checkbox Fabriqué au Gabon ?
                CheckboxListTile(
                  title: const Text('Fabriqué au Gabon ?'),
                  value: _isMadeInGabon,
                  onChanged: (bool? newValue) {
                    setState(() {
                      _isMadeInGabon = newValue ?? false;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                const SizedBox(height: 20),

                // Dropdown pour choisir le type d'article
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                      labelText: 'Type d\'article',
                      border: OutlineInputBorder()),
                  items: const [
                    DropdownMenuItem(
                        value: 'chaussures', child: Text('Chaussures')),
                    DropdownMenuItem(
                        value: 'vetements', child: Text('Vêtements')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedType = value;
                    });
                    if (value != null) {
                      ref.refresh(formSchemaProvider(value));
                    }
                  },
                  value: selectedType,
                ),
                const SizedBox(height: 20),

                // Affichage dynamique du formulaire
                if (selectedType != null)
                  Consumer(
                    builder: (context, ref, child) {
                      final schemaAsync =
                          ref.watch(formSchemaProvider(selectedType!));

                      return schemaAsync.when(
                        data: (fields) {
                          return Column(
                            children: fields.map((field) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      labelText: field.label,
                                      border: OutlineInputBorder()),
                                  keyboardType: field.type == 'number'
                                      ? TextInputType.number
                                      : TextInputType.text,
                                ),
                              );
                            }).toList(),
                          );
                        },
                        loading: () => const CircularProgressIndicator(),
                        error: (error, stack) =>
                            Center(child: Text('Erreur: $error')),
                      );
                    },
                  ),
                const SizedBox(height: 20),

                // Bouton de soumission
                ElevatedButton(
                  onPressed: _submitArticle,
                  child: const Text('Ajouter l\'article'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitArticle() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final prix = int.tryParse(_prixController.text) ?? 0;
    final prixPromotion = int.tryParse(_prixPromotionController.text) ?? 0;
    final pourcentageReduction =
        (_isPromotion && prixPromotion > 0) ? (prixPromotion / prix) * 100 : 0;

    final articleData = {
      'nom': _nomController.text,
      'description': _descriptionController.text,
      'prix': prix,
      'prixPromotion': _isPromotion ? prixPromotion : null,
      'isPromotion': _isPromotion,
      'pourcentageReduction': pourcentageReduction,
      'isMadeInGabon': _isMadeInGabon,
      'type': selectedType,
    };

    try {
      await ArticleService().createArticle(articleData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Article ajouté avec succès !')),
      );
      context.go('/home'); // Redirige après ajout
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
    }
  }
}
