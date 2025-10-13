// lib/data/starting_equipment_data.dart

import '../models/starting_equipment.dart';

/// Dados de equipamentos iniciais para todas as classes de D&D 5e
final Map<String, StartingEquipment> classStartingEquipment = {
  "Bárbaro": StartingEquipment(
    className: "Bárbaro",
    choices: [
      EquipmentChoice(
        optionA: "Um machado grande",
        optionB: "Qualquer arma marcial corpo a corpo",
        description: "Escolha sua arma principal",
      ),
      EquipmentChoice(
        optionA: "Duas machadinhas",
        optionB: "Qualquer arma simples",
        description: "Escolha suas armas secundárias",
      ),
    ],
    fixedItems: [
      FixedEquipment(
        item: "Um pacote de aventureiro e quatro azagaias",
        description: "Equipamento básico de exploração e armas de arremesso",
      ),
    ],
  ),

  "Bardo": StartingEquipment(
    className: "Bardo",
    choices: [
      EquipmentChoice(
        optionA: "Uma espada longa, rapieira",
        optionB: "Qualquer arma simples",
        description: "Escolha sua arma principal",
      ),
      EquipmentChoice(
        optionA: "Pacote de diplomata",
        optionB: "Pacote de artista",
        description: "Escolha seu conjunto de equipamentos",
      ),
    ],
    fixedItems: [
      FixedEquipment(
        item: "Um instrumento musical à escolha",
        description: "Instrumento para performances e magia",
      ),
      FixedEquipment(
        item: "Armadura de couro e adaga",
        description: "Proteção básica e arma de backup",
      ),
    ],
  ),

  "Clérigo": StartingEquipment(
    className: "Clérigo",
    choices: [
      EquipmentChoice(
        optionA: "Maça",
        optionB: "Martelo de guerra (se tiver proficiência)",
        description: "Escolha sua arma corpo a corpo",
      ),
      EquipmentChoice(
        optionA: "Cota de malha",
        optionB: "Armadura de couro e escudo",
        description: "Escolha sua proteção",
      ),
      EquipmentChoice(
        optionA: "Besta leve e 20 virotes",
        optionB: "Arma simples",
        description: "Escolha sua arma à distância",
      ),
      EquipmentChoice(
        optionA: "Pacote de sacerdote",
        optionB: "Pacote de explorador",
        description: "Escolha seu conjunto de equipamentos",
      ),
    ],
    fixedItems: [
      FixedEquipment(
        item: "Símbolo sagrado",
        description: "Foco divino para canalizar magia",
      ),
    ],
  ),

  "Druida": StartingEquipment(
    className: "Druida",
    choices: [
      EquipmentChoice(
        optionA: "Escudo de madeira",
        optionB: "Qualquer arma simples",
        description: "Escolha proteção ou arma adicional",
      ),
      EquipmentChoice(
        optionA: "Cimitarra",
        optionB: "Qualquer arma corpo a corpo simples",
        description: "Escolha sua arma corpo a corpo",
      ),
    ],
    fixedItems: [
      FixedEquipment(
        item: "Pacote de explorador e foco druídico (ex: totem, graveto, colar)",
        description: "Equipamento de exploração e foco natural",
      ),
    ],
  ),

  "Guerreiro": StartingEquipment(
    className: "Guerreiro",
    choices: [
      EquipmentChoice(
        optionA: "Cota de malha",
        optionB: "Armadura de couro, arco longo e 20 flechas",
        description: "Escolha entre proteção pesada ou mobilidade com arco",
      ),
      EquipmentChoice(
        optionA: "Arma marcial e escudo",
        optionB: "Duas armas marciais",
        description: "Escolha seu estilo de combate",
      ),
      EquipmentChoice(
        optionA: "Pacote de aventureiro",
        optionB: "Pacote de explorador",
        description: "Escolha seu conjunto de equipamentos",
      ),
    ],
    fixedItems: [],
  ),

  "Monge": StartingEquipment(
    className: "Monge",
    choices: [
      EquipmentChoice(
        optionA: "Espada curta",
        optionB: "Qualquer arma simples",
        description: "Escolha sua arma",
      ),
      EquipmentChoice(
        optionA: "Pacote de aventureiro",
        optionB: "Pacote de explorador",
        description: "Escolha seu conjunto de equipamentos",
      ),
    ],
    fixedItems: [
      FixedEquipment(
        item: "10 dardos",
        description: "Armas de arremesso para combate à distância",
      ),
    ],
  ),

  "Paladino": StartingEquipment(
    className: "Paladino",
    choices: [
      EquipmentChoice(
        optionA: "Arma marcial e escudo",
        optionB: "Duas armas marciais",
        description: "Escolha seu estilo de combate",
      ),
      EquipmentChoice(
        optionA: "Cinco azagaias",
        optionB: "Qualquer arma simples corpo a corpo",
        description: "Escolha armas de arremesso ou corpo a corpo",
      ),
      EquipmentChoice(
        optionA: "Pacote de sacerdote",
        optionB: "Pacote de aventureiro",
        description: "Escolha seu conjunto de equipamentos",
      ),
    ],
    fixedItems: [
      FixedEquipment(
        item: "Cota de malha e símbolo sagrado",
        description: "Armadura e foco divino",
      ),
    ],
  ),

  "Patrulheiro": StartingEquipment(
    className: "Patrulheiro",
    choices: [
      EquipmentChoice(
        optionA: "Escala de escamas",
        optionB: "Armadura de couro",
        description: "Escolha sua armadura",
      ),
      EquipmentChoice(
        optionA: "Duas espadas curtas",
        optionB: "Duas armas simples corpo a corpo",
        description: "Escolha suas armas corpo a corpo",
      ),
      EquipmentChoice(
        optionA: "Pacote de explorador",
        optionB: "Pacote de aventureiro",
        description: "Escolha seu conjunto de equipamentos",
      ),
    ],
    fixedItems: [
      FixedEquipment(
        item: "Arco longo e 20 flechas",
        description: "Arma à distância principal",
      ),
    ],
  ),

  "Ladino": StartingEquipment(
    className: "Ladino",
    choices: [
      EquipmentChoice(
        optionA: "Rapieira",
        optionB: "Espada curta",
        description: "Escolha sua arma principal",
      ),
      EquipmentChoice(
        optionA: "Arco curto e 20 flechas",
        optionB: "Espada curta",
        description: "Escolha arma à distância ou segunda espada",
      ),
      EquipmentChoice(
        optionA: "Pacote de assaltante",
        optionB: "Pacote de aventureiro",
        description: "Escolha seu conjunto de equipamentos",
      ),
    ],
    fixedItems: [
      FixedEquipment(
        item: "Armadura de couro, duas adagas e ferramentas de ladrão",
        description: "Proteção básica, armas de backup e ferramentas",
      ),
    ],
  ),

  "Feiticeiro": StartingEquipment(
    className: "Feiticeiro",
    choices: [
      EquipmentChoice(
        optionA: "Besta leve e 20 virotes",
        optionB: "Qualquer arma simples",
        description: "Escolha sua arma",
      ),
      EquipmentChoice(
        optionA: "Pacote de explorador",
        optionB: "Pacote de componente arcano",
        description: "Escolha seu conjunto de equipamentos",
      ),
      EquipmentChoice(
        optionA: "Foco arcano",
        optionB: "Bolsa de componentes",
        description: "Escolha seu foco de conjuração",
      ),
    ],
    fixedItems: [
      FixedEquipment(
        item: "Duas adagas",
        description: "Armas de backup simples",
      ),
    ],
  ),

  "Bruxo": StartingEquipment(
    className: "Bruxo",
    choices: [
      EquipmentChoice(
        optionA: "Arma simples corpo a corpo",
        optionB: "Arma simples à distância",
        description: "Escolha seu tipo de arma",
      ),
      EquipmentChoice(
        optionA: "Pacote de estudioso",
        optionB: "Pacote de explorador",
        description: "Escolha seu conjunto de equipamentos",
      ),
      EquipmentChoice(
        optionA: "Foco arcano",
        optionB: "Bolsa de componentes",
        description: "Escolha seu foco de conjuração",
      ),
    ],
    fixedItems: [
      FixedEquipment(
        item: "Armadura de couro, qualquer arma simples e duas adagas",
        description: "Proteção básica e arsenal de backup",
      ),
    ],
  ),

  "Mago": StartingEquipment(
    className: "Mago",
    choices: [
      EquipmentChoice(
        optionA: "Besta leve e 20 virotes",
        optionB: "Cajado arcano",
        description: "Escolha sua arma",
      ),
      EquipmentChoice(
        optionA: "Bolsa de componentes",
        optionB: "Foco arcano",
        description: "Escolha seu foco de conjuração",
      ),
      EquipmentChoice(
        optionA: "Pacote de estudioso",
        optionB: "Pacote de explorador",
        description: "Escolha seu conjunto de equipamentos",
      ),
    ],
    fixedItems: [
      FixedEquipment(
        item: "Livro de magias",
        description: "Grimório com suas magias conhecidas",
      ),
    ],
  ),
};

/// Obtém os equipamentos iniciais para uma classe específica
StartingEquipment? getStartingEquipmentForClass(String className) {
  return classStartingEquipment[className];
}

/// Lista todas as classes disponíveis
List<String> getAvailableClasses() {
  return classStartingEquipment.keys.toList();
}