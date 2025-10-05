class RaceFeature {
  final String raca;
  final String nome;
  final String descricao;
  final Map<String, int> bonusAtributos; // Ex: {"Força": 2, "Carisma": 1}

  const RaceFeature({
    required this.raca,
    required this.nome,
    required this.descricao,
    this.bonusAtributos = const {},
  });
}

const List<RaceFeature> raceFeatures = [
  // ------------------------
  // Anão
  // ------------------------
  RaceFeature(
    raca: "Anão",
    nome: "Constituição +2",
    descricao: "Anões são resistentes.",
    bonusAtributos: {"Constituição": 2},
  ),
  RaceFeature(
    raca: "Anão",
    nome: "Visão no Escuro",
    descricao:
        "Você pode enxergar no escuro até 18 metros como se fosse na luz fraca.",
  ),
  RaceFeature(
    raca: "Anão",
    nome: "Resiliência Anã",
    descricao:
        "Você tem vantagem contra veneno e resistência a dano de veneno.",
  ),

  // ------------------------
  // Elfo
  // ------------------------
  RaceFeature(
    raca: "Elfo",
    nome: "Destreza +2",
    descricao: "Elfos são ágeis.",
    bonusAtributos: {"Destreza": 2},
  ),
  RaceFeature(
    raca: "Elfo",
    nome: "Visão no Escuro",
    descricao: "Enxergam no escuro até 18 metros.",
  ),
  RaceFeature(
    raca: "Elfo",
    nome: "Sentidos Aguçados",
    descricao: "Proficiência na perícia Percepção.",
  ),

  // ------------------------
  // Humano
  // ------------------------
  RaceFeature(
    raca: "Humano",
    nome: "Versatilidade",
    descricao: "Todos os atributos recebem +1.",
    bonusAtributos: {
      "Força": 1,
      "Destreza": 1,
      "Constituição": 1,
      "Inteligência": 1,
      "Sabedoria": 1,
      "Carisma": 1,
    },
  ),

  // ------------------------
  // Halfling
  // ------------------------
  RaceFeature(
    raca: "Halfling",
    nome: "Destreza +2",
    descricao: "Halflings são rápidos.",
    bonusAtributos: {"Destreza": 2},
  ),
  RaceFeature(
    raca: "Halfling",
    nome: "Sortudo",
    descricao:
        "Quando rolar um 1 em um d20, você pode rerrolar o dado e deve usar o novo resultado.",
  ),

  // ------------------------
  // Draconato
  // ------------------------
  RaceFeature(
    raca: "Draconato",
    nome: "Força +2, Carisma +1",
    descricao: "Os draconatos são fortes e carismáticos.",
    bonusAtributos: {"Força": 2, "Carisma": 1},
  ),
  RaceFeature(
    raca: "Draconato",
    nome: "Sopro Dracônico",
    descricao:
        "Uma vez por descanso pode fazer um sopro que causa 2d6 (resistência de DES metade, CD 8 + Proficiência + CON). Esse dano aumenta em 1d6 aos níveis 6, 11 e 16.",
  ),
  // ------------------------
// Gnomo
// ------------------------
RaceFeature(
  raca: "Gnomo",
  nome: "Inteligência +2",
  descricao: "Gnomos são inventivos.",
  bonusAtributos: {"Inteligência": 2},
),
RaceFeature(
  raca: "Gnomo",
  nome: "Visão no Escuro",
  descricao: "Enxergam no escuro até 18 metros.",
),
RaceFeature(
  raca: "Gnomo",
  nome: "Astúcia de Gnomo",
  descricao:
      "Você tem vantagem em testes de resistência de Inteligência, Sabedoria e Carisma contra magia.",
),

// ------------------------
// Meio-Elfo
// ------------------------
RaceFeature(
  raca: "Meio-Elfo",
  nome: "Carisma +2",
  descricao: "Meio-elfos são charmosos.",
  bonusAtributos: {"Carisma": 2},
),
RaceFeature(
  raca: "Meio-Elfo",
  nome: "Aumento Variável",
  descricao:
      "Você aumenta dois outros atributos à sua escolha em +1 (além do Carisma).",
  // O bônus real de +1/+1 deve ser aplicado no código da ficha, se necessário.
  // Aqui, colocamos apenas o bônus fixo para simplificar.
),
RaceFeature(
  raca: "Meio-Elfo",
  nome: "Visão no Escuro",
  descricao: "Enxergam no escuro até 18 metros.",
),
RaceFeature(
  raca: "Meio-Elfo",
  nome: "Ancestral Feérico",
  descricao: "Você tem vantagem em testes de resistência para evitar ser Enfeitiçado e não pode ser magicamente Adormecido.",
),

// ------------------------
// Meio-Orc
// ------------------------
RaceFeature(
  raca: "Meio-Orc",
  nome: "Força +2, Constituição +1",
  descricao: "Meio-Orcs são fortes e resistentes.",
  bonusAtributos: {"Força": 2, "Constituição": 1},
),
RaceFeature(
  raca: "Meio-Orc",
  nome: "Visão no Escuro",
  descricao: "Enxergam no escuro até 18 metros.",
),
RaceFeature(
  raca: "Meio-Orc",
  nome: "Ameaçador",
  descricao: "Proficiência na perícia Intimidação.",
),
RaceFeature(
  raca: "Meio-Orc",
  nome: "Resistência Implacável",
  descricao:
      "Se você for reduzido a 0 PV, mas não morto, pode cair para 1 PV uma vez por descanso longo.",
),

// ------------------------
// Tiefling
// ------------------------
RaceFeature(
  raca: "Tiefling",
  nome: "Carisma +2, Inteligência +1",
  descricao: "Tieflings são carismáticos e astutos.",
  bonusAtributos: {"Carisma": 2, "Inteligência": 1},
),
RaceFeature(
  raca: "Tiefling",
  nome: "Visão no Escuro",
  descricao: "Enxergam no escuro até 18 metros.",
),
RaceFeature(
  raca: "Tiefling",
  nome: "Resistência Infernal",
  descricao: "Você tem resistência a dano de fogo.",
),
RaceFeature(
  raca: "Tiefling",
  nome: "Herança Infernal",
  descricao: "Conhece o Truque 'Taumaturgia' e ganha magias adicionais com o avanço de nível.",
),
];
