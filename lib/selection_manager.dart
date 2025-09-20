import 'package:flutter/material.dart';

class SelectionManager {
  // Raça, Classe e Antecedente
  static ValueNotifier<String?> selectedRace = ValueNotifier(null);
  static ValueNotifier<String?> selectedClass = ValueNotifier(null);
  static ValueNotifier<String?> selectedBackground = ValueNotifier(null);
}
