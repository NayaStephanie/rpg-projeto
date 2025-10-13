// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_rpg/selection_manager.dart';

// Descrições originais adaptadas
final Map<String, String> backgroundDescriptions = {
  "Artista": "Artistas viajam pelo mundo, espalhando cultura e criatividade.\n\n"
      "Vive para expressar emoções através da arte e da performance.\n\n"
      "Talentos: Proficiência em Performance e uma habilidade à escolha.\n\n"
      "Ferramentas: instrumentos artísticos.\n\n"
      "Traços: criativo, persuasivo e carismático.\n\n"
      "Idiomas: comum e um adicional à escolha.",
  "Artesão da Guilda": "Especialista em seu ofício, com grande reputação na guilda.\n\n"
      "Membro de uma guilda de artesãos, dedicado a aperfeiçoar suas habilidades.\n\n"
      "Talentos: Proficiência em ferramentas de artesão e uma habilidade à escolha.\n\n"
      "Traços: meticuloso, disciplinado e confiável.\n\n"
      "Conexões: tem contatos dentro da guilda.\n\n"
      "Idiomas: comum e um adicional à escolha.",
  "Acólito": "Sobreviveu a tempos difíceis, lidando com vícios e aprendendo a usar contatos improváveis.\n\n"
      "Talentos: Proficiência em Enganação e Intuição.\n\n"
      "Traços: resiliente, cauteloso e persuasivo.\n\n"
      "Ferramentas: utensílios cotidianos ou bebidas.\n\n"
      "Idiomas: comum.",
  "Eremita": "Viveu isolado em busca de sabedoria, paz interior ou redenção.\n\n"
      "Talentos: Proficiência em Medicina e uma habilidade à escolha.\n\n"
      "Traços: introspectivo, observador e paciente.\n\n"
      "Descoberta: algum segredo importante que mudou sua vida.\n\n"
      "Idiomas: comum e um adicional à escolha.",
  "Criminoso": "Acostumado à vida no submundo, com habilidade em furtos e disfarces.\n\n"
      "Talentos: Proficiência em Furtividade e Enganação.\n\n"
      "Ferramentas: kit de ladrão.\n\n"
      "Traços: esperto, audacioso e cauteloso.\n\n"
      "Idiomas: comum e um adicional à escolha.",
  "Charlatão": "Manipula pessoas e situações usando truques e artifícios.\n\n"
      "Talentos: Proficiência em Enganação e Persuasão.\n\n"
      "Ferramentas: kits de falsificação e instrumentos.\n\n"
      "Traços: persuasivo, criativo e manipulador.\n\n"
      "Idiomas: comum e um adicional à escolha.",
  "Marinheiro": "Acostumado à vida no mar, resistente às intempéries e aventuras náuticas.\n\n"
      "Talentos: Proficiência em Atletismo e Sobrevivência.\n\n"
      "Ferramentas: kit de navegação.\n\n"
      "Traços: resiliente, corajoso e disciplinado.\n\n"
      "Idiomas: comum e um adicional à escolha.",
  "Herói do Povo": "Ganhou fama protegendo a comunidade, inspirando confiança e respeito.\n\n"
      "Talentos: Proficiência em Intimidação e Persuasão.\n\n"
      "Traços: altruísta, corajoso e carismático.\n\n"
      "Conexões: aliados fiéis e seguidores.\n"
      "Idiomas: comum e um adicional à escolha.",
  "Forasteiro": "Viajante experiente, acostumado a sobreviver em regiões selvagens.\n\n"
      "Talentos: Proficiência em Sobrevivência e Percepção.\n\n"
      "Traços: independente, atento e autossuficiente.\n\n"
      "Ferramentas: kit de exploração.\n\n"
      "Idiomas: comum e um adicional à escolha.",
  "Sábio": "Busca conhecimento em artes, história e mistérios.\n\n"
      "Talentos: Proficiência em História e Investigação.\n\n"
      "Traços: curioso, paciente e analítico.\n\n"
      "Conexões: acesso a bibliotecas e mentores.\n\n"
      "Idiomas: comum e dois adicionais à escolha.",
  "Órfão": "Cresceu sem família, aprendendo a se virar sozinho.\n\n"
      "Talentos: Proficiência em Percepção e Furtividade.\n\n"
      "Traços: resiliente, adaptável e esperto.\n\n"
      "Ferramentas: itens improvisados.\n\n"
      "Idiomas: comum e um adicional à escolha.",
  "Nobre": "Acostumado ao poder e às responsabilidades sociais.\n\n"
      "Talentos: Proficiência em História e Persuasão.\n\n"
      "Traços: influente, educado e estratégico.\n\n"
      "Conexões: acesso a aliados ricos ou influentes.\n\n"
      "Idiomas: comum e um adicional à escolha.",
  "Soldado": "Treinado para combate e disciplina, acostumado a seguir ordens.\n\n"
      "Talentos: Proficiência em Atletismo e Intimidação.\n\n"
      "Ferramentas: kit de jogos de estratégia ou armamentos.\n\n"
      "Traços: disciplinado, corajoso e leal.\n\n"
      "Idiomas: comum e um adicional à escolha.",
};

class BackgroundDetailScreen extends StatelessWidget {
  const BackgroundDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, String> background =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;

    final description =
        backgroundDescriptions[background["name"]] ?? "Descrição indisponível.";

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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                        SelectionManager().selectedBackground = background["name"];
                        Navigator.pop(context);
                      },
                      child: const Text("Selecionar"),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // ===== Imagem =====
              Image.asset(background["img"]!, height: 80),

              const SizedBox(height: 10),

              // ===== Nome =====
              Text(
                background["name"]!,
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
