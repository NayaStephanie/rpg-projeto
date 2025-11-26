// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/dnd5e_service.dart';
import 'dnd_monster_detail_screen.dart';

class DndMonstersListScreen extends StatefulWidget {
  const DndMonstersListScreen({super.key});

  @override
  State<DndMonstersListScreen> createState() => _DndMonstersListScreenState();
}

class _DndMonstersListScreenState extends State<DndMonstersListScreen> {
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _monsters = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final list = await Dnd5eService.fetchMonsters();
      setState(() { _monsters = list; });
    } catch (e) {
      setState(() { _error = e.toString(); });
    } finally {
      setState(() { _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_error != null) return Scaffold(body: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Text('Erro: $_error'), const SizedBox(height:8), ElevatedButton(onPressed: _load, child: const Text('Tentar novamente'))])));

    return Scaffold(
      appBar: AppBar(title: const Text('DND5e — Monstros')),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: _monsters.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final m = _monsters[index];
          return ListTile(
            title: Text(m['name'] ?? ''),
            subtitle: Text(m['index'] ?? ''),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => DndMonsterDetailScreen(index: m['index'])));
            },
          );
        },
      ),
    );
  }
}
