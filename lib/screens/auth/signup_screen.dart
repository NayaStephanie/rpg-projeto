// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String storageOption = "local"; // valor padrão

  // Controllers para pegar valores dos campos
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController confirmarSenhaController = TextEditingController();

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
                  ),
                ),
                const SizedBox(height: 40),

                // Nome de usuário
                _buildTextField("Nome de Usuário", controller: nomeController),
                const SizedBox(height: 20),

                // Email
                _buildTextField("Email", controller: emailController),
                const SizedBox(height: 20),

                // Número de telefone
                _buildTextField("Número de telefone", controller: telefoneController),
                const SizedBox(height: 20),

                // Senha
                _buildTextField("Senha", controller: senhaController, isPassword: true),
                const SizedBox(height: 20),

                // Confirmar senha
                _buildTextField("Confirmar Senha", controller: confirmarSenhaController, isPassword: true),
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
                        style: GoogleFonts.imFellEnglish(
                          color: Colors.white,
                          fontSize: 20,
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
                        style: GoogleFonts.imFellEnglish(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

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
                    _validarCadastro(context);
                  },
                  child: const Text("Cadastrar"),
                ),
                const SizedBox(height: 30),

                // Botão Voltar
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Voltar",
                    style: GoogleFonts.imFellEnglish(
                      fontSize: 26,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
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
  Widget _buildTextField(String hint, {bool isPassword = false, TextEditingController? controller}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: GoogleFonts.imFellEnglish(color: Colors.white, fontSize: 18),
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

  // Função para validar cadastro
  void _validarCadastro(BuildContext context) {
    String nome = nomeController.text.trim();
    String email = emailController.text.trim();
    String telefone = telefoneController.text.trim();
    String senha = senhaController.text.trim();
    String confirmarSenha = confirmarSenhaController.text.trim();

    if (nome.isEmpty || email.isEmpty || telefone.isEmpty || senha.isEmpty || confirmarSenha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, preencha todos os campos.")),
      );
      return;
    }

    if (senha != confirmarSenha) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("As senhas não coincidem.")),
      );
      return;
    }

    // Se passou na validação
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Cadastro realizado com sucesso!")),
    );

    // Depois pode salvar em banco de dados/local/nuvem
    Navigator.pop(context);
  }
}
