// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/firestore_service.dart';
import '../auth/login_screen.dart';

class AddJournalScreen extends StatefulWidget {
  const AddJournalScreen({super.key});

  @override
  State<AddJournalScreen> createState() => _AddJournalScreenState();
}

class _AddJournalScreenState extends State<AddJournalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _body = TextEditingController();
  final _mood = TextEditingController();
  final _tags = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    _mood.dispose();
    _tags.dispose();
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
          content: Text('Você precisa estar autenticado para criar uma entrada. Deseja entrar agora?', style: GoogleFonts.imFellEnglish(color: Colors.white70)),
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
      final tags = _tags.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      final user = FirebaseAuth.instance.currentUser;
      debugPrint('addJournalEntry: uid=${user?.uid} title=${_title.text.trim()} mood=${_mood.text.trim()} tags=$tags');
      await FirestoreService.addJournalEntry(
        title: _title.text.trim(),
        body: _body.text.trim(),
        mood: _mood.text.trim(),
        tags: tags,
      );
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: Colors.black.withOpacity(0.9),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Colors.amber, width: 2)),
          title: Text('Sucesso', style: GoogleFonts.imFellEnglish(color: Colors.white, fontSize: 20)),
          content: Text('Entrada criada!', style: GoogleFonts.imFellEnglish(color: Colors.white70)),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('OK', style: GoogleFonts.imFellEnglish(color: Colors.amber))),
          ],
        ),
      ).then((_) => Navigator.of(context).pop());
    } on FirebaseException catch (e, st) {
      debugPrint('addJournalEntry FirebaseException: code=${e.code} message=${e.message}');
      debugPrint('$st');
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: Colors.black.withOpacity(0.9),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Colors.redAccent, width: 2)),
          title: Text('Erro ao salvar', style: GoogleFonts.imFellEnglish(color: Colors.white, fontSize: 20)),
          content: Text('Falha ao criar entrada!', style: GoogleFonts.imFellEnglish(color: Colors.white70)),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('OK', style: GoogleFonts.imFellEnglish(color: Colors.amber))),
          ],
        ),
      );
    } catch (e, st) {
      debugPrint('addJournalEntry error: $e');
      debugPrint('$st');
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: Colors.black.withOpacity(0.9),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Colors.redAccent, width: 2)),
          title: Text('Erro', style: GoogleFonts.imFellEnglish(color: Colors.white, fontSize: 20)),
          content: Text('Não foi possível criar a entrada. Verifique sua conexão ou permissões e tente novamente.', style: GoogleFonts.imFellEnglish(color: Colors.white70)),
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Nova Entrada', style: GoogleFonts.imFellEnglish(color: Colors.white)),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'lib/assets/images/image_fundo.png',
            fit: BoxFit.cover,
          ),
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
                    controller: _body,
                    style: GoogleFonts.imFellEnglish(color: Colors.white, fontSize: 16),
                    decoration: InputDecoration(
                      labelText: 'Corpo',
                      labelStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.black.withAlpha((0.20 * 255).toInt()),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    maxLines: 6,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _mood,
                    style: GoogleFonts.imFellEnglish(color: Colors.white, fontSize: 16),
                    decoration: InputDecoration(
                      labelText: 'Humor',
                      labelStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.black.withAlpha((0.20 * 255).toInt()),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _tags,
                    style: GoogleFonts.imFellEnglish(color: Colors.white, fontSize: 16),
                    decoration: InputDecoration(
                      labelText: 'Tags (vírgula separados)',
                      labelStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.black.withAlpha((0.20 * 255).toInt()),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _loading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF767676).withOpacity(0.35),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 56),
                            textStyle: GoogleFonts.imFellEnglish(fontSize: 18),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
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
