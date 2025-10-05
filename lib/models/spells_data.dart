// spells_data.dart
// Truques (nível 0) - ✅ Estrutura correta
const Map<String, List<String>> cantripsByClass = {
  "Mago": [
    "Raio de Fogo",
    "Zombaria Perversa", 
    "Proteção Contra Lâminas",
    "Raio de Gelo",
    "Toque Necrótico",
    // Adicione mais truques para completar
    "Mão do Mago",
    "Luz",
    "Prestidigitação",
  ],
  "Feiticeiro": [
    "Explosão Sobrenatural",
    "Mão do Mago",
    "Luz",
    // Feiticeiros compartilham muitos truques com Magos
    "Raio de Fogo",
    "Raio de Gelo",
    "Prestidigitação",
  ],
  "Clérigo": [
    "Orientação",
    "Chama Sagrada", 
    "Taumaturgia",
    "Luz",
    "Resistência",
    "Consertar",
  ],
  "Druida": [
    "Consertar",
    "Roda das Fadas", 
    "Produzir Chama",
    "Orientação",
    "Resistência",
    "Chicote de Espinhos",
  ],
  "Bardo": [
    "Zombaria Viciosa",
    "Luz",
    "Amizade", 
    "Mão do Mago",
    "Consertar",
    "Prestidigitação",
  ],
  "Bruxo": [
    "Rajada Mística",
    "Truque da Mão", // ⚠️ Verifique se é "Mão do Mago"
    "Luz",
    "Toque Necrótico",
    "Explosão Sobrenatural",
  ],
  // ⚠️ ADICIONE as classes que faltam:
  "Paladino": [], // Paladinos não têm truques
  "Patrulheiro": [], // Patrulheiros não têm truques  
};


// Quantidade de truques conhecidos por classe e nível
const Map<String, Map<int, int>> cantripsByLevel = {
  "Mago": {
    1: 3, 4: 4, 10: 5
  },
  "Feiticeiro": {
    1: 4, 4: 5, 10: 6
  },
  "Clérigo": {
    1: 3, 4: 4, 10: 5
  },
  "Druida": {
    1: 2, 4: 3, 10: 4
  },
  "Bardo": {
    1: 2, 4: 3, 10: 4
  },
  "Bruxo": {
    1: 2, 4: 3, 10: 4
  },
  "Paladino": {}, // Paladinos não têm truques
  "Patrulheiro": {}, // Patrulheiros não têm truques
};

// Magias por nível 
const Map<String, Map<int, List<String>>> spellsByClass = {
  "Mago": {
    1: ["Mísseis Mágicos", "Escudo Arcano", "Faca de Gelo", "Trovão", "Detectar Magia", "Compreender Idiomas"],
    2: ["Nublar", "Passo Nebuloso", "Espelho das Sombras", "Teia", "Invisibilidade"],
    3: ["Bola de Fogo", "Raio", "Voo", "Contrafeitiço"],
    4: ["Porta Dimensional", "Esfera Resiliente", "Pele de Pedra"],
    5: ["Cone Glacial", "Telecinese", "Parede de Pedra"],
    // Continue até o 9º nível para magos
  },
  "Clérigo": {
    1: ["Curar Ferimentos", "Bênção", "Escudo da Fé", "Detectar Magia", "Santuário"],
    2: ["Arma Espiritual", "Auxílio", "Restauração Menor", "Silêncio"],
    3: ["Revivificar", "Dissipar Magia", "Clarividência"],
    4: ["Guardião da Fé", "Liberdade de Movimento"],
    5: ["Curar Ferimentos em Massa", "Coluna de Chamas"],
    // Continue até o 9º nível
  },
  "Druida": {
    1: ["Enredar", "Boa Fruta", "Névoa Obscurecente", "Cura", "Falar com Animais"],
    2: ["Aprimorar Habilidade", "Pele de Árvore", "Raio Lunar", "Forma Selvagem Aprimorada"],
    3: ["Invocar Raios", "Crescer Plantas", "Curar Ferimentos em Massa"],
    // Continue conforme necessário
  },
  "Feiticeiro": {
    1: ["Raio das Bruxas", "Escudo", "Mísseis Mágicos", "Queimar Mãos"],
    2: ["Teia", "Força do Touro", "Espelho das Sombras"],
    3: ["Bola de Fogo", "Voo", "Haste"],
    // Continue até o 9º nível
  },
  "Bardo": {
    1: ["Encantar Pessoa", "Cura", "Sono", "Zombaria Viciosa", "Palavra de Cura"],
    2: ["Invisibilidade", "Sugestão", "Calor de Metal"],
    3: ["Contrafeitiço", "Hipnose", "Dissipar Magia"],
    // Continue até o 9º nível
  },
  "Bruxo": {
    1: ["Braços de Hadar", "Comando", "Proteção contra Bem e Mal", "Maldição"],
    2: ["Raio Escaldante", "Invisibilidade", "Sugestão"],
    3: ["Fome de Hadar", "Contrafeitiço", "Voo"],
    4: ["Dimensão da Porta", "Confusão"],
    5: ["Dominar Pessoa", "Muralha de Fogo"],
    // Bruxos vão até 5º nível
  },
 
  "Paladino": {
    1: ["Curar Ferimentos", "Detectar Bem e Mal", "Proteção contra Bem e Mal"],
    2: ["Auxiliar", "Localizar Objeto", "Zona da Verdade"],
    3: ["Revivificar", "Aura de Vitalidade", "Dissipar Magia"],
    4: ["Liberdade de Movimento", "Localizar Criatura"],
    5: ["Círculo de Poder", "Dissipar Bem e Mal"],
  },
  "Patrulheiro": {
    1: ["Marca do Caçador", "Cura", "Falar com Animais"],
    2: ["Passo Sem Pegadas", "Localizar Objeto", "Proteção contra Veneno"],
    3: ["Conjurar Animais", "Proteção contra Energia"],
    4: ["Liberdade de Movimento", "Localizar Criatura"],
    5: ["Comunhão com a Natureza", "Árvore"],
  },
};
