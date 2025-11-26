// ignore_for_file: deprecated_member_use, unused_import, use_build_context_synchronously, unused_element

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:app_rpg/models/character_model.dart';
import 'package:app_rpg/services/character_storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_rpg/models/equipment_item.dart';
import 'package:app_rpg/services/subscription_service.dart';
import 'package:app_rpg/screens/ficha_pronta/ficha_pronta.dart';
import 'package:app_rpg/screens/settings/settings_screen.dart';
import 'package:app_rpg/utils/app_localizations.dart';
import 'dart:io';
class CharactersListScreen extends StatefulWidget {
  const CharactersListScreen({super.key});

  @override
  State<CharactersListScreen> createState() => _CharactersListScreenState();
}

class _CharactersListScreenState extends State<CharactersListScreen> {
  List<CharacterModel> _characters = [];
  bool _useCloud = false; // permite alternar entre lista local e nuvem
  // loading gerenciado pelo StreamBuilder do Firestore
  bool _isPremium = false;
  int _characterLimit = 2;

  String _getTranslatedText(String key) {
    return AppLocalizations.of(context)?.translate(key) ?? key;
  }

  // Converte dados do Firestore para CharacterModel preenchendo campos faltantes com defaults
  CharacterModel _characterFromDoc(String id, Map<String, dynamic> data) {
    return CharacterModel(
      id: id,
      name: data['name'] ?? 'Sem nome',
      avatarPath: data['avatarPath'],
      race: data['race'] ?? '',
      characterClass: data['class'] ?? data['characterClass'] ?? '',
      background: data['background'] ?? '',
      level: data['level'] is int ? data['level'] : int.tryParse('${data['level']}') ?? 1,
      attributes: data['attributes'] != null ? Map<String, int>.from(data['attributes']) : {'STR':0,'DEX':0,'CON':0,'INT':0,'WIS':0,'CHA':0},
      hitPoints: data['hp'] is int ? data['hp'] : int.tryParse('${data['hp']}') ?? 0,
      armorClass: data['armorClass'] is int ? data['armorClass'] : int.tryParse('${data['armorClass']}') ?? 10,
      currentArmor: data['currentArmor'] ?? '',
      hasShield: data['hasShield'] ?? false,
      skills: data['skills'] != null ? Map<String, bool>.from(data['skills']) : <String,bool>{},
      preparedSpells: data['preparedSpells'] != null ? Map<String, bool>.from(data['preparedSpells']) : <String,bool>{},
      selectedCantrips: data['selectedCantrips'] != null ? Map<String, bool>.from(data['selectedCantrips']) : <String,bool>{},
      maxSpellSlots: <int,int>{},
      usedSpellSlots: <int,int>{},
      inspiration: data['inspiration'] is int ? data['inspiration'] : 0,
      gold: data['gold'] is int ? data['gold'] : 0,
      silver: data['silver'] is int ? data['silver'] : 0,
      copper: data['copper'] is int ? data['copper'] : 0,
      languages: data['languages'] != null ? List<String>.from(data['languages']) : <String>[],
      equipment: <EquipmentItem>[],
      startingEquipmentChoices: <int,String>{},
      deathSaveSuccesses: data['deathSaveSuccesses'] != null ? List<bool>.from(data['deathSaveSuccesses']) : <bool>[false,false,false],
      deathSaveFailures: data['deathSaveFailures'] != null ? List<bool>.from(data['deathSaveFailures']) : <bool>[false,false,false],
      createdAt: data['createdAt'] is Timestamp ? (data['createdAt'] as Timestamp).toDate() : DateTime.now(),
      lastModified: data['updatedAt'] is Timestamp ? (data['updatedAt'] as Timestamp).toDate() : DateTime.now(),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadCharacters();
  }

  Future<void> _loadCharacters() async {
    try {
      final characters = await CharacterStorageService.getAllCharacters();
      final isPremium = await SubscriptionService.isPremiumUser();
      final limit = await SubscriptionService.getCharacterLimit();
      final storageType = await SubscriptionService.getStorageType();

      setState(() {
        _characters = characters;
        _isPremium = isPremium;
        _characterLimit = limit;
        // Temporariamente forçar uso da nuvem para usuários autenticados.
        // SubscriptionService foi ajustado para retornar 'cloud' e isPremium=true
        // para usuários autenticados, então apenas refletimos isso aqui.
        _useCloud = (storageType == 'cloud') && isPremium;
      });
    } catch (e) {
      // erro ao carregar armazenamento local
      _showErrorSnackBar('Erro ao carregar personagens');
    }
  }

  Future<void> _deleteCharacter(String characterId) async {
    // Tenta deletar primeiro do Firestore (se usuário autenticado e documento existir)
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final docRef = FirebaseFirestore.instance
            .collection('usuarios')
            .doc(user.uid)
            .collection('characters')
            .doc(characterId);

        final snapshot = await docRef.get();
        if (snapshot.exists) {
          await docRef.delete();
          _showSuccessSnackBar('Personagem excluído da nuvem com sucesso');
          setState(() {}); // força rebuild
          return;
        }
      }
    } catch (e) {
      // ignora e tenta deletar localmente abaixo
    }

    // Fallback para armazenamento local
    final success = await CharacterStorageService.deleteCharacter(characterId);
    if (success) {
      _loadCharacters(); // Recarrega a lista
      _showSuccessSnackBar('Personagem excluído localmente com sucesso');
    } else {
      _showErrorSnackBar('Erro ao excluir personagem');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showDeleteConfirmation(CharacterModel character) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: const Color(0xFF2C1810),
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(
              color: Colors.amber,
              width: 2,
            ),
            ),
          title: Text(
            _getTranslatedText('deleteCharacter'),
            style: GoogleFonts.jimNightshade(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
          content: Text(
            '${_getTranslatedText('confirmDeleteCharacter')} "${character.name}"?',
            style: GoogleFonts.imFellEnglish(
              color: Colors.white70,
              fontSize: 18,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                _getTranslatedText('cancel'),
                style: GoogleFonts.cinzel(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteCharacter(character.id);
              },
              child: Text(
                _getTranslatedText('delete'),
                style: GoogleFonts.cinzel(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _openCharacterSheet(CharacterModel character) {
    () async {
      // Verifica se existe um documento no Firestore com o mesmo id (usuário autenticado)
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final docRef = FirebaseFirestore.instance
              .collection('usuarios')
              .doc(user.uid)
              .collection('characters')
              .doc(character.id);
          final snap = await docRef.get();
          if (snap.exists) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CharacterSheet(firestoreDocId: character.id)),
            ).then((_) => _loadCharacters());
            return;
          }
        }
      } catch (_) {
        // Em caso de erro, abrir local normalmente
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CharacterSheet(existingCharacter: character),
        ),
      ).then((_) => _loadCharacters()); // Recarrega a lista quando voltar
    }();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fundo
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("lib/assets/images/image_dracon_2.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.6),
          ),
          
          // Conteúdo
          SafeArea(
            child: Column(
              children: [
                // Status premium e configurações no topo
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Botão de configurações
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SettingsScreen(),
                            ),
                          ).then((_) => _loadCharacters());
                        },
                        icon: Icon(
                          Icons.settings,
                          color: Colors.white.withOpacity(0.8),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Status premium com informações
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _isPremium ? Colors.amber : Colors.grey.shade700,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: _isPremium ? Colors.amber : Colors.grey,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _isPremium ? Icons.workspace_premium : Icons.person,
                                  color: _isPremium ? Colors.black : Colors.white,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _isPremium ? 'Premium' : 'Gratuito',
                                  style: GoogleFonts.cinzel(
                                    color: _isPremium ? Colors.black : Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (!_isPremium) ...[
                            const SizedBox(height: 4),
                            Text(
                              '${_characters.length}/$_characterLimit personagens',
                              style: GoogleFonts.cinzel(
                                color: Colors.white70,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Header com título centralizado
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: Stack(
                    children: [
                      // Botão de voltar posicionado à esquerda
                      Positioned(
                        left: 0,
                        top: 0,
                        child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ),
                      // Toggle: Local / Nuvem
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Row(
                          children: [
                            const Text('Nuvem', style: TextStyle(color: Colors.white70)),
                            Builder(builder: (context) {
                              final user = FirebaseAuth.instance.currentUser;
                              return Switch(
                                value: _useCloud,
                                onChanged: user != null
                                    ? null // desabilita troca quando usuário autenticado (modo nuvem obrigatório)
                                    : (v) async {
                                        setState(() {
                                          _useCloud = v;
                                        });
                                        if (v) {
                                          setState(() {});
                                        } else {
                                          await _loadCharacters();
                                        }
                                      },
                              );
                            }),
                          ],
                        ),
                      ),
                      // Título centralizado
                      Center(
                        child: Text(
                          'Personagens',
                          style: GoogleFonts.jimNightshade(
                            fontSize: 48,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                offset: const Offset(2, 2),
                                blurRadius: 4,
                                color: Colors.black.withOpacity(0.7),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Lista de personagens (local ou via Firestore, conforme toggle)
                Expanded(
                  child: Column(
                    children: [
                      Expanded(child: _useCloud ? _buildCloudList() : _buildLocalList()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Banner simples exibindo UID atual quando em modo nuvem, ajuda a diagnosticar
  Widget _buildCloudInfoBanner() {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid ?? 'não autenticado';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.only(bottom: 8, left: 16, right: 16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          const Icon(Icons.cloud, color: Colors.amber, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Modo Nuvem ativo — UID: $uid',
              style: GoogleFonts.cinzel(color: Colors.white70, fontSize: 12),
            ),
          ),
          TextButton(
            onPressed: () {
              // Apenas mostrar instruções rápidas
              showDialog(context: context, builder: (ctx) => AlertDialog(
                backgroundColor: const Color(0xFF2C1810),
                title: Text('Diagnóstico', style: GoogleFonts.cinzel(color: Colors.amber)),
                content: Text('Se os personagens não aparecem: verifique no Firebase Console o caminho usuarios/{UID}/characters e as regras de leitura. UID mostrado acima.', style: GoogleFonts.cinzel(color: Colors.white70)),
                actions: [TextButton(onPressed: () => Navigator.of(ctx).pop(), child: Text('Fechar', style: GoogleFonts.cinzel(color: Colors.white70)))],
              ));
            },
            child: Text('Ajuda', style: GoogleFonts.cinzel(color: Colors.amber, fontSize: 12)),
          )
        ],
      ),
    );
  }

  Widget _buildCharacterCard(CharacterModel character) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: const Color(0xFF2C1810).withOpacity(0.9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.amber.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () => _openCharacterSheet(character),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header do card com avatar, nome e botão de delete
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey.shade800,
                    child: const Icon(Icons.person, color: Colors.white, size: 30),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          character.name,
                          style: GoogleFonts.jimNightshade(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${character.race} ${character.characterClass}',
                          style: GoogleFonts.imFellEnglish(
                            fontSize: 16,
                            color: Colors.amber,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => _showDeleteConfirmation(character),
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                      size: 24,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Informações básicas - todas na mesma linha
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildInfoChip('Nível ${character.level}'),
                  _buildInfoChip('PV ${character.hitPoints}'),
                  _buildInfoChip('CA ${character.armorClass}'),
                  _buildInfoChip(character.background),
                ],
              ),
              const SizedBox(height: 8),
              
              // Data de criação
              Text(
                'Criado em ${_formatDate(character.createdAt)}',
                style: GoogleFonts.jimNightshade(
                  fontSize: 14,
                  color: Colors.white54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.amber.withOpacity(0.4),
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.jimNightshade(
          fontSize: 14,
          color: Colors.amber,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Widget _buildLocalList() {
    if (_characters.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_off,
              size: 80,
              color: Colors.white.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhum personagem local',
              style: GoogleFonts.jimNightshade(
                fontSize: 24,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Crie seu primeiro personagem!',
              style: GoogleFonts.jimNightshade(
                fontSize: 18,
                color: Colors.white54,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
      itemCount: _characters.length,
      itemBuilder: (context, index) {
        final character = _characters[index];
        return _buildCharacterCard(character);
      },
    );
  }

  Widget _buildCloudList() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Center(child: Text('Usuário não autenticado'));

    final stream = FirebaseFirestore.instance
        .collection('usuarios')
        .doc(user.uid)
        .collection('characters')
        .orderBy('createdAt', descending: true)
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

        // Erro explícito visível na UI para diagnóstico
        if (snapshot.hasError) {
          // Mensagem mais amigável ao usuário com opção de ver detalhes técnicos
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.cloud_off, color: Colors.orangeAccent, size: 48),
                  const SizedBox(height: 12),
                  Text('Não foi possível carregar personagens na nuvem no momento.', style: GoogleFonts.cinzel(color: Colors.white, fontSize: 16)),
                  const SizedBox(height: 8),
                  Text('Tente recarregar a página, limpar o cache do navegador ou usar uma janela anônima. Se o problema persistir, abra o Console e copie a mensagem técnica.', style: GoogleFonts.cinzel(color: Colors.white70, fontSize: 12), textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      // Mostrar detalhes técnicos em diálogo para facilitar cópia
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Detalhes técnicos'),
                          content: SingleChildScrollView(child: Text('${snapshot.error}')),
                          actions: [
                            TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Fechar')),
                          ],
                        ),
                      );
                      if (kDebugMode) debugPrint('Firestore snapshot error: ${snapshot.error}');
                    },
                    child: const Text('Mostrar detalhes'),
                  ),
                ],
              ),
            ),
          );
        }

        final docs = snapshot.data?.docs ?? [];

        // Mostra banner informativo com contagem de documentos quando em nuvem
        if (docs.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              Text('Personagens encontrados: 0', style: GoogleFonts.cinzel(color: Colors.white38)),
            ],
          );
        }

        return Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              margin: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber.withOpacity(0.25)),
              ),
              child: Row(
                children: [
                  Text('Documentos na nuvem: ${docs.length}', style: GoogleFonts.cinzel(color: Colors.amber)),
                  const Spacer(),
                  Text('Última leitura: ${DateTime.now().toLocal().toIso8601String()}', style: GoogleFonts.cinzel(color: Colors.white38, fontSize: 12)),
                  const SizedBox(width: 8),
                  // Botão de diagnóstico: mostra IDs dos documentos e envia ao console em debug
                  IconButton(
                    icon: const Icon(Icons.bug_report, color: Colors.amber),
                    tooltip: 'Mostrar IDs dos documentos (diagnóstico)',
                    onPressed: () async {
                      final ids = docs.map((d) => d.id).toList();
                      if (kDebugMode) debugPrint('Firestore documentos IDs: $ids');
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('IDs dos documentos (diagnóstico)'),
                          content: SizedBox(
                            width: double.maxFinite,
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: ids.length,
                              separatorBuilder: (_, __) => const Divider(),
                              itemBuilder: (context, index) {
                                final id = ids[index];
                                return ListTile(
                                  title: Text(id, style: GoogleFonts.cinzel()),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.copy),
                                    onPressed: () {
                                      Clipboard.setData(ClipboardData(text: id));
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ID copiado para a área de transferência')));
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                          actions: [
                            TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Fechar')),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final doc = docs[index];
                  final character = _characterFromDoc(doc.id, doc.data() as Map<String, dynamic>);
                  return _buildCharacterCard(character);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}