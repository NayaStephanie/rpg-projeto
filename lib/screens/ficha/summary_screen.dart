// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_rpg/selection_manager.dart';
import 'package:app_rpg/race_bonuses.dart'; // Importa a lógica de bônus

// Constantes
const double titleFontSize = 50.0;
const double itemFontSize = 26.0;
const double buttonFontSize = 32.0;

  // Função para normalizar nomes para assets
  String? normalizeAssetName(String? name) {
	if (name == null) return null;
	// Remove acentos e caracteres especiais para nomes de arquivos
	String normalized = name.toLowerCase().replaceAll(' ', '_');
	normalized = normalized
		.replaceAll('á', 'a')
		.replaceAll('ã', 'a')
		.replaceAll('â', 'a')
		.replaceAll('é', 'e')
		.replaceAll('ê', 'e')
		.replaceAll('í', 'i')
		.replaceAll('ó', 'o')
		.replaceAll('ô', 'o')
		.replaceAll('õ', 'o')
		.replaceAll('ú', 'u')
		.replaceAll('ç', 'c');
	return normalized;
  }

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  // Função para normalizar nomes para assets
  // (Removido: função duplicada normalizeAssetName)

// Função para calcular modificador
int calcularMod(int valor) {
  return ((valor - 10) / 2).floor();
}

// Função para calcular o valor FINAL com bônus raciais
Map<String, int> _calcularAtributosFinais() {
  final atributosBase = SelectionManager.selectedAttributes.value;
  final race = SelectionManager.selectedRace.value;
  
  // Usa a função do race_bonuses.dart para obter o total de bônus
  final bonusRacial = getRaceBonus(race);
  
  // 2. Inicializar o mapa final com os valores base
  final Map<String, int> atributosFinais = Map.from(atributosBase);

  // 3. Aplicar os bônus
  bonusRacial.forEach((attr, bonus) {
	if (atributosFinais.containsKey(attr)) {
	  // Aplica o bônus, somando ao valor base distribuído
	  atributosFinais[attr] = (atributosFinais[attr] ?? 0) + bonus;
	}
  });

  return atributosFinais;
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

  // Widget para avatar + nome
  // (Removido: método duplicado buildAvatarCard)

  // Widget para avatar + nome
  Widget buildAvatarCard(String nome, String assetPath) {
	return Column(
	  children: [
		CircleAvatar(
		  radius: 35,
		  backgroundColor: Color.fromARGB(
			(0.35 * 255).toInt(),
			(Colors.grey.r * 255.0).round() & 0xff,
			(Colors.grey.g * 255.0).round() & 0xff,
			(Colors.grey.b * 255.0).round() & 0xff,
		  ),
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

  @override
  Widget build(BuildContext context) {
	// Recupera seleções feitas
	final race = SelectionManager.selectedRace.value;
	final classe = SelectionManager.selectedClass.value;
	final background = SelectionManager.selectedBackground.value;

	// NOVO: Calcula os atributos FINAIS (base + bônus)
	final atributosFinais = _calcularAtributosFinais();

	return Scaffold(
	  body: Stack(
		children: [
		  // Fundo
		  Container(
			decoration: const BoxDecoration(
			  image: DecorationImage(
				image: AssetImage("lib/assets/images/image_dracon_6.png"),
				fit: BoxFit.cover,
				alignment: Alignment.center,
			  ),
			),
		  ),

		  // Camada preta
		  Container(
			color: Color.fromARGB(
			  (0.65 * 255).toInt(),
			  (Colors.black.r * 255.0).round() & 0xff,
			  (Colors.black.g * 255.0).round() & 0xff,
			  (Colors.black.b * 255.0).round() & 0xff,
			),
		  ),

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
				  buildAvatarCard(
					race ?? "Raça",
					"lib/assets/images/racas/${normalizeAssetName(race) ?? 'race'}.png",
				  ),
				  buildAvatarCard(
					classe ?? "Classe",
					"lib/assets/images/classes/${normalizeAssetName(classe) ?? 'class'}.png",
				  ),
				  buildAvatarCard(
					background ?? "Antecedente",
					"lib/assets/images/antecedentes/${normalizeAssetName(background) ?? 'background'}.png",
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
					color: Color.fromARGB(
					  (0.35 * 255).toInt(),
					  0x87,
					  0x87,
					  0x87,
					),
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
					  children: atributosFinais.keys.map((chave) {
						final valor = atributosFinais[chave]!;
						final mod = calcularMod(valor);
						return Padding(
						  padding: const EdgeInsets.symmetric(vertical: 6),
						  child: Row(
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
			  backgroundColor: Color.fromARGB(
				(0.4 * 255).toInt(),
				(Colors.grey.r * 255.0).round() & 0xff,
				(Colors.grey.g * 255.0).round() & 0xff,
				(Colors.grey.b * 255.0).round() & 0xff,
			  ),
			  minimumSize: const Size(180, 70),
			  shape: RoundedRectangleBorder(
				borderRadius: BorderRadius.circular(10),
			  ),
			),
      onPressed: () {
    Navigator.pushNamed(context, '/characterSheet');
        _mostrarSnackBar(context, "Ficha criada!");
      },
			child: Text(
			  "Finalizar",
			  style: GoogleFonts.imFellEnglish(
				fontSize: buttonFontSize,
				color: Colors.white,
			  ),
			),
		  ),
		  const SizedBox(height: 20),

		  // Widget para avatar + nome
		  // (Removido: método duplicado buildAvatarCard)
			],
		  ),
		],
	  ),
	);
  }
}