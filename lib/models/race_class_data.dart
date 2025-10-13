// lib/models/race_class_data.dart

import 'equipment_item.dart';

// ----------------------------------------------------------------------
// 1. LISTAS DE OPÇÕES
// ----------------------------------------------------------------------
// NOTA: Listas básicas removidas - funcionalidade implementada 
// nos sistemas especializados (languages_data.dart, etc.)

// ----------------------------------------------------------------------
// 2. DADOS DE RAÇAS E CLASSES
// ----------------------------------------------------------------------
// NOTA: Os idiomas agora são gerenciados pelo sistema em /data/languages_data.dart

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

// Ouro Inicial por Antecedente
final Map<String, int> backgroundInitialGold = {
  "Acólito": 15,
  "Artista": 15,
  "Artesão da Guilda": 15,
  "Charlatão": 15,
  "Criminoso": 15,
  "Eremita": 5,
  "Forasteiro": 10,
  "Herói do Povo": 10,
  "Marinheiro": 10,
  "Nobre": 25,
  "Órfão": 10,
  "Sábio": 10,
  "Soldado": 10,
};

/// Calcula o ouro inicial baseado no antecedente escolhido
int getInitialGoldByBackground(String background) {
  return backgroundInitialGold[background] ?? 10; // valor padrão de 10 moedas
}

// Equipamentos Iniciais por Antecedente
final Map<String, List<EquipmentItem>> backgroundInitialEquipment = {
  "Acólito": [
    EquipmentItem(
      name: "Símbolo Sagrado",
      description: "Um símbolo religioso usado para canalizar poder divino",
      category: "Item Religioso",
    ),
    EquipmentItem(
      name: "Livro de Orações",
      description: "Livro contendo orações e rituais da sua fé",
      category: "Item Religioso",
    ),
    EquipmentItem(
      name: "Kit de Incenso",
      description: "Incensos aromáticos para cerimônias religiosas",
      category: "Item Religioso",
      quantity: 5,
    ),
  ],
  "Artista": [
    EquipmentItem(
      name: "Instrumento Musical",
      description: "Um instrumento musical de sua escolha (alaúde, flauta, tambor, etc.)",
      category: "Instrumento",
    ),
    EquipmentItem(
      name: "Carta de Favor",
      description: "Carta de um admirador influente",
      category: "Documento",
    ),
    EquipmentItem(
      name: "Trajes de Apresentação",
      description: "Roupas coloridas e chamativas para performances",
      category: "Vestimenta",
    ),
  ],
  "Artesão da Guilda": [
    EquipmentItem(
      name: "Ferramentas de Artesão",
      description: "Conjunto de ferramentas específicas do seu ofício",
      category: "Ferramenta",
    ),
    EquipmentItem(
      name: "Carta de Apresentação da Guilda",
      description: "Documento oficial da guilda atestando sua qualificação",
      category: "Documento",
    ),
    EquipmentItem(
      name: "Avental de Trabalho",
      description: "Avental resistente usado durante o trabalho",
      category: "Vestimenta",
    ),
  ],
  "Charlatão": [
    EquipmentItem(
      name: "Kit de Falsificação",
      description: "Ferramentas para criar documentos falsos",
      category: "Ferramenta",
    ),
    EquipmentItem(
      name: "Cartas Marcadas",
      description: "Baralho de cartas com marcações secretas",
      category: "Item de Jogo",
    ),
    EquipmentItem(
      name: "Anel de Sinete Falso",
      description: "Anel com brasão falso para se passar por nobre",
      category: "Acessório",
    ),
  ],
  "Criminoso": [
    EquipmentItem(
      name: "Ferramentas de Ladrão",
      description: "Kit completo para arrombar fechaduras e desarmar armadilhas",
      category: "Ferramenta",
    ),
    EquipmentItem(
      name: "Pé de Cabra",
      description: "Ferramenta útil para forçar entradas",
      category: "Ferramenta",
    ),
    EquipmentItem(
      name: "Capuz Negro",
      description: "Capuz escuro para ocultar identidade",
      category: "Vestimenta",
    ),
  ],
  "Eremita": [
    EquipmentItem(
      name: "Kit de Herbalismo",
      description: "Coleção de ervas medicinais e equipamentos para prepará-las",
      category: "Ferramenta",
    ),
    EquipmentItem(
      name: "Pergaminho de Descoberta",
      description: "Anotações sobre sua grande descoberta",
      category: "Documento",
    ),
    EquipmentItem(
      name: "Manta de Meditação",
      description: "Manta simples usada durante meditação",
      category: "Item Pessoal",
    ),
  ],
  "Forasteiro": [
    EquipmentItem(
      name: "Kit de Explorador",
      description: "Equipamentos essenciais para sobrevivência selvagem",
      category: "Ferramenta",
    ),
    EquipmentItem(
      name: "Mapa Regional",
      description: "Mapa detalhado da região que você conhece",
      category: "Documento",
    ),
    EquipmentItem(
      name: "Corda de Cânhamo",
      description: "50 pés de corda resistente",
      category: "Equipamento",
    ),
  ],
  "Herói do Povo": [
    EquipmentItem(
      name: "Distintivo do Herói",
      description: "Símbolo que comprova seus feitos heroicos",
      category: "Acessório",
    ),
    EquipmentItem(
      name: "Carta de Recomendação",
      description: "Carta de pessoas importantes que apoiam você",
      category: "Documento",
    ),
    EquipmentItem(
      name: "Manto do Herói",
      description: "Manto simples mas dignificante",
      category: "Vestimenta",
    ),
  ],
  "Marinheiro": [
    EquipmentItem(
      name: "Kit de Navegação",
      description: "Instrumentos náuticos para navegação",
      category: "Ferramenta",
    ),
    EquipmentItem(
      name: "Corda Naval",
      description: "50 pés de corda naval resistente à água",
      category: "Equipamento",
    ),
    EquipmentItem(
      name: "Cantil de Rum",
      description: "Cantil de metal com rum de boa qualidade",
      category: "Item Pessoal",
    ),
  ],
  "Nobre": [
    EquipmentItem(
      name: "Anel de Sinete",
      description: "Anel com o brasão de sua família nobre",
      category: "Acessório",
    ),
    EquipmentItem(
      name: "Pergaminho de Linhagem",
      description: "Documento comprovando sua ascendência nobre",
      category: "Documento",
    ),
    EquipmentItem(
      name: "Roupas Finas",
      description: "Vestuário elegante de alta qualidade",
      category: "Vestimenta",
    ),
  ],
  "Órfão": [
    EquipmentItem(
      name: "Kit de Sobrevivência Urbana",
      description: "Ferramentas improvisadas para sobreviver nas ruas",
      category: "Ferramenta",
    ),
    EquipmentItem(
      name: "Amuleto da Sorte",
      description: "Pequeno amuleto que você acredita trazer sorte",
      category: "Item Pessoal",
    ),
    EquipmentItem(
      name: "Mochila Remendada",
      description: "Mochila velha mas funcional",
      category: "Equipamento",
    ),
  ],
  "Sábio": [
    EquipmentItem(
      name: "Frascos de Tinta e Pena",
      description: "Material para escrever e fazer anotações",
      category: "Ferramenta",
    ),
    EquipmentItem(
      name: "Livro de Anotações",
      description: "Livro em branco para registrar descobertas",
      category: "Documento",
    ),
    EquipmentItem(
      name: "Lupa",
      description: "Lente de aumento para estudos detalhados",
      category: "Ferramenta",
    ),
  ],
  "Soldado": [
    EquipmentItem(
      name: "Insígnia Militar",
      description: "Distintivo que comprova seu serviço militar",
      category: "Acessório",
    ),
    EquipmentItem(
      name: "Baralho Militar",
      description: "Cartas de jogo usadas para entretenimento nos acampamentos",
      category: "Item de Jogo",
    ),
    EquipmentItem(
      name: "Kit de Manutenção de Armas",
      description: "Ferramentas básicas para manter armas em bom estado",
      category: "Ferramenta",
    ),
  ],
};

/// Calcula os equipamentos iniciais baseados no antecedente escolhido
List<EquipmentItem> getInitialEquipmentByBackground(String background) {
  return backgroundInitialEquipment[background]?.map((item) => 
    EquipmentItem(
      name: item.name,
      description: item.description,
      category: item.category,
      quantity: item.quantity,
    )).toList() ?? [];
}

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