// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_rpg/screens/about/about_screen.dart';
import 'package:app_rpg/screens/character/race_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fundo com imagem ocupando toda a tela
          Positioned.fill(
            child: 
            Image.asset(
              "lib/assets/images/image_dracon_inicio.png", // caminho novo
              fit: BoxFit.cover,
            ),
          ),

           // Overlay para deixar a imagem mais escura e facilitar leitura
          Container(
            color: Colors.black.withOpacity(0.65),
          ),

          // Conteúdo
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "RPGo!",
                  style: GoogleFonts.jimNightshade(
                    fontSize: 80,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 70),
                _buildMenuButton(context, "Personagens", () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => const RaceScreen(),
                  ));
                }),
                const SizedBox(height: 50),
                _buildMenuButton(context, "Criar", () {
                 Navigator.push(
  context,
  PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 700), // tempo da animação
    pageBuilder: (context, animation, secondaryAnimation) => const RaceScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0); // começa fora da tela, à direita
      const end = Offset.zero;       // termina no centro (posição final)
      final tween = Tween(begin: begin, end: end);
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,     // suavidade
      );

      return SlideTransition(
        position: tween.animate(curvedAnimation),
        child: child,
      );
    },
  ),
);

                }),
                const SizedBox(height: 50),
                _buildMenuButton(context, "Suporte", () {}),

                const SizedBox(height: 50),
                _buildMenuButton(context, "Sobre o App", () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => const AboutScreen(),
                  ));
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton(
      BuildContext context, String text, VoidCallback onTap) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF767676).withOpacity( 0.35),
        foregroundColor: Colors.white,
        minimumSize: const Size(240, 80),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        textStyle: GoogleFonts.jimNightshade(
          fontSize: 40,
          fontWeight: FontWeight.w400,
        ),
      ),
      onPressed: onTap,
      child: Text(
        text,
      ),
    );
  }
}

