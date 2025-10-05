import 'package:flutter/material.dart';
import 'package:app_rpg/models/skills_data.dart';

class SelectionManager {
  // Raça, Classe e Antecedente
  static ValueNotifier<String?> selectedRace = ValueNotifier(null);
  static ValueNotifier<String?> selectedClass = ValueNotifier(null);
  static ValueNotifier<String?> selectedBackground = ValueNotifier(null);
  static ValueNotifier<Map<String, int>> selectedAttributes = ValueNotifier({});

  // Armazena o bônus customizado que será aplicado na SummaryScreen
  // Ex: {'DES': 1} para Gnomo, ou {'FOR': 1, 'SAB': 1} para Meio-Elfo.
  static ValueNotifier<Map<String, int>> selectedCustomBonus = ValueNotifier({});

  // Armazena as perícias selecionadas pelo usuário
  static ValueNotifier<List<Skill>> selectedSkills = ValueNotifier([]);

  /// Limpa todas as seleções para iniciar um novo personagem
  static void clearAllSelections() {
    selectedRace.value = null;
    selectedClass.value = null;
    selectedBackground.value = null;
    selectedAttributes.value = {};
    selectedCustomBonus.value = {};
    selectedSkills.value = [];
    
    // Debug para confirmar que foi limpo
    print('🧹 SelectionManager: Todas as seleções foram limpas');
  }
}