// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_rpg/screens/character/race_detail_screen.dart';
import 'package:app_rpg/screens/character/class_screen.dart';
import 'package:app_rpg/selection_manager.dart';
import '../../utils/app_localizations.dart';

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
  
  String _getTranslatedText(String key) {
    final localizations = AppLocalizations.of(context);
    return localizations?.translate(key) ?? key;
  }
  
  @override
  void initState() {
    super.initState();
    // Limpa todas as seleções quando inicia uma nova criação de personagem
    SelectionManager().clearAllSelections();
  }

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
    {"key": "halfElf", "name": _getTranslatedText("halfElf"), "img": "lib/assets/images/racas/meio_elfo.png"},
    {"key": "elf", "name": _getTranslatedText("elf"), "img": "lib/assets/images/racas/elfo.png"},
    {"key": "human", "name": _getTranslatedText("human"), "img": "lib/assets/images/racas/humano.png"},
    {"key": "halfling", "name": _getTranslatedText("halfling"), "img": "lib/assets/images/racas/halfling.png"},
    {"key": "halfOrc", "name": _getTranslatedText("halfOrc"), "img": "lib/assets/images/racas/meio_orc.png"},
    {"key": "dwarf", "name": _getTranslatedText("dwarf"), "img": "lib/assets/images/racas/anao.png"},
    {"key": "dragonborn", "name": _getTranslatedText("dragonborn"), "img": "lib/assets/images/racas/draconato.png"},
    {"key": "tiefling", "name": _getTranslatedText("tiefling"), "img": "lib/assets/images/racas/tiefling.png"},
    {"key": "gnome", "name": _getTranslatedText("gnome"), "img": "lib/assets/images/racas/gnomo.png"},
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
              _getTranslatedText("race"),
              style: GoogleFonts.jimNightshade(
                fontSize: titleFontSize,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 20),

            // Grid de Raças (EXPANDED contém só o GridView)
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
                        // opcional: marcar direto ao tocar
                        // SelectionManager.selectedRace.value = race["name"];

                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration:
                                const Duration(milliseconds: 600),
                            pageBuilder: (context, animation, secondaryAnimation) =>
                                const RaceDetailScreen(),
                            settings: RouteSettings(arguments: race),
                            transitionsBuilder:
                                (context, animation, secondaryAnimation, child) {
                              final tween =
                                  Tween(begin: const Offset(0, -1), end: Offset.zero);
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

                      // O Column do item é reconstruído automaticamente
                      // quando SelectionManager.selectedRace muda
                      child: AnimatedBuilder(
                        animation: SelectionManager(),
                        builder: (context, _) {
                          final selectionManager = SelectionManager();
                          final selectedRace = selectionManager.selectedRace;
                          return Column(
                            mainAxisSize: MainAxisSize.min, // evita expandir verticalmente
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: selectedRace == race["name"]
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
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ), // fim do Expanded (Grid)

            const SizedBox(height: 20),

            // Botão Próximo (agora fora do Grid)
            Padding(
              padding: const EdgeInsets.all(20),
              child: AnimatedBuilder(
                animation: SelectionManager(),
                builder: (context, _) {
                  final selectionManager = SelectionManager();
                  final selectedRace = selectionManager.selectedRace;
                  final isSelected = selectedRace != null;
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected
                          ? Colors.grey.withOpacity(0.4)
                          : Colors.grey.shade800,
                      minimumSize: const Size(150, 70),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      if (SelectionManager().selectedRace == null) {
                        _mostrarSnackBar(
                          context,
                          _getTranslatedText("pleaseSelectRace"),
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
                      _getTranslatedText("next"),
                      style: GoogleFonts.jimNightshade(
                        fontSize: buttonFontSize,
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  );
                },
              ),
            ),
          ], // fim Column children
        ),
      ],
    ),
  );
}
}