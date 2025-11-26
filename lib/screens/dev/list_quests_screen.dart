// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/foundation.dart';
import 'add_quest_screen.dart';

class ListQuestsScreen extends StatefulWidget {
  const ListQuestsScreen({super.key});

  @override
  State<ListQuestsScreen> createState() => _ListQuestsScreenState();
}

class _ListQuestsScreenState extends State<ListQuestsScreen> {
  String _statusFilter = 'all'; // all | active | completed | failed
  String _search = '';
  bool _showAll = false; // debug: show all quests regardless of ownerId
  final TextEditingController _searchCtl = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  List<String> _savedSearches = [];
  bool _showSavedSearches = false;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(appBar: AppBar(title: const Text('Quests')), body: const Center(child: Text('Usuário não autenticado')));
    }

    final stream = _showAll
      ? FirebaseFirestore.instance.collection('usuarios').doc(user.uid).collection('quests').orderBy('createdAt', descending: true).snapshots()
      : FirebaseFirestore.instance.collection('usuarios').doc(user.uid).collection('quests').orderBy('createdAt', descending: true).snapshots();

    // When saved-searches are visible inside the AppBar.bottom, increase top padding
    // so the body list is pushed below the visible saved-searches list.
    final double _savedSearchesHeight = (_showSavedSearches && _savedSearches.isNotEmpty)
      ? (_savedSearches.length * 48.0).clamp(0.0, 240.0)
      : 0.0;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Missões', style: const TextStyle(fontSize: 20, color: Colors.white)),
        actions: [
          if (kDebugMode)
            IconButton(
              tooltip: _showAll ? 'Mostrar apenas minhas' : 'Mostrar todos (debug)',
              icon: Icon(_showAll ? Icons.filter_list : Icons.developer_mode, color: Colors.white),
              onPressed: () => setState(() => _showAll = !_showAll),
            )
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(72),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
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
                          if (t.isNotEmpty && !_savedSearches.contains(t)) {
                            setState(() => _savedSearches.insert(0, t));
                          }
                          _searchFocus.unfocus();
                          setState(() => _showSavedSearches = false);
                        },
                        onTap: () {
                          if (_savedSearches.isNotEmpty) setState(() => _showSavedSearches = true);
                        },
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
                                trailing: IconButton(
                                  icon: const Icon(Icons.close, color: Colors.white70, size: 18),
                                  onPressed: () => setState(() => _savedSearches.removeAt(i)),
                                ),
                                onTap: () => setState(() {
                                  _searchCtl.text = s;
                                  _search = s.toLowerCase();
                                  _showSavedSearches = false;
                                  _searchFocus.unfocus();
                                }),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.filter_list, color: Colors.white),
                  onSelected: (v) => setState(() => _statusFilter = v),
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'all', child: Text('Todos')),
                    PopupMenuItem(value: 'active', child: Text('Ativas')),
                    PopupMenuItem(value: 'completed', child: Text('Concluídas')),
                    PopupMenuItem(value: 'failed', child: Text('Falhadas')),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('lib/assets/images/image_fundo.png', fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.65)),
          // Debug banner showing current user UID (only in debug builds)
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
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + kToolbarHeight + 72 + 8 + _savedSearchesHeight),
            child: StreamBuilder<QuerySnapshot>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) {
            final err = snapshot.error;
            debugPrint('ListQuestsScreen error: $err');
            return _buildErrorState(context, onRetry: () => setState(() {}));
          }
          final docs = snapshot.data?.docs ?? [];
          // Diagnostic logs to help identify ownerId / data issues
          debugPrint('ListQuestsScreen: stream docs=${docs.length} showAll=$_showAll');
          for (final d in docs) {
            try {
              final data = d.data() as Map<String, dynamic>;
              debugPrint('  doc=${d.id} ownerId=${data['ownerId']} title=${(data['title'] as String?) ?? ''} status=${(data['status'] as String?) ?? ''} createdAt=${data['createdAt']}');
            } catch (e) {
              debugPrint('  doc=${d.id} data parse error: $e');
            }
          }

          // Aplica filtros client-side para pesquisa e status (fácil e evita índices adicionais)
          final filtered = docs.where((d) {
            final data = d.data() as Map<String, dynamic>;
            final title = (data['title'] as String?)?.toLowerCase() ?? '';
            final status = (data['status'] as String?) ?? 'active';
            if (_statusFilter != 'all' && status != _statusFilter) return false;
            if (_search.isNotEmpty && !title.contains(_search)) return false;
            return true;
          }).toList();

          if (filtered.isEmpty) {
            return _buildEmptyState(
              context,
              icon: Icons.search_off,
              title: 'Nada encontrado',
              message: _search.isNotEmpty
                  ? 'Nenhuma missão corresponde à sua busca. Tente outro termo ou crie uma nova missão.'
                  : 'Você ainda não tem missões. Crie uma nova missão para começar.',
              primaryLabel: 'Criar Missão',
              onPrimary: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddQuestScreen())),
              showClearFilters: _search.isNotEmpty || _statusFilter != 'all',
              onClearFilters: () => setState(() {
                _search = '';
                _statusFilter = 'all';
              }),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 32, left: 8, right: 8),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final doc = filtered[index];
              final data = doc.data() as Map<String, dynamic>;
              final title = data['title'] ?? 'Sem título';
              final level = data['levelRequirement']?.toString() ?? '-';
              final status = (data['status'] as String?) ?? 'active';
              final location = data['location'] ?? '';
              final reward = data['reward'] as Map<String, dynamic>?;
              final gold = reward != null ? reward['gold']?.toString() ?? '0' : '0';

              Color statusColor;
              String statusLabel;
              switch (status) {
                case 'completed':
                  statusColor = Colors.green;
                  statusLabel = 'Concluída';
                  break;
                case 'failed':
                  statusColor = Colors.red;
                  statusLabel = 'Falhada';
                  break;
                default:
                  statusColor = Colors.amber;
                  statusLabel = 'Ativa';
              }

              return Card(
                color: Colors.black.withOpacity(0.3),
                child: ListTile(
                  title: Text(title, style: const TextStyle(color: Colors.white)),
                  subtitle: Text('Nível: $level • Local: $location • Ouro: $gold', style: const TextStyle(color: Colors.white70)),
                  leading: CircleAvatar(backgroundColor: statusColor, child: Text(statusLabel[0], style: const TextStyle(color: Colors.white))),
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
                          content: Text('Excluir esta missão?', style: GoogleFonts.imFellEnglish(color: Colors.white70)),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Cancelar', style: GoogleFonts.imFellEnglish(color: Colors.white70))),
                            TextButton(onPressed: () => Navigator.pop(context, true), child: Text('Excluir', style: GoogleFonts.imFellEnglish(color: Colors.amber))),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        try {
                          await FirebaseFirestore.instance.collection('usuarios').doc(user.uid).collection('quests').doc(doc.id).delete();
                          if (context.mounted)
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Missão removida', style: GoogleFonts.imFellEnglish(color: Colors.white)),
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
      required VoidCallback onPrimary,
      bool showClearFilters = false,
      VoidCallback? onClearFilters}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 72, color: Colors.white70),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: Colors.white70)),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onPrimary, child: Text(primaryLabel)),
            if (showClearFilters) ...[
              const SizedBox(height: 8),
              TextButton(onPressed: onClearFilters, child: const Text('Limpar filtros')),
            ]
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
            const Text('Não foi possível carregar suas missões. Verifique sua conexão e tente novamente.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onRetry, child: const Text('Tentar novamente')),
          ],
        ),
      ),
    );
  }
}
