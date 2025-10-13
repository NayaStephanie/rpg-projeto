// ignore_for_file: deprecated_member_use, library_prefixes, unnecessary_to_list_in_spreads, prefer_final_fields, avoid_print, use_build_context_synchronously, unnecessary_import, sort_child_properties_last

import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app_rpg/models/armor.dart';
import 'package:app_rpg/models/equipment_item.dart';
import 'package:app_rpg/models/race_class_data.dart' as raceClassData;
import 'package:app_rpg/models/ca_calculator.dart';
import 'package:app_rpg/models/spells_data.dart';
import 'package:app_rpg/models/class_features.dart';
import 'package:app_rpg/models/race_features.dart' as raceFeatureData;
import 'package:app_rpg/models/armor_proficiences.dart';
import 'package:app_rpg/models/skills_data.dart';
import 'package:app_rpg/models/saving_throws.dart';
import 'package:app_rpg/data/languages_data.dart';
import 'package:app_rpg/selection_manager.dart';
import 'package:app_rpg/race_bonuses.dart';
import 'package:app_rpg/models/character_model.dart';
import 'package:app_rpg/services/character_storage_service.dart';
import 'package:app_rpg/services/subscription_service.dart';
import 'package:app_rpg/utils/app_routes.dart';
import 'package:app_rpg/services/avatar_storage_service.dart';


class CharacterSheet extends StatefulWidget {
  final CharacterModel? existingCharacter;
  
  const CharacterSheet({
    super.key,
    this.existingCharacter,
  });

  @override
  State<CharacterSheet> createState() => _CharacterSheetState();
}

class _CharacterSheetState extends State<CharacterSheet> {
  // Controlador para o nome do personagem
  final TextEditingController _nameController = TextEditingController();
  
  // Avatar do personagem
  String? _avatarPath;
  
  // ID do personagem (para distinguir entre criação e edição)
  String? _characterId;
  DateTime? _characterCreatedAt;
  
  int _level = 1;
  String _race = "Humano";
  String _characterClass = "Guerreiro";
  int _inspiracao = 0;

  // Adiciona variáveis para tesouro
  int _gold = 0;
  int _silver = 0;
  int _copper = 0;

  // Lista de equipamentos do personagem
  List<EquipmentItem> _equipment = [];

  // Adiciona listas para rastrear sucessos e falhas de salvaguarda contra a morte
  List<bool> _deathSaveSuccesses = [false, false, false];
  List<bool> _deathSaveFailures = [false, false, false];

  // ATRIBUTOS E MODIFICADORES 
  int _str = 10;
  int _dex = 10;
  int _con = 10;
  int _int = 10;
  int _wis = 10;
  int _cha = 10;

  // CÁLCULO DE MODIFICADORES
  int get _strMod => (_str - 10) ~/ 2;
  int get _dexMod => (_dex - 10) ~/ 2;
  int get _conMod => (_con - 10) ~/ 2;
  int get _intMod => (_int - 10) ~/ 2;
  int get _wisMod => (_wis - 10) ~/ 2;
  int get _chaMod => (_cha - 10) ~/ 2;

  // ARMA E ARMADURA PADRÃO
  Armor _currentArmor = armors[0]; // Começa com Sem Armadura
  bool _hasShield = false;

  int pv = 22;
  late int ca = _calculateCA();

  // Cada nível de magia tem um número de slots e usados
  Map<int, int> maxSpellSlots = {};
  Map<int, int> usedSpellSlots = {};

  Map<String, bool> _preparedSpells = {}; // Para rastrear magias preparadas

  Map<String, bool> _selectedCantrips = {}; // Para rastrear truques selecionados
 
  String _background = "Acólito"; // valor inicial

  late SkillsResult _skillsResult;

  late List<SavingThrow> _savingThrows; // variável para salvaguardas
  int _passivePerception = 10; // valor base

  // Variáveis para idiomas
  List<String> _knownLanguages = []; // Idiomas atualmente conhecidos
  List<String> _selectedAdditionalLanguages = []; // Idiomas escolhidos adicionalmente
  LanguageResult? _languageResult; // Resultado do cálculo de idiomas

// Método auxiliar para obter modificador de atributo
int _getAttributeModifier(String attribute) {
  switch (attribute.toLowerCase()) {
    case 'força':
      return _strMod;
    case 'destreza':
      return _dexMod;
    case 'constituição':
      return _conMod;
    case 'inteligência':
      return _intMod;
    case 'sabedoria':
      return _wisMod;
    case 'carisma':
      return _chaMod;
    default:
      return 0;
  }
}
// Função para calcular quantos truques a classe pode conhecer no nível atual
int _getMaxCantrips(String characterClass, int level) {
  final cantripData = cantripsByLevel[characterClass] ?? {};
  
  // Encontra o nível mais alto que não excede o nível atual
  int maxCantrips = 0;
  for (int cantripLevel in cantripData.keys.toList()..sort()) {
    if (level >= cantripLevel) {
      maxCantrips = cantripData[cantripLevel]!;
    } else {
      break;
    }
  }
  
  return maxCantrips;
}

// MÉTODO: Calcula os idiomas baseado nas escolhas do usuário
void _calculateLanguages() {
  // Calcula idiomas automáticos
  final automaticLanguages = calculateAutomaticLanguages(_race, _characterClass, _background);
  
  // Calcula quantos idiomas extras podem ser escolhidos
  final additionalChoices = calculateTotalLanguageChoices(_race, _characterClass, _background);
  
  // Cria o resultado
  _languageResult = LanguageResult(
    automaticLanguages: automaticLanguages,
    additionalChoices: additionalChoices,
    selectedAdditional: _selectedAdditionalLanguages,
  );
  
  // Atualiza idiomas conhecidos
  _knownLanguages = _languageResult!.allLanguages;
}

// MÉTODO: Exibe diálogo para escolher idiomas adicionais
void _showLanguageSelectionDialog() {
  if (_languageResult == null || _languageResult!.additionalChoices == 0) {
    return;
  }
  
  final availableChoices = getAvailableLanguageChoices(_languageResult!.automaticLanguages);
  
  showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (dialogContext, setDialogState) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: Colors.amber.shade700, width: 3),
        ),
        title: Text(
          "Escolher Idiomas Adicionais",
          style: GoogleFonts.imFellEnglish(color: Colors.amber),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Escolha ${_languageResult!.additionalChoices} idioma(s) adicional(is):",
                style: GoogleFonts.cinzel(color: Colors.white),
              ),
              Text(
                "Selecionados: ${_selectedAdditionalLanguages.length}/${_languageResult!.additionalChoices}",
                style: GoogleFonts.cinzel(color: Colors.amber, fontSize: 12),
              ),
              const SizedBox(height: 16),
              Container(
                height: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.amber.shade700),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView.builder(
                  itemCount: availableChoices.length,
                  itemBuilder: (context, index) {
                    final language = availableChoices[index];
                    final isSelected = _selectedAdditionalLanguages.contains(language);
                    final canSelect = isSelected || _selectedAdditionalLanguages.length < _languageResult!.additionalChoices;
                    
                    return ListTile(
                      title: Text(
                        language,
                        style: GoogleFonts.cinzel(
                          color: canSelect ? Colors.white : Colors.grey,
                        ),
                      ),
                      trailing: Checkbox(
                        value: isSelected,
                        activeColor: Colors.amber.shade700,
                        onChanged: canSelect ? (value) {
                          setDialogState(() {
                            if (value == true) {
                              _selectedAdditionalLanguages.add(language);
                            } else {
                              _selectedAdditionalLanguages.remove(language);
                            }
                          });
                        } : null,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text("Cancelar", style: GoogleFonts.imFellEnglish(color: Colors.white)),
            onPressed: () => Navigator.pop(dialogContext),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber.shade700,
            ),
            child: Text("Confirmar", style: GoogleFonts.imFellEnglish(color: Colors.black)),
            onPressed: _selectedAdditionalLanguages.length == _languageResult!.additionalChoices
                ? () {
                    Navigator.pop(dialogContext);
                    setState(() {
                      _calculateLanguages();
                    });
                  }
                : null,
          ),
        ],
      ),
    ),
  );
}

// Função para contar quantos truques estão selecionados
int _getSelectedCantripsCount(String characterClass) {
  return _selectedCantrips.entries
    .where((entry) => entry.key.startsWith('${characterClass}_0_') && entry.value)
    .length;
}
@override
void initState() {
  super.initState();

  // Verifica se há um personagem existente para carregar
  if (widget.existingCharacter != null) {
    print('🎯 Ficha: Carregando personagem existente: ${widget.existingCharacter!.name}');
    _loadExistingCharacterData(widget.existingCharacter!);
  } else {
    print('🎯 Ficha: Criando novo personagem');
    // PEGA OS DADOS DO SELECTIONMANAGER
    _loadDataFromSelectionManager();

    // INICIALIZA O RESTO BASEADO NOS DADOS CARREGADOS
    _skillsResult = getSkillsForCharacter(_race, _characterClass, _background);
    
    // Carrega perícias salvas se existirem e não estiverem vazias
    final selectionManager = SelectionManager();
    final savedSkills = selectionManager.selectedSkills;
    if (savedSkills.isNotEmpty) {
      print('🎯 Ficha: Carregando perícias salvas: ${savedSkills.map((s) => s.name).join(", ")}');
      _skillsResult = SkillsResult(
        skills: savedSkills,
        classOptions: _skillsResult.classOptions,
        classChoiceCount: _skillsResult.classChoiceCount,
        raceFreeChoices: _skillsResult.raceFreeChoices,
        duplicateChoiceCount: _skillsResult.duplicateChoiceCount,
      );
    } else {
      print('🎯 Ficha: Inicializando com perícias padrão - nenhuma salva encontrada');
    }
  }
  
  _savingThrows = getSavingThrowsForClass(_characterClass);
  _updatePassivePerception();
  _setInitialEquipment(_characterClass);

  // RECALCULA CA E SPELL SLOTS
  ca = _calculateCA();
  maxSpellSlots = _calculateSpellSlots(_characterClass, _level);
  usedSpellSlots = {};
  for (int level in maxSpellSlots.keys) {
    usedSpellSlots[level] = 0;
  }
}

@override
void dispose() {
  _nameController.dispose();
  super.dispose();
}

//MÉTODO: Carrega dados do SelectionManager
void _loadDataFromSelectionManager() {
  // Pega as seleções (com fallbacks para valores padrão)
  final selectionManager = SelectionManager();
  final selectedRace = selectionManager.selectedRace ?? "Humano";
  final selectedClass = selectionManager.selectedClass ?? "Guerreiro";
  final selectedBackground = selectionManager.selectedBackground ?? "Acólito";
  final selectedAttributes = selectionManager.selectedAttributes;
  
  // Atualiza as variáveis da ficha
  setState(() {
    _race = selectedRace;
    _characterClass = selectedClass;
    _background = selectedBackground;
    
    // Atualiza o ouro automaticamente baseado no antecedente
    _gold = raceClassData.getInitialGoldByBackground(selectedBackground);
    
    // Combina equipamentos do antecedente com os equipamentos iniciais da classe selecionados pelo usuário
    List<EquipmentItem> allEquipment = [];
    
    // Adiciona equipamentos do antecedente
    allEquipment.addAll(raceClassData.getInitialEquipmentByBackground(selectedBackground));
    
    // Adiciona equipamentos iniciais da classe (se foram selecionados pelo usuário)
    final startingEquipment = selectionManager.startingEquipment;
    if (startingEquipment.isNotEmpty) {
      allEquipment.addAll(startingEquipment);
      print('🎯 Ficha: Adicionando ${startingEquipment.length} equipamentos iniciais da classe: ${startingEquipment.map((e) => e.name).join(", ")}');
    }
    
    _equipment = allEquipment;
    
    // Aplica os atributos selecionados + bônus raciais
    _applyAttributesWithRacialBonus(selectedAttributes);
    
    // Calcula idiomas baseado nas seleções
    _calculateLanguages();
    
    // Se há idiomas para escolher, mostra o diálogo após um pequeno delay
    if (_languageResult != null && 
        _languageResult!.additionalChoices > 0 && 
        _selectedAdditionalLanguages.length < _languageResult!.additionalChoices) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            _showLanguageSelectionDialog();
          }
        });
      });
    }
  });
}

// MÉTODO: Carrega dados de um personagem existente
void _loadExistingCharacterData(CharacterModel character) {
  setState(() {
    // Dados básicos
    _characterId = character.id; // ✅ Salva o ID para manter na edição
    _characterCreatedAt = character.createdAt; // ✅ Salva a data de criação original
    _nameController.text = character.name;
    _avatarPath = character.avatarPath;
    _level = character.level;
    _race = character.race;
    _characterClass = character.characterClass;
    _background = character.background;
    
    // Atributos - usando os nomes corretos das variáveis
    _str = character.attributes['Força'] ?? 10;
    _dex = character.attributes['Destreza'] ?? 10;
    _con = character.attributes['Constituição'] ?? 10;
    _int = character.attributes['Inteligência'] ?? 10;
    _wis = character.attributes['Sabedoria'] ?? 10;
    _cha = character.attributes['Carisma'] ?? 10;
    
    // Converter perícias do Map<String, bool> para List<Skill>
    final skillsList = <Skill>[];
    final allSkillsMap = {
      'Atletismo': 'Força',
      'Acrobacia': 'Destreza',
      'Furtividade': 'Destreza',
      'Prestidigitação': 'Destreza',
      'Arcanismo': 'Inteligência',
      'História': 'Inteligência',
      'Investigação': 'Inteligência',
      'Natureza': 'Inteligência',
      'Religião': 'Inteligência',
      'Intuição': 'Sabedoria',
      'Medicina': 'Sabedoria',
      'Percepção': 'Sabedoria',
      'Sobrevivência': 'Sabedoria',
      'Adestrar Animais': 'Sabedoria',
      'Enganação': 'Carisma',
      'Intimidação': 'Carisma',
      'Atuação': 'Carisma',
      'Persuasão': 'Carisma',
    };
    
    character.skills.forEach((skillName, isSelected) {
      final skill = Skill(
        name: skillName,
        attribute: allSkillsMap[skillName] ?? 'Desconhecido',
      );
      skill.selected = isSelected;
      skillsList.add(skill);
    });
    
    if (skillsList.isNotEmpty) {
      _skillsResult = SkillsResult(
        skills: skillsList,
        classOptions: [], // Será recalculado se necessário
        classChoiceCount: 0,
        raceFreeChoices: 0,
        duplicateChoiceCount: 0,
      );
    } else {
      _skillsResult = getSkillsForCharacter(_race, _characterClass, _background);
    }
    
    // Outros dados
    _inspiracao = character.inspiration;
    _gold = character.gold;
    _silver = character.silver;
    _copper = character.copper;
    _equipment = character.equipment;
    
    // Carrega idiomas (para compatibilidade com versões antigas)
    if (character.languages.isNotEmpty) {
      // Personagem já tem idiomas salvos - separa automáticos dos escolhidos
      final automaticLanguages = calculateAutomaticLanguages(_race, _characterClass, _background);
      _selectedAdditionalLanguages = character.languages
          .where((lang) => !automaticLanguages.contains(lang))
          .toList();
    } else {
      // Personagem antigo sem idiomas - inicializa vazio
      _selectedAdditionalLanguages = [];
    }
    _calculateLanguages();
  });
  
  print('🎯 Ficha: Personagem ${character.name} carregado com sucesso');
}

// MÉTODO: Salva o personagem atual
Future<void> _saveCharacter() async {
  final name = _nameController.text.trim();
  if (name.isEmpty) {
    _showSnackBar('Por favor, insira um nome para o personagem', isError: true);
    return;
  }

  try {
    // Coleta as perícias selecionadas
    Map<String, bool> skillsMap = {};
    for (var skill in _skillsResult.skills) {
      skillsMap[skill.name] = skill.selected;
    }

    // Determina se é edição ou criação
    bool isEditing = _characterId != null;
    print('🎯 Ficha: ${isEditing ? "Editando" : "Criando"} personagem: $name');

    // Cria o modelo do personagem
    final character = CharacterModel(
      id: _characterId ?? DateTime.now().millisecondsSinceEpoch.toString(), // ✅ Usa ID existente se estiver editando
      name: name,
      avatarPath: _avatarPath,
      race: _race,
      characterClass: _characterClass,
      background: _background,
      level: _level,
      attributes: {
        'FOR': _str,
        'DES': _dex,
        'CON': _con,
        'INT': _int,
        'SAB': _wis,
        'CAR': _cha,
      },
      hitPoints: pv,
      armorClass: ca,
      currentArmor: _currentArmor.name,
      hasShield: _hasShield,
      skills: skillsMap,
      preparedSpells: _preparedSpells,
      selectedCantrips: _selectedCantrips,
      maxSpellSlots: maxSpellSlots,
      usedSpellSlots: usedSpellSlots,
      inspiration: _inspiracao,
      gold: _gold,
      silver: _silver,
      copper: _copper,
      languages: _knownLanguages,
      equipment: _equipment,
      startingEquipmentChoices: SelectionManager().startingEquipmentChoices, // Salva as escolhas de equipamentos iniciais feitas pelo usuário
      deathSaveSuccesses: _deathSaveSuccesses,
      deathSaveFailures: _deathSaveFailures,
      createdAt: _characterCreatedAt ?? DateTime.now(), // ✅ Usa data original se estiver editando
      lastModified: DateTime.now(),
    );

    // Salva o personagem
    final saveResult = await CharacterStorageService.saveCharacter(character);
    
    if (saveResult.success) {
      _showSnackBar('Personagem salvo com sucesso!', isError: false);
    } else if (saveResult.requiresUpgrade) {
      _showUpgradeDialog(saveResult.errorMessage ?? 'Limite de personagens atingido');
    } else {
      _showSnackBar(saveResult.errorMessage ?? 'Erro ao salvar personagem', isError: true);
    }
  } catch (e) {
    _showSnackBar('Erro inesperado ao salvar: $e', isError: true);
  }
}

// MÉTODO: Exibe mensagens para o usuário
void _showSnackBar(String message, {required bool isError}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: isError ? Colors.red : Colors.green,
      duration: const Duration(seconds: 3),
    ),
  );
}

// MÉTODO: Exibe dialog de upgrade para premium
void _showUpgradeDialog(String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: const Color(0xFF2C1810),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(color: Colors.amber, width: 2),
        ),
        title: Row(
          children: [
            Icon(
              Icons.workspace_premium,
              color: Colors.amber,
              size: 28,
            ),
            const SizedBox(width: 12),
            Text(
              'Upgrade Premium',
              style: GoogleFonts.cinzel(
                color: Colors.amber,
                fontSize: 20,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: GoogleFonts.cinzel(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Benefícios Premium:',
              style: GoogleFonts.cinzel(
                color: Colors.amber,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            ...['🔓 Personagens ilimitados', 
                '☁️ Armazenamento na nuvem', 
                '🔄 Backup automático',
                '⚡ Suporte prioritário',
                '🎮 Recursos exclusivos']
              .map((benefit) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text(
                  benefit,
                  style: GoogleFonts.imFellEnglish(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Mais Tarde',
              style: GoogleFonts.cinzel(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              _handleUpgradeToPremium();
            },
            child: Text(
              'Fazer Upgrade',
              style: GoogleFonts.cinzel(
                fontSize: 16,
              ),
            ),
          ),
        ],
      );
    },
  );
}

// MÉTODO: Lida com o upgrade para premium
Future<void> _handleUpgradeToPremium() async {
  // Mostra loading
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      backgroundColor: const Color(0xFF2C1810),
      content: Row(
        children: [
          CircularProgressIndicator(color: Colors.amber),
          const SizedBox(width: 20),
          Text(
            'Processando upgrade...',
            style: GoogleFonts.imFellEnglish(color: Colors.white),
          ),
        ],
      ),
    ),
  );

  try {
    // Simula processamento (em produção seria integração com pagamento)
    await Future.delayed(const Duration(seconds: 2));
    
    // Faz o upgrade
    final success = await SubscriptionService.upgradeToPremium();
    
    Navigator.of(context).pop(); // Remove loading
    
    if (success) {
      _showSnackBar('Upgrade realizado com sucesso! Bem-vindo ao Premium! 🎉', isError: false);
      // Agora pode tentar salvar novamente
      _saveCharacter();
    } else {
      _showSnackBar('Erro ao processar upgrade. Tente novamente.', isError: true);
    }
  } catch (e) {
    Navigator.of(context).pop(); // Remove loading
    _showSnackBar('Erro ao processar upgrade: $e', isError: true);
  }
}

// MÉTODO: Aplica atributos com bônus racial
void _applyAttributesWithRacialBonus(Map<String, int> baseAttributes) {
  // Pega os bônus raciais usando sua função existente
  final racialBonus = getRaceBonus(_race);
  
  // Aplica os valores base + bônus racial
  _str = (baseAttributes['FOR'] ?? 10) + (racialBonus['FOR'] ?? 0);
  _dex = (baseAttributes['DES'] ?? 10) + (racialBonus['DES'] ?? 0);
  _con = (baseAttributes['CON'] ?? 10) + (racialBonus['CON'] ?? 0);
  _int = (baseAttributes['INT'] ?? 10) + (racialBonus['INT'] ?? 0);
  _wis = (baseAttributes['SAB'] ?? 10) + (racialBonus['SAB'] ?? 0);
  _cha = (baseAttributes['CAR'] ?? 10) + (racialBonus['CAR'] ?? 0);
}

// MÉTODO: Mostra preview da imagem antes de confirmar
void _showImagePreview(XFile imageFile) {
  print('🖼️ Mostrando preview da imagem: ${imageFile.path}');
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(color: Colors.amber, width: 2),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.amber, width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Preview da Imagem',
                style: GoogleFonts.imFellEnglish(
                  color: Colors.amber,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 20),
              // Preview da imagem
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.amber, width: 3),
                ),
                child: ClipOval(
                  child: FutureBuilder<Uint8List>(
                    future: imageFile.readAsBytes(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Image.memory(
                          snapshot.data!,
                          fit: BoxFit.cover,
                          width: 200,
                          height: 200,
                        );
                      } else if (snapshot.hasError) {
                        print('🖼️ ERRO ao carregar preview: ${snapshot.error}');
                        return Container(
                          color: Colors.grey.shade800,
                          child: const Icon(
                            Icons.error,
                            color: Colors.red,
                            size: 50,
                          ),
                        );
                      } else {
                        return Container(
                          color: Colors.grey.shade800,
                          child: const CircularProgressIndicator(
                            color: Colors.amber,
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Esta imagem ficará perfeita para o seu personagem!',
                style: GoogleFonts.imFellEnglish(
                  color: Colors.white,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade700,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      print('🖼️ Preview cancelado');
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Cancelar',
                      style: GoogleFonts.cinzel(),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _saveSelectedAvatar(imageFile);
                    },
                    child: Text(
                      'Confirmar',
                      style: GoogleFonts.cinzel(
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

// MÉTODO: Seleciona uma imagem para o avatar do personagem
Future<void> _selectAvatar() async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: const Color(0xFF2C1810),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(color: Colors.amber, width: 2),
        ),
        title: Text(
          'Avatar do Personagem',
          style: GoogleFonts.imFellEnglish(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Orientações sobre a imagem
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.amber.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.info_outline, color: Colors.amber, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Orientações para a Imagem',
                          style: GoogleFonts.imFellEnglish(
                            color: Colors.amber,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildImageTip('📐', 'Formato: Quadrado (1:1) é ideal'),
                    _buildImageTip('📏', 'Tamanho: Mínimo 200x200 pixels'),
                    _buildImageTip('💾', 'Peso: Máximo 5MB'),
                    _buildImageTip('🖼️', 'Tipos: JPG, PNG, WEBP'),
                    _buildImageTip('👤', 'Dica: Fotos de rosto ficam melhores'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              // Opções de seleção
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.amber),
                title: Text(
                  'Escolher da Galeria',
                  style: GoogleFonts.imFellEnglish(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                subtitle: Text(
                  'Selecionar uma foto já salva',
                  style: GoogleFonts.imFellEnglish(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _pickImageFromGallery();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.amber),
                title: Text(
                  'Tirar Foto',
                  style: GoogleFonts.imFellEnglish(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                subtitle: Text(
                  'Usar a câmera do dispositivo',
                  style: GoogleFonts.imFellEnglish(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _pickImageFromCamera();
                },
              ),
              if (_avatarPath != null)
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: Text(
                    'Remover Avatar',
                    style: GoogleFonts.imFellEnglish(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text(
                    'Voltar ao ícone padrão',
                    style: GoogleFonts.imFellEnglish(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    _removeAvatar();
                  },
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancelar',
              style: GoogleFonts.cinzel(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ),
        ],
      );
    },
  );
}

// Widget helper para as dicas de imagem
Widget _buildImageTip(String emoji, String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 14)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.imFellEnglish(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
      ],
    ),
  );
}

// MÉTODO: Seleciona imagem da galeria
Future<void> _pickImageFromGallery() async {
  print('🖼️ Iniciando seleção da galeria...');
  try {
    // Para Flutter Web, usamos uma abordagem mais direta
    final image = await AvatarStorageService.pickAvatarImage(fromCamera: false);
    print('🖼️ Imagem selecionada: ${image?.path}');
    
    if (image != null) {
      print('🖼️ Validando imagem...');
      // Valida a imagem antes de mostrar preview
      final validation = await AvatarStorageService.validateImage(image);
      print('🖼️ Resultado da validação: ${validation.isValid}');
      
      if (validation.isValid) {
        print('🖼️ Imagem válida, salvando diretamente...');
        // Para web, vamos salvar diretamente sem preview para evitar problemas
        await _saveSelectedAvatar(image);
      } else {
        print('🖼️ Imagem inválida: ${validation.errorMessage}');
        _showImageValidationError(validation.errorMessage ?? 'Imagem inválida');
      }
    } else {
      print('🖼️ Nenhuma imagem foi selecionada');
      _showSnackBar('Nenhuma imagem foi selecionada', isError: false);
    }
  } catch (e) {
    print('🖼️ ERRO na galeria: $e');
    _showSnackBar('Erro ao selecionar imagem da galeria: $e', isError: true);
  }
}

// MÉTODO: Seleciona imagem da câmera
Future<void> _pickImageFromCamera() async {
  print('📷 Iniciando câmera...');
  try {
    final image = await AvatarStorageService.pickAvatarImage(fromCamera: true);
    print('📷 Imagem capturada: ${image?.path}');
    
    if (image != null) {
      print('📷 Validando imagem...');
      // Valida a imagem antes de mostrar preview
      final validation = await AvatarStorageService.validateImage(image);
      print('📷 Resultado da validação: ${validation.isValid}');
      
      if (validation.isValid) {
        print('📷 Imagem válida, mostrando preview...');
        _showImagePreview(image);
      } else {
        print('📷 Imagem inválida: ${validation.errorMessage}');
        _showImageValidationError(validation.errorMessage ?? 'Imagem inválida');
      }
    } else {
      print('📷 Nenhuma foto foi tirada');
      _showSnackBar('Nenhuma foto foi tirada', isError: false);
    }
  } catch (e) {
    print('📷 ERRO na câmera: $e');
    _showSnackBar('Erro ao tirar foto: $e', isError: true);
  }
}

// MÉTODO: Mostra erro de validação de imagem com mais detalhes
void _showImageValidationError(String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: const Color(0xFF2C1810),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(color: Colors.amber, width: 2),
        ),
        title: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(width: 8),
            Text(
              'Imagem Inválida',
              style: GoogleFonts.cinzel(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: GoogleFonts.imFellEnglish(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.amber.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Requisitos da Imagem:',
                    style: GoogleFonts.cinzel(
                      color: Colors.amber,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildRequirement('✅ Formato: JPG, PNG ou WEBP'),
                  _buildRequirement('✅ Tamanho: Máximo 5MB'),
                  _buildRequirement('✅ Qualidade: Mínimo 200x200 pixels'),
                  _buildRequirement('✅ Proporção: Quadrada é ideal'),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Entendi',
              style: GoogleFonts.cinzel(
                color: Colors.amber,
                fontSize: 16,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _selectAvatar(); // Volta para a seleção
            },
            child: Text(
              'Tentar Novamente',
              style: GoogleFonts.cinzel(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      );
    },
  );
}

// Widget helper para requisitos
Widget _buildRequirement(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 1),
    child: Text(
      text,
      style: GoogleFonts.imFellEnglish(
        color: Colors.white,
        fontSize: 12,
      ),
    ),
  );
}

// MÉTODO: Salva a imagem selecionada
Future<void> _saveSelectedAvatar(XFile imageFile) async {
  // Mostra loading
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: const Color(0xFF2C1810),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: Colors.amber),
            const SizedBox(height: 16),
            Text(
              'Processando imagem...',
              style: GoogleFonts.imFellEnglish(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    },
  );

  try {
    // Gera um ID temporário para salvar a imagem
    final tempId = DateTime.now().millisecondsSinceEpoch.toString();
    final savedPath = await AvatarStorageService.saveAvatarImage(imageFile, tempId);
    
    // Fecha o loading
    Navigator.of(context).pop();
    
    if (savedPath != null) {
      setState(() {
        _avatarPath = savedPath;
      });
      
      // Mostra sucesso com informações da imagem
      final fileSize = await imageFile.length();
      final sizeInMB = (fileSize / (1024 * 1024)).toStringAsFixed(1);
      
      _showSnackBar(
        'Avatar salvo com sucesso! (${sizeInMB}MB)', 
        isError: false,
      );
    } else {
      _showSnackBar('Erro ao salvar avatar', isError: true);
    }
  } catch (e) {
    // Fecha o loading em caso de erro
    Navigator.of(context).pop();
    _showSnackBar('Erro ao processar imagem: $e', isError: true);
  }
}

// MÉTODO: Remove o avatar atual
void _removeAvatar() {
  setState(() {
    _avatarPath = null;
  });
  _showSnackBar('Avatar removido', isError: false);
}

  // FUNÇÃO: Calcula os slots de magia baseado na classe e nível
  Map<int, int> _calculateSpellSlots(String characterClass, int level) {
    Map<int, int> slots = {};
    
    // Adiciona verificação de nulidade e normalização
  if (characterClass.isEmpty || level < 1) {
    return slots;
  }
  
  switch (characterClass.toUpperCase().trim()) {
    case "PALADINO":
    case "PATRULHEIRO":
      // Semi-conjuradores: começam no nível 2
      if (level >= 2) {
        if (level >= 17) {
          slots = {1: 4, 2: 3, 3: 3, 4: 3, 5: 2};
        } else if (level >= 13) {
          slots = {1: 4, 2: 3, 3: 3, 4: 1};
        } else if (level >= 9) {
          slots = {1: 4, 2: 3, 3: 2};
        } else if (level >= 5) {
          slots = {1: 4, 2: 2};
        } else if (level >= 3) {
          slots = {1: 3};
        } else if (level >= 2) {
          slots = {1: 2};
        }
      }
      break;
      
    case "BRUXO":
      // Bruxos têm mecânica especial: poucos slots de alto nível
      if (level >= 1) {
        int slotLevel = 1;
        int numSlots = 1;
        
        if (level >= 17) { slotLevel = 5; numSlots = 4; }
        else if (level >= 11) { slotLevel = 5; numSlots = 3; }
        else if (level >= 9) { slotLevel = 5; numSlots = 2; }
        else if (level >= 7) { slotLevel = 4; numSlots = 2; }
        else if (level >= 5) { slotLevel = 3; numSlots = 2; }
        else if (level >= 3) { slotLevel = 2; numSlots = 2; }
        else if (level >= 2) { slotLevel = 1; numSlots = 2; }
        else { slotLevel = 1; numSlots = 1; }
        
        slots[slotLevel] = numSlots;
      }
      break;
      
    case "MAGO":
    case "FEITICEIRO":
    case "CLÉRIGO":
    case "DRUIDA":
    case "BARDO":
      // Conjuradores completos
      if (level >= 1) {
        // Tabela completa de progressão de slots
        if (level >= 20) { slots = {1: 4, 2: 3, 3: 3, 4: 3, 5: 3, 6: 2, 7: 2, 8: 1, 9: 1}; }
        else if (level >= 19) { slots = {1: 4, 2: 3, 3: 3, 4: 3, 5: 3, 6: 2, 7: 1, 8: 1, 9: 1}; }
        else if (level >= 18) { slots = {1: 4, 2: 3, 3: 3, 4: 3, 5: 3, 6: 1, 7: 1, 8: 1, 9: 1}; }
        else if (level >= 17) { slots = {1: 4, 2: 3, 3: 3, 4: 3, 5: 2, 6: 1, 7: 1, 8: 1, 9: 1}; }
        else if (level >= 15) { slots = {1: 4, 2: 3, 3: 3, 4: 3, 5: 2, 6: 1, 7: 1, 8: 1}; }
        else if (level >= 13) { slots = {1: 4, 2: 3, 3: 3, 4: 3, 5: 2, 6: 1, 7: 1}; }
        else if (level >= 11) { slots = {1: 4, 2: 3, 3: 3, 4: 3, 5: 2, 6: 1}; }
        else if (level >= 9) { slots = {1: 4, 2: 3, 3: 3, 4: 3, 5: 1}; }
        else if (level >= 7) { slots = {1: 4, 2: 3, 3: 3, 4: 1}; }
        else if (level >= 5) { slots = {1: 4, 2: 3, 3: 2}; }
        else if (level >= 3) { slots = {1: 4, 2: 2}; }
        else if (level >= 2) { slots = {1: 3}; }
        else if (level >= 1) { slots = {1: 2}; }
      }
      break;
      
    default:
      // Classes sem magia - retorna mapa vazio
      break;
  }
  
  return slots;
}

  //  Método auxiliar para definir o equipamento inicial baseado na classe
  void _setInitialEquipment(String characterClass) {
    switch (characterClass) {
      case "Paladino":
        _currentArmor = armors.firstWhere((a) => a.name == "Placas");
        _hasShield = true;
        break;
      case "Guerreiro":
        _currentArmor = armors.firstWhere((a) => a.name == "Cota de Malha");
        _hasShield = true;
        break;
      case "Bruxo":
      case "Ladino":
      case "Bardo":
        _currentArmor = armors.firstWhere((a) => a.name == "Couro");
        _hasShield = false;
        break;
      case "Clérigo":
      case "Druida":
      case "Patrulheiro":
        _currentArmor = armors.firstWhere((a) => a.name == "Cota de Escamas");
        _hasShield = true;
        break;
      case "Mago":
      case "Feiticeiro":
        _currentArmor = armors[0];
        _hasShield = false;
        break;
      case "Bárbaro":
      case "Monge":
        _currentArmor = armors[0];
        _hasShield = false;
        break;
      default:
        _currentArmor = armors[0];
        _hasShield = false;
        break;
    }
  }

// Método para calcular percepção passiva
void _updatePassivePerception() {
  setState(() {
    // Base: 10 + modificador de Sabedoria
    int baseValue = 10 + _wisMod;
    
    // Verifica se tem proficiência em Percepção
    final perceptionSkill = _skillsResult.skills
        .where((skill) => skill.name == 'Percepção' && skill.selected)
        .firstOrNull;
    
    if (perceptionSkill != null) {
      int proficiencyBonus = (_level - 1) ~/ 4 + 2;
      baseValue += proficiencyBonus;
    }
    
    _passivePerception = baseValue;
  });
}

  // Lógica de CÁLCULO DA CA
  int _calculateCA() {
    // CA Monge: 10 + DES Mod + SAB Mod (Só se estiver sem armadura)
    if (_characterClass == "Monge" && _currentArmor.type == ArmorType.none) {
      return 10 + _dexMod + _wisMod + (_hasShield ? 2 : 0);
    }

    // Valor padrão: usa o CACalculator normalmente
    return CACalculator.calculate(
      characterClass: _characterClass,
      currentArmor: _currentArmor,
      dexMod: _dexMod,
      conMod: _conMod,
      shield: _hasShield,
      mageArmor: false,
    );
  }

  // Método para exibir o diálogo de perícias
void _showSkillsDialog(BuildContext context
  ) {
  final result = _skillsResult;

  // Quantidade de perícias extras que a classe pode escolher
  final int maxChoices = classSkillChoiceCount[_characterClass] ?? 2;

  // CORREÇÃO: O total deve ser classChoiceCount + raceFreeChoices
  // duplicateChoiceCount não deve ser SOMADO, ele já está incluído no classChoiceCount
  final int totalMaxChoices = result.classChoiceCount + result.raceFreeChoices;
  
  print('Max choices from map: $maxChoices');
  print('Total calculated choices: $totalMaxChoices');
  print('Breakdown: classChoiceCount(${result.classChoiceCount}) + raceFreeChoices(${result.raceFreeChoices}) = $totalMaxChoices');

  showDialog(
    context: context,
    builder: (ctx) {
      return Dialog(
        backgroundColor: Colors.grey.shade900.withOpacity(0.92),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: Colors.amber.shade700, width: 3),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          constraints: const BoxConstraints(maxHeight: 500, maxWidth: 350),
          child: StatefulBuilder(
            builder: (ctx, setState) {
              // conta quantas estão selecionadas
              int selectedCount = result.skills.where((s) => s.selected && !s.fixed).length;

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // título
                    Text(
                      "PERÍCIAS",
                      style: GoogleFonts.cinzel(
                        fontSize: 24,
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        shadows: [
                          Shadow(
                            offset: const Offset(1, 1),
                            blurRadius: 2,
                            color: Colors.black.withOpacity(0.7),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Divider(color: Colors.amber.shade600, thickness: 1.5),

                    // informações da classe
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        "Classe: $_characterClass\nRaça: $_race\nAntecedente: $_background",
                        style: GoogleFonts.imFellEnglish(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ),

                    // instrução
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                         "Você pode escolher até $totalMaxChoices perícias adicionais.\nSelecionadas: $selectedCount",
                        style: GoogleFonts.imFellEnglish(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // agrupamento por atributo
                    ..._buildGroupedSkills(result.skills, setState, selectedCount, totalMaxChoices),

                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          // Atualiza o estado principal com as perícias selecionadas
                          this.setState(() {
                            _skillsResult = result;
                          });
                          
                          // Salva as perícias selecionadas no SelectionManager
                          SelectionManager().setSelectedSkills(result.skills);
                          
                          Navigator.pop(ctx);
                        },
                        child: Text(
                          "Salvar",
                          style: GoogleFonts.cinzel(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      );
    },
  );
}

/// constrói a lista agrupada de perícias por atributo
List<Widget> _buildGroupedSkills(
  List<Skill> skills,
  void Function(void Function()) setState,
  int selectedCount,
  int maxChoices,
) {
  final Map<String, List<Skill>> grouped = {};
  for (var skill in skills) {
    grouped.putIfAbsent(skill.attribute, () => []).add(skill);
  }

  return grouped.entries.map((entry) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // título do atributo
          Text(
            entry.key.toUpperCase(),
            style: GoogleFonts.cinzel(
              fontSize: 18,
              color: Colors.amber.shade200,
              fontWeight: FontWeight.bold,
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

          // lista de perícias do atributo
          ...entry.value.map((skill) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  Checkbox(
                    value: skill.selected,
                    activeColor: Colors.amber.shade700,
                    checkColor: Colors.black,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    onChanged: skill.fixed
                        ? null // fixa não pode ser alterada
                        : (bool? value) {
                            setState(() {
                              if (value == true) {
                                if (selectedCount < maxChoices) {
                                  skill.selected = true;
                                }
                              } else {
                                skill.selected = false;
                              }
                            });
                          },
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      skill.name,
                      style: GoogleFonts.imFellEnglish(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    _getSkillModifier(skill),
                    style: GoogleFonts.cinzel(
                      fontSize: 12,
                      color: Colors.amber.shade300,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }).toList();
}


// Método para calcular o modificador de uma perícia
String _getSkillModifier(Skill skill) {
  int modifier = 0;

  switch (skill.attribute.toLowerCase()) {
    case 'força':
      modifier = _strMod; // ✅ Agora usa a variável real
      break;
    case 'destreza':
      modifier = _dexMod;
      break;
    case 'constituição':
      modifier = _conMod;
      break;
    case 'inteligência':
      modifier = _intMod; // ✅ Agora usa a variável real
      break;
    case 'sabedoria':
      modifier = _wisMod;
      break;
    case 'carisma':
      modifier = _chaMod; // ✅ Agora usa a variável real
      break;
  }

  if (skill.selected) {
    modifier += 2 + ((_level - 1) ~/ 4); // bônus proficiência
  }

  return modifier >= 0 ? '+$modifier' : '$modifier';
}

  // MÉTODO PARA ABRIR O DIÁLOGO DE PV
  Future<void> _showPVDialog() async {
    final result = await showDialog<int>(
      context: context,
      builder: (dialogContext) {
        int tempValue = 0;
        String action = "aumentar";

        return StatefulBuilder(
          builder: (builderContext, dialogSetState) {
            return AlertDialog(
              backgroundColor: Colors.grey.shade900,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: BorderSide(color: Colors.amber.shade700, width: 3),
              ),
              title: Text("Alterar PV (Atual: $pv)", style: GoogleFonts.imFellEnglish(color: Colors.amber)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ChoiceChip(
                        label: Text(
                          "Aumentar",
                          style: GoogleFonts.imFellEnglish(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                        selected: action == "aumentar",
                        selectedColor: Colors.green.shade700,
                        onSelected: (selected) {
                          dialogSetState(() {
                            action = "aumentar";
                          });
                        },
                      ),
                      const SizedBox(width: 10),
                      ChoiceChip(
                        label: Text(
                          "Diminuir",
                          style: GoogleFonts.imFellEnglish(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                        selected: action == "diminuir",
                        selectedColor: const Color.fromARGB(255, 234, 72, 8),
                        onSelected: (selected) {
                          dialogSetState(() {
                            action = "diminuir";
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Quantidade",
                      labelStyle: TextStyle(color: Colors.white, fontStyle: GoogleFonts.imFellEnglish().fontStyle),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.amber),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    onChanged: (v) {
                      tempValue = int.tryParse(v) ?? 0;
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: Text("Cancelar", style: GoogleFonts.imFellEnglish(color: Colors.white)),
                  onPressed: () => Navigator.pop(builderContext),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber.shade700,
                  ),
                  child: Text("OK", style: GoogleFonts.imFellEnglish(color: Colors.black)),
                  onPressed: () {
                    int newValue = pv;
                    if (action == "aumentar") {
                      newValue += tempValue;
                    } else {
                      newValue -= tempValue;
                      if (newValue < 0) newValue = 0;
                    }
                    Navigator.pop(builderContext, newValue);
                  },
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null) {
      setState(() {
        pv = result;
      });
    }
  }

  // Retorna o nível máximo de magias que a classe pode ter
  int maxLevelForClass(String className) {
    switch (className.toUpperCase()) {
      case "PALADINO":
      case "PATRULHEIRO":
        return 5;
      case "BRUXO":
        return 5;
      case "MAGO":
      case "FEITICEIRO":
      case "CLÉRIGO":
      case "DRUIDA":
      case "BARDO":
        return 9;
      default:
        return 0;
    }
  }

// Exibir o diálogo de Magias

void _showSpellsDialog(BuildContext context) {
  final currentClass = _characterClass.trim();
  final cantrips = cantripsByClass[currentClass] ?? [];
  final spellsForClass = spellsByClass[currentClass] ?? {};

  int maxSpellLevel = 0;
  int classMax = maxLevelForClass(currentClass);

  if (classMax > 0) {
    if (_level >= 17) {
      maxSpellLevel = classMax >= 9 ? 9 : classMax;
    } else if (_level >= 15) {
      maxSpellLevel = classMax >= 8 ? 8 : classMax;
    } else if (_level >= 13) {
      maxSpellLevel = classMax >= 7 ? 7 : classMax;
    } else if (_level >= 11) {
      maxSpellLevel = classMax >= 6 ? 6 : classMax;
    } else if (_level >= 9) {
      maxSpellLevel = classMax >= 5 ? 5 : classMax;
    } else if (_level >= 7) {
      maxSpellLevel = classMax >= 4 ? 4 : classMax;
    } else if (_level >= 5) {
      maxSpellLevel = classMax >= 3 ? 3 : classMax;
    } else if (_level >= 3) {
      maxSpellLevel = classMax >= 2 ? 2 : classMax;
    } else if (_level >= 1) {
      maxSpellLevel = classMax >= 1 ? 1 : 0;
    }
  }

  showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (dialogContext, setDialogState) => Dialog(
        backgroundColor: Colors.grey.shade900.withOpacity(0.92),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: Colors.amber.shade700, width: 3),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          constraints: const BoxConstraints(maxHeight: 600, maxWidth: 350),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Magias de $_characterClass (Nível $_level)",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.jimNightshade(
                    fontSize: 24,
                    color: Colors.amber.shade200,
                  ),
                ),
                const Divider(color: Colors.amber, thickness: 1.2),

                // Truques (Cantrips)
                if (cantrips.isNotEmpty) ...[
                  _sectionTitle("Truques"),
                  _spellsCard(cantrips, spellLevel: 0, onSpellToggle: ()  => setDialogState(() {})),
                  const SizedBox(height: 16),
                ],

                // Mostra apenas os níveis de magia com slots disponíveis
                for (int level = 1; level <= maxSpellLevel; level++) ...[
                  if ((maxSpellSlots[level] ?? 0) > 0) ...[
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Nível $level",
                            style: GoogleFonts.jimNightshade(
                              fontSize: 22,
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
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(maxSpellSlots[level] ?? 0, (index) {
                            return GestureDetector(
                              onTap: () {
                                setDialogState(() {
                                  usedSpellSlots[level] = usedSpellSlots[level]! > index
                                      ? index
                                      : index + 1;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 2),
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: (usedSpellSlots[level] ?? 0) > index
                                    ? Colors.grey.shade600
                                    : Colors.amber.shade700,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 1),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _spellsCard(
                      spellsForClass[level] ?? [],
                      spellLevel: level,
                      onSpellToggle: () => setDialogState(() {}),
                    ),
                    const SizedBox(height: 16),
                  ],
                ],
                if (maxSpellSlots.isEmpty) ...[
                  Text(
                    "Esta classe não possui magias no nível $_level",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cinzel(fontSize: 16, color: Colors.white),
                  ),
                ],

                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text(
                    "Fechar",
                    style: GoogleFonts.jimNightshade(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
  // Widget auxiliar para exibir a lista de magias em um cartão
Widget _spellsCard(List<String> spells, {required int spellLevel, Function? onSpellToggle}) {
  // ...existing code...
  // O resto do método permanece igual
  final classesPreparam = ['Mago', 'Clérigo', 'Paladino', 'Druida'];
  final precisaPrepararMagias = classesPreparam.contains(_characterClass);

  final isTruco = spellLevel == 0;
  final maxCantrips = isTruco ? _getMaxCantrips(_characterClass, _level) : 0;
  final selectedCantripsCount = isTruco ? _getSelectedCantripsCount(_characterClass) : 0;
  
  return _card(
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isTruco && maxCantrips > 0) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              "Selecionados: $selectedCantripsCount/$maxCantrips",
              style: GoogleFonts.cinzel(
                fontSize: 14,
                color: selectedCantripsCount >= maxCantrips 
                  ? Colors.red.shade300 
                  : Colors.amber.shade300,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        ...spells.map((spell) {
          final spellKey = '${_characterClass}_${spellLevel}_$spell';
          
          final isSelected = isTruco 
            ? (_selectedCantrips[spellKey] ?? false)
            : (_preparedSpells[spellKey] ?? false);
          
          final canSelectMoreCantrips = isTruco 
            ? (selectedCantripsCount < maxCantrips || isSelected)
            : true;
          
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                if ((isTruco && maxCantrips > 0) || 
                    (precisaPrepararMagias && spellLevel > 0)) ...[
                  Checkbox(
                    value: isSelected,
                    activeColor: Colors.amber.shade700,
                    checkColor: Colors.black,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    onChanged: canSelectMoreCantrips ? (bool? value) {
                      if (isTruco) {
                        _selectedCantrips[spellKey] = value ?? false;
                      } else {
                        _preparedSpells[spellKey] = value ?? false;
                      }
                      
                      if (onSpellToggle != null) {
                        onSpellToggle();
                      }
                      setState(() {});
                    } : null,
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Text(
                    spell,
                    style: GoogleFonts.cinzel(
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: (isTruco && !canSelectMoreCantrips && !isSelected)
                        ? Colors.white.withOpacity(0.5)
                        : Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    ),
  );
}

// Adicione também limpeza quando o nível muda (se você tem um método para isso)
void _changeLevel(int newLevel) {
  setState(() {
    _level = newLevel;
    
    // Recalcula slots de magia
    maxSpellSlots = _calculateSpellSlots(_characterClass, _level);
    usedSpellSlots = {};
    for (int level in maxSpellSlots.keys) {
      usedSpellSlots[level] = 0;
    }
    
    // Verifica se o número de truques mudou e limpa seleções se necessário
    final newMaxCantrips = _getMaxCantrips(_characterClass, _level);
    final currentSelected = _getSelectedCantripsCount(_characterClass);
    
    if (currentSelected > newMaxCantrips) {
      // Remove truques excedentes (mantém apenas os primeiros selecionados)
      final selectedEntries = _selectedCantrips.entries
        .where((entry) => entry.key.startsWith('${_characterClass}_0_') && entry.value)
        .take(newMaxCantrips)
        .toList();
      
      // Limpa todos os truques da classe atual
      _selectedCantrips.removeWhere((key, value) => key.startsWith('${_characterClass}_0_'));
      
      // Re-adiciona apenas os permitidos
      for (var entry in selectedEntries) {
        _selectedCantrips[entry.key] = true;
      }
    }
  });
}

  // Método background para envolver o corpo
  Widget background({required Widget child}) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('lib/assets/images/image_fundo.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
  
  // Widget auxiliar para as caixas de informação
  Widget _infoBox(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 49, 34, 28).withOpacity(0.80),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.amber.shade700, width: 2),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: GoogleFonts.jimNightshade(
              fontSize: 16,
              color: Colors.amber,
              shadows: [
                Shadow(
                  offset: const Offset(1, 1),
                  blurRadius: 2,
                  color: Colors.black.withOpacity(0.8),
                ),
              ],
            ),
          ),
          Text(
            value,
            style: GoogleFonts.cinzel(
              fontSize: 10,
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
        ],
      ),
    );
  }

  // Widget auxiliar para linha de ataque e magia
  Widget _attackRow(String name, String bonus, String damage) {
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
                    offset: const Offset(1, 1),
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
          const SizedBox(width: 15),
          Text(
            damage,
            style: GoogleFonts.cinzel(
              fontSize: 16,
              color: Colors.amber,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // Widget auxiliar para "cartão" de seção
  Widget _card(Widget child) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 49, 34, 28).withOpacity(0.80),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.amber.shade700, width: 2),
      ),
      child: DefaultTextStyle(
        style: GoogleFonts.imFellEnglish(
          fontSize: 18,
          color: Colors.white,
          shadows: [
            Shadow(
              offset: const Offset(0.5, 0.5),
              blurRadius: 1,
              color: Colors.white54,
            ),
            Shadow(
              offset: const Offset(1, 1),
              blurRadius: 2,
              color: Colors.black.withOpacity(0.8),
            ),
          ],
        ),
        child: child,
      ),
    );
  }

  // Widget auxiliar para título de seção
  Widget _sectionTitle(String title) {
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

  // WIDGET: Exibe o nome da característica e a descrição logo abaixo
  Widget _featureRow(String name, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: GoogleFonts.cinzel(
              fontSize: 16,
              color: Colors.amber,
            ),
          ),
          Text(
            description,
            style: GoogleFonts.imFellEnglish(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
Widget _infoDisplay(String title, String value) {
  return Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 49, 34, 28).withOpacity(0.80),
      borderRadius: BorderRadius.circular(6),
      border: Border.all(color: Colors.amber.shade700, width: 2),
    ),
    child: Column(
      children: [
        Text(
          title,
          style: GoogleFonts.jimNightshade(
            fontSize: 16,
            color: Colors.amber,
            shadows: [
              Shadow(
                offset: const Offset(1, 1),
                blurRadius: 2,
                color: Colors.black.withOpacity(0.8),
              ),
            ],
          ),
        ),
        Text(
          value,
          style: GoogleFonts.cinzel(
            fontSize: 10,
            color: Colors.white,
          ),
        ),
      ],
    ),
  );
}
  // Adiciona um widget auxiliar para caixas de tesouro editáveis
  Widget _editableInfoBox(String title, int value, ValueChanged<int> onChanged) {
    TextEditingController controller = TextEditingController(text: value.toString());
    return Container(
      width: 70,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.amber.shade700, width: 2),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: GoogleFonts.jimNightshade(
              fontSize: 24,
              color: Colors.amber,
              shadows: [
                Shadow(
                  offset: const Offset(1, 1),
                  blurRadius: 2,
                  color: Colors.black.withOpacity(0.8),
                ),
              ],
            ),
          ),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: GoogleFonts.cinzel(fontSize: 18, color: Colors.white),
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 4),
            ),
            textAlign: TextAlign.center,
            onSubmitted: (val) {
              int parsed = int.tryParse(val) ?? 0;
              onChanged(parsed);
            },
          ),
        ],
      ),
    );
  }

  // Método para exibir diálogo com detalhes dos equipamentos
  void _showEquipmentDetailsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2C1810),
          title: Text(
            "Detalhes dos Equipamentos",
            style: GoogleFonts.cinzel(
              color: Colors.amber,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: _equipment.map((item) => Card(
                  color: const Color(0xFF1A0F08),
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                item.toString(),
                                style: GoogleFonts.cinzel(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.amber.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                item.category,
                                style: GoogleFonts.cinzel(
                                  color: Colors.amber,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.description,
                          style: GoogleFonts.cinzel(
                            color: Colors.grey[300],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                )).toList(),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Fechar",
                style: GoogleFonts.cinzel(
                  color: Colors.amber,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasShieldProficiency = [
      "Bárbaro", "Clérigo", "Druida", "Guerreiro", "Paladino", "Patrulheiro"
    ].contains(_characterClass);

    return Scaffold(
      backgroundColor: Colors.transparent, 
      body: background(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Botão de voltar para home
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          AppRoutes.home,
                          (route) => false,
                        );
                      },
                      icon: const Icon(
                        Icons.home,
                        color: Colors.white,
                        size: 32,
                      ),
                      tooltip: 'Voltar ao Menu Principal',
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 8),
                // Avatar e Nome
                Row(
                  children: [
                    // Avatar do personagem
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: _selectAvatar,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.amber,
                                width: 3,
                              ),
                              color: Colors.grey.shade800,
                            ),
                            child: _avatarPath != null
                                ? ClipOval(
                                    child: kIsWeb
                                        ? Image.network(
                                            _avatarPath!,
                                            fit: BoxFit.cover,
                                            width: 100,
                                            height: 100,
                                            errorBuilder: (context, error, stackTrace) {
                                              return const Icon(
                                                Icons.person_add,
                                                color: Colors.white,
                                                size: 40,
                                              );
                                            },
                                          )
                                        : Image.file(
                                            File(_avatarPath!),
                                            fit: BoxFit.cover,
                                            width: 100,
                                            height: 100,
                                            errorBuilder: (context, error, stackTrace) {
                                              return const Icon(
                                                Icons.person_add,
                                                color: Colors.white,
                                                size: 40,
                                              );
                                            },
                                          ),
                                  )
                                : AnimatedContainer(
                                    duration: const Duration(seconds: 2),
                                    curve: Curves.easeInOut,
                                    child: const Icon(
                                      Icons.person_add,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                  ),
                          ),
                        ),
                        // Indicador de qualidade da imagem
                        if (_avatarPath != null)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        // Dica visual para editar
                        if (_avatarPath != null)
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.amber.withOpacity(0.9),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.edit,
                                color: Colors.black,
                                size: 16,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    // Campo do nome com dica para avatar
                    Expanded(
                      child: Column(
                        children: [
                          TextField(
                            controller: _nameController,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.jimNightshade(
                              color: Colors.white,
                              fontSize: 28,
                            ),
                            decoration: const InputDecoration(
                              hintText: 'Nome do Personagem',
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                            ),
                          ),
                          // Dica do avatar
                          if (_avatarPath == null)
                            Text(
                              '👈 Toque no círculo para adicionar uma foto',
                              style: GoogleFonts.cinzel(
                                color: Colors.amber.withOpacity(0.7),
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                  const SizedBox(height: 15),

                  // Botão Salvar Personagem
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: _saveCharacter,
                      icon: const Icon(Icons.save, color: Colors.white),
                      label: Text(
                        'Salvar Personagem',
                        style: GoogleFonts.jimNightshade(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B4513),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Informações básicas
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    // RAÇA - agora só informativo
                    Expanded(
                      child: _infoDisplay("Raça", _race),
                    ),
                    const SizedBox(width: 8),

                    // NÍVEL - permanece editável
                    Expanded(
                      child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () async {
                        final result = await showDialog<int>(
                        context: context,
                        builder: (dialogContext) {
                          int tempLevel = _level;
                          return StatefulBuilder(
                          builder: (context, setDialogState) {
                            return AlertDialog(
                            backgroundColor: Colors.grey.shade900,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                              side: BorderSide(color: Colors.amber.shade700, width: 3),
                            ),
                            title: Text(
                              "Alterar Nível",
                              style: GoogleFonts.imFellEnglish(color: Colors.amber),
                            ),
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                              IconButton(
                                icon: Icon(Icons.remove, color: tempLevel > 1 ? Colors.amber : Colors.grey),
                                onPressed: tempLevel > 1
                                  ? () => setDialogState(() => tempLevel--)
                                  : null,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                tempLevel.toString(),
                                style: GoogleFonts.cinzel(fontSize: 28, color: Colors.white),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.add, color: tempLevel < 20 ? Colors.amber : Colors.grey),
                                onPressed: tempLevel < 20
                                  ? () => setDialogState(() => tempLevel++)
                                  : null,
                              ),
                              ],
                            ),
                            actions: [
                              TextButton(
                              child: Text("Cancelar", style: GoogleFonts.imFellEnglish(color: Colors.white)),
                              onPressed: () => Navigator.pop(dialogContext),
                              ),
                              ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber.shade700,
                              ),
                              child: Text("OK", style: GoogleFonts.imFellEnglish(color: Colors.black)),
                              onPressed: () => Navigator.pop(dialogContext, tempLevel),
                              ),
                            ],
                            );
                          },
                          );
                        },
                        );
                        if (result != null && result != _level) {
                        _changeLevel(result);
                        setState(() {
                          ca = _calculateCA();
                        });
                        }
                      },
                      child: _infoBox("Nível", _level.toString()),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // CLASSE - agora só informativo
                    Expanded(
                      child: _infoDisplay("Classe", _characterClass),
                    ),
                    const SizedBox(width: 8),

                    // ANTECEDENTE - agora só informativo
                    Expanded(
                      child: _infoDisplay("Antecedente", _background),
                    ),
                    ],
                  ),
                  const SizedBox(height: 25),

                  // Atributos hexagonais
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                    HexagonStat(label: "FOR", value: _str.toString(), onTap: () => _showSkillsDialog(context)),
                    HexagonStat(label: "DES", value: _dex.toString(), onTap: () => _showSkillsDialog(context)),
                    HexagonStat(label: "CON", value: _con.toString(), onTap: () => _showSkillsDialog(context)),
                    HexagonStat(label: "INT", value: _int.toString(), onTap: () => _showSkillsDialog(context)),
                    HexagonStat(label: "SAB", value: _wis.toString(), onTap: () => _showSkillsDialog(context)),
                    HexagonStat(label: "CAR", value: _cha.toString(), onTap: () => _showSkillsDialog(context)),
                    ],
                  ),
                  const SizedBox(height: 25),

                  // Inspiração, Proficiência e Iniciativa
                  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () async {
                          final result = await showDialog<int>(
                            context: context,
                            builder: (dialogContext) {
                              int tempInspiration = _inspiracao;
                              return StatefulBuilder(
                                builder: (context, setDialogState) {
                                  return AlertDialog(
                                    backgroundColor: Colors.grey.shade900,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                      side: BorderSide(color: Colors.amber.shade700, width: 3),
                                    ),
                                    title: Text(
                                      "Alterar Inspiração",
                                      style: GoogleFonts.imFellEnglish(color: Colors.amber),
                                    ),
                                    content: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.remove, color: tempInspiration > 0 ? Colors.amber : Colors.grey),
                                          onPressed: tempInspiration > 0
                                            ? () => setDialogState(() => tempInspiration--)
                                            : null,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 16),
                                          child: Text(
                                            tempInspiration.toString(),
                                            style: GoogleFonts.cinzel(fontSize: 28, color: Colors.white),
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.add, color: tempInspiration < 99 ? Colors.amber : Colors.grey),
                                          onPressed: tempInspiration < 99
                                            ? () => setDialogState(() => tempInspiration++)
                                            : null,
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        child: Text("Cancelar", style: GoogleFonts.imFellEnglish(color: Colors.white)),
                                        onPressed: () => Navigator.pop(dialogContext),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.amber.shade700,
                                        ),
                                        child: Text("OK", style: GoogleFonts.imFellEnglish(color: Colors.black)),
                                        onPressed: () => Navigator.pop(dialogContext, tempInspiration),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          );
                          if (result != null && result != _inspiracao) {
                            setState(() {
                              _inspiracao = result;
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          margin: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade800.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.amber.shade700,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.amber.shade200,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "Inspiração",
                                    style: GoogleFonts.jimNightshade(
                                      fontSize: 18,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                          offset: const Offset(1, 1),
                                          blurRadius: 2,
                                          color: Colors.brown.withOpacity(0.7),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _inspiracao.toString(),
                                style: GoogleFonts.jimNightshade(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber.shade200,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(6),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade800.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.amber.shade700, width: 2),
                        ),
                        child: Column(
                          children: [
                            Text(
                              "Proficiência",
                              style: GoogleFonts.jimNightshade(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "+${2 + ((_level - 1) ~/ 4)}",
                              style: GoogleFonts.jimNightshade(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber.shade200,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(6),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade800.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.amber.shade700, width: 2),
                        ),
                        child: Column(
                          children: [
                            Text(
                              "Iniciativa",
                              style: GoogleFonts.jimNightshade(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              _dexMod.toString(),
                              style: GoogleFonts.jimNightshade(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber.shade200,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Nova linha com percepção passiva e salvaguardas
                Row(
                  children: [
                  // Percepção Passiva (1/3 da largura)
                  Expanded(
                    flex: 1,
                    child: Container(
                    margin: const EdgeInsets.all(6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.amber.shade700, width: 2),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      Text(
                        "Sabedoria Passiva",
                        style: GoogleFonts.jimNightshade(
                        fontSize: 18,
                        color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        _passivePerception.toString(),
                        style: GoogleFonts.jimNightshade(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber.shade200,
                        ),
                      ),
                      Text(
                        "(Percepção)",
                        style: GoogleFonts.cinzel(
                        fontSize: 11,
                        color: Colors.amber.shade200,
                        ),
                      ),
                      ],
                    ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Salvaguardas (2/3 da largura)
                  Expanded(
                    flex: 2,
                    child: Container(
                    margin: const EdgeInsets.all(6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.amber.shade700, width: 2),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Text(
                        "Salvaguardas",
                        style: GoogleFonts.jimNightshade(
                        fontSize: 18,
                        color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ..._savingThrows.map((savingThrow) {
                        int attributeMod = _getAttributeModifier(savingThrow.attribute);
                        int proficiencyBonus = savingThrow.proficient ? ((_level - 1) ~/ 4 + 2) : 0;
                        int totalBonus = attributeMod + proficiencyBonus;
                        String bonusText = totalBonus >= 0 ? '+$totalBonus' : '$totalBonus';

                        return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          children: [
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                            border: Border.all(color: Colors.amber.shade700),
                            borderRadius: BorderRadius.circular(2),
                            color: savingThrow.proficient ? Colors.amber.shade700 : Colors.transparent,
                            ),
                            child: savingThrow.proficient
                              ? Icon(Icons.check, size: 12, color: Colors.black)
                              : null,
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 30,
                            alignment: Alignment.center,
                            child: Text(
                            bonusText,
                            style: GoogleFonts.cinzel(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                            savingThrow.name,
                            style: GoogleFonts.cinzel(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                            ),
                          ),
                          ],
                        ),
                        );
                      }).toList(),
                      ],
                    ),
                    ),
                  ),
                  ],
                ),

                // Ataques e magias
                _sectionTitle("Ataques & Magias"),
                _card(
                  Column(
                    children: raceClassData.classAttacks[_characterClass]?.map((attack) {
                      return _attackRow(
                        attack['name']!,
                        attack['bonus']!,
                        attack['damage']!,
                      );
                    }).toList() ??
                    [
                      Center(
                        child: Text(
                          "Sem ataques iniciais definidos para esta classe",
                          style: GoogleFonts.cinzel(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 25),

                // CA e PV em hexágonos maiores
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    HexagonStat(
                      label: "CA",
                      value: ca.toString(),
                      size: 100,
                  
                    ),
                    HexagonStat(
                      label: "PV",
                      value: pv.toString(),
                      size: 100,
                      onTap: _showPVDialog,
                    ),
                  ],
                ),
                const SizedBox(height: 25),

                _sectionTitle("Salvaguarda contra a Morte"),
                _card(
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 70,
                            child: Text(
                              'Sucessos',
                              style: GoogleFonts.cinzel(
                                fontSize: 14,
                                color: Colors.amber,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          const SizedBox(width: 10),
                          ...List.generate(
                            3,
                            (i) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _deathSaveSuccesses[i] = !_deathSaveSuccesses[i];
                                  });
                                },
                                child: Icon(
                                  _deathSaveSuccesses[i] ? Icons.check_circle : Icons.circle_outlined,
                                  color: Colors.amber,
                                  size: 28,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 70,
                            child: Text(
                              'Falhas',
                              style: GoogleFonts.cinzel(
                                fontSize: 14,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          const SizedBox(width: 10),
                          ...List.generate(
                            3,
                            (i) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _deathSaveFailures[i] = !_deathSaveFailures[i];
                                  });
                                },
                                child: Icon(
                                  _deathSaveFailures[i] ? Icons.cancel : Icons.circle_outlined,
                                  color: Colors.grey,
                                  size: 28,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ),
                const SizedBox(height: 25),

                _sectionTitle("Tesouro"),
                _card(
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _editableInfoBox("Ouro", _gold, (val) {
                        setState(() {
                          _gold = val;
                        });
                      }),
                      _editableInfoBox("Prata", _silver, (val) {
                        setState(() {
                          _silver = val;
                        });
                      }),
                      _editableInfoBox("Cobre", _copper, (val) {
                        setState(() {
                          _copper = val;
                        });
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 25),

                // Equipamentos
                _sectionTitle("Equipamentos"),
                _card(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_equipment.isEmpty)
                        Text(
                          "Nenhum equipamento",
                          style: GoogleFonts.cinzel(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        )
                      else
                        ..._equipment.map((item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  item.toString(),
                                  style: GoogleFonts.cinzel(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  item.category,
                                  style: GoogleFonts.cinzel(
                                    fontSize: 14,
                                    color: Colors.amber,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )).toList(),
                      if (_equipment.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        const Divider(color: Colors.amber, thickness: 1),
                        TextButton.icon(
                          onPressed: () => _showEquipmentDetailsDialog(),
                          icon: const Icon(Icons.info_outline, color: Colors.amber),
                          label: Text(
                            "Ver Detalhes",
                            style: GoogleFonts.cinzel(
                              color: Colors.amber,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 25),

                // Características & Habilidades
                _sectionTitle("Características & Habilidades"),
                _card(
                  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                    "Características de Raça ($_race):",
                    style: GoogleFonts.cinzel(
                      fontSize: 18,
                      color: Colors.amber,
                    ),
                    ),
                    const Divider(color: Colors.amber, thickness: 1),
                    ...raceFeatureData.raceFeatures
                      .where((f) => f.raca == _race.split(' ')[0])
                      .map(
                      (feature) => _featureRow(
                        feature.nome,
                        feature.descricao,
                      ),
                      ),
                    const SizedBox(height: 4),
                    ...?raceClassData.raceFeatures[_race]?.map(
                    (feature) => Padding(
                      padding: const EdgeInsets.only(bottom: 2.0),
                      child: Text("• $feature"),
                    ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                    "Características de Classe ($_characterClass):",
                    style: GoogleFonts.cinzel(
                      fontSize: 18,
                      color: Colors.amber,
                    ),
                    ),
                    const Divider(color: Colors.amber, thickness: 1),
                    ...classFeatures
                      .where((f) => f.classe == _characterClass && f.nivel <= _level)
                      .map(
                      (feature) => _featureRow(
                        "Nível ${feature.nivel}: ${feature.nome}",
                        feature.descricao,
                      ),
                      ),
                  ],
                  ),
                ),
                const SizedBox(height: 25),

                // Equipamentos
                _sectionTitle("Equipamentos"),
                _card(
                  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                    children: [
                      Icon(
                      Icons.security,
                      color: Colors.amber.shade700,
                      size: 20,
                      ),
                      const SizedBox(width: 10),
                      Text(
                      "Armadura:",
                      style: GoogleFonts.cinzel(
                        fontSize: 16,
                        color: Colors.amber,
                        shadows: [
                        Shadow(
                          offset: const Offset(1, 1),
                          blurRadius: 2,
                          color: Colors.black.withOpacity(0.7),
                        ),
                        ],
                      ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                      child: DropdownButton<Armor>(
                        value: _currentArmor,
                        dropdownColor: Colors.grey.shade800.withOpacity(0.9),
                        style: GoogleFonts.imFellEnglish(fontSize: 14, color: Colors.white),
                        underline: const SizedBox(),
                        isExpanded: true,
                        items: armors
                          .where((armor) => classArmorProficiencies[_characterClass]!
                            .contains(armor.type))
                          .map((armor) {
                        return DropdownMenuItem<Armor>(
                          value: armor,
                          child: Text("${armor.name} (CA Base: ${armor.baseAC})"),
                        );
                        }).toList(),
                        onChanged: (Armor? selected) {
                        if (selected != null) {
                          setState(() {
                          _currentArmor = selected;
                          ca = _calculateCA();
                          });
                        }
                        },
                      ),
                      ),
                    ],
                    ),
                    Row(
                    children: [
                      Icon(
                      Icons.shield,
                      color: _hasShield ? Colors.amber.shade700 : Colors.grey.shade600,
                      size: 24,
                      ),
                      const SizedBox(width: 10),
                      Text(
                      "Escudo:",
                      style: GoogleFonts.cinzel(
                        fontSize: 18,
                        color: Colors.amber,
                        shadows: [
                        Shadow(
                          offset: const Offset(1, 1),
                          blurRadius: 2,
                          color: Colors.black.withOpacity(0.7),
                        ),
                        ],
                      ),
                      ),
                      const SizedBox(width: 10),
                      Checkbox(
                      value: _hasShield,
                      activeColor: Colors.amber.shade700,
                      checkColor: Colors.black,
                      onChanged: hasShieldProficiency
                        ? (val) {
                          setState(() {
                            _hasShield = val ?? false;
                            ca = _calculateCA();
                          });
                          }
                        : null,
                      ),
                      Text(
                      _hasShield ? "Sim (+2 CA)" : "Não",
                      style: GoogleFonts.cinzel(
                        fontSize: 15,
                        color: _hasShield ? Colors.amber : Colors.white70,
                        fontStyle: FontStyle.italic,
                      ),
                      ),
                    ],
                    ),
                  ],
                  ),
                ),
                const SizedBox(height: 25),

                // Idiomas e Proficiências
                Row(
                  children: [
                  Expanded(
                    child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _sectionTitle("Idiomas"),
                          if (_languageResult != null && _languageResult!.additionalChoices > 0)
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: Colors.amber.shade700,
                                size: 20,
                              ),
                              onPressed: _showLanguageSelectionDialog,
                              tooltip: 'Escolher idiomas adicionais',
                            ),
                        ],
                      ),
                      _card(
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_knownLanguages.isNotEmpty) ...[
                              // Idiomas automáticos
                              if (_languageResult?.automaticLanguages.isNotEmpty == true) ...[
                                Text(
                                  "Automáticos:",
                                  style: GoogleFonts.cinzel(
                                    color: Colors.amber,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                ..._languageResult!.automaticLanguages.map(
                                  (lang) => Padding(
                                    padding: const EdgeInsets.only(left: 8, bottom: 2),
                                    child: Text(
                                      "• $lang",
                                      style: GoogleFonts.cinzel(color: Colors.white, fontSize: 14),
                                    ),
                                  ),
                                ),
                                if (_selectedAdditionalLanguages.isNotEmpty) 
                                  const SizedBox(height: 8),
                              ],
                              // Idiomas escolhidos
                              if (_selectedAdditionalLanguages.isNotEmpty) ...[
                                Text(
                                  "Escolhidos:",
                                  style: GoogleFonts.cinzel(
                                    color: Colors.blue.shade300,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                ..._selectedAdditionalLanguages.map(
                                  (lang) => Padding(
                                    padding: const EdgeInsets.only(left: 8, bottom: 2),
                                    child: Text(
                                      "• $lang",
                                      style: GoogleFonts.cinzel(color: Colors.blue.shade100, fontSize: 14),
                                    ),
                                  ),
                                ),
                              ],
                              // Indicador de idiomas disponíveis para escolha
                              if (_languageResult != null && 
                                  _selectedAdditionalLanguages.length < _languageResult!.additionalChoices) ...[
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.amber.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: Colors.amber.withOpacity(0.3)),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.info_outline,
                                        color: Colors.amber,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          "Você pode escolher ${_languageResult!.additionalChoices - _selectedAdditionalLanguages.length} idioma(s) adicional(is)",
                                          style: GoogleFonts.cinzel(
                                            color: Colors.amber,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ] else ...[
                              const Text("Nenhum idioma conhecido"),
                            ],
                          ],
                        ),
                      ),
                    ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                    children: [
                      _sectionTitle("Proficiências"),
                      _card(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: raceClassData.classProficiencies[_characterClass]
                            ?.map((prof) => Text(prof))
                            .toList() ??
                          [const Text("Nenhuma")],
                      ),
                      ),
                    ],
                    ),
                  ),
                  ],
                ),
                const SizedBox(height: 30),

                // Botão de magias
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.withOpacity(0.4),
                    minimumSize: const Size(150, 70),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => _showSpellsDialog(context),
                  child: Text("Magias", style: GoogleFonts.jimNightshade(color: Colors.white, fontSize: 28)),
                ),
              ],
            ),
          ),
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
        painter: HexagonPainter(color: Colors.grey.shade800.withOpacity(0.50)),
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
                  fontSize: 22, color: Colors.white)),
              Text(value, style: GoogleFonts.cinzel(fontSize: 16, color: Colors.white)),
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

  HexagonPainter({this.color = Colors.white});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final Paint border = Paint()
      ..color = Colors.amber.shade700
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final Path path = Path();

    final double w = size.width;
    final double h = size.height;
    final double r = w / 2;

    for (int i = 0; i < 6; i++) {
      double angle = pi / 3 * i - pi / 2;
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