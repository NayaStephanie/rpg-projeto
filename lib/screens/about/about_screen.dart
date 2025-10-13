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

Sob o emblema da Fatec Ribeirão Preto, e guiados pelos desígnios da Programação para Dispositivos Móveis, dois aprendizes da arte tecnológica empreenderam a criação deste artefato digital.

Seu propósito é singular: oferecer aos viajantes dos mundos imaginários uma ferramenta capaz de ordenar, preservar e dar forma às fichas que narram suas epopeias.

Assim, entre linhas de código e lampejos de inspiração, ergueu-se este aplicativo — simples em essência, mas nobre em intento.

Obra dos artífices:
• Nayara Stephanie S. Silva
• Victor Peaguda Bekcivanyi

Que este legado sirva aos aventureiros como o pergaminho serve ao cronista: guardião fiel de suas histórias.
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