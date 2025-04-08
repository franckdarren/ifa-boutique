import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ifa_boutique/pages/article/mes_articles_page.dart';
import 'package:ifa_boutique/pages/commande/mes_commandes_page.dart';
import 'package:ifa_boutique/pages/dashboard_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart'; // Assure-toi que le chemin est correct

class MyHomePage extends ConsumerStatefulWidget {
  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  int _selectedIndex = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    DashboardPage(),
    MesArticlesPage(),
    MesCommandesPage(),
  ];

  // Lanceur vers WhatsApp
  Future<void> openWhatsApp({
    required String phoneNumber,
    String message = '',
  }) async {
    final Uri url = Uri.parse(
      'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}',
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Impossible d’ouvrir WhatsApp');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Accueil"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context.push('/create-article');
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 10,
        currentIndex: _selectedIndex,
        onTap: _navigateBottomBar,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_outlined), label: 'Accueil'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag), label: 'Articles'),
          BottomNavigationBarItem(
              icon: Icon(Icons.mobile_friendly_rounded), label: 'Ventes'),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Center(
                child: Image.asset(
                  'lib/images/logo1.png',
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            ListTile(
              title: const Text(
                'Mon compte',
                style: TextStyle(fontSize: 18),
              ),
              trailing: const Icon(Icons.arrow_right),
              leading: const Icon(Icons.person),
              onTap: () {
                Navigator.of(context).pop();
                context.push('/mon-profil');
              },
            ),
            const Divider(),
            ListTile(
              title: const Text(
                'Nous contacter',
                style: TextStyle(fontSize: 18),
              ),
              trailing: const Icon(Icons.arrow_right),
              leading: const Icon(Icons.call),
              onTap: () {
                openWhatsApp(phoneNumber: '24102704750', message: 'Bonjour !');
              },
            ),
            const Divider(),
            ListTile(
              title: const Text(
                'Se déconnecter',
                style: TextStyle(fontSize: 18),
              ),
              trailing: const Icon(Icons.arrow_right),
              leading: const Icon(Icons.output_rounded),
              onTap: () {
                Navigator.of(context).pop();
                ref.read(authProvider.notifier).logout(context);
              },
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
