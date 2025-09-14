import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String storageOption = "local"; // valor padrão

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
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Título
                Text(
                  "Criar Conta",
                  style: GoogleFonts.jimNightshade(
                    fontSize: 60,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),

                // Nome de usuário
                _buildTextField("Nome de Usuário"),
                const SizedBox(height: 20),

                // Email
                _buildTextField("Email"),
                const SizedBox(height: 20),

                // Número de telefone
                _buildTextField("Número de telefone"),
                const SizedBox(height: 20),

                // Senha
                _buildTextField("Senha", isPassword: true),
                const SizedBox(height: 20),

                // Confirmar senha
                _buildTextField("Confirmar Senha", isPassword: true),
                const SizedBox(height: 30),

                // Opções de armazenamento
                Row(
                  children: [
                    Radio<String>(
                      value: "local",
                      groupValue: storageOption,
                      activeColor: Colors.white,
                      onChanged: (value) {
                        setState(() {
                          storageOption = value!;
                        });
                      },
                    ),
                    Expanded(
                      child: Text(
                        "Salvar localmente (grátis)",
                        style: GoogleFonts.cinzel(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Radio<String>(
                      value: "cloud",
                      groupValue: storageOption,
                      activeColor: Colors.white,
                      onChanged: (value) {
                        setState(() {
                          storageOption = value!;
                        });
                      },
                    ),
                    Expanded(
                      child: Text(
                        "Salvar na nuvem (premium)",
                        style: GoogleFonts.cinzel(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // Botão Cadastrar
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF767676),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 65),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    textStyle: GoogleFonts.cinzel(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () {
                    // ação de cadastro
                  },
                  child: const Text("CADASTRAR"),
                ),
                const SizedBox(height: 30),

                // Botão Voltar
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "VOLTAR",
                    style: GoogleFonts.cinzel(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget auxiliar para criar campos de texto
  Widget _buildTextField(String hint, {bool isPassword = false}) {
    return TextField(
      obscureText: isPassword,
      style: GoogleFonts.cinzel(color: Colors.white, fontSize: 18),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.black.withAlpha((0.20 * 255).toInt()),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}
