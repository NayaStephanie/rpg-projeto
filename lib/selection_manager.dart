import 'package:flutter/material.dart';

class SelectionManager {
  // Raça, Classe e Antecedente
  static ValueNotifier<String?> selectedRace = ValueNotifier(null);
  static ValueNotifier<String?> selectedClass = ValueNotifier(null);
  static ValueNotifier<String?> selectedBackground = ValueNotifier(null);
  static ValueNotifier<Map<String, int>> selectedAttributes = ValueNotifier({});

  // Armazena o bônus customizado que será aplicado na SummaryScreen
  // Ex: {'DES': 1} para Gnomo, ou {'FOR': 1, 'SAB': 1} para Meio-Elfo.
  static ValueNotifier<Map<String, int>> selectedCustomBonus = ValueNotifier({});


}