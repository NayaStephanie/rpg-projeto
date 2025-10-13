import 'package:app_rpg/selection_manager.dart';
// Mapeia o nome normalizado da raça (minúsculas, sem acento) para seus bônus fixos.
// Bônus customizados são tratados separadamente no SelectionManager.
const Map<String, Map<String, int>> raceBonuses = {
  // Exemplo para as raças que aparecem nas suas imagens
  'humano': {
    'FOR': 1, 'DES': 1, 'CON': 1, 'INT': 1, 'SAB': 1, 'CAR': 1
  },
  'gnomo': {
    'INT': 2
  },
  'meioelfo': {
    'CAR': 2
  },
  'meioorco': {
    'FOR': 2, 'CON': 1
  },
  'halfling': {
    'DES': 2
  },
  'draconato': {
    'FOR': 2, 'CAR': 1
  },
  'tiefling': {
    'INT': 1, 'CAR': 2
  },
  'anao': {
    'CON': 2
  },
  'elfo': {
    'DES': 2
  },
  
};

String _normalizeName(String name) {
  return name
      .toLowerCase()
      .replaceAll(RegExp(r'[áàãâä]'), 'a')
      .replaceAll(RegExp(r'[éèêë]'), 'e')
      .replaceAll(RegExp(r'[íìîï]'), 'i')
      .replaceAll(RegExp(r'[óòõôö]'), 'o')
      .replaceAll(RegExp(r'[úùûü]'), 'u')
      .replaceAll(RegExp(r'[ç]'), 'c')
      .replaceAll(RegExp(r'[^a-z0-9_]'), '');
}

// Função utilitária para obter todos os bônus (fixos + customizados)
Map<String, int> getRaceBonus(String? race) {
  if (race == null) return {};

  final normalizedRace = _normalizeName(race);
  final fixedBonus = raceBonuses[normalizedRace] ?? {};
  final customBonus = SelectionManager().selectedCustomBonus;

  // Combina o bônus fixo com o bônus customizado
  final Map<String, int> totalBonus = Map.from(fixedBonus);
  
  customBonus.forEach((attr, val) {
    totalBonus[attr] = (totalBonus[attr] ?? 0) + val.toInt();
  });
  
  return totalBonus;
}