// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'add_journal_screen.dart';

class ListJournalsScreen extends StatefulWidget {
  const ListJournalsScreen({super.key});

  @override
  State<ListJournalsScreen> createState() => _ListJournalsScreenState();
}

class _ListJournalsScreenState extends State<ListJournalsScreen> {
  final TextEditingController _searchCtl = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  String _search = '';
  List<String> _savedSearches = [];
  bool _showSavedSearches = false;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return Scaffold(appBar: AppBar(title: const Text('Diário')), body: const Center(child: Text('Usuário não autenticado')));

    final stream = FirebaseFirestore.instance.collection('usuarios').doc(user.uid).collection('journals').orderBy('createdAt', descending: true).snapshots();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, title: Text('Diário', style: const TextStyle(fontSize: 20, color: Colors.white))),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('lib/assets/images/image_fundo.png', fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.65)),
          if (kDebugMode)
            Positioned(
              left: 16,
              right: 16,
              top: MediaQuery.of(context).padding.top + kToolbarHeight + 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white24)),
                child: Text('UID: ${user.uid}', style: GoogleFonts.imFellEnglish(color: Colors.white70, fontSize: 12)),
              ),
            ),
          // Search field below appbar
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + kToolbarHeight + (kDebugMode ? 56 : 12), left: 16, right: 16),
            child: Column(
              children: [
                TextField(
                  controller: _searchCtl,
                  focusNode: _searchFocus,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Pesquisar título...',
                    hintStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.black.withAlpha((0.20 * 255).toInt()),
                    prefixIcon: const Icon(Icons.search, color: Colors.white70),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onChanged: (v) => setState(() => _search = v.trim().toLowerCase()),
                  onSubmitted: (v) {
                    final t = v.trim();
                    if (t.isNotEmpty && !_savedSearches.contains(t)) setState(() => _savedSearches.insert(0, t));
                    _searchFocus.unfocus();
                    setState(() => _showSavedSearches = false);
                  },
                  onTap: () { if (_savedSearches.isNotEmpty) setState(() => _showSavedSearches = true); },
                ),
                if (_showSavedSearches && _savedSearches.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), borderRadius: BorderRadius.circular(8)),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _savedSearches.length,
                      itemBuilder: (context, i) {
                        final s = _savedSearches[i];
                        return ListTile(
                          dense: true,
                          title: Text(s, style: const TextStyle(color: Colors.white)),
                          trailing: IconButton(icon: const Icon(Icons.close, color: Colors.white70, size: 18), onPressed: () => setState(() => _savedSearches.removeAt(i))),
                          onTap: () => setState(() { _searchCtl.text = s; _search = s; _showSavedSearches = false; _searchFocus.unfocus(); }),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          StreamBuilder<QuerySnapshot>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) {
            debugPrint('ListJournalsScreen error: ${snapshot.error}');
            return _buildErrorState(context, onRetry: () => setState(() {}));
          }
          final docs = snapshot.data?.docs ?? [];
          // Aplica filtro client-side pela busca
          final filtered = docs.where((d) {
            if (_search.isEmpty) return true;
            try {
              final data = d.data() as Map<String, dynamic>;
              final title = (data['title'] as String?)?.toLowerCase() ?? '';
              return title.contains(_search);
            } catch (_) {
              return false;
            }
          }).toList();

          if (filtered.isEmpty) {
            return _buildEmptyState(
              context,
              icon: Icons.book_outlined,
              title: 'Nenhuma entrada',
              message: 'Ainda não há entradas no seu diário. Crie a primeira para começar a registrar suas aventuras.',
              primaryLabel: 'Nova Entrada',
              onPrimary: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddJournalScreen())),
            );
          }
          // calcula padding top para não sobrepor o campo de busca
          final double listTopPadding = MediaQuery.of(context).padding.top + kToolbarHeight + (kDebugMode ? 140 : 96);

          return ListView.builder(
            padding: EdgeInsets.only(top: listTopPadding, bottom: 32, left: 8, right: 8),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final doc = filtered[index];
              final data = doc.data() as Map<String, dynamic>;
              final title = data['title'] ?? 'Sem título';
              final mood = data['mood'] ?? '';
              final tags = (data['tags'] as List<dynamic>?)?.join(', ') ?? '';
              return Card(
                color: Colors.black.withOpacity(0.3),
                child: ListTile(
                  title: Text(title, style: const TextStyle(color: Colors.white)),
                  subtitle: Text('Humor: $mood • Tags: $tags', style: const TextStyle(color: Colors.white70)),
                  onTap: () {},
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          backgroundColor: Colors.black.withOpacity(0.9),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Colors.amber, width: 2)),
                          title: Text('Confirmar', style: GoogleFonts.imFellEnglish(color: Colors.white, fontSize: 20)),
                          content: Text('Excluir esta entrada?', style: GoogleFonts.imFellEnglish(color: Colors.white70)),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Cancelar', style: GoogleFonts.imFellEnglish(color: Colors.white70))),
                            TextButton(onPressed: () => Navigator.pop(context, true), child: Text('Excluir', style: GoogleFonts.imFellEnglish(color: Colors.amber))),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        try {
                          await FirebaseFirestore.instance.collection('usuarios').doc(user.uid).collection('journals').doc(doc.id).delete();
                          if (context.mounted)
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Entrada removida', style: GoogleFonts.imFellEnglish(color: Colors.white)),
                              backgroundColor: Colors.green.withOpacity(0.85),
                            ));
                        } catch (e) {
                          if (context.mounted)
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Erro ao remover: $e', style: GoogleFonts.imFellEnglish(color: Colors.white)),
                              backgroundColor: Colors.redAccent.withOpacity(0.9),
                            ));
                        }
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchCtl.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  Widget _buildEmptyState(BuildContext context,
      {required IconData icon,
      required String title,
      required String message,
      required String primaryLabel,
      required VoidCallback onPrimary}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: Colors.white70),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: Colors.white70)),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onPrimary, child: Text(primaryLabel)),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, {required VoidCallback onRetry}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 72, color: Colors.red[300]),
            const SizedBox(height: 16),
            const Text('Ops, ocorreu um erro', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            const Text('Não foi possível carregar suas entradas do diário. Verifique sua conexão e tente novamente.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onRetry, child: const Text('Tentar novamente')),
          ],
        ),
      ),
    );
  }
}
