// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_rpg/selection_manager.dart';

// Constantes
const double titleFontSize = 50.0;
const double itemFontSize = 26.0;
const double buttonFontSize = 32.0;

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  // Função para calcular modificador
  int calcularMod(int valor) {
    return ((valor - 10) / 2).floor();
  }

  // Função para exibir SnackBar customizado
  void _mostrarSnackBar(BuildContext context, String mensagem,
      {IconData? icone, Color cor = Colors.green}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icone ?? Icons.check_circle_outline, color: Colors.white),
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

  @override
  Widget build(BuildContext context) {
    // Recupera seleções feitas
    final race = SelectionManager.selectedRace.value;
    final classe = SelectionManager.selectedClass.value;
    final background = SelectionManager.selectedBackground.value;
    final atributos = SelectionManager.selectedAttributes.value;

    return Scaffold(
      body: Stack(
        children: [
          // Fundo
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("lib/assets/images/image_dracon_5.png"),
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
          ),

          // Camada preta
          Container(color: Colors.black.withOpacity(0.65)),

          // Conteúdo
          Column(
            children: [
              const SizedBox(height: 30),

              // Título
              Text(
                "Resumo da Ficha",
                style: GoogleFonts.jimNightshade(
                  fontSize: titleFontSize,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 20),

              // Ícones + Nomes (Raça, Classe, Antecedente)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildAvatarCard(
                    race ?? "Raça",
                    "lib/assets/images/racas/${_normalizeAssetName(race) ?? 'race'}.png",
                  ),
                  _buildAvatarCard(
                    classe ?? "Classe",
                    "lib/assets/images/classes/${_normalizeAssetName(classe) ?? 'class'}.png",
                  ),
                  _buildAvatarCard(
                    background ?? "Antecedente",
                    "lib/assets/images/antecedentes/${_normalizeAssetName(background) ?? 'background'}.png",
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Tabela de atributos
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF878787).withOpacity(0.35),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      // Cabeçalho
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text("ATR",
                              style: GoogleFonts.jimNightshade(
                                  fontSize: itemFontSize,
                                  color: Colors.white)),
                          Text("MOD",
                              style: GoogleFonts.jimNightshade(
                                  fontSize: itemFontSize,
                                  color: Colors.white)),
                          Text("VAL",
                              style: GoogleFonts.jimNightshade(
                                  fontSize: itemFontSize,
                                  color: Colors.white)),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Lista de atributos
                      Expanded(
                        child: ListView(
                          children: atributos.keys.map((chave) {
                            final valor = atributos[chave]!;
                            final mod = calcularMod(valor);
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 6),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(chave,
                                      style: GoogleFonts.imFellEnglish(
                                          fontSize: 24, color: Colors.white)),
                                  Text(mod.toString(),
                                      style: GoogleFonts.imFellEnglish(
                                          fontSize: 24, color: Colors.white)),
                                  Text(valor.toString(),
                                      style: GoogleFonts.imFellEnglish(
                                          fontSize: 24, color: Colors.white)),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Botão Finalizar/Montar
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.withOpacity(0.4),
                  minimumSize: const Size(180, 70),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  _mostrarSnackBar(
                    context,
                    "Ficha montada com sucesso!",
                    icone: Icons.check_circle_outline,
                    cor: Colors.green,
                  );
                },
                child: Text("Montar",
                    style: GoogleFonts.jimNightshade(
                        fontSize: buttonFontSize, color: Colors.black)),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }

  // Função para normalizar nomes para assets
  String? _normalizeAssetName(String? name) {
    if (name == null) return null;
    return name
        .toLowerCase()
        .replaceAll(RegExp(r'[áàãâä]'), 'a')
        .replaceAll(RegExp(r'[éèêë]'), 'e')
        .replaceAll(RegExp(r'[íìîï]'), 'i')
        .replaceAll(RegExp(r'[óòõôö]'), 'o')
        .replaceAll(RegExp(r'[úùûü]'), 'u')
        .replaceAll(RegExp(r'[ç]'), 'c')
        .replaceAll(RegExp(r'[^a-z0-9_]'), '');
  }

  // Widget para avatar + nome
  Widget _buildAvatarCard(String nome, String assetPath) {
    return Column(
      children: [
        CircleAvatar(
          radius: 35,
          backgroundColor: Colors.grey.withOpacity(0.35),
          backgroundImage: AssetImage(assetPath),
        ),
        const SizedBox(height: 8),
        Text(
          nome,
          style: GoogleFonts.imFellEnglish(fontSize: 20, color: Colors.white),
        ),
      ],
    );
  }
}

