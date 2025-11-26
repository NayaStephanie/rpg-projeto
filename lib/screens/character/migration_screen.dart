// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:io';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import '../../services/character_storage_service.dart';
import '../../models/character_model.dart';

class MigrationScreen extends StatefulWidget {
  const MigrationScreen({super.key});

  @override
  State<MigrationScreen> createState() => _MigrationScreenState();
}

class _MigrationScreenState extends State<MigrationScreen> {
  bool _running = false;
  String? _log;
  int _updated = 0;
  int _uploaded = 0;

  void _appendLog(String line) {
    setState(() {
      _log = (_log ?? '') + line + '\n';
    });
  }

  Future<void> _updateCloudLowerFields() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _appendLog('Usuário não autenticado');
      return;
    }

    setState(() {
      _running = true;
      _log = '';
      _updated = 0;
    });

    final db = FirebaseFirestore.instance;
    try {
      _appendLog('Buscando personagens na nuvem...');
      final charSnap = await db.collection('usuarios').doc(user.uid).collection('characters').get();
      for (final doc in charSnap.docs) {
        final data = doc.data();
        final name = (data['name'] as String?) ?? '';
        final nameLower = (data['nameLower'] as String?) ?? '';
        if (name.isNotEmpty && nameLower.isEmpty) {
          await doc.reference.update({'nameLower': name.toLowerCase()});
          _updated++;
          _appendLog('Atualizado characters/${doc.id} (nameLower)');
        }
      }

      _appendLog('Buscando inventários na nuvem...');
      final invSnap = await db.collection('usuarios').doc(user.uid).collection('inventories').get();
      for (final doc in invSnap.docs) {
        final data = doc.data();
        final itemName = (data['itemName'] as String?) ?? '';
        final itemNameLower = (data['itemNameLower'] as String?) ?? '';
        if (itemName.isNotEmpty && itemNameLower.isEmpty) {
          await doc.reference.update({'itemNameLower': itemName.toLowerCase()});
          _updated++;
          _appendLog('Atualizado inventories/${doc.id} (itemNameLower)');
        }
      }

      _appendLog('Atualização concluída. Total atualizado: $_updated');
    } catch (e) {
      _appendLog('Erro durante atualização: $e');
    } finally {
      setState(() {
        _running = false;
      });
    }
  }

  Future<void> _uploadLocalCharacters() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _appendLog('Usuário não autenticado');
      return;
    }

    setState(() {
      _running = true;
      _log = '';
      _uploaded = 0;
    });

    final db = FirebaseFirestore.instance;
    try {
      _appendLog('Carregando personagens locais...');
      final local = await CharacterStorageService.getAllCharacters();
      if (local.isEmpty) {
        _appendLog('Nenhum personagem local encontrado');
      }

      for (final CharacterModel c in local) {
        final data = c.toJson();
        // Campos essenciais e lowercased para pesquisa
        final payload = {
          'name': c.name,
          'nameLower': c.name.toLowerCase(),
          'race': c.race,
          'class': c.characterClass,
          'level': c.level,
          'hp': c.hitPoints,
          'raw': data,
          'createdAt': FieldValue.serverTimestamp(),
        };

        // Evitar duplicatas: se já existir documento com mesmo id local, usar doc(id)
        final docRef = db.collection('usuarios').doc(user.uid).collection('characters').doc(c.id);
        final existing = await docRef.get();
        if (existing.exists) {
          // Atualiza (merge) para preservar histórico e não criar duplicata
          await docRef.set(payload, SetOptions(merge: true));
          _appendLog('Atualizado (merge) personagem existente com id: ${c.id}');
        } else {
          // Se não existir por id, verificar por nameLower para evitar duplicata por nome
          final q = await db
              .collection('usuarios')
              .doc(user.uid)
              .collection('characters')
              .where('nameLower', isEqualTo: c.name.toLowerCase())
              .limit(1)
              .get();
          if (q.docs.isNotEmpty) {
            _appendLog('Pulei upload: personagem com mesmo nome já existe na nuvem: ${c.name}');
          } else {
            await docRef.set(payload);
            _uploaded++;
            _appendLog('Enviado personagem local: ${c.name} (docId=${c.id})');
          }
        }
      }

      _appendLog('Upload concluído. Total enviado: $_uploaded');
    } catch (e) {
      _appendLog('Erro durante upload: $e');
    } finally {
      setState(() {
        _running = false;
      });
    }
  }

  Future<void> _backupLocalCharacters() async {
    setState(() {
      _running = true;
      _log = '';
    });

    try {
      _appendLog('Gerando backup de personagens locais...');
      final local = await CharacterStorageService.getAllCharacters();
      final list = local.map((c) => c.toJson()).toList();
      final jsonStr = jsonEncode(list);

      final dir = await getApplicationDocumentsDirectory();
      final fileName = 'characters_backup_${DateTime.now().toIso8601String().replaceAll(':', '-')}.json';
      final file = File('${dir.path}/$fileName');
      await file.writeAsString(jsonStr);

      _appendLog('Backup salvo em: ${file.path}');
    } catch (e) {
      _appendLog('Erro ao criar backup: $e');
    } finally {
      setState(() {
        _running = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Migração de dados')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _running ? null : () async {
                final confirm = await showDialog<bool>(context: context, builder: (_) => AlertDialog(
                  title: const Text('Confirmar'),
                  content: const Text('Atualizar documentos na nuvem adicionando campos lowercased?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
                    TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Confirmar')),
                  ],
                ));

                if (confirm == true) await _updateCloudLowerFields();
              },
              child: const Text('Atualizar documentos na nuvem (adicionar lowercased)'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _running ? null : () async {
                final confirm = await showDialog<bool>(context: context, builder: (_) => AlertDialog(
                  title: const Text('Confirmar'),
                  content: const Text('Enviar personagens locais para a nuvem? Isso criará novos documentos em Firestore.'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
                    TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Confirmar')),
                  ],
                ));

                if (confirm == true) await _uploadLocalCharacters();
              },
              child: const Text('Enviar personagens locais para a nuvem'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _running ? null : () async {
                final confirm = await showDialog<bool>(context: context, builder: (_) => AlertDialog(
                  title: const Text('Backup local'),
                  content: const Text('Criar backup dos personagens locais em um arquivo JSON no dispositivo?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
                    TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Confirmar')),
                  ],
                ));

                if (confirm == true) await _backupLocalCharacters();
              },
              child: const Text('Criar backup local (JSON)'),
            ),
            const SizedBox(height: 16),
            if (_running) const LinearProgressIndicator(),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: SingleChildScrollView(
                  child: Text(_log ?? 'Aguardando ação...', style: GoogleFonts.imFellEnglish()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
