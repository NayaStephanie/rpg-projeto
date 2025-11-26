// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '../../services/firestore_service.dart';

class EditInventoryFirestoreScreen extends StatefulWidget {
  final String docId;
  final Map<String, dynamic> initialData;

  const EditInventoryFirestoreScreen({required this.docId, required this.initialData, super.key});

  @override
  State<EditInventoryFirestoreScreen> createState() => _EditInventoryFirestoreScreenState();
}

class _EditInventoryFirestoreScreenState extends State<EditInventoryFirestoreScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _itemCtl;
  late TextEditingController _quantityCtl;
  late TextEditingController _weightCtl;
  late TextEditingController _rarityCtl;
  late TextEditingController _descCtl;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final d = widget.initialData;
    _itemCtl = TextEditingController(text: d['itemName']?.toString() ?? '');
    _quantityCtl = TextEditingController(text: d['quantity']?.toString() ?? '1');
    _weightCtl = TextEditingController(text: d['weight']?.toString() ?? '0');
    _rarityCtl = TextEditingController(text: d['rarity']?.toString() ?? '');
    _descCtl = TextEditingController(text: d['description']?.toString() ?? '');
  }

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
      await FirestoreService.updateInventoryItem(
        docId: widget.docId,
        itemName: _itemCtl.text.trim(),
        quantity: int.tryParse(_quantityCtl.text.trim()),
        weight: double.tryParse(_weightCtl.text.trim()),
        rarity: _rarityCtl.text.trim(),
        description: _descCtl.text.trim(),
      );

      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Sucesso'),
          content: const Text('Item atualizado com sucesso.'),
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
          content: Text('Falha ao atualizar item: $e'),
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
      appBar: AppBar(title: const Text('Editar Item (Nuvem)')),
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
                ),
                TextFormField(
                  controller: _weightCtl,
                  decoration: const InputDecoration(labelText: 'Peso'),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
                TextFormField(
                  controller: _rarityCtl,
                  decoration: const InputDecoration(labelText: 'Raridade'),
                ),
                TextFormField(
                  controller: _descCtl,
                  decoration: const InputDecoration(labelText: 'Descrição'),
                  maxLines: 3,
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
