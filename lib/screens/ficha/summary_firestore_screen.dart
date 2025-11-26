import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SummaryFirestoreScreen extends StatelessWidget {
  final String docId;
  const SummaryFirestoreScreen({super.key, required this.docId});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(appBar: AppBar(title: const Text('Ficha')), body: const Center(child: Text('Usuário não autenticado')));
    }

    final docRef = FirebaseFirestore.instance.collection('usuarios').doc(user.uid).collection('characters').doc(docId);

    return Scaffold(
      appBar: AppBar(title: const Text('Ficha (Nuvem)')),
      body: StreamBuilder<DocumentSnapshot>(
        stream: docRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text('Erro: ${snapshot.error}'));
          final doc = snapshot.data;
          if (doc == null || !doc.exists) return const Center(child: Text('Documento não encontrado'));

          final data = doc.data() as Map<String, dynamic>? ?? {};

          // Tentativa de extrair dados principais
          final name = data['name'] ?? (data['raw'] is Map ? data['raw']['name'] : '—');
          final race = data['race'] ?? (data['raw'] is Map ? data['raw']['race'] : null);
          final charClass = data['class'] ?? (data['raw'] is Map ? data['raw']['characterClass'] : null);
          final level = data['level'] ?? (data['raw'] is Map ? data['raw']['level'] : null);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(name.toString(), style: GoogleFonts.jimNightshade(fontSize: 36)),
              const SizedBox(height: 8),
              Text('Raça: ${race ?? '—'} — Classe: ${charClass ?? '—'} — Nível: ${level ?? '—'}'),
              const SizedBox(height: 12),
              if (data['raw'] is Map && (data['raw']['attributes'] != null))
                ...(data['raw']['attributes'] as Map<String, dynamic>).entries.map((e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text('${e.key}: ${e.value}', style: GoogleFonts.imFellEnglish()),
                    ))
              else if (data['attributes'] != null)
                ...(data['attributes'] as Map<String, dynamic>).entries.map((e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text('${e.key}: ${e.value}', style: GoogleFonts.imFellEnglish()),
                    ))
              else
                Text('Sem atributos disponíveis', style: GoogleFonts.imFellEnglish()),
            ]),
          );
        },
      ),
    );
  }
}
