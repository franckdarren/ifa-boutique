import 'package:flutter/material.dart';

class MonProfilPage extends StatefulWidget {
  const MonProfilPage({super.key});

  @override
  State<MonProfilPage> createState() => _MonProfilPageState();
}

class _MonProfilPageState extends State<MonProfilPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mon compte')),
    );
  }
}
