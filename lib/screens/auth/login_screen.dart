// ignore_for_file: deprecated_member_use, unused_element

import 'package:app_rpg/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../recuperar/recuperar_senha_screen.dart';
import 'signup_screen.dart';

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

  //Pausado apenas para ficar mais facil de testar
  void _login() {
    if (_formKey.currentState!.validate()) {
      if (emailController.text == _mockEmail &&
          senhaController.text == _mockSenha) {
        // Login bem-sucedido → vai para a home
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Mostra erro se email/senha não conferem
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Email ou senha incorretos")),
        );
      }
    }
  }

  String? _validarEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Informe seu email";
    }
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!regex.hasMatch(value)) {
      return "Digite um email válido";
    }
    return null;
  }

  String? _validarSenha(String? value) {
    if (value == null || value.isEmpty) {
      return "Informe sua senha";
    }
    if (value.length < 4) {
      return "Senha muito curta";
    }
    return null;
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
                    "Entrar",
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
                      hintText: "Email",
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
                      hintText: "Senha",
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
                      textStyle: GoogleFonts.imFellEnglish(
                        fontSize: 26,
                      ),
                    ),
                    onPressed:(){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                    },
                    //_login,
                    child: const Text("Entrar"),
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
                      textStyle: GoogleFonts.imFellEnglish(
                        fontSize: 26,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignupScreen(),
                        ),
                      );
                    },
                    child: const Text("Cadastrar"),
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
                      "Esqueci minha senha",
                      style: GoogleFonts.imFellEnglish(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
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
