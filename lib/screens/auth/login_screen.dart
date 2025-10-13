// ignore_for_file: deprecated_member_use, avoid_print

import 'package:app_rpg/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../recuperar/recuperar_senha_screen.dart';
import 'signup_screen.dart';
import '../../utils/app_localizations.dart';
import '../../utils/language_manager.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Mock de usuário fixo (simulação de autenticação)
  final String _mockEmail = "teste@rpg.com";
  final String _mockSenha = "1234";

 /* @override
  void initState() {
    super.initState();
    // Pré-preenche o campo de e-mail com o mock para facilitar testes
    emailController.text = _mockEmail;
  }*/

  String _getTranslatedText(String key) {
    return AppLocalizations.of(context)?.translate(key) ?? key;
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      final email = emailController.text.trim();
      final senha = senhaController.text.trim();

      if (email == _mockEmail && senha == _mockSenha) {
        // Login bem-sucedido → vai para a home
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        // Mostra erro se email/senha não conferem
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _getTranslatedText('emailOrPasswordIncorrect'),
              style: GoogleFonts.imFellEnglish(color: Colors.white, fontSize: 18),
            ),
            backgroundColor: Colors.red.withOpacity(0.8),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
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

  @override
  Widget build(BuildContext context) {
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
                    onPressed: _login, // usa o mock
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