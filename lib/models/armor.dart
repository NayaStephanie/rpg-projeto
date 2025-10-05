// models/armor.dart

enum ArmorType { light, medium, heavy, none }

class Armor {
  final String name;
  final ArmorType type;
  final int baseAC;
  // O bônus máximo de DES permitido (null se não houver limite, 0 se ignorar)
  final int? dexMaxBonus; 
  // Nota: allowsDex foi removido, pois o cálculo deve usar dexMaxBonus e ArmorType.

  const Armor({
    required this.name,
    required this.type,
    required this.baseAC,
    this.dexMaxBonus, // Se null, permite DES completa (Armadura Leve e Sem Armadura). Se 0, não permite DES (Armadura Pesada). Se N, limita em N (Armadura Média).
  });
}

// Tabela de armaduras de exemplo (como em D&D)
const List<Armor> armors = [
  Armor(name: "Sem Armadura", type: ArmorType.none, baseAC: 10),
  // Armadura Leve: CA Base + Modificador de Destreza Completo (dexMaxBonus: null)
  Armor(name: "Couro", type: ArmorType.light, baseAC: 11), 
  // Armadura Média: CA Base + Modificador de Destreza (limitado a 2)
  Armor(name: "Cota de Escamas", type: ArmorType.medium, baseAC: 14, dexMaxBonus: 2), 
  // Armadura Pesada: CA Base + Modificador de Destreza (ignorado, dexMaxBonus: 0)
  Armor(name: "Cota de Malha", type: ArmorType.heavy, baseAC: 16, dexMaxBonus: 0),
  // Exemplo para o Paladino
  Armor(name: "Placas", type: ArmorType.heavy, baseAC: 18, dexMaxBonus: 0), 
];