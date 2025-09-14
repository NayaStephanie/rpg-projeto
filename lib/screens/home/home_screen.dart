import 'package:flutter/material.dart';
import '../../utils/app_routes.dart';

/// Tela inicial após login
/// Mostra opções para criar personagem
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.races);
          },
          child: const Text("Criar Personagem"),
        ),
      ),
    );
  }
}
