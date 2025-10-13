// lib/models/starting_equipment.dart

/// Representa uma escolha de equipamento inicial (opção A ou B)
class EquipmentChoice {
  final String optionA;
  final String optionB;
  final String description;

  EquipmentChoice({
    required this.optionA,
    required this.optionB,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'optionA': optionA,
      'optionB': optionB,
      'description': description,
    };
  }

  factory EquipmentChoice.fromJson(Map<String, dynamic> json) {
    return EquipmentChoice(
      optionA: json['optionA'] ?? '',
      optionB: json['optionB'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

/// Representa um item fixo que o personagem recebe automaticamente
class FixedEquipment {
  final String item;
  final String description;

  FixedEquipment({
    required this.item,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'item': item,
      'description': description,
    };
  }

  factory FixedEquipment.fromJson(Map<String, dynamic> json) {
    return FixedEquipment(
      item: json['item'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

/// Representa o conjunto completo de equipamentos iniciais de uma classe
class StartingEquipment {
  final String className;
  final List<EquipmentChoice> choices;
  final List<FixedEquipment> fixedItems;

  StartingEquipment({
    required this.className,
    required this.choices,
    required this.fixedItems,
  });

  Map<String, dynamic> toJson() {
    return {
      'className': className,
      'choices': choices.map((choice) => choice.toJson()).toList(),
      'fixedItems': fixedItems.map((item) => item.toJson()).toList(),
    };
  }

  factory StartingEquipment.fromJson(Map<String, dynamic> json) {
    return StartingEquipment(
      className: json['className'] ?? '',
      choices: (json['choices'] as List? ?? [])
          .map((choice) => EquipmentChoice.fromJson(choice))
          .toList(),
      fixedItems: (json['fixedItems'] as List? ?? [])
          .map((item) => FixedEquipment.fromJson(item))
          .toList(),
    );
  }
}

/// Representa as escolhas feitas pelo jogador para seus equipamentos iniciais
class PlayerEquipmentChoices {
  final String characterId;
  final String className;
  final Map<int, String> selectedChoices; // índice da escolha -> "A" ou "B"
  final DateTime timestamp;

  PlayerEquipmentChoices({
    required this.characterId,
    required this.className,
    required this.selectedChoices,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'characterId': characterId,
      'className': className,
      'selectedChoices': selectedChoices.map((key, value) => MapEntry(key.toString(), value)),
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory PlayerEquipmentChoices.fromJson(Map<String, dynamic> json) {
    return PlayerEquipmentChoices(
      characterId: json['characterId'] ?? '',
      className: json['className'] ?? '',
      selectedChoices: (json['selectedChoices'] as Map<String, dynamic>? ?? {})
          .map((key, value) => MapEntry(int.parse(key), value as String)),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  PlayerEquipmentChoices copyWith({
    String? characterId,
    String? className,
    Map<int, String>? selectedChoices,
    DateTime? timestamp,
  }) {
    return PlayerEquipmentChoices(
      characterId: characterId ?? this.characterId,
      className: className ?? this.className,
      selectedChoices: selectedChoices ?? this.selectedChoices,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}