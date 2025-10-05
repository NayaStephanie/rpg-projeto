// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_rpg/screens/character/class_detail_screen.dart';
import 'package:app_rpg/selection_manager.dart';
import 'package:app_rpg/utils/app_routes.dart';

// Constantes para padronizar
const double titleFontSize = 80.0;
const double itemFontSize = 28.0;
const double buttonFontSize = 40.0;

class ClassScreen extends StatefulWidget {
  const ClassScreen({super.key});

  @override
  State<ClassScreen> createState() => _ClassScreenState();
}

class _ClassScreenState extends State<ClassScreen> {
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
    final classes = [
      {"name": "Bárbaro", "img": "lib/assets/images/classes/barbaro.png"},
      {"name": "Bardo", "img": "lib/assets/images/classes/bardo.png"},
      {"name": "Bruxo", "img": "lib/assets/images/classes/bruxo.png"},
      {"name": "Clérigo", "img": "lib/assets/images/classes/clerigo.png"},
      {"name": "Druida", "img": "lib/assets/images/classes/druida.png"},
      {"name": "Feiticeiro", "img": "lib/assets/images/classes/feiticeiro.png"},
      {"name": "Guerreiro", "img": "lib/assets/images/classes/guerreiro.png"},
      {"name": "Ladino", "img": "lib/assets/images/classes/ladino.png"},
      {"name": "Mago", "img": "lib/assets/images/classes/mago.png"},
      {"name": "Monge", "img": "lib/assets/images/classes/monge.png"},
      {"name": "Paladino", "img": "lib/assets/images/classes/paladino.png"},
      {"name": "Patrulheiro", "img": "lib/assets/images/classes/patrulheiro.png"},
    ];

    return Scaffold(
      body: Stack(
        children: [
          // Fundo
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("lib/assets/images/image_dracon_3.png"),
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
                "Classe",
                style: GoogleFonts.jimNightshade(
                  fontSize: titleFontSize,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 20),

              // Grid de Classes
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
                      mainAxisSpacing: 2,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: classes.length,
                    itemBuilder: (context, index) {
                      final classe = classes[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: const Duration(milliseconds: 600),
                              pageBuilder: (context, animation, secondaryAnimation) =>
                                  const ClassDetailScreen(),
                              settings: RouteSettings(arguments: classe),
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
                            // Atualiza a tela quando voltar da tela de detalhes
                            setState(() {});
                          });
                        },
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: SelectionManager.selectedClass.value ==
                                          classe["name"]
                                      ? Colors.yellow
                                      : Colors.transparent,
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Image.asset(
                                classe["img"]!,
                                height: 90,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              classe["name"]!,
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
                child: ValueListenableBuilder<String?>(
                  valueListenable: SelectionManager.selectedClass,
                  builder: (context, selectedClass, _) {
                    final isSelected = selectedClass != null;
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
                      onPressed: isSelected
                          ? () {
                              Navigator.pushNamed(context, AppRoutes.backgroundScreen);
                            }
                          : () {
                              _mostrarSnackBar(
                                context,
                                "Por favor, selecione uma classe antes de prosseguir.",
                                icone: Icons.warning_amber_rounded,
                                cor: Colors.orange,
                              );
                            },
                      child: Text(
                        isSelected ? "Próximo" : "Próximo",
                        style: GoogleFonts.jimNightshade(
                          fontSize: buttonFontSize,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
