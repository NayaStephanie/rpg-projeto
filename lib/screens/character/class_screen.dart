// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_rpg/screens/character/class_detail_screen.dart';


class ClassScreen extends StatelessWidget {
  const ClassScreen({super.key});

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
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("lib/assets/images/image_dracon_3.png"),
                fit: BoxFit.cover,
                alignment: Alignment.center, // Parte esquerda do fundo
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.65),
          ),
          Column(
           
            children: [
              const SizedBox(height: 90),
              Text(
                "Classe",
                style: GoogleFonts.jimNightshade(
                  fontSize: 80,
                  color: Colors.white,
                ),
                ),
              const SizedBox(height: 70),
              // Grid de raças
              Container(
                margin: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0), 
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: const Color(0xFF878787).withOpacity(0.35),
                  borderRadius: BorderRadius.circular(5),
                ),
                height: 330, // defina uma altura fixa adequada para o grid
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,    //numero de colunas
                    crossAxisSpacing: 20, //espaço entre colunas
                    mainAxisSpacing: 2,   //espaço entre linhas
                    childAspectRatio: 0.5, // largura/altura dos itens
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
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Column(
                          children: [
                            Image.asset(
                              classe["img"]!,
                              height: 105,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              classe["name"]!,
                              style: GoogleFonts.jimNightshade(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 70),

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
