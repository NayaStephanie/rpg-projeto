// lib/models/race_class_data.dart

// ----------------------------------------------------------------------
// 1. LISTAS DE OPÇÕES
// ----------------------------------------------------------------------

final List<String> availableRaces = [
  "Humano",
  "Elfo",
  "Draconato",
  "Anão", // Adicionando mais opções de raça
  "Tiefling",
  "Halfling",
  "Gnomo",
  "Meio-Elfo",
  "Meio-Orc",
];

final List<String> availableClasses = [
  "Bárbaro",
  "Bardo",
  "Clérigo",
  "Druida",
  "Guerreiro",
  "Monge",
  "Paladino",
  "Patrulheiro",
  "Ladino",
  "Feiticeiro",
  "Bruxo",
  "Mago",
];

final List<String> availableBackgrounds = [
  "Artista",
  "Artesão da Guilda",
  "Acólito",
  "Eremita",
  "Criminoso",
  "Charlatão",
  "Marinheiro",
  "Herói do Povo",
  "Forasteiro",
  "Sábio",
  "Órfão",
  "Nobre",
  "Soldado",
];

// ----------------------------------------------------------------------
// 2. DADOS DE RAÇAS E CLASSES
// ----------------------------------------------------------------------

// Idiomas por Raça
final Map<String, List<String>> raceLanguages = {
  "Humano": ["Comum", "Um idioma adicional à escolha"],
  "Elfo": ["Comum", "Élfico"],
  "Draconato": ["Comum", "Dracônico"],
  "Anão": ["Comum", "Anão"],
  "Tiefling": ["Comum", "Infernal"],
  "Gnomo": ["Comum", "Gnômico"],
  "Halfling": ["Comum", "Halfling"],
  "Meio-Elfo": ["Comum", "Élfico", "Um idioma adicional à escolha"],
  "Meio-Orc": ["Comum", "Orc"],
};

// Características por Raça
final Map<String, List<String>> raceFeatures = {
  "Humano": ["Deslocamento: 9m", "Aumento de Habilidade"],
  "Elfo": ["Deslocamento: 9m", "Ancestral Feérico: vantagem contra ser enfeitiçado, imune a magias de sono.", "Transe: não dorme, mas medita por 4 horas."],
  "Draconato": ["Deslocamento: 9m", "Resistência Dracônica", "Ancestralidade Dracônica: escolha um ancestral. Suas escamas são dessa cor, sua resistência e sopro são de acordo com o elemento"],
  "Anão": ["Deslocamento: 7,5m", "Deslocamento não é reduzido por armadura"],
  "Tiefling": ["Deslocamento: 9m", "Resistência ao Fogo", "Herança Infernal"],
  "Gnomo": ["Deslocamento: 7,5m", "Resistência a Magia", "Engenhosidade Gnômica"],
  "Halfling": ["Deslocamento: 7,5m", "Sorte Halfling", "Coragem: vantagem contra medo"],
  "Meio-Elfo": ["Deslocamento: 9m", "Ancestral Feérico", "Visão no Escuro"],
  "Meio-Orc": ["Deslocamento: 9m", "Visão no Escuro", "Ameaçador", "Resistência Implacável"],
};

// Proficiências por Classe
final Map<String, List<String>> classProficiencies = {
  "Bárbaro": ["Armaduras Leves e Médias", "Escudos", "Armas Simples e Marciais"],
  "Bardo": ["Armaduras Leves", "Armas Simples", "Bestas de Mão", "Sabres"],
  "Clérigo": ["Armaduras Leves e Médias", "Escudos", "Armas Simples"], // Pode variar por domínio
  "Druida": ["Armaduras Leves e Médias", "Escudos", "Cajados", "Maças", "Cimitarras"],
  "Guerreiro": ["Todas as Armaduras e Escudos", "Todas as Armas"],
  "Monge": ["Armas Simples", "Espadas Curtas"],
  "Paladino": ["Armaduras Leves, Médias e Pesadas", "Escudos", "Armas Marciais"],
  "Patrulheiro": ["Armaduras Leves e Médias", "Escudos", "Armas Simples e Marciais"],
  "Ladino": ["Armaduras Leves", "Armas Simples", "Besta de Mão", "Espadas Longas", "Rapieiras"],
  "Feiticeiro": ["Adagas", "Bordões", "Dardos", "Fundas", "Bestas Leves"],
  "Bruxo": ["Armaduras Leves", "Armas Simples"],
  "Mago": ["Adagas", "Bordões", "Dardos", "Fundas", "Bestas Leves"],
};

// Ataques Iniciais por Classe (Focando em um ataque primário)
final Map<String, List<Map<String, String>>> classAttacks = {
  "Bárbaro": [
    {"name": "Machado Grande", "bonus": "+5", "damage": "1d12+3 / Cort"},
  ],
  "Bardo": [
    {"name": "Rapieira", "bonus": "+3", "damage": "1d8+1 / Perf"},
  ],
  "Clérigo": [
    {"name": "Maça", "bonus": "+2", "damage": "1d6+1 / Con"},
  ],
  "Druida": [
    {"name": "Cimitarra", "bonus": "+2", "damage": "1d6+1 / Cort"},
    {"name": "Chuva de Espinhos", "bonus": "+4", "damage": "1d8 / Perf"},
  ],
  "Guerreiro": [
    {"name": "Espada Longa", "bonus": "+5", "damage": "1d8+3 / Cort"},
  ],
  "Monge": [
    {"name": "Ataque Desarmado", "bonus": "+3", "damage": "1d4+2 / Con"},
    {"name": "Dardo", "bonus": "+5", "damage": "1d4+3 / Perf"},
  ],
  "Paladino": [
    {"name": "Espada Longa", "bonus": "+5", "damage": "1d8+3 / Cort"},
    {"name": "Javalina", "bonus": "+5", "damage": "1d6+3 / Perf"},
  ],
  "Patrulheiro": [
    {"name": "Arco Curto", "bonus": "+5", "damage": "1d6+3 / Perf"},
  ],
  "Ladino": [
    {"name": "Rapieira", "bonus": "+5", "damage": "1d8+3 / Perf"},
    {"name": "Besta de Mão", "bonus": "+5", "damage": "1d6+3 / Perf"},
  ],
  "Feiticeiro": [
    {"name": "Adaga", "bonus": "+2", "damage": "1d4-1 / Perf"},
    {"name": "Raio de Fogo", "bonus": "+5", "damage": "1d10 / Fogo"},
  ],
  "Bruxo": [
    {"name": "Explosão Sobrenatural", "bonus": "+5", "damage": "1d10 / Força"},
  ],
  "Mago": [
    {"name": "Adaga", "bonus": "+2", "damage": "1d4-1 / Perf"},
    {"name": "Raio de Fogo", "bonus": "+5", "damage": "1d10 / Fogo"},
  ],
};