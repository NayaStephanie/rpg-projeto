// lib/services/starting_equipment_service.dart

import '../models/equipment_item.dart';
import '../data/starting_equipment_data.dart';

/// Serviço para gerenciar equipamentos iniciais e escolhas dos jogadores
class StartingEquipmentService {
  
  /// Converte escolhas do jogador em itens de equipamento concretos
  List<EquipmentItem> generateEquipmentFromChoices({
    required String className,
    required Map<int, String> playerChoices,
  }) {
    final startingEquipment = getStartingEquipmentForClass(className);
    if (startingEquipment == null) {
      return [];
    }

    List<EquipmentItem> generatedEquipment = [];

    // Processar escolhas
    for (int i = 0; i < startingEquipment.choices.length; i++) {
      final choice = startingEquipment.choices[i];
      final selectedOption = playerChoices[i] ?? 'A'; // Padrão para opção A
      
      String selectedItem;
      if (selectedOption == 'A') {
        selectedItem = choice.optionA;
      } else {
        selectedItem = choice.optionB;
      }

      generatedEquipment.add(EquipmentItem(
        name: selectedItem,
        description: choice.description,
        category: _categorizeEquipment(selectedItem),
      ));
    }

    // Adicionar itens fixos
    for (final fixedItem in startingEquipment.fixedItems) {
      generatedEquipment.add(EquipmentItem(
        name: fixedItem.item,
        description: fixedItem.description,
        category: _categorizeEquipment(fixedItem.item),
      ));
    }

    return generatedEquipment;
  }

  /// Categoriza automaticamente um item de equipamento baseado no nome
  String _categorizeEquipment(String itemName) {
    final name = itemName.toLowerCase();
    
    // Armas
    if (name.contains('espada') || name.contains('machado') || name.contains('maça') || 
        name.contains('martelo') || name.contains('rapieira') || name.contains('cimitarra') ||
        name.contains('azagaia') || name.contains('dardo') || name.contains('adaga') ||
        name.contains('besta') || name.contains('arco') || name.contains('virote') ||
        name.contains('flecha') || name.contains('cajado')) {
      return 'Arma';
    }
    
    // Armaduras
    if (name.contains('armadura') || name.contains('cota') || name.contains('escudo') ||
        name.contains('escala')) {
      return 'Armadura';
    }
    
    // Instrumentos
    if (name.contains('instrumento')) {
      return 'Instrumento';
    }
    
    // Pacotes/Kits
    if (name.contains('pacote') || name.contains('kit')) {
      return 'Kit de Equipamentos';
    }
    
    // Itens mágicos/religiosos
    if (name.contains('símbolo') || name.contains('foco') || name.contains('bolsa de componentes') ||
        name.contains('livro de magias')) {
      return 'Item Mágico';
    }
    
    // Ferramentas
    if (name.contains('ferramentas')) {
      return 'Ferramenta';
    }
    
    return 'Equipamento Geral';
  }

  /// Valida se todas as escolhas obrigatórias foram feitas
  bool validateChoices({
    required String className,
    required Map<int, String> playerChoices,
  }) {
    final startingEquipment = getStartingEquipmentForClass(className);
    if (startingEquipment == null) {
      return false;
    }

    // Verificar se todas as escolhas foram feitas
    for (int i = 0; i < startingEquipment.choices.length; i++) {
      if (!playerChoices.containsKey(i) || 
          (playerChoices[i] != 'A' && playerChoices[i] != 'B')) {
        return false;
      }
    }

    return true;
  }

  /// Obtém um resumo legível das escolhas feitas
  Map<String, String> getChoicesSummary({
    required String className,
    required Map<int, String> playerChoices,
  }) {
    final startingEquipment = getStartingEquipmentForClass(className);
    if (startingEquipment == null) {
      return {};
    }

    Map<String, String> summary = {};
    
    for (int i = 0; i < startingEquipment.choices.length; i++) {
      final choice = startingEquipment.choices[i];
      final selectedOption = playerChoices[i];
      
      if (selectedOption != null) {
        String selectedItem = selectedOption == 'A' ? choice.optionA : choice.optionB;
        summary['Escolha ${i + 1}'] = selectedItem;
      }
    }

    return summary;
  }

  /// Retorna as escolhas padrão (todas opção A) para uma classe
  Map<int, String> getDefaultChoices(String className) {
    final startingEquipment = getStartingEquipmentForClass(className);
    if (startingEquipment == null) {
      return {};
    }

    Map<int, String> defaultChoices = {};
    for (int i = 0; i < startingEquipment.choices.length; i++) {
      defaultChoices[i] = 'A';
    }
    
    return defaultChoices;
  }

  /// Calcula o valor estimado dos equipamentos escolhidos (para balanceamento)
  int calculateEquipmentValue({
    required String className,
    required Map<int, String> playerChoices,
  }) {
    // Valores básicos para diferentes tipos de equipamento
    final Map<String, int> baseValues = {
      'arma simples': 5,
      'arma marcial': 15,
      'armadura leve': 10,
      'armadura média': 50,
      'armadura pesada': 100,
      'escudo': 10,
      'pacote': 20,
      'instrumento': 25,
      'foco mágico': 20,
    };

    int totalValue = 0;
    final equipment = generateEquipmentFromChoices(
      className: className,
      playerChoices: playerChoices,
    );

    for (final item in equipment) {
      // Estimativa simples baseada no tipo
      if (item.category == 'Arma') {
        totalValue += baseValues['arma marcial'] ?? 10;
      } else if (item.category == 'Armadura') {
        totalValue += baseValues['armadura média'] ?? 30;
      } else if (item.category == 'Kit de Equipamentos') {
        totalValue += baseValues['pacote'] ?? 20;
      } else {
        totalValue += 10; // Valor padrão
      }
    }

    return totalValue;
  }
}