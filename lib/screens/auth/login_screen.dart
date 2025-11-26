// ignore_for_file: deprecated_member_use, avoid_print, use_build_context_synchronously

import 'package:app_rpg/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../recuperar/recuperar_senha_screen.dart';
import 'signup_screen.dart';
import '../../utils/app_localizations.dart';
import '../../utils/language_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  final bool showLogoutMessage;
  const LoginScreen({super.key, this.showLogoutMessage = false});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();


  String _getTranslatedText(String key) {
    return AppLocalizations.of(context)?.translate(key) ?? key;
  }

  Future<void> _login(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    _showLoadingDialog();
    try {
      await AuthService.signIn(email: emailController.text.trim(), password: senhaController.text.trim());
      if (!mounted) return;
      Navigator.of(context).pop(); // fecha o loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Usuário autenticado com sucesso!',
            style: GoogleFonts.imFellEnglish(color: Colors.white, fontSize: 18),
          ),
          backgroundColor: Colors.green.withOpacity(0.9),
        ),
      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop();
      // Mensagens seguras para o usuário
      final safeMessage = (e.code == 'user-not-found' || e.code == 'wrong-password')
          ? _getTranslatedText('emailOrPasswordIncorrect')
          : 'Não foi possível efetuar o login. Verifique seus dados e tente novamente.';

      // Log para debug (não exibir para o usuário)
      print('FirebaseAuthException login: code=${e.code} message=${e.message}');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(safeMessage, style: GoogleFonts.imFellEnglish(color: Colors.white, fontSize: 18)),
          backgroundColor: Colors.red.withOpacity(0.85),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop();
      // Mensagem genérica para erros inesperados
      print('Login error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ocorreu um erro ao tentar entrar. Tente novamente mais tarde.', style: GoogleFonts.imFellEnglish(color: Colors.white, fontSize: 18)),
          backgroundColor: Colors.red.withOpacity(0.85),
        ),
      );
    }
  }

 
  void _showLanguageDialog() {
    print('_showLanguageDialog chamado'); // Debug
    
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        backgroundColor: Colors.black.withOpacity(0.9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(color: Colors.amber, width: 2),
        ),
        title: Text(
          'Selecionar Idioma', // Fixo para testar
          style: GoogleFonts.imFellEnglish(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Português
            ListTile(
              leading: const Text('🇧🇷', style: TextStyle(fontSize: 24)),
              title: Text(
                'Português',
                style: GoogleFonts.imFellEnglish(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              onTap: () {
                print('Português selecionado'); // Debug
                Navigator.of(dialogContext).pop();
                _changeLanguage('pt');
              },
            ),
            // English
            ListTile(
              leading: const Text('🇺🇸', style: TextStyle(fontSize: 24)),
              title: Text(
                'English',
                style: GoogleFonts.imFellEnglish(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              onTap: () {
                print('English selecionado'); // Debug
                Navigator.of(dialogContext).pop();
                _changeLanguage('en');
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              print('Cancelar pressionado'); // Debug
              Navigator.of(dialogContext).pop();
            },
            child: Text(
              'Cancelar', // Fixo para testar
              style: GoogleFonts.imFellEnglish(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _changeLanguage(String languageCode) async {
    print('_changeLanguage chamado com: $languageCode'); // Debug
    
    final languageManager = Provider.of<LanguageManager>(context, listen: false);
    await languageManager.changeLanguage(languageCode);
    
    if (!mounted) return;
    
    // Mostra feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Idioma alterado para: $languageCode',
          style: GoogleFonts.imFellEnglish(color: Colors.white, fontSize: 16),
        ),
        backgroundColor: Colors.green.withOpacity(0.8),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
  }

  String? _validarEmail(String? value) {
    if (value == null || value.isEmpty) return _getTranslatedText('enterEmail');
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!regex.hasMatch(value)) return _getTranslatedText('validEmail');
    return null;
  }

  String? _validarSenha(String? value) {
    if (value == null || value.isEmpty) return _getTranslatedText('enterPassword');
    if (value.length < 4) return _getTranslatedText('passwordTooShort');
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // Se vier da ação de logout, mostra uma mensagem breve
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.showLogoutMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Você saiu com sucesso',
              style: GoogleFonts.imFellEnglish(color: Colors.white, fontSize: 18),
            ),
            backgroundColor: Colors.green.withOpacity(0.9),
          ),
        );
      }
    });
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fundo
          Image.asset(
            "lib/assets/images/image_fundo.png",
            fit: BoxFit.cover,
          ),

          // Conteúdo central
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 80),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Título
                  Text(
                    _getTranslatedText('login'),
                    style: GoogleFonts.jimNightshade(
                      fontSize: 80,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 60),

                  // Campo Email
                  TextFormField(
                    controller: emailController,
                    style: GoogleFonts.imFellEnglish(
                        color: Colors.white, fontSize: 20),
                    decoration: InputDecoration(
                      hintText: _getTranslatedText('email'),
                      hintStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.black.withAlpha((0.20 * 255).toInt()),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                    ),
                    validator: _validarEmail,
                  ),
                  const SizedBox(height: 20),

                  // Campo Senha
                  TextFormField(
                    controller: senhaController,
                    obscureText: true,
                    style: GoogleFonts.imFellEnglish(
                        color: Colors.white, fontSize: 20),
                    decoration: InputDecoration(
                      hintText: _getTranslatedText('password'),
                      hintStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.black.withAlpha((0.20 * 255).toInt()),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                    ),
                    validator: _validarSenha,
                  ),
                  const SizedBox(height: 50),

                  // Botão Entrar
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF767676).withOpacity(0.35),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 65),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      textStyle: GoogleFonts.imFellEnglish(fontSize: 26),
                    ),
                    onPressed: () => _login(context),
                    child: Text(_getTranslatedText('login')),
                  ),
                  const SizedBox(height: 45),

                  // Botão Cadastrar
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF767676).withOpacity(0.35),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 65),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      textStyle: GoogleFonts.imFellEnglish(fontSize: 26),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignupScreen(),
                        ),
                      );
                    },
                    child: Text(_getTranslatedText('signup')),
                  ),
                  const SizedBox(height: 45),

                  // Esqueci minha senha
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RecuperarSenhaScreen(),
                        ),
                      );
                    },
                    child: Text(
                      _getTranslatedText('forgotPassword'),
                      style: GoogleFonts.imFellEnglish(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Botão de seleção de idioma
                  GestureDetector(
                    onTap: () {
                      print('Botão de idioma clicado!'); // Debug
                      
                      // Testa se o clique funciona
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Botão funcionando!'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                      
                      _showLanguageDialog();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.language,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _getTranslatedText('selectLanguage'),
                            style: GoogleFonts.imFellEnglish(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
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