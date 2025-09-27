// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';


class CharacterSheet extends StatelessWidget {
  const CharacterSheet({super.key});

  // Método para exibir o diálogo de perícias (sem alterações)
  void _showSkillsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.grey.shade900.withOpacity(0.92),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: Colors.amber.shade700, width: 3),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          constraints: const BoxConstraints(maxHeight: 500, maxWidth: 350),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Perícias",
                  style: GoogleFonts.cinzel(
                    fontSize: 26,
                    color: Colors.amber.shade200,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        offset: Offset(1, 1),
                        blurRadius: 2,
                        color: Colors.black.withOpacity(0.7),
                      ),
                    ],
                  ),
                ),
                const Divider(color: Colors.amber, thickness: 1.2),
                _skillGroup("Força", ["Atletismo"]),
                _skillGroup("Destreza", ["Acrobacia", "Furtividade", "Prestidigitação"]),
                _skillGroup("Inteligência", ["Arcanismo", "História", "Investigação", "Natureza", "Religião"]),
                _skillGroup("Sabedoria", ["Intuição", "Medicina", "Percepção", "Sobrevivência", "Lidar com Animais"]),
                _skillGroup("Carisma", ["Atuação", "Enganação", "Intimidação", "Persuasão"]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget auxiliar para grupo de perícias (sem alterações)
  static Widget _skillGroup(String title, List<String> skills) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            Text(
            title,
            style: GoogleFonts.jimNightshade(
              fontSize: 20,
              color: Colors.amber.shade200,
              shadows: [
              Shadow(
                offset: const Offset(1, 1),
                blurRadius: 2,
                color: Colors.black.withOpacity(0.8),
              ),
              ],
            ),
            ),
          const SizedBox(height: 4),
          ...skills.map((s) => Row(
                children: [
                  const Icon(Icons.circle, size: 10, color: Colors.white),
                  const SizedBox(width: 6),
                  Text(s, style: GoogleFonts.cinzel(fontSize: 14, color: Colors.white, shadows: [
                    Shadow(
                      offset: const Offset(1, 1),
                      blurRadius: 2,
                      color: Colors.black.withOpacity(0.8),
                    ),
                  ])),
                ],
              )),
        ],
      ),
    );
  }

  // Método background para envolver o corpo (sem alterações, dependendo do asset)
  Widget background({required Widget child}) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('lib/assets/images/fundo_fogueira.jpeg'), 
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: Colors.transparent, 
      
      // ⚠️ Envolve todo o corpo com o widget 'background'
      body: background(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Nome
                Text(
                  "Van Dammer",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.jimNightshade(
                    fontSize: 64,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        offset: const Offset(2, 2),
                        blurRadius: 4,
                        color: Colors.black.withOpacity(0.7),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),

                // Informações básicas
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _infoBox("Raça", "Humano Base"),
                    _infoBox("Nível", "03"),
                    _infoBox("Classe", "Paladino"),
                    _infoBox("Antecedente", "Acólito"),
                  ],
                ),
                const SizedBox(height: 25),

                // Atributos hexagonais (com clique)
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    HexagonStat(label: "FOR", value: "16", onTap: () => _showSkillsDialog(context)),
                    HexagonStat(label: "DES", value: "10", onTap: () => _showSkillsDialog(context)),
                    HexagonStat(label: "CON", value: "16", onTap: () => _showSkillsDialog(context)),
                    HexagonStat(label: "INT", value: "8", onTap: () => _showSkillsDialog(context)),
                    HexagonStat(label: "SAB", value: "8", onTap: () => _showSkillsDialog(context)),
                    HexagonStat(label: "CAR", value: "14", onTap: () => _showSkillsDialog(context)),
                    
                  ],
                ),
                const SizedBox(height: 25),

                // Ataques e magias
                _sectionTitle("Ataques & Magias"),
                _card(Column(
                  children: [
                    _attackRow("Espada Curta", "+5", "1d6+3 / Corto"),
                    _attackRow("Lança", "+5", "1d6+3 / Perf"),
                    _attackRow("Arco", "+3", "1d8 / Perf"),
                  ],
                )),
                const SizedBox(height: 25),

                // CA e PV em hexágonos maiores
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    HexagonStat(label: "CA", value: "13", size: 100, onTap: () => _showSkillsDialog(context)),
                    HexagonStat(label: "PV", value: "22", size: 100, onTap: () => _showSkillsDialog(context)),
                  ],
                ),
                const SizedBox(height: 25),

                // Equipamentos
                _sectionTitle("Equipamentos"),
                _card(Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Armadura de couro"),
                    Text("Espada Curta"),
                    Text("Escudo"),
                    Text("Rações de viagem"),
                  ],
                )),
                const SizedBox(height: 25),

                // Características e Habilidades
                _sectionTitle("Características & Habilidades"),
                _card(Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Mestre de Arma Grande"),
                    Text("Defesa em Armadura"),
                    Text("Punhos Místicos"),
                    Text("Sentido de Perigo"),
                    Text("Ataque Desarmado"),
                    Text("Aspecto do Lobo"),
                    Text("Sopro de Fogo"),
                  ],
                )),
                const SizedBox(height: 25),

                // Idiomas e Proficiências
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          _sectionTitle("Idiomas"),
                          _card(Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Comum"),
                              Text("Dracônico"),
                            ],
                          )),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        children: [
                          _sectionTitle("Proficiências"),
                          _card(Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Ferramenta Ladra"),
                              Text("Costura"),
                            ],
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Botão de magias
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {},
                  child: Text("Magias", style: GoogleFonts.cinzel(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Widgets auxiliares (ajustados) ---
  
 
  static Widget _infoBox(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade300.withOpacity(0.70), // Opacidade adicionada
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.amber.shade700, width: 2), // Borda em tom dourado
      ),
      child: Column(
        children: [
          Text(
        title,
        style: GoogleFonts.jimNightshade(
          fontSize: 18,
          color: Colors.white,
          shadows: [
            Shadow(
              offset: Offset(1, 1),
              blurRadius: 2,
              color: Colors.black.withOpacity(0.8),
            ),
          ],
        ),
          ),
          Text(
        value,
        style: GoogleFonts.cinzel(
          fontSize: 12,
          color: Colors.white,
          shadows: [
            Shadow(
          offset: Offset(1, 1),
          blurRadius: 2,
          color: Colors.black.withOpacity(0.8),
            ),
            
          ],
        ),
          ),
        ],
      ),
    );
  }

  static Widget _attackRow(String name, String bonus, String damage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              name,
              style: GoogleFonts.cinzel(
                fontSize: 16,
                color: Colors.white,
                shadows: [
                  Shadow(
                    offset: Offset(1, 1),
                    blurRadius: 2,
                    color: Colors.black.withOpacity(0.8),
                  ),
                ],
              ),
            ),
          ),
          Text(
            bonus,
            style: GoogleFonts.cinzel(
              fontSize: 16,
              color: const Color.fromARGB(255, 225, 240, 18),
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            damage,
            style: GoogleFonts.cinzel(
              fontSize: 16,
              color: const Color.fromARGB(255, 49, 41, 41),
              fontWeight: FontWeight.w600,
              
            ),
          ),
        ],
      ),
    );
  }

  static Widget _card(Widget child) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade200.withOpacity(0.70),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.amber.shade700, width: 2), // Borda em tom dourado
      ),
      child: DefaultTextStyle(
        style: GoogleFonts.cinzel(
          fontSize: 16,
          color: Colors.white,
          shadows: [
            Shadow(
              offset: Offset(1, 1),
              blurRadius: 2,
              color: Colors.black.withOpacity(0.8),
            ),
          ],
        ),
        child: child,
      ),
    );
  }

  static Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        title,
        style: GoogleFonts.jimNightshade(
          fontSize: 30,
          color: Colors.white,
          shadows: [
            Shadow(
              offset: const Offset(1, 1),
              blurRadius: 2,
              color: Colors.black.withOpacity(0.8),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget de atributo hexagonal
class HexagonStat extends StatelessWidget {
  final String label;
  final String value;
  final double size;
  final VoidCallback? onTap;

  const HexagonStat({
    super.key,
    required this.label,
    required this.value,
    this.size = 80,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: CustomPaint(
        // Passa a cor para o CustomPainter para que o hexágono tenha fundo escuro
        painter: HexagonPainter(color: Colors.grey.shade800.withOpacity(  0.50)), // Opacidade ajustada para melhor visibilidade
        size: Size(size, size),
        child: Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label,
                    style: GoogleFonts.jimNightshade(
                    fontSize: 22, color: Colors.white)), // Texto em branco para contraste
              Text(value, style: GoogleFonts.cinzel(fontSize: 16, color: Colors.white)), // Texto em branco para contraste
            ],
          ),
        ),
      ),
    );
  }
}

// Desenha o hexágono
class HexagonPainter extends CustomPainter {
  final Color color;

  HexagonPainter({this.color = Colors.white}); // Construtor para definir a cor

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color // Usa a cor passada (agora Colors.grey.shade800)
      ..style = PaintingStyle.fill;

    final Paint border = Paint()
      ..color = Colors.amber.shade700 // Borda em tom dourado
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final Path path = Path();

    final double w = size.width;
    final double h = size.height;
    final double r = w / 2;

    for (int i = 0; i < 6; i++) {
      double angle = pi / 3 * i - pi / 2; // gira para cima
      double x = r + r * cos(angle);
      double y = h / 2 + r * sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path, border);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}