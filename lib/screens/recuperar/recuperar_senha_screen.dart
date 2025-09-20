// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecuperarSenhaScreen extends StatefulWidget {
  const RecuperarSenhaScreen({super.key});

  @override
  State<RecuperarSenhaScreen> createState() => _RecuperarSenhaScreenState();
}

class _RecuperarSenhaScreenState extends State<RecuperarSenhaScreen> {
  final TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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

  void _enviar() {
    if (_formKey.currentState!.validate()) {
      // Aqui no futuro pode enviar requisição ao backend
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Um link de recuperação foi enviado para ${emailController.text}"),
        ),
      );
    }
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

          // Conteúdo
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 165),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Título
                  Text(
                    "Recuperar Senha",
                    style: GoogleFonts.jimNightshade(
                      fontSize: 60,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 70),

                  // Campo de email
                  TextFormField(
                    controller: emailController,
                    style: GoogleFonts.imFellEnglish(
                        color: Colors.white, fontSize: 18),
                    decoration: InputDecoration(
                      hintText: "Informe o email de cadastro",
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
                  const SizedBox(height: 50),

                  // Botão ENVIAR
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF767676).withOpacity(0.35),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 65),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: GoogleFonts.imFellEnglish(
                          fontSize: 26,
                        ),
                      ),
                      onPressed: _enviar,
                      child: const Text("Enviar"),
                    ),
                  ),

                  const SizedBox(height: 50),

                  // Botão VOLTAR
                  SizedBox(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF767676).withOpacity(0.35),
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
                        Navigator.pop(context);
                      },
                      child: const Text("Voltar"),
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
