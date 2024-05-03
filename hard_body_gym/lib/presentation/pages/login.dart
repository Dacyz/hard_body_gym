import 'package:flutter/material.dart';
import 'package:hard_body_gym/data/api.dart';
import 'package:hard_body_gym/presentation/pages/home.dart';
import 'package:hard_body_gym/presentation/provider/provider.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static const String route = '/login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final user = TextEditingController();
  final pass = TextEditingController();

  Future<void> login() async {
    final data = Provider.of<DataService>(context, listen: false);
    try {
      if (user.text.isEmpty || pass.text.isEmpty) {
        return showDialog(
          context: context,
          builder: (_) => const AlertDialog.adaptive(
            content: Text('Campos vacíos'),
          ),
        );
      }
      final resp = await ApiData.login(user.text, pass.text);
      if (resp == null) {
        return showDialog(
          context: context,
          builder: (_) => const AlertDialog.adaptive(
            content: Text('Credenciales incorrectas'),
          ),
        );
      }
      data.user = resp;
      Navigator.pushNamed(context, HomePage.route);
    } catch (e) {
      return showDialog(
        context: context,
        builder: (_) => AlertDialog.adaptive(
          content: Text('$e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/image/logo.png',
                width: 150,
              ),
              const SizedBox(height: 8),
              const Text('Inicia sesión'),
              const SizedBox(height: 24),
              TextField(
                controller: user,
                decoration: const InputDecoration(
                  hintText: 'Usuario',
                  label: Text('Usuario'),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: pass,
                decoration: const InputDecoration(
                  hintText: 'Contraseña',
                  label: Text('Contraseña'),
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: login,
                child: const Text('Inicia sesión'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
