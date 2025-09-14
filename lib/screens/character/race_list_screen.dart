import 'package:flutter/material.dart';
import '../../data/races.dart';
import '../../widgets/info_card.dart';

/// Lista todas as raças disponíveis
class RaceListScreen extends StatelessWidget {
  const RaceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Escolha sua Raça")),
      body: ListView.builder(
        itemCount: races.length,
        itemBuilder: (context, index) {
          final race = races[index];
          return InfoCard(
            title: race.name,
            description: race.description,
            icon: race.icon,
          );
        },
      ),
    );
  }
}
