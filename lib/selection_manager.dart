// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:app_rpg/models/skills_data.dart';
import 'package:app_rpg/models/equipment_item.dart';

class SelectionManager extends ChangeNotifier {
  // Singleton pattern
  static final SelectionManager _instance = SelectionManager._internal();
  factory SelectionManager() => _instance;
  SelectionManager._internal();

  // Estado privado
  String? _selectedRace;
  String? _selectedClass;
  String? _selectedBackground;
  Map<String, int> _selectedAttributes = {};
  Map<String, int> _selectedCustomBonus = {};
  List<Skill> _selectedSkills = [];
  Map<int, String> _startingEquipmentChoices = {};
  List<EquipmentItem> _startingEquipment = [];

  // Getters públicos
  String? get selectedRace => _selectedRace;
  String? get selectedClass => _selectedClass;
  String? get selectedBackground => _selectedBackground;
  Map<String, int> get selectedAttributes => Map.unmodifiable(_selectedAttributes);
  Map<String, int> get selectedCustomBonus => Map.unmodifiable(_selectedCustomBonus);
  List<Skill> get selectedSkills => List.unmodifiable(_selectedSkills);
  Map<int, String> get startingEquipmentChoices => Map.unmodifiable(_startingEquipmentChoices);
  List<EquipmentItem> get startingEquipment => List.unmodifiable(_startingEquipment);

  // Setters que notificam listeners
  set selectedRace(String? value) {
    if (_selectedRace != value) {
      _selectedRace = value;
      notifyListeners();
    }
  }

  set selectedClass(String? value) {
    if (_selectedClass != value) {
      _selectedClass = value;
      notifyListeners();
    }
  }

  set selectedBackground(String? value) {
    if (_selectedBackground != value) {
      _selectedBackground = value;
      notifyListeners();
    }
  }

  void setSelectedAttributes(Map<String, int> attributes) {
    _selectedAttributes = Map.from(attributes);
    notifyListeners();
  }

  void setSelectedCustomBonus(Map<String, int> bonus) {
    _selectedCustomBonus = Map.from(bonus);
    notifyListeners();
  }

  void setSelectedSkills(List<Skill> skills) {
    _selectedSkills = List.from(skills);
    notifyListeners();
  }

  void setStartingEquipmentChoices(Map<int, String> choices) {
    _startingEquipmentChoices = Map.from(choices);
    notifyListeners();
  }

  void setStartingEquipment(List<EquipmentItem> equipment) {
    _startingEquipment = List.from(equipment);
    notifyListeners();
  }

  /// Limpa todas as seleções para iniciar um novo personagem
  void clearAllSelections() {
    _selectedRace = null;
    _selectedClass = null;
    _selectedBackground = null;
    _selectedAttributes = {};
    _selectedCustomBonus = {};
    _selectedSkills = [];
    _startingEquipmentChoices = {};
    _startingEquipment = [];
    
    // Debug para confirmar que foi limpo
    print('🧹 SelectionManager: Todas as seleções foram limpas');
    notifyListeners();
  }
}