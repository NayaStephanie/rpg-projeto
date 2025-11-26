// ignore_for_file: unused_import, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/firestore_service.dart';

class EditCharacterFirestoreScreen extends StatefulWidget {
  final String docId;
  final Map<String, dynamic> initialData;

  const EditCharacterFirestoreScreen({required this.docId, required this.initialData, super.key});

  @override
  State<EditCharacterFirestoreScreen> createState() => _EditCharacterFirestoreScreenState();
}

class _EditCharacterFirestoreScreenState extends State<EditCharacterFirestoreScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtl;
  late TextEditingController _raceCtl;
  late TextEditingController _classCtl;
  late TextEditingController _levelCtl;
  late TextEditingController _hpCtl;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final d = widget.initialData;
    _nameCtl = TextEditingController(text: d['name']?.toString() ?? '');
    _raceCtl = TextEditingController(text: d['race']?.toString() ?? '');
    _classCtl = TextEditingController(text: d['class']?.toString() ?? '');
    _levelCtl = TextEditingController(text: d['level']?.toString() ?? '0');
    _hpCtl = TextEditingController(text: d['hp']?.toString() ?? '0');
  }

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
      await FirestoreService.updateCharacter(
        docId: widget.docId,
        name: _nameCtl.text.trim(),
        race: _raceCtl.text.trim(),
        charClass: _classCtl.text.trim(),
        level: int.tryParse(_levelCtl.text.trim()),
        hp: int.tryParse(_hpCtl.text.trim()),
      );

      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Sucesso'),
          content: const Text('Personagem atualizado com sucesso.'),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('OK')),
          ],
        ),
      ).then((_) => Navigator.of(context).pop());
    } catch (e) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Erro'),
          content: Text('Falha ao atualizar personagem: $e'),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Fechar')),
            TextButton(onPressed: () { Navigator.of(context).pop(); _submit(); }, child: const Text('Tentar novamente')),
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
      appBar: AppBar(title: const Text('Editar Personagem (Nuvem)')),
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
                ),
                TextFormField(
                  controller: _classCtl,
                  decoration: const InputDecoration(labelText: 'Classe'),
                ),
                TextFormField(
                  controller: _levelCtl,
                  decoration: const InputDecoration(labelText: 'Nível'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: _hpCtl,
                  decoration: const InputDecoration(labelText: 'HP'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                _loading ? const CircularProgressIndicator() : ElevatedButton(onPressed: _submit, child: const Text('Atualizar')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
