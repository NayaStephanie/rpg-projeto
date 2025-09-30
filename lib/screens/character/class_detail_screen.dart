// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_rpg/selection_manager.dart';

class ClassDetailScreen extends StatelessWidget {
  const ClassDetailScreen({super.key});

  // Descrições originais das classes
  static final Map<String, String> classDescriptions = {
    
    //Fazer campo de seleção para pericias e equipamentos de cada classe
    "Monge":
        "Mestres da disciplina física e espiritual, os monges combinam agilidade e poder interno.\n\n"
        "Defesa sem armadura: Adicione seu modificador de Sabedoria e Destreza ao seu CA. (Não pode usar armadura) \n\n"
        "Artes marciais: Usa Destreza ao invés de Força para ataques com armas de monge e ataques desarmados,\n"
        "assim como usar sua ação bonus para dar um ataque desarmado após um ataque corpo a corpo"
        "Proficiencias\nArmaduras: Nenhuma\nArmas: Armas Simples e Espada Curta\nTeste de Resistência: Força e Destreza\n",
        //"Perícias: Escolha duas dentre Acrobacia, Atletismo, Furtividade, História, Intuição e Religião\n\n"
        
    "Mago":
        "Estudiosos arcanos, os magos dominam magias poderosas, mas frágeis fisicamente.\n\n"
        "Magia estudada: podem aprender e preparar magias de acordo com seu nível.\n\n"
        "Versatilidade mágica: acesso a ritualizações e magias de diversas escolas.\n\n",
       
    "Clérigo":
        "Servos de divindades, os clérigos equilibram combate e magia divina.\n\n"
        "Sabedoria divina: +2 em Sabedoria ou +1 em Constituição.\n\n"
        "Deslocamento: 9 metros por rodada.\n\n"
        "Domínio divino: habilidade de escolher um domínio que oferece magias e poderes especiais.\n\n"
        "Canalização de energia: podem curar aliados ou repelir inimigos.\n\n"
        "Idiomas: comum e celestial.",
    "Bruxo":
        "Pactos sombrios concedem aos bruxos poder arcano em troca de devoção ou vínculo.\n\n"
        "Carisma místico: +2 em Carisma ou +1 em Destreza.\n\n"
        "Deslocamento: 9 metros por rodada.\n\n"
        "Magia inata: lançam feitiços com base no pacto escolhido.\n\n"
        "Invocações: habilidades especiais únicas que aumentam suas magias ou ataques.\n\n"
        "Idiomas: comum e infernal ou um idioma adicional.",
    "Bardo":
        "Artistas e encantadores, os bardos usam música e magia para inspirar e influenciar.\n\n"
        "Carisma inspirador: +2 em Carisma ou +1 em Destreza.\n\n"
        "Deslocamento: 9 metros por rodada.\n\n"
        "Magia musical: podem lançar feitiços de suporte ou ilusão.\n\n"
        "Versatilidade: proficiência em diversas perícias e instrumentos.\n\n"
        "Idiomas: comum e um idioma adicional à escolha.",
    "Bárbaro":
        "Guerrilheiros ferozes, os bárbaros confiam em força bruta e resistência em combate.\n\n"
        "Força brutal: +2 em Força ou +1 em Constituição.\n\n"
        "Deslocamento: 9 metros por rodada.\n\n"
        "Fúria: aumenta dano e resistência temporariamente.\n\n"
        "Resistência física: vantagem em testes de resistência contra efeitos que causam dano.\n\n"
        "Idiomas: comum e orc ou um idioma adicional.",
    "Ladino":
        "Astutos e ágeis, os ladinos são especialistas em furtividade, truques e ataques precisos.\n\n"
        "Destreza ágil: +2 em Destreza ou +1 em Inteligência.\n\n"
        "Deslocamento: 9 metros por rodada.\n\n"
        "Ataque furtivo: dano extra ao atacar inimigos desprevenidos.\n\n"
        "Versatilidade: proficiência em perícias de agilidade e enganação.\n\n"
        "Idiomas: comum e um idioma adicional à escolha.",
    "Guerreiro":
        "Defensores e combatentes versáteis, os guerreiros se destacam no uso de armas e armaduras.\n\n"
        "Força marcial: +2 em Força ou +1 em Constituição.\n\n"
        "Deslocamento: 9 metros por rodada.\n\n"
        "Especialização em combate: podem escolher um estilo de luta que aprimora suas habilidades.\n\n"
        "Resistência: aptidão para armaduras pesadas e diversas armas.\n\n"
        "Idiomas: comum.",
    "Feiticeiro":
        "A magia dos feiticeiros nasce de um talento inato ou linhagem especial.\n\n"
        "Carisma arcano: +2 em Carisma ou +1 em Constituição.\n\n"
        "Deslocamento: 9 metros por rodada.\n\n"
        "Magia inata: lançam feitiços com foco em sua origem mágica.\n\n"
        "Metamagia: podem modificar magias para efeitos especiais.\n\n"
        "Idiomas: comum e um idioma adicional à escolha.",
    "Druida":
        "Protetores da natureza, os druidas utilizam magia e formas animais para manter o equilíbrio.\n\n"
        "Sabedoria natural: +2 em Sabedoria ou +1 em Constituição.\n\n"
        "Deslocamento: 9 metros por rodada.\n\n"
        "Magia natural: podem lançar feitiços baseados em elementos e cura.\n\n"
        "Transformação: habilidade de assumir formas animais.\n\n"
        "Idiomas: comum e dracônico ou silvestre.",
    "Patrulheiro":
        "Guardas do mundo selvagem, os patrulheiros combinam rastreamento, combate e magia.\n\n"
        "Destreza e sobrevivência: +2 em Destreza ou +1 em Sabedoria.\n\n"
        "Deslocamento: 9 metros por rodada.\n\n"
        "Caçador experiente: proficiência em armas e habilidades de rastrear inimigos.\n\n"
        "Companheiro animal: podem ter um aliado natural em combate.\n\n"
        "Idiomas: comum e um idioma adicional à escolha.",
    "Paladino":
        "Guardiões sagrados, os paladinos unem força física e poderes divinos.\n\n"
        "Força e Carisma: +2 em Força ou +1 em Carisma.\n\n"
        "Deslocamento: 9 metros por rodada.\n\n"
        "Juramento sagrado: poderes concedidos por sua fé e devoção.\n\n"
        "Cura e proteção: podem curar aliados e proteger os justos.\n\n"
        "Idiomas: comum e celestial.",
  };

  @override
  Widget build(BuildContext context) {
    final Map<String, String> classData =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;

    final description =
        classDescriptions[classData["name"]] ?? "Descrição indisponível.";

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/assets/images/image_dracon_3.png"),
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
                        SelectionManager.selectedClass.value =
                            classData["name"];
                        Navigator.pop(context);
                      },
                      child: const Text("Selecionar"),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // ===== Imagem da classe =====
              Image.asset(classData["img"]!, height: 80),

              const SizedBox(height: 10),

              // ===== Nome da classe =====
              Text(
                classData["name"]!,
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
