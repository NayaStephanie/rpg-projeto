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

  // Função para exibir SnackBar customizado
void _mostrarSnackBar(BuildContext context, String mensagem,
    {IconData? icone, Color cor = Colors.red}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(icone ?? Icons.error_outline, color: Colors.white),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              mensagem,
              style: GoogleFonts.imFellEnglish(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: cor.withOpacity(0.85),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      duration: const Duration(seconds: 3),
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

  if (nome.isEmpty ||
      email.isEmpty ||
      telefone.isEmpty ||
      senha.isEmpty ||
      confirmarSenha.isEmpty) {
    _mostrarSnackBar(
      context,
      "Por favor, preencha todos os campos.",
      icone: Icons.warning_amber_rounded,
      cor: Colors.orange,
    );
    return;
  }

  if (senha != confirmarSenha) {
    _mostrarSnackBar(
      context,
      "As senhas não coincidem.",
      icone: Icons.lock_outline,
      cor: Colors.red,
    );
    return;
  }

  // Se passou na validação
  _mostrarSnackBar(
    context,
    "Cadastro realizado com sucesso!",
    icone: Icons.check_circle_outline,
    cor: Colors.green,
  );

  // Depois pode salvar em banco de dados/local/nuvem
  Navigator.pop(context);
}
}
