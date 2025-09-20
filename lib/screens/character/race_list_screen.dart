// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_rpg/screens/character/race_detail_screen.dart';
import 'package:app_rpg/screens/character/class_screen.dart';
// Define a constant for font sizes
const double buttonFontSize = 22.0;



class RaceScreen extends StatelessWidget {
  const RaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final races = [
      {"name": "Meio-Elfo", "img": "lib/assets/images/racas/raca_meio_elfo.png"},
      {"name": "Elfo", "img": "lib/assets/images/racas/raca_elfo.png"},
      {"name": "Humano", "img": "lib/assets/images/racas/raca_humano.png"},
      {"name": "Halfling", "img": "lib/assets/images/racas/raca_halfling.png"},
      {"name": "Meio-Orc", "img": "lib/assets/images/racas/raca_meio_orc.png"},
      {"name": "Anão", "img": "lib/assets/images/racas/raca_anao.png"},
      {"name": "Draconato", "img": "lib/assets/images/racas/raca_draconato.png"},
      {"name": "Tiefling", "img": "lib/assets/images/racas/raca_tiefling.png"},
      {"name": "Gnomo", "img": "lib/assets/images/racas/raca_gnomo.png"},
    ];

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("lib/assets/images/image_dracon_2.png"),
                fit: BoxFit.cover,
                alignment: Alignment.centerLeft, // Parte esquerda do fundo
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.65),
          ),
          Column(
            children: [
            const SizedBox(height: 30),
            Text(
              "Raça",
              style: GoogleFonts.jimNightshade(
                fontSize: 80,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),

            // Grid de raças
            Expanded(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF878787).withOpacity(0.35),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  
                  child: GridView.builder(

                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,     //numero de colunas
                      crossAxisSpacing: 15,  //espaço entre colunas
                      mainAxisSpacing: 2,     //espaço entre linhas
                      childAspectRatio: 0.7, // largura/altura dos itens
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
                              pageBuilder: (context, animation, secondaryAnimation) =>
                                  const RaceDetailScreen(),
                              settings: RouteSettings(arguments: race),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
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
                          );
                        },
                        child: Column(
                          children: [
                            Image.asset(
                              race["img"]!,
                              height: 100,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              race["name"]!,
                              style: GoogleFonts.jimNightshade(
                                fontSize: 28,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Botão próximo
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
                    // aqui depois leva para a tela de Classe
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ClassScreen(),
                      ),
                    );
                  },
                  child: Text(
                    "Próximo",
                    style: GoogleFonts.jimNightshade(fontSize: 40, color: Colors.black),
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