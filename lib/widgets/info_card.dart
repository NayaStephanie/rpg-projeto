import 'package:flutter/material.dart';

/// Card genérico que pode ser usado para Raça, Classe, etc.
class InfoCard extends StatelessWidget {
  final String title;
  final String description;
  final String icon;

  const InfoCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.asset(icon, width: 40),
        title: Text(title),
        subtitle: Text(description),
      ),
    );
  }
}
