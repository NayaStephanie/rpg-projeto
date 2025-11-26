// ignore_for_file: deprecated_member_use, use_build_context_synchronously, unnecessary_import

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_rpg/screens/about/about_screen.dart';
import 'package:app_rpg/screens/character/race_list_screen.dart';
import 'package:app_rpg/screens/characters/characters_list_screen.dart';
// imports removidos para simplificar a Home pública (apenas botões essenciais)
import 'package:app_rpg/screens/support/support_screen.dart';
import 'package:app_rpg/screens/auth/login_screen.dart';
import 'package:app_rpg/screens/dev/manage_collections_screen.dart';
import '../../utils/app_routes.dart';
import '../../services/auth_service.dart';
import 'package:flutter/foundation.dart';
import '../../utils/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String _getTranslatedText(BuildContext context, String key) {
    final localizations = AppLocalizations.of(context);
    return localizations?.translate(key) ?? key;
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.black.withOpacity(0.9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(color: Colors.amber, width: 2),
        ),
        title: Text(
          _getTranslatedText(context, 'logout') ,
          style: GoogleFonts.imFellEnglish(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        content: Text(
          _getTranslatedText(context, 'confirmLogout'),
          style: GoogleFonts.imFellEnglish(color: Colors.white, fontSize: 18),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
            child: Text(
              _getTranslatedText(context, 'cancel'),
              style: GoogleFonts.imFellEnglish(color: Colors.white, fontSize: 16),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              // mostra loading
              showDialog(context: context, barrierDismissible: false, builder: (_) => const Center(child: CircularProgressIndicator()));
              try {
                await AuthService.signOut();
              } catch (e) {
                // ignora - exibiremos mensagem abaixo
              }
              Navigator.of(context, rootNavigator: true).pop();
              // redireciona com flag para mostrar mensagem de logout
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen(showLogoutMessage: true)));
            },
            child: Text(
              _getTranslatedText(context, 'confirm'),
              style: GoogleFonts.imFellEnglish(color: Colors.amber, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _showLogoutConfirmation(context),
          )
        ],
      ),
      extendBodyBehindAppBar: true,
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
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "RPGo!",
                    style: GoogleFonts.jimNightshade(
                      fontSize: 72,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Apenas os botões essenciais: Personagens, Criar, Suporte, Sobre
                  _buildMenuButton(context, _getTranslatedText(context, "characters"), () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const CharactersListScreen()));
                  }),
                  const SizedBox(height: 32),
                  _buildMenuButton(context, _getTranslatedText(context, "createCharacter"), () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const RaceScreen()));
                  }),
                  const SizedBox(height: 32),
                  _buildMenuButton(context, _getTranslatedText(context, "support"), () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => const SupportScreen(),
                    ));
                  }),
                  const SizedBox(height: 32),
                  _buildMenuButton(context, _getTranslatedText(context, "about"), () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => const AboutScreen(),
                    ));
                  }),
                  const SizedBox(height: 32),
                  _buildMenuButton(context, 'Monstros', () {
                    Navigator.pushNamed(context, AppRoutes.dndMonsters);
                  }),
                  const SizedBox(height: 32),
                  _buildMenuButton(context, 'Extras', () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ManageCollectionsScreen()));
                  }),
                ],
              ),
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

