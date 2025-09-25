import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showButton = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      bool isAtBottom = _scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent;

      if (isAtBottom != _showButton) {
        setState(() {
          _showButton = isAtBottom;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Colocando a imagem de fundo
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              'lib/assets/images/image_fundo.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Sobre o Projeto',
                    style: GoogleFonts.jimNightshade(
                      fontSize: 60,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Text(
                        '''
Seja bem-vindo, aventureiro!

Este grimório digital nasceu nas terras da Faculdade de Tecnologia de Ribeirão Preto (Fatec), forjado na disciplina de Programação para Dispositivos Móveis.

Nosso objetivo é oferecer uma ferramenta mágica para auxiliar heróis e mestres na criação e gestão de fichas de RPG, tornando a jornada mais prática, imersiva e envolvente.

Equipe de desenvolvimento:
• Nayara Stephanie S. Silva
• Victor Peaguda Bekcivanyi

Que este artefato seja útil em suas campanhas, e que os dados sempre rolem a seu favor!
                        ''',
                        style: GoogleFonts.imFellEnglish(
                          fontSize: 26,
                          height: 2,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Botão aparece só no final do scroll
                  if (_showButton)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        // ignore: deprecated_member_use
                        backgroundColor: const Color(0xFF767676).withOpacity(0.35),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 65),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: GoogleFonts.cinzel(
                          fontSize: 20,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Voltar',
                        style: GoogleFonts.imFellEnglish(
                          fontSize: 26,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
