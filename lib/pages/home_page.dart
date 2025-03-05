import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
                context.go('/create-article');
              }),
          // IconButton(icon: Icon(Icons.notifications), onPressed: () {})
        ],
      ),
      body: Text('HOME'),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _navigateBottomBar,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Articles'),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag), label: 'Commandes'),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_rounded), label: 'Profil'),
          ]),
    );
  }
}
