// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_rpg/screens/character/background_detail_screen.dart';
import 'package:app_rpg/selection_manager.dart';

// Constantes para padronizar
const double titleFontSize = 80.0;
const double itemFontSize = 28.0;
const double buttonFontSize = 40.0;

class BackgroundScreen extends StatefulWidget {
  const BackgroundScreen({super.key});

  @override
  State<BackgroundScreen> createState() => _BackgroundScreenState();
}

class _BackgroundScreenState extends State<BackgroundScreen> {
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
    final backgrounds = [
      {"name": "Artista", "img": "lib/assets/images/antecedentes/artista.png"},
      {"name": "Artesão da Guilda", "img": "lib/assets/images/antecedentes/artesao_guilda.png"},
      {"name": "Acólito", "img": "lib/assets/images/antecedentes/acolito.png"},
      {"name": "Eremita", "img": "lib/assets/images/antecedentes/eremita.png"},
      {"name": "Criminoso", "img": "lib/assets/images/antecedentes/criminoso.png"},
      {"name": "Charlatão", "img": "lib/assets/images/antecedentes/charlatao.png"},
      {"name": "Marinheiro", "img": "lib/assets/images/antecedentes/marinheiro.png"},
      {"name": "Herói do Povo", "img": "lib/assets/images/antecedentes/heroi_povo.png"},
      {"name": "Forasteiro", "img": "lib/assets/images/antecedentes/forasteiro.png"},
      {"name": "Sábio", "img": "lib/assets/images/antecedentes/sabio.png"},
      {"name": "Órfão", "img": "lib/assets/images/antecedentes/orfao.png"},
      {"name": "Nobre", "img": "lib/assets/images/antecedentes/nobre.png"},
      {"name": "Soldado", "img": "lib/assets/images/antecedentes/soldado.png"},
    ];

    return Scaffold(
      body: Stack(
        children: [
          // Fundo
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("lib/assets/images/image_dracon_4.png"),
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
                "Antecedente",
                style: GoogleFonts.jimNightshade(
                  fontSize: titleFontSize,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 20),

              // Grid de Antecedentes
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
                      crossAxisCount: 3, // Número de colunas
                      crossAxisSpacing: 10, // Espaçamento horizontal
                      mainAxisSpacing: 1, // Espaçamento vertical
                      childAspectRatio: 0.5,
                    ),
                    itemCount: backgrounds.length,
                    itemBuilder: (context, index) {
                      final bg = backgrounds[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: const Duration(milliseconds: 600),
                              pageBuilder: (context, animation, secondaryAnimation) =>
                                  const BackgroundDetailScreen(),
                              settings: RouteSettings(arguments: bg),
                              transitionsBuilder:
                                  (context, animation, secondaryAnimation, child) {
                                final tween = Tween(begin: const Offset(0, -1), end: Offset.zero);
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
                          ).then((_) {
                            setState(() {}); // Atualiza quando voltar
                          });
                        },
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: SelectionManager.selectedBackground.value ==
                                          bg["name"]
                                      ? Colors.yellow
                                      : Colors.transparent,
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Image.asset(
                                bg["img"]!,
                                height: 100,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              bg["name"]!,
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
                    if (SelectionManager.selectedBackground.value == null) {
                      _mostrarSnackBar(
                        context,
                        "Por favor, selecione um antecedente antes de prosseguir.",
                        icone: Icons.warning_amber_rounded,
                        cor: Colors.orange,
                      );
                    } else {
                      // Próxima tela do fluxo
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
