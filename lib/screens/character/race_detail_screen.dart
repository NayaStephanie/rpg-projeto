// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_rpg/selection_manager.dart';

class RaceDetailScreen extends StatelessWidget {
  const RaceDetailScreen({super.key});

  // Descrições originais adaptadas de D&D 5e
  static final Map<String, String> raceDescriptions = {
    "Meio-Elfo":
        "Filhos de dois mundos, os meio-elfos combinam a adaptabilidade humana com a graça élfica. Costumam ser diplomáticos e versáteis, com facilidade para se encaixar em diferentes papéis.\n\n"
        "Atributos aprimorados: +2 em Carisma e +1 em duas outras habilidades de sua escolha.\n\n"
        "Deslocamento: 9 metros por rodada.\n\n"
        "Idade: adultos aos 15 anos e vivem até 180 anos.\n\n"
        "Tamanho e peso: entre 1,50m e 1,80m, peso médio 65kg.\n\n"
        "Visão no escuro: até 18 metros em tons de cinza.\n\n"
        "Herança feérica: vantagem contra encantamentos e imunidade a sono mágico.\n\n"
        "Versatilidade de talentos: proficiência em duas perícias extras.\n\n"
        "Idiomas: comum, élfico e mais um idioma à sua escolha.",
    //Elfo tem três sub-raças, Drow, Alto Elfo e Elfo da Floresta, sendo que os dois primeiros ganham magia com nivel
    "Elfo":
        "Elfos são conhecidos por sua longevidade, visão aguçada e forte conexão com a magia. Valorizam a arte e a natureza, sendo rápidos e atentos em qualquer ambiente.\n\n"
        "Graça élfica: +2 em Destreza.\n\n"
        "Deslocamento: 9 metros por rodada.\n\n"
        "Idade: adultos por volta dos 100 anos e vivem até cerca de 750 anos.\n\n"
        "Tamanho e peso: entre 1,50m e 1,80m, peso diverso.\n\n"
        "Visão no escuro: enxergam até 18 metros na penumbra ou escuridão.\n\n"
        "Tradição feérica: vantagem contra encantamentos e imunidade a efeitos mágicos de sono.\n\n"
        "Sentidos aguçados: proficiência em Percepção.\n\n"
        "Idiomas: comum e élfico.",
    //Tratar Humano para tambem poder escolher sua variante (Depois que incluirmos os talentos)
    "Humano":
      "Extremamente diversos, os humanos prosperam em todas as partes do mundo.Sua capacidade de adaptação os torna aventureiros ousados e criativos.\n\n"
      "Atributos adaptáveis: humanos recebem +1 em todos os atributos, refletindo sua versatilidade.\n\n"
      "Deslocamento: 9 metros por rodada.\n\n"
      "Idade: adultos por volta dos 18 anos e vivem menos de um século.\n\n"
      "Tamanho e peso: entre 1,50m e 2,00m, peso médio 70kg.\n\n"
      "Versatilidade: adaptáveis a qualquer situação, os humanos podem se destacar em diferentes funções.\n\n"
      "Idiomas: sabem falar comum e um idioma adicional à escolha.",
    //Halfling tem duas sub-raças, Pés Leves e Robusto
    "Halfling":
        "Pequenos e ágeis, os halflings têm um espírito otimista e acolhedor. Preferem uma vida tranquila, mas quando aventureiros, destacam-se pela sorte e agilidade.\n\n"
        "Pequenos e ágeis: +2 em Destreza.\n\n"
        "Deslocamento: 7,5 metros por rodada.\n\n"
        "Idade: adultos aos 20. Vivem até 150 anos.\n\n"
        "Tamanho e peso: cerca de 90cm, peso médio 20kg.\n\n"
        "Sortudos: ao rolar 1 em um teste de ataque, habilidade ou resistência, pode rolar novamente o dado.\n\n"
        "Valentia: vantagem contra efeitos de medo.\n\n"
        "Agilidade natural: podem se mover pelo espaço de criaturas maiores.\n\n"
        "Idiomas: comum e halfling.",
    "Meio-Orc":
        "Nascidos da força orc e da resiliência humana, os meio-orcs carregam uma presença intimidadora. Muitos são guerreiros ferozes, mas também leais companheiros.\n\n"
        "Força brutal: +2 em Força e +1 em Constituição.\n\n"
        "Deslocamento: 9 metros por rodada.\n\n"
        "Idade: adultos aos 14. Vivem até cerca de 75 anos.\n\n"
        "Tamanho e peso: entre 1,70m e 2,00m, peso médio 95kg.\n\n"
        "Visão no escuro: até 18 metros.\n\n"
        "Resistência incansável: quando reduzido a 0 PV, pode permanecer em 1 PV uma vez por descanso longo.\n\n"
        "Ataques selvagens: ao conseguir um acerto crítico com arma corpo a corpo, rola um dado adicional de dano.\n\n"
        "Idiomas: comum e orc.",
    //Anão tem três sub raças, Duergar, Anão da Montanha e Anão da Colina
    "Anão":
        "De estatura baixa e coração firme, os anões são famosos por sua habilidade em forjar armas e armaduras. Sua disciplina e honra os tornam aliados leais\n\n"
        "Força da montanha: +2 em Constituição.\n\n"
        "Tamanho e peso: entre 1,20m e 1,50m, peso médio 75kg.\n\n"
        "Deslocamento: 7,5 metros por rodada (mas não é reduzido por armadura pesada).\n\n"
        "Idade: adultos por volta dos 50 anos e vivem até cerca de 350 anos.\n\n"
        "Tendência: geralmente são leais e honoráveis.\n\n"
        "Visão no escuro: até 18 metros.\n\n"
        "Ligação com pedra: adiciona dobro de proficiência em história relacionado à origem de trabalhos de pedra.\n\n"
        "Resistência anã: vantagem contra veneno e resistência a dano de veneno.\n\n"
        "Treino em combate: proficiência com machados de batalha, martelos leves e martelos de guerra.\n\n"
        "Tradição das ferramentas: proficiência em uma ferramenta de artesão à escolha: Ferreiro, Pedreiro ou Cervejeiro.\n\n"
        "Idiomas: comum e anão.",
    //Precisamos entender como vamos fazer para adicionar as cores de dragão
    "Draconato":
        "Descendentes de dragões, os draconatos têm sangue poderoso em suas veias. Exalam força e orgulho, e muitos carregam consigo a habilidade de soltar um sopro elemental.\n\n"
        "Força dracônica: +2 em Força e +1 em Carisma.\n\n"
        "Idade: adultos aos 15. Vivem até 80 anos.\n\n"
        "Tamanho e peso: mais de 1,80m. Peso médio 125kg.\n\n"
        "Deslocamento: 9 metros por rodada.\n\n"
        "Ancestralidade dracônica: cada draconato possui um tipo de dragão ancestral (fogo, gelo, ácido, etc.), que define seu sopro e resistência.\n\n"
        "Arma de sopro: podem exalar energia elemental (dano e área variam conforme o ancestral). Uma vez por descanso pode fazer um sopro que causa 2d6 (resistência de DES metade, CD 8 + Proficiência + CON). Esse dano aumenta em 1d6 aos níveis 6, 11 e 16.\n\n"
        "Resistência dracônica: resistência ao tipo de dano do ancestral.\n\n"
        "Idiomas: comum e dracônico.",
    //Tiefling ganha magias conforme nivel
    "Tiefling":
        "Marcados por uma herança infernal, os tieflings enfrentam preconceito, mas possuem determinação e carisma únicos. Muitos se voltam para a magia e para seu destino misterioso.\n\n"
        "Herança infernal: +2 em Carisma e +1 em Inteligência.\n\n"
        "Deslocamento: 9 metros por rodada.\n\n"
        "Idade: como humanos, adultos aos 18. Vivem até 100 anos.\n\n"
        "Tamanho e peso: como humanos,entre 1,50m e 1,90m, peso médio 70kg.\n\n"
        "Visão no escuro: até 18 metros.\n\n"
        "Resistência infernal: resistência a dano de fogo.\n\n"
        "Magia inata: aprendem pequenos truques mágicos, que evoluem com o nível.\n\n"
        "Idiomas: comum e infernal.",
    //Gnomos tem duas sub-raças, Gnomo das Florestas e Gnomo das Rochas
    "Gnomo":
        "Pequenos em tamanho, mas grandes em curiosidade. Os gnomos adoram invenções, truques e mistérios. São brincalhões, mas também sábios e engenhosos.\n\n"
        "Inteligência aguçada: +2 em Inteligência e +1 em Destreza ou Constituição, à escolha.\n\n"
        "Deslocamento: 7,5 metros por rodada.\n\n"
        "Idade: adultos por volta dos 40 anos e vivem até cerca de 500 anos.\n\n"
        "Tamanho e peso: entre 0,90m e 1,20m, peso médio 20kg.\n\n"
        "Visão no escuro: até 18 metros.\n\n"
        "Truques gnomescos: aprendem pequenos truques mágicos naturais, que evoluem com o nível.\n\n"
        "Resistência gnomesca: vantagem contra magia que visa enganar ou enfeitiçar.\n\n"
        "Esperteza gnômica: vantagem em testes de resistência de INT, SAB e CAR contra magia.\n\n"
        "Idiomas: comum e gnômico.",
  };

  @override
  Widget build(BuildContext context) {
    final Map<String, String> race =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;

    final description = raceDescriptions[race["name"]] ?? "Descrição indisponível.";

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/assets/images/image_dracon_3.png"), // fundo
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ===== Botões no topo =====
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.withOpacity(0.7),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(120, 50),
                        textStyle: GoogleFonts.jimNightshade(fontSize: 22),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Voltar"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.withOpacity(0.7),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(120, 50),
                        textStyle: GoogleFonts.jimNightshade(fontSize: 22),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        // Salva a raça no ValueNotifier
                        SelectionManager.selectedRace.value = race["name"];
                        Navigator.pop(context); // volta depois de selecionar
                      },
                      child: const Text("Selecionar"),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // ===== Imagem da raça =====
              Image.asset(race["img"]!, height: 80),

              const SizedBox(height: 10),

              // ===== Nome da raça =====
              Text(
                race["name"]!,
                style: GoogleFonts.jimNightshade(
                  fontSize: 36,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              // ===== Descrição rolável =====
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      description,
                      style: GoogleFonts.imFellEnglish(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
