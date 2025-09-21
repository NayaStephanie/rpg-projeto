// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_rpg/screens/character/race_detail_screen.dart';
import 'package:app_rpg/screens/character/class_screen.dart';
import 'package:app_rpg/selection_manager.dart';

// Constantes para padronizar
const double titleFontSize = 80.0;
const double itemFontSize = 28.0;
const double buttonFontSize = 40.0;

class RaceScreen extends StatefulWidget {
  const RaceScreen({super.key});

  @override
  State<RaceScreen> createState() => _RaceScreenState();
}

class _RaceScreenState extends State<RaceScreen> {
  // Função para exibir SnackBar customizado
  void _mostrarSnackBar(BuildContext context, String mensagem,
      {IconData? icone, Color cor = Colors.red}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icone ?? Icons.error_outline, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                mensagem,
                style: GoogleFonts.imFellEnglish(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: cor.withOpacity(0.85),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final races = [
      {"name": "Meio-Elfo", "img": "lib/assets/images/racas/meio_elfo.png"},
      {"name": "Elfo", "img": "lib/assets/images/racas/elfo.png"},
      {"name": "Humano", "img": "lib/assets/images/racas/humano.png"},
      {"name": "Halfling", "img": "lib/assets/images/racas/halfling.png"},
      {"name": "Meio-Orc", "img": "lib/assets/images/racas/meio_orc.png"},
      {"name": "Anão", "img": "lib/assets/images/racas/anao.png"},
      {"name": "Draconato", "img": "lib/assets/images/racas/draconato.png"},
      {"name": "Tiefling", "img": "lib/assets/images/racas/tiefling.png"},
      {"name": "Gnomo", "img": "lib/assets/images/racas/gnomo.png"},
    ];

    return Scaffold(
      body: Stack(
        children: [
          // Fundo
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("lib/assets/images/image_dracon_2.png"),
                fit: BoxFit.cover,
                alignment: Alignment.centerLeft,
              ),
            ),
          ),

          // Camada preta com opacidade
          Container(color: Colors.black.withOpacity(0.65)),

          // Conteúdo
          Column(
            children: [
              const SizedBox(height: 30),

              // Título
              Text(
                "Raça",
                style: GoogleFonts.jimNightshade(
                  fontSize: titleFontSize,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 20),

              // Grid de Raças
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF878787).withOpacity(0.35),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 2,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: races.length,
                    itemBuilder: (context, index) {
                      final race = races[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration:
                                  const Duration(milliseconds: 600),
                              pageBuilder: (context, animation,
                                      secondaryAnimation) =>
                                  const RaceDetailScreen(),
                              settings: RouteSettings(arguments: race),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                final tween = Tween(
                                    begin: const Offset(0, -1),
                                    end: Offset.zero);
                                final curved = CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeInOut,
                                );
                                return SlideTransition(
                                  position: tween.animate(curved),
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: SelectionManager.selectedRace.value ==
                                          race["name"]
                                      ? Colors.yellow
                                      : Colors.transparent,
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Image.asset(
                                race["img"]!,
                                height: 90,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              race["name"]!,
                              style: GoogleFonts.jimNightshade(
                                fontSize: itemFontSize,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Botão Próximo
              Padding(
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.withOpacity(0.4),
                    minimumSize: const Size(150, 70),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    if (SelectionManager.selectedRace.value == null) {
                      _mostrarSnackBar(
                        context,
                        "Por favor, selecione uma raça antes de prosseguir.",
                        icone: Icons.warning_amber_rounded,
                        cor: Colors.orange,
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ClassScreen(),
                        ),
                      );
                    }
                  },
                  child: Text(
                    "Próximo",
                    style: GoogleFonts.jimNightshade(
                      fontSize: buttonFontSize,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
