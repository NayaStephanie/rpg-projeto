class CharacterModel {
  final String id;
  final String name;
  final String? avatarPath; // Caminho para a imagem do avatar
  final String race;
  final String characterClass;
  final String background;
  final int level;
  final Map<String, int> attributes;
  final int hitPoints;
  final int armorClass;
  final String currentArmor;
  final bool hasShield;
  final Map<String, bool> skills;
  final Map<String, bool> preparedSpells;
  final Map<String, bool> selectedCantrips;
  final Map<int, int> maxSpellSlots;
  final Map<int, int> usedSpellSlots;
  final int inspiration;
  final int gold;
  final int silver;
  final int copper;
  final List<bool> deathSaveSuccesses;
  final List<bool> deathSaveFailures;
  final DateTime createdAt;
  final DateTime lastModified;

  CharacterModel({
    required this.id,
    required this.name,
    this.avatarPath, // Opcional
    required this.race,
    required this.characterClass,
    required this.background,
    required this.level,
    required this.attributes,
    required this.hitPoints,
    required this.armorClass,
    required this.currentArmor,
    required this.hasShield,
    required this.skills,
    required this.preparedSpells,
    required this.selectedCantrips,
    required this.maxSpellSlots,
    required this.usedSpellSlots,
    required this.inspiration,
    required this.gold,
    required this.silver,
    required this.copper,
    required this.deathSaveSuccesses,
    required this.deathSaveFailures,
    required this.createdAt,
    required this.lastModified,
  });

  // Converte o modelo para Map para armazenamento local
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatarPath': avatarPath,
      'race': race,
      'characterClass': characterClass,
      'background': background,
      'level': level,
      'attributes': attributes,
      'hitPoints': hitPoints,
      'armorClass': armorClass,
      'currentArmor': currentArmor,
      'hasShield': hasShield,
      'skills': skills,
      'preparedSpells': preparedSpells,
      'selectedCantrips': selectedCantrips,
      'maxSpellSlots': maxSpellSlots.map((key, value) => MapEntry(key.toString(), value)),
      'usedSpellSlots': usedSpellSlots.map((key, value) => MapEntry(key.toString(), value)),
      'inspiration': inspiration,
      'gold': gold,
      'silver': silver,
      'copper': copper,
      'deathSaveSuccesses': deathSaveSuccesses,
      'deathSaveFailures': deathSaveFailures,
      'createdAt': createdAt.toIso8601String(),
      'lastModified': lastModified.toIso8601String(),
    };
  }

  // Cria o modelo a partir de um Map
  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      id: json['id'],
      name: json['name'],
      avatarPath: json['avatarPath'],
      race: json['race'],
      characterClass: json['characterClass'],
      background: json['background'],
      level: json['level'],
      attributes: Map<String, int>.from(json['attributes']),
      hitPoints: json['hitPoints'],
      armorClass: json['armorClass'],
      currentArmor: json['currentArmor'],
      hasShield: json['hasShield'],
      skills: Map<String, bool>.from(json['skills']),
      preparedSpells: Map<String, bool>.from(json['preparedSpells']),
      selectedCantrips: Map<String, bool>.from(json['selectedCantrips']),
      maxSpellSlots: (json['maxSpellSlots'] as Map<String, dynamic>)
          .map((key, value) => MapEntry(int.parse(key), value as int)),
      usedSpellSlots: (json['usedSpellSlots'] as Map<String, dynamic>)
          .map((key, value) => MapEntry(int.parse(key), value as int)),
      inspiration: json['inspiration'] is bool 
          ? (json['inspiration'] as bool ? 1 : 0)  // Converte bool antigo para int
          : json['inspiration'] as int? ?? 0,      // Usa int se já estiver no novo formato
      gold: json['gold'],
      silver: json['silver'],
      copper: json['copper'],
      deathSaveSuccesses: List<bool>.from(json['deathSaveSuccesses']),
      deathSaveFailures: List<bool>.from(json['deathSaveFailures']),
      createdAt: DateTime.parse(json['createdAt']),
      lastModified: DateTime.parse(json['lastModified']),
    );
  }

  // Cria uma cópia do modelo com alterações
  CharacterModel copyWith({
    String? id,
    String? name,
    String? avatarPath,
    String? race,
    String? characterClass,
    String? background,
    int? level,
    Map<String, int>? attributes,
    int? hitPoints,
    int? armorClass,
    String? currentArmor,
    bool? hasShield,
    Map<String, bool>? skills,
    Map<String, bool>? preparedSpells,
    Map<String, bool>? selectedCantrips,
    Map<int, int>? maxSpellSlots,
    Map<int, int>? usedSpellSlots,
    int? inspiration,
    int? gold,
    int? silver,
    int? copper,
    List<bool>? deathSaveSuccesses,
    List<bool>? deathSaveFailures,
    DateTime? createdAt,
    DateTime? lastModified,
  }) {
    return CharacterModel(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarPath: avatarPath ?? this.avatarPath,
      race: race ?? this.race,
      characterClass: characterClass ?? this.characterClass,
      background: background ?? this.background,
      level: level ?? this.level,
      attributes: attributes ?? this.attributes,
      hitPoints: hitPoints ?? this.hitPoints,
      armorClass: armorClass ?? this.armorClass,
      currentArmor: currentArmor ?? this.currentArmor,
      hasShield: hasShield ?? this.hasShield,
      skills: skills ?? this.skills,
      preparedSpells: preparedSpells ?? this.preparedSpells,
      selectedCantrips: selectedCantrips ?? this.selectedCantrips,
      maxSpellSlots: maxSpellSlots ?? this.maxSpellSlots,
      usedSpellSlots: usedSpellSlots ?? this.usedSpellSlots,
      inspiration: inspiration ?? this.inspiration,
      gold: gold ?? this.gold,
      silver: silver ?? this.silver,
      copper: copper ?? this.copper,
      deathSaveSuccesses: deathSaveSuccesses ?? this.deathSaveSuccesses,
      deathSaveFailures: deathSaveFailures ?? this.deathSaveFailures,
      createdAt: createdAt ?? this.createdAt,
      lastModified: lastModified ?? this.lastModified,
    );
  }
}