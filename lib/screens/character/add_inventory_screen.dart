// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../services/firestore_service.dart';
// local storage removed: saving now targets only Firestore

class AddInventoryScreen extends StatefulWidget {
  const AddInventoryScreen({super.key});

  @override
  State<AddInventoryScreen> createState() => _AddInventoryScreenState();
}

class _AddInventoryScreenState extends State<AddInventoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _itemCtl = TextEditingController();
  final _quantityCtl = TextEditingController();
  final _weightCtl = TextEditingController();
  final _rarityCtl = TextEditingController();
  final _descCtl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _itemCtl.dispose();
    _quantityCtl.dispose();
    _weightCtl.dispose();
    _rarityCtl.dispose();
    _descCtl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      // Salva diretamente na nuvem (Firestore). Não salvamos localmente.
      final docId = await FirestoreService.addInventoryItem(
        itemName: _itemCtl.text.trim(),
        quantity: int.parse(_quantityCtl.text.trim()),
        weight: double.parse(_weightCtl.text.trim()),
        rarity: _rarityCtl.text.trim(),
        description: _descCtl.text.trim(),
      );
      if (kDebugMode) debugPrint('Inventário salvo na nuvem com id: $docId');

      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Sucesso'),
          content: const Text('Item salvo com sucesso.'),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('OK')),
          ],
        ),
      ).then((_) => Navigator.of(context).pop());
    } catch (e) {
      // Se falhar, já temos o item salvo localmente
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Erro'),
          content: Text('Falha ao salvar item na nuvem. Item salvo localmente. Erro: $e'),
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
      appBar: AppBar(title: const Text('Adicionar Item')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _itemCtl,
                  decoration: const InputDecoration(labelText: 'Nome do item'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Preencha o nome do item' : null,
                ),
                TextFormField(
                  controller: _quantityCtl,
                  decoration: const InputDecoration(labelText: 'Quantidade'),
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Preencha a quantidade';
                    if (int.tryParse(v.trim()) == null) return 'Número inválido';
                    return null;
                  },
                ),
                TextFormField(
                  controller: _weightCtl,
                  decoration: const InputDecoration(labelText: 'Peso'),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Preencha o peso';
                    if (double.tryParse(v.trim()) == null) return 'Número inválido';
                    return null;
                  },
                ),
                TextFormField(
                  controller: _rarityCtl,
                  decoration: const InputDecoration(labelText: 'Raridade'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Preencha a raridade' : null,
                ),
                TextFormField(
                  controller: _descCtl,
                  decoration: const InputDecoration(labelText: 'Descrição'),
                  maxLines: 3,
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
