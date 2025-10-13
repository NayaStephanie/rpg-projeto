// lib/widgets/starting_equipment_selector.dart

// ignore_for_file: use_super_parameters, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/starting_equipment.dart';
import '../data/starting_equipment_data.dart';

/// Widget para seleção de equipamentos iniciais baseado na classe do personagem
class StartingEquipmentSelector extends StatefulWidget {
  final String className;
  final Map<int, String>? initialChoices;
  final Function(Map<int, String>) onChoicesChanged;

  const StartingEquipmentSelector({
    Key? key,
    required this.className,
    this.initialChoices,
    required this.onChoicesChanged,
  }) : super(key: key);

  @override
  State<StartingEquipmentSelector> createState() => _StartingEquipmentSelectorState();
}

class _StartingEquipmentSelectorState extends State<StartingEquipmentSelector> {
  late Map<int, String> _selectedChoices;
  StartingEquipment? _startingEquipment;

  @override
  void initState() {
    super.initState();
    _startingEquipment = getStartingEquipmentForClass(widget.className);
    _selectedChoices = Map.from(widget.initialChoices ?? {});
    
    // Se não há escolhas iniciais, usar padrões (opção A)
    if (_selectedChoices.isEmpty && _startingEquipment != null) {
      for (int i = 0; i < _startingEquipment!.choices.length; i++) {
        _selectedChoices[i] = 'A';
      }
    }
  }

  @override
  void didUpdateWidget(StartingEquipmentSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.className != widget.className) {
      _startingEquipment = getStartingEquipmentForClass(widget.className);
      _selectedChoices.clear();
      
      // Resetar para padrões
      if (_startingEquipment != null) {
        for (int i = 0; i < _startingEquipment!.choices.length; i++) {
          _selectedChoices[i] = 'A';
        }
      }
      _notifyChanges();
    }
  }

  void _notifyChanges() {
    widget.onChoicesChanged(_selectedChoices);
  }

  void _updateChoice(int index, String choice) {
    setState(() {
      _selectedChoices[index] = choice;
    });
    _notifyChanges();
  }

  @override
  Widget build(BuildContext context) {
    if (_startingEquipment == null) {
      return Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade900.withOpacity(0.8),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.red.shade700, width: 2),
        ),
        child: Text(
          'Equipamentos iniciais não disponíveis para a classe ${widget.className}',
          style: GoogleFonts.cinzel(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade900.withOpacity(0.8),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.amber.shade700, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título
          Text(
            'Equipamentos Iniciais - ${widget.className}',
            style: GoogleFonts.jimNightshade(
              fontSize: 24,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 16),

          // Escolhas
          if (_startingEquipment!.choices.isNotEmpty) ...[
            Text(
              'Faça suas escolhas:',
              style: GoogleFonts.cinzel(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.amber.shade200,
              ),
            ),
            const SizedBox(height: 12),
            
            ...List.generate(_startingEquipment!.choices.length, (index) {
              final choice = _startingEquipment!.choices[index];
              final currentSelection = _selectedChoices[index] ?? 'A';
              
              return _buildChoiceCard(
                index: index,
                choice: choice,
                currentSelection: currentSelection,
              );
            }),
          ],

          // Itens fixos
          if (_startingEquipment!.fixedItems.isNotEmpty) ...[
            const SizedBox(height: 20),
            Text(
              'Equipamentos garantidos:',
              style: GoogleFonts.cinzel(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.amber.shade200,
              ),
            ),
            const SizedBox(height: 8),
            
            ...List.generate(_startingEquipment!.fixedItems.length, (index) {
              final fixedItem = _startingEquipment!.fixedItems[index];
              return _buildFixedItemCard(fixedItem);
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildChoiceCard({
    required int index,
    required EquipmentChoice choice,
    required String currentSelection,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade800.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade700.withOpacity(0.5), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Descrição da escolha
          Text(
            choice.description,
            style: GoogleFonts.cinzel(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          
          // Opções
          Column(
            children: [
              RadioListTile<String>(
                value: 'A',
                groupValue: currentSelection,
                onChanged: (value) => _updateChoice(index, value!),
                title: Text(
                  'A) ${choice.optionA}',
                  style: GoogleFonts.cinzel(
                    fontSize: 15,
                    color: Colors.white70,
                  ),
                ),
                activeColor: Colors.amber.shade700,
                dense: true,
                contentPadding: EdgeInsets.zero,
              ),
              RadioListTile<String>(
                value: 'B',
                groupValue: currentSelection,
                onChanged: (value) => _updateChoice(index, value!),
                title: Text(
                  'B) ${choice.optionB}',
                  style: GoogleFonts.cinzel(
                    fontSize: 15,
                    color: Colors.white70,
                  ),
                ),
                activeColor: Colors.amber.shade700,
                dense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFixedItemCard(FixedEquipment fixedItem) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.green.shade900.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade700, width: 1),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.green.shade400,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fixedItem.item,
                  style: GoogleFonts.cinzel(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                if (fixedItem.description.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    fixedItem.description,
                    style: GoogleFonts.cinzel(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}