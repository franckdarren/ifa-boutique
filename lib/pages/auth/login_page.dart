import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../constant.dart';

class LoginPage extends ConsumerStatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Fonction de validation de l'email
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer un email';
    }
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!regex.hasMatch(value)) {
      return 'Veuillez entrer un email valide';
    }
    return null;
  }

  // Fonction de validation du mot de passe
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer un mot de passe';
    }
    if (value.length < 8) {
      return 'Il faut au moins 8 caractères';
    }
    return null;
  }

  // Fonction pour gérer la soumission du formulaire
  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final auth = ref.read(authProvider.notifier);
      await auth.login(
          _emailController.text, _passwordController.text, context);

      // final authState = ref.read(authProvider);
      // if (authState.token != null) {
      //   context.go('/home'); // Redirige vers la page d'accueil après connexion
      // } else {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text(authState.error ?? 'Une erreur est survenue')),
      //   );
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    return Scaffold(
      // appBar: AppBar(title: Text('Connexion')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'lib/images/logo1.png',
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 30),
                Text(
                  'Connectez-vous',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: couleurPrimaire),
                ),
                SizedBox(height: 30),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: _validateEmail,
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Mot de passe',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock),
                        ),
                        obscureText: true,
                        validator: _validatePassword,
                      ),
                      SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: authState.isLoading ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: couleurPrimaire,
                          foregroundColor:
                              Colors.white, // 🔵 couleur du texte / icône
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12), // 🎯 arrondi
                          ),
                          padding: EdgeInsets.symmetric(vertical: 15),
                          minimumSize: Size(double.infinity, 50),
                        ),
                        child: authState.isLoading
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white, // 👈 couleur du loader
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'Se connecter',
                                style: TextStyle(fontSize: 16),
                              ),
                      ),
                      SizedBox(height: 30),
                      Text(
                        'Se connecter avec :',
                        style: TextStyle(fontSize: 16, color: couleurPrimaire),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Bouton Google
                          InkWell(
                            onTap: () {
                              // Action pour Google
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 25,
                              child: Image.asset(
                                'lib/images/google.png',
                                width: 30,
                                height: 30,
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          // Bouton Facebook
                          InkWell(
                            onTap: () {
                              // Action pour Facebook
                            },
                            child: CircleAvatar(
                              backgroundColor: Color(0xFF1877F2),
                              radius: 25,
                              child: Image.asset(
                                'lib/images/facebook.png',
                                width: 30,
                                height: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () => context.go('/register'),
                  child: Text('Créer un compte',
                      style: TextStyle(color: couleurPrimaire, fontSize: 16)),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
