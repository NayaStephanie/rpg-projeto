class ClassFeature {
  final String classe;
  final int nivel;
  final String nome;
  final String descricao;

  const ClassFeature({
    required this.classe,
    required this.nivel,
    required this.nome,
    required this.descricao,
  });
}

const List<ClassFeature> classFeatures = [
  // ------------------------
  // Bárbaro
  // ------------------------
  ClassFeature(
    classe: "Bárbaro",
    nivel: 1,
    nome: "Fúria (dano +2)",
    descricao:
        "Enquanto em fúria, você recebe vantagem em testes de Força, "
        "causa dano extra em ataques corpo a corpo e sofre menos dano de armas.",
  ),
  ClassFeature(
    classe: "Bárbaro",
    nivel: 1,
    nome: "Defesa sem Armadura (dano +2)",
    descricao:
        "Enquanto não estiver usando armadura, sua CA é 10 + Modificador de Destreza + Modificador de Constituição. "
        "Você pode usar um escudo e ainda assim se beneficiar dessa característica.",
  ),
  ClassFeature(
    classe: "Bárbaro",
    nivel: 2,
    nome: "Sentido de Perigo (dano +2)",
    descricao:
        "Você tem vantagem em testes de resistência de Destreza contra "
        "efeitos que você possa ver, como armadilhas e magias.",
  ),
  ClassFeature(
    classe: "Bárbaro",
    nivel: 2,
    nome: "Ataque Descuidado (dano +2)",
    descricao:
        "Você pode decidir receber Vantagem  para seu primeiro ataque corpo-a-corpo baseado em FOR no turno, "
        "mas todos os oponentes receberão Vantagem para ataques contra você até o começo de seu próximo turno..",
  ),

  // ------------------------
  // Mago
  // ------------------------
  ClassFeature(
    classe: "Mago",
    nivel: 1,
    nome: "Truques",
    descricao:
        "Você conhece um número de truques (magias de nível 0) que pode "
        "conjurar à vontade.",
  ),
  ClassFeature(
    classe: "Mago",
    nivel: 2,
    nome: "Recuperação Arcana",
    descricao:
        "Uma vez por dia, durante um descanso curto, você pode recuperar "
        "espaços de magia gastos.",
  ),

  // ------------------------
  // Paladino
  // ------------------------
  ClassFeature(
    classe: "Paladino",
    nivel: 1,
    nome: "Sentido Divino",
    descricao:
        "Você pode detectar celestiais, ínferos e mortos-vivos até o próximo turno.",
  ),
  ClassFeature(
    classe: "Paladino",
    nivel: 2,
    nome: "Imposição das Mãos",
    descricao:
        "Você tem um pool de pontos de cura que pode gastar para curar ferimentos ou doenças.",
  ),

  // ------------------------
  // Ladino
  // ------------------------
  ClassFeature(
    classe: "Ladino",
    nivel: 1,
    nome: "Ataque Furtivo",
    descricao:
        "Uma vez por turno, você pode causar dano extra quando atingir "
        "com um ataque que tenha vantagem.",
  ),
  ClassFeature(
    classe: "Ladino",
    nivel: 2,
    nome: "Ação Ardilosa",
    descricao:
        "Você pode usar uma ação bônus em cada turno para Correr, Desengajar ou Esconder-se.",
  ),

// ------------------------
// Monge
// ------------------------
ClassFeature(
  classe: "Monge",
  nivel: 1,
  nome: "Defesa sem Armadura",
  descricao:
      "Sua CA é 10 + Modificador de Destreza + Modificador de Sabedoria quando não estiver usando armadura ou escudo.",
),
ClassFeature(
  classe: "Monge",
  nivel: 1,
  nome: "Artes Marciais",
  descricao:
      "Você pode realizar um ataque desarmado extra como ação bônus após atacar com uma arma de monge ou desarmado.",
),
ClassFeature(
  classe: "Monge",
  nivel: 2,
  nome: "Ki",
  descricao:
      "Você ganha um pool de pontos Ki que pode gastar para impulsionar suas habilidades de classe, como Ataque Turbilhão.",
),

// ------------------------
// Clérigo
// ------------------------
ClassFeature(
  classe: "Clérigo",
  nivel: 1,
  nome: "Conjuração",
  descricao:
      "Você pode conjurar magias de clérigo. Seu atributo de conjuração é Sabedoria.",
),
ClassFeature(
  classe: "Clérigo",
  nivel: 1,
  nome: "Domínio Divino",
  descricao:
      "Escolha um Domínio. Isso concede magias de Domínio e recursos específicos de Domínio.",
),
ClassFeature(
  classe: "Clérigo",
  nivel: 2,
  nome: "Canalizar Divindade",
  descricao:
      "Você pode usar ações que consomem o poder divino para efeitos específicos, determinados pelo seu Domínio.",
),

// ------------------------
// Bruxo
// ------------------------
ClassFeature(
  classe: "Bruxo",
  nivel: 1,
  nome: "Pacto e Feitiçaria",
  descricao:
      "Você conjura magias usando espaços de magia que se recuperam em um descanso curto.",
),
ClassFeature(
  classe: "Bruxo",
  nivel: 1,
  nome: "Patrono de Outro Mundo",
  descricao:
      "Escolha seu Patrono (Arquifada, Corruptor, Grande Antigo). Isso concede uma habilidade no Nível 1.",
),
ClassFeature(
  classe: "Bruxo",
  nivel: 2,
  nome: "Invocações Místicas",
  descricao:
      "Você ganha duas Invocações Místicas à sua escolha, melhorando suas magias e truques.",
),

// ------------------------
// Bardo
// ------------------------
ClassFeature(
  classe: "Bardo",
  nivel: 1,
  nome: "Inspiração de Bardo",
  descricao:
      "Você pode usar uma ação bônus para inspirar outra criatura, permitindo que ela adicione um d6 a um teste de habilidade, ataque ou resistência.",
),
ClassFeature(
  classe: "Bardo",
  nivel: 2,
  nome: "Restabelecimento",
  descricao:
      "Você pode gastar um uso de Inspiração de Bardo para ajudar a si ou a um aliado a ter sucesso em um teste.",
),
ClassFeature(
  classe: "Bardo",
  nivel: 2,
  nome: "Canalizar Divindade",
  descricao:
      "Você pode usar ações que consomem o poder divino para efeitos específicos, determinados pelo seu Domínio.",
),

// ------------------------
// Guerreiro
// ------------------------
ClassFeature(
  classe: "Guerreiro",
  nivel: 1,
  nome: "Estilo de Luta",
  descricao:
      "Escolha um estilo de luta que conceda um bônus constante, como +2 de CA ou +2 de dano em um tipo de ataque.",
),
ClassFeature(
  classe: "Guerreiro",
  nivel: 1,
  nome: "Recuperar o Fôlego",
  descricao:
      "Você pode usar uma ação bônus para se curar de uma quantidade de dano equivalente a 1d10 + Nível de Guerreiro.",
),
ClassFeature(
  classe: "Guerreiro",
  nivel: 2,
  nome: "Ação Adicional",
  descricao:
      "Você pode usar uma ação adicional em seu turno (uma vez por descanso curto).",
),

// ------------------------
// Feiticeiro
// ------------------------
ClassFeature(
  classe: "Feiticeiro",
  nivel: 1,
  nome: "Conjuração",
  descricao:
      "Você pode conjurar magias de feiticeiro. Seu atributo de conjuração é Carisma.",
),
ClassFeature(
  classe: "Feiticeiro",
  nivel: 1,
  nome: "Origem Sorcerous",
  descricao:
      "Escolha uma linhagem (Dracônica, Selvagem, etc.) que concede uma habilidade única no Nível 1.",
),
ClassFeature(
  classe: "Feiticeiro",
  nivel: 2,
  nome: "Pontos de Feitiçaria",
  descricao:
      "Você ganha pontos para criar ou alterar espaços de magia, ou usar Metamagia.",
),

// ------------------------
// Druida
// ------------------------
ClassFeature(
  classe: "Druida",
  nivel: 1,
  nome: "Druídico",
  descricao:
      "Você conhece a linguagem secreta druídica, que permite deixar mensagens escondidas.",
),
ClassFeature(
  classe: "Druida",
  nivel: 1,
  nome: "Conjuração",
  descricao:
      "Você pode conjurar magias de druida. Seu atributo de conjuração é Sabedoria.",
),
ClassFeature(
  classe: "Druida",
  nivel: 2,
  nome: "Forma Selvagem",
  descricao:
      "Você pode usar sua ação para se transformar em uma besta de ND específico (geralmente 1/4 ou 1/2) duas vezes por descanso.",
),

// ------------------------
// Patrulheiro
// ------------------------
ClassFeature(
  classe: "Patrulheiro",
  nivel: 1,
  nome: "Inimigo Predileto",
  descricao:
      "Você escolhe um tipo de criatura (p. ex., bestas, orcs). Você tem vantagem em testes de Sabedoria (Sobrevivência) para rastreá-los.",
),
ClassFeature(
  classe: "Patrulheiro",
  nivel: 1,
  nome: "Explorador Natural",
  descricao:
      "Escolha um tipo de terreno. Você é duplamente proficiente em testes de Inteligência e Sabedoria relacionados a esse terreno.",
),
ClassFeature(
  classe: "Patrulheiro",
  nivel: 2,
  nome: "Estilo de Luta",
  descricao:
      "Escolha um estilo de luta, como Arco e Flecha, que concede um bônus constante.",
),
];
