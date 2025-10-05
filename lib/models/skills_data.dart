// skills_data.dart

/// Modelo de perícia
class Skill {
  final String name;
  final String attribute;
  bool fixed; // veio fixo (não pode desmarcar)
  bool selected; // está marcada no final

  Skill({
    required this.name,
    required this.attribute,
    this.fixed = false,
    this.selected = false,
  });
}

/// Resultado da montagem inicial de perícias para o personagem
class SkillsResult {
  final List<Skill> skills; // todas as perícias (com fixed/selected setados)
  final List<String> classOptions; // opções que a classe pode escolher (sem as fixas)
  final int classChoiceCount; // quantas escolhas de classe
  final int raceFreeChoices; // escolhas livres de raça (ex: Meio-Elfo = 2)
  final int duplicateChoiceCount; // se houve duplicatas fixas, quantas substituições são permitidas

  SkillsResult({
    required this.skills,
    required this.classOptions,
    required this.classChoiceCount,
    this.raceFreeChoices = 0,
    this.duplicateChoiceCount = 0,
  });
}

/// Lista completa de perícias (nome -> atributo)
final Map<String, String> _allSkills = {
  'Atletismo': 'Força',
  'Acrobacia': 'Destreza',
  'Furtividade': 'Destreza',
  'Prestidigitação': 'Destreza',
  'Arcanismo': 'Inteligência',
  'História': 'Inteligência',
  'Investigação': 'Inteligência',
  'Natureza': 'Inteligência',
  'Religião': 'Inteligência',
  'Intuição': 'Sabedoria',
  'Medicina': 'Sabedoria',
  'Percepção': 'Sabedoria',
  'Sobrevivência': 'Sabedoria',
  'Adestrar Animais': 'Sabedoria',
  'Atuação': 'Carisma',
  'Enganação': 'Carisma',
  'Intimidação': 'Carisma',
  'Persuasão': 'Carisma',
};

/// Raças -> perícias automáticas (chaves em minúsculas)
final Map<String, List<String>> _raceSkills = {
  'humano': [],
  'elfo': ['Percepção'],
  'draconato': [],
  'anão': [],
  'tiefling': [],
  'halfling': [],
  'gnomo': [],
  'meio-elfo': [], // tratado especial (escolhe 2 quaisquer)
  'meio-orc': ['Intimidação'],
};

/// Antecedentes -> perícias automáticas (chaves em minúsculas)
final Map<String, List<String>> _backgroundSkills = {
  'artista': ['Acrobacia', 'Atuação'],
  'artesão da guilda': ['Intuição', 'Persuasão'],
  'acólito': ['Intuição', 'Religião'],
  'eremita': ['Medicina', 'Religião'],
  'criminoso': ['Enganação', 'Furtividade'],
  'charlatão': ['Enganação', 'Prestidigitação'],
  'marinheiro': ['Atletismo', 'Percepção'],
  'herói do povo': ['Adestrar Animais', 'Sobrevivência'],
  'forasteiro': ['Atletismo', 'Sobrevivência'],
  'sábio': ['Arcanismo', 'História'],
  'órfão': ['Furtividade', 'Intuição'],
  'nobre': ['História', 'Persuasão'],
  'soldado': ['Atletismo', 'Intimidação'],
};

/// Opções de perícias por classe (chaves em minúsculas)
final Map<String, List<String>> _classSkillOptions = {
  'bárbaro': ['Adestrar Animais', 'Atletismo', 'Intimidação', 'Natureza', 'Percepção', 'Sobrevivência'],
  'bardo': _allSkills.keys.toList(), // escolhe 3 quaisquer
  'clérigo': ['História', 'Intuição', 'Medicina', 'Persuasão', 'Religião'],
  'druida': ['Arcanismo', 'Adestrar Animais', 'Intuição', 'Medicina', 'Natureza', 'Percepção', 'Religião', 'Sobrevivência'],
  'guerreiro': ['Acrobacia', 'Adestrar Animais', 'Atletismo', 'História', 'Intuição', 'Intimidação', 'Percepção', 'Sobrevivência'],
  'monge': ['Acrobacia', 'Atletismo', 'História', 'Intuição', 'Religião', 'Furtividade'],
  'paladino': ['Atletismo', 'Intuição', 'Intimidação', 'Medicina', 'Persuasão', 'Religião'],
  'patrulheiro': ['Acrobacia', 'Adestrar Animais', 'Atletismo', 'Intuição', 'Investigação', 'Natureza', 'Percepção', 'Furtividade', 'Sobrevivência'],
  'ladino': ['Acrobacia', 'Atletismo', 'Enganação', 'Intuição', 'Intimidação', 'Investigação', 'Percepção', 'Atuação', 'Persuasão', 'Prestidigitação', 'Furtividade'],
  'feiticeiro': ['Arcanismo', 'Atuação', 'Enganação', 'Intimidação', 'Persuasão', 'Religião'],
  'bruxo': ['Arcanismo', 'Enganação', 'História', 'Intimidação', 'Religião'],
  'mago': ['Arcanismo', 'História', 'Investigação', 'Medicina', 'Religião'],
};

// Quantidade de perícias que cada classe pode escolher (chaves em minúsculas)
final Map<String, int> classSkillChoiceCount = {
  'bárbaro': 2,
  'bardo': 3,
  'clérigo': 2,
  'druida': 2,
  'guerreiro': 2,
  'monge': 2,
  'paladino': 2,
  'patrulheiro': 3,
  'ladino': 4,
  'feiticeiro': 2,
  'bruxo': 2,
  'mago': 2,
};

SkillsResult getSkillsForCharacter(String race, String charClass, String background) {
  // normaliza chaves
  final raceKey = race.toLowerCase();
  final classKey = charClass.toLowerCase();
  final backgroundKey = background.toLowerCase();

  // perícias fixas por raça e antecedente
  final raceFixed = _raceSkills[raceKey] ?? [];
  final bgFixed = _backgroundSkills[backgroundKey] ?? [];
  final fixedSet = <String>{...raceFixed, ...bgFixed};

  // opções da classe
  final rawClassOptions = _classSkillOptions[classKey] ?? [];
  
  // MUDANÇA PRINCIPAL: cria conjunto com apenas as perícias relevantes
  final relevantSkills = <String>{};
  relevantSkills.addAll(fixedSet); // perícias fixas
  relevantSkills.addAll(rawClassOptions); // opções da classe
  
  // Para meio-elfo, adiciona todas as perícias como opções
  if (raceKey == 'meio-elfo') {
    relevantSkills.addAll(_allSkills.keys);
  }

  // MUDANÇA: inicializa apenas as perícias relevantes
  final skills = relevantSkills
      .map((name) => Skill(
            name: name, 
            attribute: _allSkills[name] ?? 'Desconhecido'
          ))
      .toList();

  // marca fixas
  for (var skill in skills) {
    if (fixedSet.contains(skill.name)) {
      skill.selected = true;
      skill.fixed = true;
    }
  }

  // escolhas livres de raça (ex: meio-elfo = 2)
  final raceFreeChoices = raceKey == 'meio-elfo' ? 2 : 0;

  // opções da classe (removendo as que já vieram fixas)
  final classOptionsFiltered = rawClassOptions.where((s) => !fixedSet.contains(s)).toList();

  // quantas a classe pode escolher (do map) - valor fixo da classe
  final baseClassChoiceCount = classSkillChoiceCount[classKey] ?? 0;
  
  // CORREÇÃO: Para classes normais, o número de escolhas é sempre o valor base
  // Duplicatas não dão escolhas extras, elas só indicam conflito
  final classChoiceCount = baseClassChoiceCount;

  // Duplicate count: quantas perícias da classe já vieram fixas (apenas para debug)
  int duplicateCount = 0;
  if (classKey != 'bardo' && raceKey != 'meio-elfo') {
    duplicateCount = rawClassOptions.where((s) => fixedSet.contains(s)).length;
  }

  return SkillsResult(
    skills: skills,
    classOptions: classOptionsFiltered,
    classChoiceCount: classChoiceCount,
    raceFreeChoices: raceFreeChoices,
    duplicateChoiceCount: duplicateCount,
  );
}