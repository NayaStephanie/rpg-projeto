// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_rpg/selection_manager.dart';

class ClassDetailScreen extends StatelessWidget {
  const ClassDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, String> classData =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/assets/images/image_dracon_3.png"), // fundo
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ===== Botões no topo =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.withOpacity(0.7),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(120, 50),
                        textStyle: GoogleFonts.jimNightshade(fontSize: 22),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),


                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Voltar"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.withOpacity(0.7),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(120, 50),
                        textStyle: GoogleFonts.jimNightshade(fontSize: 22),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                       // Salva a classe no ValueNotifier
                        SelectionManager.selectedClass.value = classData["name"];
                        Navigator.pop(context); // volta depois de selecionar
                      },
                      child: const Text("Selecionar"),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // ===== Imagem da classe =====
              Image.asset(classData["img"]!, height: 80),

              const SizedBox(height: 10),

              // ===== Nome da classe =====
              Text(
                classData["name"]!,
                style: GoogleFonts.jimNightshade(
                  fontSize: 36,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              // ===== Descrição rolável =====
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      """
Aumento na pontuação de habilidade: Meio-elfos recebem um bônus de +2 em Carisma e +1 em duas outras habilidades à sua escolha.

Velocidade: 9 metros.

Visão no escuro: até 18 metros.

Ancestralidade Féerica: vantagem contra encantamentos e imunidade a sono mágico.

Versatilidade de Habilidades: proficiência em duas habilidades à sua escolha.

Idiomas: Comum, Élfico e mais um idioma adicional.
                      """,
                      style: GoogleFonts.imFellEnglish(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
