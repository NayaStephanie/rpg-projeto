import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/dnd5e_service.dart';

class DndMonsterDetailScreen extends StatefulWidget {
  final String index;
  const DndMonsterDetailScreen({super.key, required this.index});

  @override
  State<DndMonsterDetailScreen> createState() => _DndMonsterDetailScreenState();
}

class _DndMonsterDetailScreenState extends State<DndMonsterDetailScreen> {
  bool _loading = true;
  String? _error;
  Map<String, dynamic>? _data;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final d = await Dnd5eService.fetchMonsterDetail(widget.index);
      setState(() { _data = d; });
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

    final d = _data ?? {};
    return Scaffold(
      appBar: AppBar(title: Text(d['name'] ?? 'Detalhes')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(d['name'] ?? '', style: GoogleFonts.imFellEnglish(fontSize: 22)),
            const SizedBox(height: 8),
            Text('Size: ${d['size'] ?? ''} — Type: ${d['type'] ?? ''} — Alignment: ${d['alignment'] ?? ''}'),
            const SizedBox(height: 12),
            if (d['armor_class'] != null) Text('Armor Class: ${d['armor_class']}'),
            if (d['hit_points'] != null) Text('Hit Points: ${d['hit_points']}'),
            const SizedBox(height: 12),
            if (d['actions'] != null)
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Actions:', style: GoogleFonts.imFellEnglish(fontSize: 18)),
                const SizedBox(height: 6),
                ...List<Widget>.from((d['actions'] as List? ?? []).map((a) => ListTile(title: Text(a['name'] ?? ''), subtitle: Text(a['desc'] ?? '')))),
              ]),
          ]),
        ),
      ),
    );
  }
}
