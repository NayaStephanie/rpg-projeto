import 'package:flutter/material.dart';
import '../../utils/app_routes.dart';

/// Tela de Login
/// Por enquanto só tem botão que leva pra Home
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, AppRoutes.home);
          },
          child: const Text("Entrar"),
        ),
      ),
    );
  }
}
