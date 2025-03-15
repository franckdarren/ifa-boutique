import 'package:flutter/material.dart';

class MesArticlesPage extends StatefulWidget {
  const MesArticlesPage({super.key});

  @override
  State<MesArticlesPage> createState() => _MesArticlesPageState();
}

class _MesArticlesPageState extends State<MesArticlesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mes articles')),
    );
  }
}
