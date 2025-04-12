import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import de Riverpod
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../providers/boutique_provider.dart';
import '../../models/boutique_model.dart';
import '../../constant.dart';

class CreateBoutiquePage extends ConsumerStatefulWidget {
  const CreateBoutiquePage({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateBoutiquePage> createState() => _CreateBoutiquePageState();
}

class _CreateBoutiquePageState extends ConsumerState<CreateBoutiquePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _adresseController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _heureOuvertureController =
      TextEditingController();
  final TextEditingController _heureFermetureController =
      TextEditingController();

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  late Future<int> _userIdFuture;

  @override
  void initState() {
    super.initState();
    _userIdFuture = _getUserId();
  }

  // Méthodes de validation
  String? _validateNom(String? value) {
    if (value == null || value.isEmpty)
      return 'Veuillez entrer le nom de votre boutique';
    return null;
  }

  String? _validateAdresse(String? value) {
    if (value == null || value.isEmpty) return 'Veuillez entrer une adresse';
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty)
      return 'Veuillez entrer un numéro de téléphone';
    return null;
  }

  String? _validateDescription(String? value) {
    if (value == null || value.isEmpty)
      return 'Veuillez entrer une description';
    return null;
  }

  String? _validateHeureOuverture(String? value) {
    if (value == null || value.isEmpty)
      return 'Veuillez entrer l\'heure d\'ouverture';
    return null;
  }

  String? _validateHeureFermeture(String? value) {
    if (value == null || value.isEmpty)
      return 'Veuillez entrer l\'heure de fermeture';
    return null;
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  // Récupérer l'ID de l'utilisateur depuis Flutter Secure Storage
  Future<int> _getUserId() async {
    final userIdString = await _storage.read(key: 'user_id');
    if (userIdString == null) {
      throw Exception('Utilisateur non authentifié');
    }
    return int.parse(userIdString);
  }

  // Soumettre le formulaire
  void _submitForm() async {
    // On attend que l'ID utilisateur soit récupéré
    final userId = await _userIdFuture;

    if (_formKey.currentState?.validate() ?? false) {
      // Récupérer les valeurs des champs
      final nom = _nomController.text;
      final adresse = _adresseController.text;
      final phone = _phoneController.text;
      final description = _descriptionController.text;
      final heureOuverture = _heureOuvertureController.text;
      final heureFermeture = _heureFermetureController.text;

      // Vérifier si une image a été sélectionnée
      if (_selectedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Veuillez sélectionner un logo pour la boutique.')),
        );
        return;
      }

      // Créer un objet Boutique avec les paramètres nécessaires
      final boutique = Boutique(
        nom: nom,
        adresse: adresse,
        phone: phone,
        description: description,
        heureOuverture: heureOuverture,
        heureFermeture: heureFermeture,
        urlLogo: '', // L'URL du logo sera définie après l'upload
        userId: userId,
      );

      // Utiliser ref pour accéder au provider et ajouter la boutique
      ref
          .read(boutiqueListProvider.notifier)
          .addBoutique(boutique, _selectedImage!)
          .then((_) {
        // Boutique créée avec succès, redirection vers la page d'accueil
        context.go('/login');
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Erreur lors de la création de la boutique : $error')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        ref.watch(boutiqueListProvider).isLoading; // État de chargement

    return Scaffold(
      appBar: AppBar(title: const Text('Créer une boutique')),
      body: FutureBuilder<int>(
        future: _userIdFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }
          // Une fois l'ID utilisateur récupéré, on affiche le formulaire
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Champ Nom
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _nomController,
                      decoration: const InputDecoration(
                        labelText: 'Nom de boutique',
                        border: OutlineInputBorder(),
                      ),
                      validator: _validateNom,
                    ),
                    const SizedBox(height: 20),
                    // Champ Adresse
                    TextFormField(
                      controller: _adresseController,
                      decoration: const InputDecoration(
                        labelText: 'Adresse',
                        border: OutlineInputBorder(),
                      ),
                      validator: _validateAdresse,
                    ),
                    const SizedBox(height: 20),
                    // Champ Téléphone
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Téléphone',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: _validatePhone,
                    ),
                    const SizedBox(height: 20),
                    // Champ Description
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                      validator: _validateDescription,
                    ),
                    const SizedBox(height: 20),
                    // Champ Heure d'ouverture
                    TextFormField(
                      controller: _heureOuvertureController,
                      decoration: const InputDecoration(
                        labelText: 'Heure ouverture',
                        border: OutlineInputBorder(),
                      ),
                      validator: _validateHeureOuverture,
                    ),
                    const SizedBox(height: 20),
                    // Champ Heure de fermeture
                    TextFormField(
                      controller: _heureFermetureController,
                      decoration: const InputDecoration(
                        labelText: 'Heure fermeture',
                        border: OutlineInputBorder(),
                      ),
                      validator: _validateHeureFermeture,
                    ),
                    const SizedBox(height: 20),
                    // Sélecteur d'image pour le logo
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: _selectedImage != null
                            ? Image.file(_selectedImage!, fit: BoxFit.cover)
                            : const Icon(Icons.camera_alt,
                                size: 50, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: const Text('Sélectionner une image'),
                    ),
                    const SizedBox(height: 20),
                    // Bouton pour créer la boutique
                    ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : _submitForm, // Désactiver si chargement
                      child: isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text('Créer la boutique'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: couleurPrimaire,
                        foregroundColor:
                            Colors.white, // 🔵 couleur du texte / icône
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12), // 🎯 arrondi
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
        },
      ),
    );
  }
}
