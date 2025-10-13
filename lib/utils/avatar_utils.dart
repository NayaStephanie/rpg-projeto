import 'package:flutter/material.dart';

// Lista de ícones de avatares pré-definidos
const List<IconData> predefinedAvatarIcons = [
  Icons.person,
  Icons.face,
  Icons.account_circle,
  Icons.sentiment_satisfied,
  Icons.child_care,
  Icons.elderly,
  Icons.accessibility,
  Icons.sports,
  Icons.school,
  Icons.work,
  Icons.favorite,
  Icons.star,
];

// Lista de cores para os avatares
const List<Color> avatarColors = [
  Colors.blue,
  Colors.red,
  Colors.green,
  Colors.orange,
  Colors.purple,
  Colors.teal,
  Colors.indigo,
  Colors.pink,
  Colors.brown,
  Colors.grey,
  Colors.amber,
  Colors.cyan,
];

// Classe para representar um avatar
class AvatarData {
  final IconData icon;
  final Color color;
  final String id;

  AvatarData({
    required this.icon,
    required this.color,
    required this.id,
  });
}

// Lista de avatares pré-definidos
final List<AvatarData> predefinedAvatars = List.generate(
  predefinedAvatarIcons.length,
  (index) => AvatarData(
    icon: predefinedAvatarIcons[index],
    color: avatarColors[index % avatarColors.length],
    id: 'avatar_$index',
  ),
);

// Função para obter um avatar padrão baseado no índice
AvatarData getDefaultAvatar(int index) {
  return predefinedAvatars[index % predefinedAvatars.length];
}