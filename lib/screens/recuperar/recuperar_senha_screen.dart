import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecuperarSenhaScreen extends StatelessWidget {
  const RecuperarSenhaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fundo com imagem ou cor
          Image.asset(
            "lib/assets/images/image_fundo.png", // use a mesma textura das outras telas
            fit: BoxFit.cover,
          ),


          // Conteúdo
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Título
                Text(
                  "Recuperar Senha",
                  style: GoogleFonts.jimNightshade(
                    fontSize: 60,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 70),

                // Campo de email
                TextField(
                  controller: emailController,
                  style: GoogleFonts.cinzel(color: Colors.white, fontSize: 18),
                  decoration: InputDecoration(
                    hintText: "Informe o Email de cadastro",
                    hintStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.black.withAlpha((0.20 * 255).toInt()),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 50),

                // Botão ENVIAR
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF767676),
                    foregroundColor: Colors.white,
                    minimumSize:  Size(double.infinity, 65),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    textStyle: GoogleFonts.cinzel(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                    onPressed: () {
                      // depois você adiciona a lógica de verificação do email
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Verificação de email em desenvolvimento..."),
                        ),
                      );
                    },
                    child: const Text("ENVIAR"),
                  ),
                ),

                const SizedBox(height: 50),

                // Botão VOLTAR
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF767676),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(200, 65),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),

                    ),
                    textStyle: GoogleFonts.cinzel(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                    onPressed: () {
                      Navigator.pop(context); // volta para tela anterior
                    },
                    child: const Text("VOLTAR"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
