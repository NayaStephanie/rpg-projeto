import 'package:flutter/material.dart';

/// Tela de Cadastro (placeholder por enquanto)
class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cadastrar")),
      body: const Center(
        child: Text("Tela de Cadastro"),
      ),
    );
  }
}
