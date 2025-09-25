// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_rpg/selection_manager.dart';
import 'package:app_rpg/screens/ficha/summary_screen.dart';

// Constantes
const double titleFontSize = 80.0;
const double itemFontSize = 28.0;
const double buttonFontSize = 40.0;

class AttributesScreen extends StatefulWidget {
  const AttributesScreen({super.key});

  @override
  State<AttributesScreen> createState() => _AttributesScreenState();
}

class _AttributesScreenState extends State<AttributesScreen> {
  // Atributos iniciais
  final Map<String, int> atributos = {
    "FOR": 8,
    "DES": 8,
    "CON": 8,
    "INT": 8,
    "SAB": 8,
    "CAR": 8,
  };

  int pontosUsados = 0;
  final int maxPontos = 27;

  @override
  void initState() {
    super.initState();
    // Garante que o diálogo de bônus racial só apareça após a tela ser construída
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForCustomRaceBonus(context);
    });
  }

  // Função para calcular modificador
  int calcularMod(int valor) {
    return ((valor - 10) / 2).floor();
  }

  // Função de custo do Point Buy
  int custoAtributo(int valor) {
    if (valor <= 13) return valor - 8;
    if (valor == 14) return 7;
    if (valor == 15) return 9;
    return 0;
  }

  // Atualiza pontos totais
  void atualizarPontos() {
    int total = 0;
    atributos.forEach((_, val) {
      total += custoAtributo(val);
    });
    setState(() {
      pontosUsados = total;
    });
  }

  // Aumentar atributo
  void aumentar(String chave) {
    final atual = atributos[chave]!;
    if (atual < 15) {
      final novo = atual + 1;
      int totalTemp = pontosUsados - custoAtributo(atual) + custoAtributo(novo);
      if (totalTemp <= maxPontos) {
        atributos[chave] = novo;
        atualizarPontos();
      }
    }
  }

  // Diminuir atributo
  void diminuir(String chave) {
    final atual = atributos[chave]!;
    if (atual > 8) {
      final novo = atual - 1;
      atributos[chave] = novo;
      atualizarPontos();
    }
  }

  // SnackBar padronizado
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

  // Explicação MOD/VAL
  void _mostrarExplicacao(String titulo, String mensagem) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(titulo, style: GoogleFonts.jimNightshade(fontSize: 28)),
        content: Text(
          mensagem,
          style: GoogleFonts.imFellEnglish(fontSize: 20),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  // Explicação Point Buy
  void _mostrarAjuda() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Distribuição de Atributos (Point Buy)",
            style: GoogleFonts.jimNightshade(fontSize: 28)),
        content: Text(
          "Você começa com todos os atributos em 8 e possui 27 pontos para distribuir.\n\n"
          "Cada aumento custa pontos:\n"
          "- De 8 até 13 custa 1 ponto por nível.\n"
          "- De 13 para 14 custa 2 pontos.\n"
          "- De 14 para 15 custa 2 pontos.\n\n"
          "O máximo antes dos bônus raciais é 15.\n\n"
          "Dica: use os pontos para fortalecer os atributos que combinam com a classe escolhida!",
          style: GoogleFonts.imFellEnglish(fontSize: 20),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Fechar"),
          ),
        ],
      ),
    );
  }

  // --- LÓGICA DE BÔNUS RACIAL ---

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

  void _checkForCustomRaceBonus(BuildContext context) {
    final race = SelectionManager.selectedRace.value;
    if (race == null) {
      SelectionManager.selectedCustomBonus.value = {};
      return;
    }

    final normalizedRace = _normalizeAssetName(race)!;

    if (normalizedRace == 'gnomo') {
      _showGnomeBonusDialog(context);
    } else if (normalizedRace == 'meioelfo') {
      _showHalfElfBonusDialog(context);
    } else {
      // Limpa bônus customizados para raças sem escolha (importante!)
      SelectionManager.selectedCustomBonus.value = {};
    }
  }

  // Diálogo para Gnomo (+1 DES ou CON)
  void _showGnomeBonusDialog(BuildContext context) {
    String? selectedAttribute;
    
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setStateSB) {
            return AlertDialog(
              title: Text("Bônus Racial de Gnomo", style: GoogleFonts.jimNightshade(fontSize: 28)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Seu personagem Gnomo recebe +2 em INT e mais +1 em uma habilidade à sua escolha (Destreza ou Constituição). Selecione onde aplicar o +1:",
                    style: GoogleFonts.imFellEnglish(fontSize: 20)),
                  RadioListTile<String>(
                    title: const Text('Destreza (DES)'),
                    value: 'DES',
                    groupValue: selectedAttribute,
                    onChanged: (value) => setStateSB(() => selectedAttribute = value),
                  ),
                  RadioListTile<String>(
                    title: const Text('Constituição (CON)'),
                    value: 'CON',
                    groupValue: selectedAttribute,
                    onChanged: (value) => setStateSB(() => selectedAttribute = value),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: selectedAttribute == null
                      ? null
                      : () {
                          SelectionManager.selectedCustomBonus.value = {selectedAttribute!: 1};
                          Navigator.of(dialogContext).pop();
                          _mostrarSnackBar(context, "Bônus de Gnomo (+1 $selectedAttribute) aplicado!", icone: Icons.check_circle, cor: Colors.green);
                        },
                  child: const Text('Confirmar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Diálogo para Meio-Elfo (+1 em Duas Habilidades)
  void _showHalfElfBonusDialog(BuildContext context) {
    Map<String, int> tempBonus = {};
    
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setStateSB) {
            // Meio-Elfo não pode escolher Carisma (CAR)
            final availableAttributes = atributos.keys.where((attr) => attr != 'CAR').toList();
            final selectedCount = tempBonus.keys.length;

            return AlertDialog(
              title: Text("Bônus Racial de Meio-Elfo", style: GoogleFonts.jimNightshade(fontSize: 28)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Seu personagem Meio-Elfo recebe +2 em CAR e mais +1 em duas outras habilidades à sua escolha. Selecione as duas habilidades:",
                    style: GoogleFonts.imFellEnglish(fontSize: 20)),
                  ...availableAttributes.map((attr) {
                    final isSelected = tempBonus.containsKey(attr);
                    
                    return CheckboxListTile(
                      title: Text(attr),
                      value: isSelected,
                      onChanged: (bool? value) {
                        setStateSB(() {
                          if (value == true) {
                            if (selectedCount < 2) {
                              tempBonus[attr] = 1;
                            }
                          } else {
                            tempBonus.remove(attr);
                          }
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                      // Desabilita caixas de seleção se já tiver 2 e não for a atual
                      enabled: isSelected || selectedCount < 2,
                    );
                  }),
                  Text("Selecionado: $selectedCount/2", style: GoogleFonts.imFellEnglish(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: selectedCount != 2
                      ? null
                      : () {
                          SelectionManager.selectedCustomBonus.value = tempBonus;
                          Navigator.of(dialogContext).pop();
                          final bonusList = tempBonus.keys.join(' e ');
                          _mostrarSnackBar(context, "Bônus de Meio-Elfo (+1 em $bonusList) aplicado!", icone: Icons.check_circle, cor: Colors.green);
                        },
                  child: const Text('Confirmar'),
                ),
              ],
            );
          },
        );
      },
    );
  }
  
  // --- FIM LÓGICA DE BÔNUS RACIAL ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fundo
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("lib/assets/images/image_dracon_5.png"),
                fit: BoxFit.cover,
                alignment: Alignment.centerLeft,
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
                "Atributos",
                style: GoogleFonts.jimNightshade(
                  fontSize: titleFontSize,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 20),

              // Tabela de atributos
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF878787).withOpacity(0.35),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    children: [
                      // Cabeçalho
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text("ATR", style: GoogleFonts.jimNightshade(fontSize: itemFontSize, color: Colors.white)),
                          GestureDetector(
                            onTap: () => _mostrarExplicacao("Modificador",
                                "O modificador é derivado do valor do atributo e influencia jogadas de ataque, testes e perícias."),
                            child: Text("MOD", style: GoogleFonts.jimNightshade(fontSize: itemFontSize, color: Colors.white)),
                          ),
                          GestureDetector(
                            onTap: () => _mostrarExplicacao("Valor de Atributo",
                                "O valor do atributo representa a força bruta daquela característica (mínimo 8, máximo 15 antes dos bônus raciais)."),
                            child: Text("VAL", style: GoogleFonts.jimNightshade(fontSize: itemFontSize, color: Colors.white)),
                          ),
                          const SizedBox(width: 80),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Lista de atributos
                      Expanded(
                        child: ListView(
                          children: atributos.keys.map((chave) {
                            final valor = atributos[chave]!;
                            final mod = calcularMod(valor);
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.arrow_downward, color: Colors.red),
                                      onPressed: () => diminuir(chave),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.arrow_upward, color: Colors.green),
                                      onPressed: () => aumentar(chave),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),

                      // Pontuação
                      Text(
                        "Pontos $pontosUsados/$maxPontos",
                        style: GoogleFonts.imFellEnglish(
                            fontSize: 22, color: pontosUsados > maxPontos ? Colors.red : Colors.white),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Botões
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.withOpacity(0.4),
                      minimumSize: const Size(150, 70),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _mostrarAjuda,
                    child: Text("Ajuda",
                        style: GoogleFonts.jimNightshade(
                            fontSize: buttonFontSize, color: Colors.black)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: pontosUsados == maxPontos
                          ? Colors.grey.withOpacity(0.4)
                          : Colors.grey.withOpacity(0.2),
                      minimumSize: const Size(150, 70),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      if (pontosUsados != maxPontos) {
                        _mostrarSnackBar(context,
                            "Você precisa distribuir todos os pontos (27) antes de continuar.",
                            icone: Icons.warning_amber_rounded, cor: Colors.orange);
                      } else {
                        SelectionManager.selectedAttributes.value = atributos;
                        // Verifica se os bônus customizados foram escolhidos antes de avançar, se necessário.
                        // Para o Gnomo e Meio-Elfo, o diálogo garante que a escolha foi feita antes de fechar.
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SummaryScreen()),
                        );
                      }
                    },
                    child: Text("Próximo",
                        style: GoogleFonts.jimNightshade(
                            fontSize: buttonFontSize, color: Colors.black)),
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }
}