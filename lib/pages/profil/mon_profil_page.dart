import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart'; // ajuste le chemin selon ton projet

class MonProfilPage extends ConsumerWidget {
  const MonProfilPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final boutique = user?.boutique;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mon Profil',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF183356),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Image de profil
                  // CircleAvatar(
                  //   radius: 60,
                  //   backgroundImage: NetworkImage(user.profilePhotoUrl),
                  //   backgroundColor: Colors.grey[300],
                  // ),
                  const SizedBox(height: 20),

                  // Nom utilisateur
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF183356),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Email
                  Text(user.email, style: TextStyle(color: Colors.grey[600])),

                  const SizedBox(height: 8),

                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),

                  // BOUTIQUE
                  if (boutique != null) ...[
                    const Text(
                      "Détails de la boutique",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF183356),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Logo
                    // if (boutique.urlLogo.isNotEmpty)
                    //   ClipRRect(
                    //     borderRadius: BorderRadius.circular(12),
                    //     child: Image.network(
                    //       boutique.urlLogo,
                    //       height: 100,
                    //       width: 100,
                    //       fit: BoxFit.cover,
                    //     ),
                    //   ),
                    // const SizedBox(height: 16),

                    infoRow("Nom", boutique.nom),
                    infoRow("Adresse", boutique.adresse),
                    infoRow("Téléphone", boutique.phone),
                    infoRow("Solde", "${boutique.solde} FCFA"),
                    infoRow("Horaires",
                        "${boutique.heureOuverture} - ${boutique.heureFermeture}"),
                    infoRow("Description", boutique.description),
                  ]
                ],
              ),
            ),
    );
  }

  // Widget utilitaire pour afficher une ligne d'info
  Widget infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label : ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
