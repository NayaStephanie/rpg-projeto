// Adicione no arquivo models/skills_data.dart (ou crie um novo arquivo models/saving_throws.dart)

/// Modelo para uma salvaguarda
class SavingThrow {
  final String name;
  final String attribute;
  bool proficient; // se é proficiente nesta salvaguarda
  
  SavingThrow({
    required this.name,
    required this.attribute,
    this.proficient = false,
  });
}

/// Salvaguardas por classe (chaves em minúsculas)
final Map<String, List<String>> _classSavingThrows = {
  'bárbaro': ['Força', 'Constituição'],
  'bardo': ['Destreza', 'Carisma'],
  'clérigo': ['Sabedoria', 'Carisma'],
  'druida': ['Inteligência', 'Sabedoria'],
  'guerreiro': ['Força', 'Constituição'],
  'monge': ['Força', 'Destreza'],
  'paladino': ['Sabedoria', 'Carisma'],
  'patrulheiro': ['Força', 'Destreza'],
  'ladino': ['Destreza', 'Inteligência'],
  'feiticeiro': ['Constituição', 'Carisma'],
  'bruxo': ['Sabedoria', 'Carisma'],
  'mago': ['Inteligência', 'Sabedoria'],
};

/// Todas as salvaguardas possíveis
final List<String> _allSavingThrows = [
  'Força',
  'Destreza', 
  'Constituição',
  'Inteligência',
  'Sabedoria',
  'Carisma'
];

/// Função para obter salvaguardas do personagem
List<SavingThrow> getSavingThrowsForClass(String characterClass) {
  final classKey = characterClass.toLowerCase();
  final classProficiencies = _classSavingThrows[classKey] ?? [];
  
  return _allSavingThrows.map((savingThrow) {
    return SavingThrow(
      name: savingThrow,
      attribute: savingThrow,
      proficient: classProficiencies.contains(savingThrow),
    );
  }).toList();
}
