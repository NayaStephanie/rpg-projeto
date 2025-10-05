class ClassRule {
  final String nome;
  final String regra; 
  // "padrao" = 10 + DES
  // "monge" = 10 + DES + SAB
  // "barbaro" = 10 + DES + CON
  // "feiticeiro_draconico" = 13 + DES
  // pode expandir com outras regras depois

  const ClassRule({
    required this.nome,
    required this.regra,
  });
}

const List<ClassRule> regrasClasses = [
  ClassRule(nome: "Monge", regra: "monge"),
  ClassRule(nome: "Bárbaro", regra: "barbaro"),
  ClassRule(nome: "Feiticeiro", regra: "feiticeiro_draconico"),
  
  // Demais classes usam o cálculo padrão
  ClassRule(nome: "Mago", regra: "padrao"),
  ClassRule(nome: "Clérigo", regra: "padrao"),
  ClassRule(nome: "Bruxo", regra: "padrao"),
  ClassRule(nome: "Bardo", regra: "padrao"),
  ClassRule(nome: "Ladino", regra: "padrao"),
  ClassRule(nome: "Guerreiro", regra: "padrao"),
  ClassRule(nome: "Druida", regra: "padrao"),
  ClassRule(nome: "Patrulheiro", regra: "padrao"),
  ClassRule(nome: "Paladino", regra: "padrao"),
];
