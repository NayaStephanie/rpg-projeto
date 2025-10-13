// Dados de idiomas para D&D 5e

/// Lista completa de idiomas disponíveis no jogo
const List<String> availableLanguages = [
  "Comum",
  "Anão",
  "Élfico", 
  "Gnômico",
  "Halfling",
  "Orc",
  "Dracônico",
  "Infernal",
  "Celestial",
  "Abissal",
  "Silvestre",
  "Primordial",
  "Goblin",
  "Gigante",
  "Aquan", // Primordial da água
  "Auran", // Primordial do ar
  "Ignan", // Primordial do fogo
  "Terran", // Primordial da terra
];

/// Idiomas automáticos que cada raça recebe
const Map<String, List<String>> raceAutomaticLanguages = {
  // Raças básicas
  "humano": ["Comum"],
  "elfo": ["Comum", "Élfico"],
  "anão": ["Comum", "Anão"],
  "halfling": ["Comum", "Halfling"],
  "draconato": ["Comum", "Dracônico"],
  "gnomo": ["Comum", "Gnômico"],
  "meio-elfo": ["Comum", "Élfico"],
  "meio-orc": ["Comum", "Orc"],
  "tiefling": ["Comum", "Infernal"],
  
  // Sub-raças específicas podem ter idiomas extras
  "elfo da floresta": ["Comum", "Élfico"],
  "elfo negro": ["Comum", "Élfico"],
  "alto elfo": ["Comum", "Élfico"],
  "anão da colina": ["Comum", "Anão"],
  "anão da montanha": ["Comum", "Anão"],
  "halfling pés peludos": ["Comum", "Halfling"],
  "halfling robusto": ["Comum", "Halfling"],
  "gnomo da floresta": ["Comum", "Gnômico"],
  "gnomo das rochas": ["Comum", "Gnômico"],
};

/// Quantos idiomas extras cada raça pode escolher
const Map<String, int> raceLanguageChoices = {
  "humano": 1, // Humanos podem escolher 1 idioma extra
  "alto elfo": 1, // Alto Elfo pode escolher 1 idioma extra
  "meio-elfo": 1, // Meio-elfo pode escolher 1 idioma extra
  // Outras raças não ganham escolhas por padrão
};

/// Idiomas automáticos que cada classe recebe
const Map<String, List<String>> classAutomaticLanguages = {
  "druida": ["Druídico"], // Druidas conhecem Druídico (idioma secreto)
  "bardo": [], // Bardos não ganham idiomas automáticos por padrão
  // Outras classes não ganham idiomas automáticos
};

/// Quantos idiomas extras cada classe pode escolher
const Map<String, int> classLanguageChoices = {
  "clérigo": 0, // Clérigos não ganham escolhas extras por padrão
  "druida": 0, // Druidas não ganham escolhas extras por padrão
  // Outras classes não ganham escolhas por padrão
};

/// Idiomas automáticos que cada antecedente recebe
const Map<String, List<String>> backgroundAutomaticLanguages = {
  "acólito": [],
  "artesão de guilda": [],
  "artista": [],
  "charlatão": [],
  "criminoso": [],
  "eremita": [], // Pode variar
  "forasteiro": [],
  "herói do povo": [],
  "marinheiro": [],
  "nobre": [],
  "soldado": [],
};

/// Quantos idiomas extras cada antecedente pode escolher
const Map<String, int> backgroundLanguageChoices = {
  "acólito": 2, // Acólitos podem escolher 2 idiomas adicionais
  "artesão de guilda": 1, // Artesãos podem escolher 1 idioma
  "eremita": 1, // Eremitas podem escolher 1 idioma
  "forasteiro": 1, // Forasteiros podem escolher 1 idioma
  "nobre": 1, // Nobres podem escolher 1 idioma
  "sábio": 2, // Sábios podem escolher 2 idiomas
  // Outros antecedentes podem não ter escolhas
};

/// Função para obter idiomas válidos para escolha (exclui os já conhecidos)
List<String> getAvailableLanguageChoices(List<String> knownLanguages) {
  return availableLanguages
      .where((language) => !knownLanguages.contains(language))
      .toList();
}

/// Função para calcular todos os idiomas automáticos baseado em raça, classe e antecedente
List<String> calculateAutomaticLanguages(String race, String characterClass, String background) {
  Set<String> languages = {};
  
  // Normaliza as entradas para minúsculas
  final normalizedRace = race.toLowerCase();
  final normalizedClass = characterClass.toLowerCase();
  final normalizedBackground = background.toLowerCase();
  
  // Adiciona idiomas da raça
  languages.addAll(raceAutomaticLanguages[normalizedRace] ?? []);
  
  // Adiciona idiomas da classe
  languages.addAll(classAutomaticLanguages[normalizedClass] ?? []);
  
  // Adiciona idiomas do antecedente
  languages.addAll(backgroundAutomaticLanguages[normalizedBackground] ?? []);
  
  return languages.toList();
}

/// Função para calcular quantos idiomas extras podem ser escolhidos
int calculateTotalLanguageChoices(String race, String characterClass, String background) {
  int total = 0;
  
  // Normaliza as entradas para minúsculas
  final normalizedRace = race.toLowerCase();
  final normalizedClass = characterClass.toLowerCase();
  final normalizedBackground = background.toLowerCase();
  
  total += raceLanguageChoices[normalizedRace] ?? 0;
  total += classLanguageChoices[normalizedClass] ?? 0;
  total += backgroundLanguageChoices[normalizedBackground] ?? 0;
  
  return total;
}

/// Estrutura para representar o resultado do cálculo de idiomas
class LanguageResult {
  final List<String> automaticLanguages;
  final int additionalChoices;
  final List<String> selectedAdditional;
  
  LanguageResult({
    required this.automaticLanguages,
    required this.additionalChoices,
    this.selectedAdditional = const [],
  });
  
  /// Retorna todos os idiomas (automáticos + escolhidos)
  List<String> get allLanguages {
    Set<String> all = {};
    all.addAll(automaticLanguages);
    all.addAll(selectedAdditional);
    return all.toList()..sort();
  }
}