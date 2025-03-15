import 'package:flutter/material.dart';

class MesCommandesPage extends StatefulWidget {
  const MesCommandesPage({super.key});

  @override
  State<MesCommandesPage> createState() => _MesCommandesPageState();
}

class _MesCommandesPageState extends State<MesCommandesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mes commandes')),
    );
  }
}
