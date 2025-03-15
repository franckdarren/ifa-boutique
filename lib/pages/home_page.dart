import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ifa_boutique/pages/article/mes_articles_page.dart';
import 'package:ifa_boutique/pages/commande/mes_commandes_page.dart';
import 'package:ifa_boutique/pages/dashboard_page.dart';
import 'package:url_launcher/url_launcher.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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

  // Lanceur vers whatsapp
  Future<void> openWhatsApp(
      {required String phoneNumber, String message = ''}) async {
    final Uri url = Uri.parse(
        'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}');

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
        title: Text("Acceuil"),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                context.push('/create-article');
              }),
          // IconButton(icon: Icon(Icons.notifications), onPressed: () {})
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
          elevation: 10,
          currentIndex: _selectedIndex,
          onTap: _navigateBottomBar,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart_outlined), label: 'Accueil'),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag), label: 'Articles'),
            BottomNavigationBarItem(
                icon: Icon(Icons.mobile_friendly_rounded), label: 'Ventes'),
          ]),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('lib/images/img1.jpg'),
                ),
              ),
            ),
            ListTile(
              title: Text(
                'Mon compte',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              trailing: Icon(Icons.arrow_right),
              leading: Icon(Icons.person),
              onTap: () {
                Navigator.of(context).pop();
                context.push('/mon-profil');
              },
            ),
            Divider(),
            ListTile(
              title: Text(
                'Nous contacter',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              trailing: Icon(Icons.arrow_right),
              leading: Icon(Icons.call),
              onTap: () {
                openWhatsApp(phoneNumber: '24102704750', message: 'Bonjour !');
              },
            ),
            Divider(),
            ListTile(
              title: Text(
                'Se déconnecter',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              trailing: Icon(Icons.arrow_right),
              leading: Icon(Icons.output_rounded),
              onTap: () {
                Navigator.of(context).pop();
                context.push('/mon-profil');
              },
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
