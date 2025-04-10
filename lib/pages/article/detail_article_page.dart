import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DetailsArticlePage extends StatelessWidget {
  const DetailsArticlePage({super.key});

  @override
  Widget build(BuildContext context) {
    final article = GoRouterState.of(context).extra as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(title: Text(article['nom'])),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: article['nom'],
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  article['image'],
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              article['prix'],
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Taille : ${article['taille']}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              "Statut : ${article['statut']}",
              style: TextStyle(
                fontSize: 16,
                color: article['statut'].toLowerCase() == 'en stock'
                    ? Colors.green
                    : Colors.red,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Description de l'article...",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
