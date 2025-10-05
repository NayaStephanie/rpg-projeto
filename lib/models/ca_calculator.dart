// lib/models/ca_calculator.dart

// Arquivo: ca_calculator.dart (Ajuste a sua função 'calculate')

import 'dart:math' as math;
import 'armor.dart';

class CACalculator {
  static int calculate({
    required String characterClass,
    required Armor currentArmor, // Armadura selecionada
    required int dexMod, // Modificador de Destreza (ex: -1, 0, +1, +2, +3, ...)
    required int conMod, // Modificador de Constituição
    required bool shield, // Se está usando escudo
    required bool mageArmor, // Se tem Armadura Arcana
  }) {
    int ca = 0;

    // 1. Lógica do Bárbaro (Sem armadura)
    if (characterClass == "Bárbaro" && currentArmor.type == ArmorType.none) {
      ca = 10 + dexMod + conMod;
    } 
    // 2. Lógica de Armadura Arcana (Magias)
    else if (mageArmor) {
      ca = 13 + dexMod;
    } 
    // 3. Lógica padrão baseada na Armadura
    else {
      int dexBonus = dexMod;
      int? maxBonus = currentArmor.dexMaxBonus;
      
      // Armadura Média/Pesada limita ou ignora o bônus de Destreza
      if (maxBonus != null) {
        dexBonus = math.min(dexMod, maxBonus);
      }
      
      ca = currentArmor.baseAC + dexBonus;
      
      // Adiciona bônus de Escudo, se aplicável (assumindo proficiência e que não é Bárbaro/Mago sem armadura)
      if (shield) {
        ca += 2;
      }
    }

    // Retorna a CA calculada (nunca menor que 0)
    return math.max(0, ca);
  }
}