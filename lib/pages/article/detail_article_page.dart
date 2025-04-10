import 'package:flutter/material.dart';

class DetailsArticlePage extends StatelessWidget {
  final Map<String, dynamic> article;

  const DetailsArticlePage({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final statut = article['statut'].toLowerCase();

    return Scaffold(
      appBar: AppBar(title: Text(article['nom'])),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                article['image'],
                width: double.infinity,
                height: 250,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              article['prix'],
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Taille : ${article['taille']}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              article['statut'],
              style: TextStyle(
                fontSize: 16,
                color: statut == 'en stock' ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
