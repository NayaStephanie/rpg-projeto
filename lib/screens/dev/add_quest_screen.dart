// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/firestore_service.dart';
import '../auth/login_screen.dart';

class AddQuestScreen extends StatefulWidget {
  const AddQuestScreen({super.key});

  @override
  State<AddQuestScreen> createState() => _AddQuestScreenState();
}

class _AddQuestScreenState extends State<AddQuestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _desc = TextEditingController();
  final _levelRequirement = TextEditingController();
  String _status = 'active';
  final _reward = TextEditingController(); // gold amount
  final _rewardItems = TextEditingController(); // comma separated items
  final _location = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _title.dispose();
    _desc.dispose();
    _levelRequirement.dispose();
    _reward.dispose();
    _rewardItems.dispose();
    _location.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    // exige usuário autenticado
    if (FirebaseAuth.instance.currentUser == null) {
      final go = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: Colors.black.withOpacity(0.9),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Colors.amber, width: 2)),
          title: Text('Login necessário', style: GoogleFonts.imFellEnglish(color: Colors.white, fontSize: 20)),
          content: Text('Você precisa estar autenticado para criar uma missão. Deseja entrar agora?', style: GoogleFonts.imFellEnglish(color: Colors.white70)),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text('Cancelar', style: GoogleFonts.imFellEnglish(color: Colors.white70))),
            TextButton(onPressed: () => Navigator.of(context).pop(true), child: Text('Login', style: GoogleFonts.imFellEnglish(color: Colors.amber))),
          ],
        ),
      );
      if (go == true) Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
      return;
    }
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final gold = int.tryParse(_reward.text.trim()) ?? 0;
      final items = _rewardItems.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      final reward = {'gold': gold, 'items': items};
      final levelReq = int.tryParse(_levelRequirement.text.trim()) ?? 0;
      final user = FirebaseAuth.instance.currentUser;
      debugPrint('addQuest: uid=${user?.uid} title=${_title.text.trim()} levelRequirement=$levelReq status=$_status reward=$reward location=${_location.text.trim()}');
      final id = await FirestoreService.addQuest(
        title: _title.text.trim(),
        description: _desc.text.trim(),
        levelRequirement: levelReq,
        status: _status,
        reward: reward,
        location: _location.text.trim(),
      );
      debugPrint('addQuest created id=$id');
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: Colors.black.withOpacity(0.9),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Colors.amber, width: 2)),
          title: Text('Sucesso', style: GoogleFonts.imFellEnglish(color: Colors.white, fontSize: 20)),
          content: Text('Missão criada!', style: GoogleFonts.imFellEnglish(color: Colors.white70)),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('OK', style: GoogleFonts.imFellEnglish(color: Colors.amber))),
          ],
        ),
      ).then((_) => Navigator.of(context).pop());
    } on FirebaseException catch (e, st) {
      debugPrint('addQuest FirebaseException: code=${e.code} message=${e.message}');
      debugPrint('$st');
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: Colors.black.withOpacity(0.9),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Colors.redAccent, width: 2)),
          title: Text('Erro ao salvar', style: GoogleFonts.imFellEnglish(color: Colors.white, fontSize: 20)),
          content: Text('Falha ao criar missão!', style: GoogleFonts.imFellEnglish(color: Colors.white70)),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('OK', style: GoogleFonts.imFellEnglish(color: Colors.amber))),
          ],
        ),
      );
    } catch (e, st) {
      debugPrint('addQuest error: $e');
      debugPrint('$st');
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: Colors.black.withOpacity(0.9),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Colors.redAccent, width: 2)),
          title: Text('Erro', style: GoogleFonts.imFellEnglish(color: Colors.white, fontSize: 20)),
          content: Text('Não foi possível criar a missão. Verifique sua conexão ou permissões e tente novamente.', style: GoogleFonts.imFellEnglish(color: Colors.white70)),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('OK', style: GoogleFonts.imFellEnglish(color: Colors.amber))),
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, title: Text('Nova Missão', style: GoogleFonts.imFellEnglish(color: Colors.white))),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('lib/assets/images/image_fundo.png', fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.65)),
          SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 30,
              right: 30,
              top: MediaQuery.of(context).padding.top + kToolbarHeight + 24,
              bottom: 40,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _title,
                    style: GoogleFonts.imFellEnglish(color: Colors.white, fontSize: 18),
                    decoration: InputDecoration(
                      labelText: 'Título',
                      labelStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.black.withAlpha((0.20 * 255).toInt()),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Preencha' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _desc,
                    style: GoogleFonts.imFellEnglish(color: Colors.white, fontSize: 16),
                    decoration: InputDecoration(
                      labelText: 'Descrição',
                      labelStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.black.withAlpha((0.20 * 255).toInt()),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _levelRequirement,
                    style: GoogleFonts.imFellEnglish(color: Colors.white, fontSize: 16),
                    decoration: InputDecoration(
                      labelText: 'Requisito de Nível',
                      labelStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.black.withAlpha((0.20 * 255).toInt()),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Preencha';
                      if (int.tryParse(v.trim()) == null) return 'Número inválido';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _status,
                    items: const [
                      DropdownMenuItem(value: 'active', child: Text('Ativa')),
                      DropdownMenuItem(value: 'completed', child: Text('Concluída')),
                      DropdownMenuItem(value: 'failed', child: Text('Falhada')),
                    ],
                    onChanged: (v) => setState(() => _status = v ?? 'active'),
                    decoration: InputDecoration(labelText: 'Status', labelStyle: const TextStyle(color: Colors.white70), filled: true, fillColor: Colors.black.withAlpha((0.20 * 255).toInt()), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _reward,
                    style: GoogleFonts.imFellEnglish(color: Colors.white, fontSize: 16),
                    decoration: InputDecoration(
                      labelText: 'Recompensa (ouro)',
                      labelStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.black.withAlpha((0.20 * 255).toInt()),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _rewardItems,
                    style: GoogleFonts.imFellEnglish(color: Colors.white, fontSize: 16),
                    decoration: InputDecoration(
                      labelText: 'Itens de recompensa (vírgula separados)',
                      labelStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.black.withAlpha((0.20 * 255).toInt()),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _location,
                    style: GoogleFonts.imFellEnglish(color: Colors.white, fontSize: 16),
                    decoration: InputDecoration(
                      labelText: 'Local (ex.: Vila, Castelo)',
                      labelStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.black.withAlpha((0.20 * 255).toInt()),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 18),
                  _loading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF767676).withOpacity(0.35), foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 56), textStyle: GoogleFonts.imFellEnglish(fontSize: 18), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                          onPressed: _submit,
                          child: const Text('Salvar'),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
