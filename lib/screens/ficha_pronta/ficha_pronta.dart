import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'dart:math';

void main() => runApp(DevicePreview(
      enabled: true,
      builder: (context) => const MyApp(),
    ));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const CharacterSheet(),
    );
  }
}

class CharacterSheet extends StatelessWidget {
  const CharacterSheet({super.key});

  void _showSkillsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          constraints: const BoxConstraints(maxHeight: 500, maxWidth: 350),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Perícias",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const Divider(),
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

  static Widget _skillGroup(String title, List<String> skills) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          ...skills.map((s) => Row(
                children: [
                  const Icon(Icons.circle, size: 10, color: Colors.black),
                  const SizedBox(width: 6),
                  Text(s, style: const TextStyle(fontSize: 14)),
                ],
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade800,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Nome
              const Text(
                "Van Dammer",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
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
              _sectionTitle("Equipamento"),
              _card(Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
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
                children: const [
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
                          children: const [
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
                          children: const [
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
                child: const Text("Magias"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Widgets auxiliares ---
  static Widget _infoBox(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          Text(value, style: const TextStyle(fontSize: 12)),
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
          Expanded(child: Text(name)),
          Text(bonus),
          Text(damage),
        ],
      ),
    );
  }

  static Widget _card(Widget child) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }

  static Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

/// Widget de atributo hexagonal (agora clicável)
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
        painter: HexagonPainter(),
        size: Size(size, size),
        child: Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              Text(value, style: const TextStyle(fontSize: 20)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Desenha o hexágono
class HexagonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final Paint border = Paint()
      ..color = Colors.black
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