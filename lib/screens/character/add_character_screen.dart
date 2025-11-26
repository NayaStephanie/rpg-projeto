// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../services/firestore_service.dart';
// local storage removed: saves now go directly to Firestore
import '../../models/character_model.dart';
import '../../models/equipment_item.dart';

class AddCharacterScreen extends StatefulWidget {
  const AddCharacterScreen({super.key});

  @override
  State<AddCharacterScreen> createState() => _AddCharacterScreenState();
}

class _AddCharacterScreenState extends State<AddCharacterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtl = TextEditingController();
  final _raceCtl = TextEditingController();
  final _classCtl = TextEditingController();
  final _levelCtl = TextEditingController();
  final _hpCtl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _nameCtl.dispose();
    _raceCtl.dispose();
    _classCtl.dispose();
    _levelCtl.dispose();
    _hpCtl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      // Cria o modelo do personagem
      final id = DateTime.now().millisecondsSinceEpoch.toString();
      final character = CharacterModel(
        id: id,
        name: _nameCtl.text.trim(),
        avatarPath: null,
        race: _raceCtl.text.trim(),
        characterClass: _classCtl.text.trim(),
        background: '',
        level: int.parse(_levelCtl.text.trim()),
        attributes: {'FOR':10,'DES':10,'CON':10,'INT':10,'SAB':10,'CAR':10},
        hitPoints: int.parse(_hpCtl.text.trim()),
        armorClass: 10,
        currentArmor: '',
        hasShield: false,
        skills: <String,bool>{},
        preparedSpells: <String,bool>{},
        selectedCantrips: <String,bool>{},
        maxSpellSlots: <int,int>{},
        usedSpellSlots: <int,int>{},
        inspiration: 0,
        gold: 0,
        silver: 0,
        copper: 0,
        languages: <String>[],
        equipment: <EquipmentItem>[],
        startingEquipmentChoices: <int,String>{},
        deathSaveSuccesses: <bool>[false,false,false],
        deathSaveFailures: <bool>[false,false,false],
        createdAt: DateTime.now(),
        lastModified: DateTime.now(),
      );

      // Salva diretamente na nuvem (sem fallback local). Usamos saveFullCharacter com docId
      try {
        await FirestoreService.saveFullCharacter(character.toJson(), docId: character.id);
        if (kDebugMode) debugPrint('Personagem salvo na nuvem com id: ${character.id}');
        if (!mounted) return;
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Sucesso'),
            content: const Text('Personagem salvo com sucesso na nuvem.'),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('OK')),
            ],
          ),
        ).then((_) => Navigator.of(context).pop());
      } catch (e, st) {
        if (kDebugMode) debugPrint('Erro ao salvar personagem no Firestore: $e');
        if (kDebugMode) debugPrint('$st');
        if (!mounted) return;
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Erro'),
            content: Text('Falha ao salvar personagem na nuvem: $e'),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('OK')),
            ],
          ),
        );
        return;
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Erro'),
          content: Text('Falha ao salvar personagem: $e'),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('OK')),
          ],
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adicionar Personagem')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameCtl,
                  decoration: const InputDecoration(labelText: 'Nome'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Preencha o nome' : null,
                ),
                TextFormField(
                  controller: _raceCtl,
                  decoration: const InputDecoration(labelText: 'Raça'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Preencha a raça' : null,
                ),
                TextFormField(
                  controller: _classCtl,
                  decoration: const InputDecoration(labelText: 'Classe'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Preencha a classe' : null,
                ),
                TextFormField(
                  controller: _levelCtl,
                  decoration: const InputDecoration(labelText: 'Nível'),
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Preencha o nível';
                    if (int.tryParse(v.trim()) == null) return 'Número inválido';
                    return null;
                  },
                ),
                TextFormField(
                  controller: _hpCtl,
                  decoration: const InputDecoration(labelText: 'HP'),
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Preencha o HP';
                    if (int.tryParse(v.trim()) == null) return 'Número inválido';
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _loading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(onPressed: _submit, child: const Text('Salvar')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
