import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FirestoreSearchScreen extends StatefulWidget {
  const FirestoreSearchScreen({super.key});

  @override
  State<FirestoreSearchScreen> createState() => _FirestoreSearchScreenState();
}

class _FirestoreSearchScreenState extends State<FirestoreSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _orderBy = 'nameAsc';
  int _retryKey = 0;

  void _retry() {
    setState(() {
      _retryKey++;
    });
  }

  Query _baseQuery() {
    final user = FirebaseAuth.instance.currentUser;
    final db = FirebaseFirestore.instance;
    final coll = db.collection('usuarios').doc(user!.uid).collection('characters');

    switch (_orderBy) {
      case 'nameAsc':
        return coll.orderBy('nameLower', descending: false);
      case 'nameDesc':
        return coll.orderBy('nameLower', descending: true);
      case 'dateAsc':
        return coll.orderBy('createdAt', descending: false);
      case 'dateDesc':
      default:
        return coll.orderBy('createdAt', descending: true);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final queryText = _searchController.text.trim().toLowerCase();

    return Scaffold(
      appBar: AppBar(
        title: Text('Pesquisar Personagens', style: GoogleFonts.imFellEnglish()),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Pesquisar por nome',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 8),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.sort),
                  onSelected: (v) => setState(() => _orderBy = v),
                  itemBuilder: (_) => [
                    const PopupMenuItem(value: 'nameAsc', child: Text('Nome (A → Z)')),
                    const PopupMenuItem(value: 'nameDesc', child: Text('Nome (Z → A)')),
                    const PopupMenuItem(value: 'dateDesc', child: Text('Data (mais recentes)')),
                    const PopupMenuItem(value: 'dateAsc', child: Text('Data (mais antigas)')),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              key: ValueKey('${_retryKey}_${_orderBy}_$queryText'),
              stream: _baseQuery().snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Erro ao recuperar dados', style: GoogleFonts.imFellEnglish(fontSize: 18)),
                        const SizedBox(height: 8),
                        ElevatedButton(onPressed: _retry, child: const Text('Tentar novamente')),
                      ],
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data?.docs ?? [];

                // Filtragem client-side case-insensitive usando campo 'nameLower' quando disponível
                final results = docs.where((d) {
                  if (queryText.isEmpty) return true;
                  final data = d.data() as Map<String, dynamic>;
                  final nameLower = (data['nameLower'] as String?) ?? (data['name'] as String? ?? '').toLowerCase();
                  return nameLower.contains(queryText);
                }).toList();

                if (results.isEmpty) {
                  return Center(child: Text('Nenhum resultado', style: GoogleFonts.imFellEnglish()));
                }

                return RefreshIndicator(
                  onRefresh: () async => _retry(),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: results.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final doc = results[index];
                      final data = doc.data() as Map<String, dynamic>;
                      final name = data['name'] ?? '—';
                      final race = data['race'] ?? '';
                      final level = data['level'] ?? '';

                      return ListTile(
                        title: Text(name.toString()),
                        subtitle: Text('Raça: $race — Nível: $level'),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
