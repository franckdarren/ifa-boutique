import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import de Riverpod
import 'package:go_router/go_router.dart';
import 'package:ifa_boutique/pages/article/mes_articles_page.dart';
import 'package:ifa_boutique/pages/commande/mes_commandes_page.dart';
import 'package:ifa_boutique/pages/profil/mon_profil_page.dart';
import 'pages/auth/login_page.dart';
import 'pages/auth/register_page.dart';
import 'pages/home_page.dart';
import 'pages/boutique/create_boutique_page.dart';
import 'pages/article/create_article_page.dart';
import 'pages/article/detail_article_page.dart';
import '../../constant.dart';

void main() {
  runApp(const ProviderScope(child: MyApp())); // ⬅️ ProviderScope ajouté ici
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter _router = GoRouter(
      initialLocation: '/home',
      routes: [
        GoRoute(path: '/login', builder: (context, state) => LoginPage()),
        GoRoute(path: '/register', builder: (context, state) => RegisterPage()),
        GoRoute(path: '/home', builder: (context, state) => MyHomePage()),
        GoRoute(
            path: '/create-boutique',
            builder: (context, state) => CreateBoutiquePage()),
        GoRoute(
            path: '/create-article',
            builder: (context, state) => CreateArticlePage()),
        GoRoute(
            path: '/mes-articles',
            builder: (context, state) => MesArticlesPage()),
        GoRoute(
            path: '/mes-commandes',
            builder: (context, state) => MesCommandesPage()),
        GoRoute(
            path: '/mon-profil', builder: (context, state) => MonProfilPage()),
        GoRoute(
          path: '/details',
          builder: (context, state) => const DetailsArticlePage(),
        ),
      ],
    );

    return MaterialApp.router(
      routerConfig: _router,
      title: 'IFA Boutique',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: couleurPrimaire, primary: couleurPrimaire),
        useMaterial3: true,
      ),
    );
  }
}
