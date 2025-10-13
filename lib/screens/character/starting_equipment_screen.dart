// lib/screens/character/starting_equipment_screen.dart

// ignore_for_file: unnecessary_to_list_in_spreads, deprecated_member_use, use_super_parameters

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/starting_equipment_selector.dart';
import '../../selection_manager.dart';
import '../../services/starting_equipment_service.dart';
import '../../utils/app_routes.dart';

class StartingEquipmentScreen extends StatefulWidget {
  const StartingEquipmentScreen({Key? key}) : super(key: key);

  @override
  State<StartingEquipmentScreen> createState() => _StartingEquipmentScreenState();
}

class _StartingEquipmentScreenState extends State<StartingEquipmentScreen> {
  final StartingEquipmentService _equipmentService = StartingEquipmentService();
  Map<int, String> _currentChoices = {};
  bool _isChoicesValid = false;

  @override
  void initState() {
    super.initState();
    _initializeChoices();
  }

  void _initializeChoices() {
    final selectedClass = SelectionManager().selectedClass;
    if (selectedClass != null) {
      _currentChoices = _equipmentService.getDefaultChoices(selectedClass);
      _validateChoices();
    }
  }

  void _onChoicesChanged(Map<int, String> choices) {
    setState(() {
      _currentChoices = choices;
      _validateChoices();
    });
  }

  void _validateChoices() {
    final selectedClass = SelectionManager().selectedClass;
    if (selectedClass != null) {
      _isChoicesValid = _equipmentService.validateChoices(
        className: selectedClass,
        playerChoices: _currentChoices,
      );
    }
  }

  void _mostrarSnackBar(String mensagem, {IconData? icone, Color cor = Colors.red}) {
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

  void _confirmarEscolhas() {
    if (!_isChoicesValid) {
      _mostrarSnackBar(
        'Por favor, complete todas as escolhas de equipamentos antes de continuar.',
        icone: Icons.warning,
        cor: Colors.orange,
      );
      return;
    }

    final selectedClass = SelectionManager().selectedClass;
    if (selectedClass == null) {
      _mostrarSnackBar('Erro: classe não selecionada.');
      return;
    }

    // Salvar escolhas no SelectionManager
    SelectionManager().setStartingEquipmentChoices(_currentChoices);

    // Gerar equipamentos baseados nas escolhas
    final generatedEquipment = _equipmentService.generateEquipmentFromChoices(
      className: selectedClass,
      playerChoices: _currentChoices,
    );

    // Salvar equipamentos gerados
    SelectionManager().setStartingEquipment(generatedEquipment);

    _mostrarSnackBar(
      'Equipamentos selecionados com sucesso!',
      icone: Icons.check,
      cor: Colors.green,
    );

    // Navegar para próxima tela (ex: finalização de personagem)
    // Ajuste a rota conforme necessário
    Navigator.of(context).pushNamed(AppRoutes.characterSheet);
  }

  void _voltarTela() {
    Navigator.of(context).pop();
  }

  Widget _buildSummaryCard() {
    final selectedClass = SelectionManager().selectedClass;
    if (selectedClass == null || _currentChoices.isEmpty) {
      return const SizedBox.shrink();
    }

    final summary = _equipmentService.getChoicesSummary(
      className: selectedClass,
      playerChoices: _currentChoices,
    );

    if (summary.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade900.withOpacity(0.8),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.amber.shade700, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resumo das suas escolhas:',
            style: GoogleFonts.jimNightshade(
              fontSize: 24,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 12),
          ...summary.entries.map((entry) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${entry.key}: ',
                  style: GoogleFonts.cinzel(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.amber.shade200,
                  ),
                ),
                Expanded(
                  child: Text(
                    entry.value,
                    style: GoogleFonts.cinzel(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedClass = SelectionManager().selectedClass;

    return Scaffold(
      body: Stack(
        children: [
          // Fundo
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("lib/assets/images/image_dracon_3.png"),
                fit: BoxFit.cover,
                alignment: Alignment.centerLeft,
              ),
            ),
          ),

          // Camada preta com opacidade
          Container(color: Colors.black.withOpacity(0.65)),

          // Conteúdo
          SafeArea(
            child: Column(
              children: [
                // Header com título e botão voltar
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                        onPressed: _voltarTela,
                      ),
                      Expanded(
                        child: Text(
                          'Equipamentos Iniciais',
                          style: GoogleFonts.jimNightshade(
                            fontSize: 40,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 44), // Para balancear o espaço do IconButton
                    ],
                  ),
                ),

                // Conteúdo principal
                Expanded(
                  child: selectedClass == null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                size: 64,
                                color: Colors.red,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Erro: Classe não selecionada',
                                style: GoogleFonts.cinzel(
                                  fontSize: 24,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.amber.shade700,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: _voltarTela,
                                child: Text(
                                  'Voltar',
                                  style: GoogleFonts.cinzel(color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        )
                      : SingleChildScrollView(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Instruções estilizadas
                              Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(bottom: 20),
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade900.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: Colors.amber.shade700, width: 2),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Configuração de Equipamentos',
                                      style: GoogleFonts.jimNightshade(
                                        fontSize: 28,
                                        color: Colors.amber,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'Como um $selectedClass, você tem direito a equipamentos específicos. '
                                      'Algumas opções permitem escolha entre alternativas. '
                                      'Selecione cuidadosamente, pois isso afetará suas capacidades iniciais.',
                                      style: GoogleFonts.cinzel(
                                        fontSize: 18,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Seletor de equipamentos
                              StartingEquipmentSelector(
                                className: selectedClass,
                                initialChoices: _currentChoices,
                                onChoicesChanged: _onChoicesChanged,
                              ),

                              // Resumo das escolhas
                              _buildSummaryCard(),

                              const SizedBox(height: 24),

                              // Botões de ação estilizados
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: _voltarTela,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.grey.shade700,
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: Text(
                                        'Voltar',
                                        style: GoogleFonts.cinzel(
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    flex: 2,
                                    child: ElevatedButton(
                                      onPressed: _isChoicesValid ? _confirmarEscolhas : null,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: _isChoicesValid 
                                            ? Colors.amber.shade700
                                            : Colors.grey.shade600,
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: Text(
                                        'Confirmar',
                                        style: GoogleFonts.cinzel(
                                          fontSize: 20,
                                          color: _isChoicesValid ? Colors.black : Colors.white70,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 32),
                            ],
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