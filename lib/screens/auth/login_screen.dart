import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// importa a tela de cadastro
import 'signup_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Título
                Text(
                  "Entrar",
                  style: GoogleFonts.jimNightshade(
                    fontSize: 80,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 60),

                // Campo Email
                TextField(
                  style: GoogleFonts.cinzel(color: Colors.white, fontSize: 20),
                  decoration: InputDecoration(
                    hintText: "Email ou usuário",
                    hintStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.black.withAlpha((0.20 * 255).toInt()),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Campo Senha
                TextField(
                  obscureText: true,
                  style: GoogleFonts.cinzel(color: Colors.white, fontSize: 20),
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
                ),
                const SizedBox(height: 50),

                // Botão Entrar
                ElevatedButton(
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
                  onPressed: () {},
                  child: const Text("ENTRAR"),
                ),
                const SizedBox(height: 45),

                // Botão Cadastrar
                ElevatedButton(
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignupScreen(),
                      ),
                    );
                  },
                  child: const Text("CADASTRAR-SE"),
                ),
                const SizedBox(height: 45),

                // Esqueci minha senha
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    "ESQUECI MINHA SENHA",
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
}

