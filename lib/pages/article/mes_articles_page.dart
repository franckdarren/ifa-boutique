import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MesArticlesPage extends StatefulWidget {
  const MesArticlesPage({super.key});

  @override
  State<MesArticlesPage> createState() => _MesArticlesPageState();
}

class _MesArticlesPageState extends State<MesArticlesPage> {
  // Exemple de liste d'articles
  final List<Map<String, dynamic>> articles = const [
    {
      'image': 'lib/images/chemise.jpg',
      'prix': '4500 Fcfa',
      'nom': 'Chemise',
      'taille': 'XL',
      'statut': 'En stock',
    },
    {
      'image': 'lib/images/chemise.jpg',
      'prix': '7000 Fcfa',
      'nom': 'Pantalon',
      'taille': 'L',
      'statut': 'En rupture',
    },
    {
      'image': 'lib/images/chemise.jpg',
      'prix': '3000 Fcfa',
      'nom': 'T-shirt',
      'taille': 'M',
      'statut': 'En stock',
    },
    // Ajoute autant d'articles que tu veux ici
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mes articles')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: articles.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Deux colonnes
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.65, // Ajuste cette valeur si besoin
          ),
          itemBuilder: (context, index) {
            final article = articles[index];
            final statut = article['statut'].toLowerCase();

            return GestureDetector(
              onTap: () {
                context.push('/details', extra: article);
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Hero(
                          tag: article['nom'], // Utilise un identifiant unique
                          child: Image.asset(
                            article['image'],
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      article['prix'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      article['nom'],
                      style: const TextStyle(fontSize: 14),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          article['taille'],
                          style: const TextStyle(fontSize: 14),
                        ),
                        Text(
                          article['statut'],
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: article['statut'].toLowerCase() == 'en stock'
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
