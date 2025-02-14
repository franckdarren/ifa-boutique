import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import de Riverpod
import 'package:go_router/go_router.dart';
import 'screens/auth/login_page.dart';
import 'screens/auth/register_page.dart';
import 'screens/home_page.dart';
import 'screens/boutique/create_boutique_page.dart';

void main() {
  runApp(const ProviderScope(child: MyApp())); // ⬅️ ProviderScope ajouté ici
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter _router = GoRouter(
      initialLocation: '/login',
      routes: [
        GoRoute(path: '/login', builder: (context, state) => LoginPage()),
        GoRoute(path: '/register', builder: (context, state) => RegisterPage()),
        GoRoute(path: '/home', builder: (context, state) => MyHomePage()),
        GoRoute(
            path: '/create-boutique',
            builder: (context, state) => CreateBoutiquePage()),
      ],
    );

    return MaterialApp.router(
      routerConfig: _router,
      title: 'IFA Boutique',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
