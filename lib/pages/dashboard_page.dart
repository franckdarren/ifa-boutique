import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constant.dart';
import '../../providers/auth_provider.dart';
import '../../providers/dashboard_provider.dart';
import 'components/infobox.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Après le premier build, lancer le timer
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Assurez-vous que l'utilisateur est déjà chargé
      final authState = ref.read(authProvider);
      final user = authState.user;
      if (user != null) {
        _timer = Timer.periodic(Duration(seconds: 10), (_) {
          // Rafraîchir le dashboardProvider automatiquement
          ref.refresh(dashboardProvider(user.id));
        });
      }
    });
  }

  @override
  void dispose() {
    // Annuler le timer lors de la destruction du widget
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final boutique = user?.boutique;

    // Vérification des données utilisateur/boutique
    if (user == null || boutique == null) {
      return const Scaffold(
        body: Center(child: Text("Utilisateur ou boutique non trouvé")),
      );
    }

    // Provider de stats (avec userId en paramètre si nécessaire)
    final dashboardStats = ref.watch(dashboardProvider(user.id));

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Solde de la boutique
            Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: couleurPrimaire,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Solde',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Text(
                    "${boutique.solde} FCFA",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Statistiques dynamiques
            dashboardStats.when(
              data: (stats) {
                return Row(
                  children: [
                    Expanded(
                      child: InfoBox(
                        title: 'Articles',
                        number: '${stats.articlesCount}',
                        textColor: Colors.black,
                        borderColor: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: InfoBox(
                        title: 'Ventes',
                        number: '0', // Mettre à jour quand disponible
                        textColor: ventes,
                        borderColor: ventes,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: InfoBox(
                        title: 'Alertes',
                        number: '0', // Mettre à jour quand disponible
                        textColor: alertes,
                        borderColor: alertes,
                      ),
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) =>
                  Center(child: Text('Erreur lors du chargement : $error')),
            ),
          ],
        ),
      ),
    );
  }
}
