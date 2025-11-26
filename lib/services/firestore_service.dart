import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FirestoreService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Converte valores comuns para um DateTime que o Firestore aceita como timestamp.
  // Aceita `String` (ISO8601), `int` (mills since epoch) ou `DateTime`.
  static DateTime? _coerceToDateTime(dynamic v) {
    if (v == null) return null;
    if (v is DateTime) return v;
    if (v is String) {
      try {
        return DateTime.parse(v);
      } catch (_) {
        return null;
      }
    }
    if (v is int) {
      try {
        return DateTime.fromMillisecondsSinceEpoch(v);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  /// Adiciona um personagem na subcoleção `characters` dentro do documento do usuário em `usuarios/{uid}/characters`.
  /// Campos (exemplo): name, race, charClass, level, hp, createdAt
  static Future<String> addCharacter({
    required String name,
    required String race,
    required String charClass,
    required int level,
    required int hp,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw FirebaseAuthException(code: 'NO_USER', message: 'Usuário não autenticado');

    final data = {
      'name': name,
      'nameLower': name.toLowerCase(),
      'race': race,
      'class': charClass,
      'level': level,
      'hp': hp,
      'createdAt': FieldValue.serverTimestamp(),
    };
    final docRef = await _db.collection('usuarios').doc(user.uid).collection('characters').add(data);
    // registra atividade de criação
    await addActivityLog(type: 'create_character', targetId: docRef.id, description: 'Criou personagem $name', metadata: {'level': level});
    return docRef.id;
  }

  /// Adiciona um item de inventário na subcoleção `inventories` dentro do documento do usuário.
  /// Campos (exemplo): itemName, quantity, weight, rarity, description, createdAt
  static Future<String> addInventoryItem({
    required String itemName,
    required int quantity,
    required double weight,
    required String rarity,
    required String description,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw FirebaseAuthException(code: 'NO_USER', message: 'Usuário não autenticado');

    final data = {
      'itemName': itemName,
      'itemNameLower': itemName.toLowerCase(),
      'quantity': quantity,
      'weight': weight,
      'rarity': rarity,
      'description': description,
      'createdAt': FieldValue.serverTimestamp(),
    };
    final docRef = await _db.collection('usuarios').doc(user.uid).collection('inventories').add(data);
    // registra atividade de criação de inventário
    await addActivityLog(type: 'create_inventory_item', targetId: docRef.id, description: 'Criou item de inventário $itemName', metadata: {'quantity': quantity});
    return docRef.id;
  }

  /// Atualiza um personagem existente identificado por [docId] na subcoleção `characters`.
  static Future<void> updateCharacter({
    required String docId,
    String? name,
    String? race,
    String? charClass,
    int? level,
    int? hp,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw FirebaseAuthException(code: 'NO_USER', message: 'Usuário não autenticado');

    final Map<String, Object?> data = {};
    if (name != null) {
      data['name'] = name;
      data['nameLower'] = name.toLowerCase();
    }
    if (race != null) data['race'] = race;
    if (charClass != null) data['class'] = charClass;
    if (level != null) data['level'] = level;
    if (hp != null) data['hp'] = hp;
    data['updatedAt'] = FieldValue.serverTimestamp();

    if (data.isEmpty) return;
    await _db.collection('usuarios').doc(user.uid).collection('characters').doc(docId).update(data);
    // registra atividade de atualização
    await addActivityLog(type: 'update_character', targetId: docId, description: 'Atualizou personagem ${name ?? docId}', metadata: {'level': level});
  }

  /// Atualiza um item de inventário existente identificado por [docId] na subcoleção `inventories`.
  static Future<void> updateInventoryItem({
    required String docId,
    String? itemName,
    int? quantity,
    double? weight,
    String? rarity,
    String? description,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw FirebaseAuthException(code: 'NO_USER', message: 'Usuário não autenticado');

    final Map<String, Object?> data = {};
    if (itemName != null) {
      data['itemName'] = itemName;
      data['itemNameLower'] = itemName.toLowerCase();
    }
    if (quantity != null) data['quantity'] = quantity;
    if (weight != null) data['weight'] = weight;
    if (rarity != null) data['rarity'] = rarity;
    if (description != null) data['description'] = description;
    data['updatedAt'] = FieldValue.serverTimestamp();

    if (data.isEmpty) return;
    await _db.collection('usuarios').doc(user.uid).collection('inventories').doc(docId).update(data);
    // registra atividade de atualização de inventário
    await addActivityLog(type: 'update_inventory_item', targetId: docId, description: 'Atualizou item ${itemName ?? docId}', metadata: {'quantity': quantity});
  }

  /// Salva um CharacterModel completo na subcoleção `characters` (usa o `id` do modelo como docId).
  /// O modelo completo é armazenado em um campo `raw` para preservar compatibilidade.
  static Future<void> saveFullCharacter(Map<String, dynamic> rawData, {required String docId}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw FirebaseAuthException(code: 'NO_USER', message: 'Usuário não autenticado');

    // tenta converter createdAt para DateTime (caso venha como ISO string do modelo)
    final createdAtVal = _coerceToDateTime(rawData['createdAt']);
    final lastModifiedVal = _coerceToDateTime(rawData['lastModified']);

    final data = {
      'name': rawData['name'],
      'nameLower': (rawData['name'] as String?)?.toLowerCase(),
      'race': rawData['race'],
      'class': rawData['characterClass'] ?? rawData['class'],
      'level': rawData['level'],
      'hp': rawData['hitPoints'] ?? rawData['hp'],
      // Preserve any provided createdAt (from the model) otherwise set server timestamp
      'createdAt': createdAtVal ?? FieldValue.serverTimestamp(),
      // também tenta preservar lastModified quando possível
      'lastModified': lastModifiedVal ?? FieldValue.serverTimestamp(),
      'raw': rawData,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    await _db.collection('usuarios').doc(user.uid).collection('characters').doc(docId).set(data, SetOptions(merge: true));
  }

  /// Registra uma entrada de atividade na subcoleção `activity_logs` do usuário.
  static Future<void> addActivityLog({
    required String type,
    required String targetId,
    required String description,
    Map<String, dynamic>? metadata,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw FirebaseAuthException(code: 'NO_USER', message: 'Usuário não autenticado');

    final data = {
      'type': type,
      'targetId': targetId,
      'description': description,
      'metadata': metadata ?? {},
      'createdAt': FieldValue.serverTimestamp(),
    };

    await _db.collection('usuarios').doc(user.uid).collection('activity_logs').add(data);
  }

  /// Salva apenas o raw (sem docId) - cria novo documento e retorna o id.
  static Future<String> addFullCharacter(Map<String, dynamic> rawData) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw FirebaseAuthException(code: 'NO_USER', message: 'Usuário não autenticado');

    final data = {
      'name': rawData['name'],
      'nameLower': (rawData['name'] as String?)?.toLowerCase(),
      'race': rawData['race'],
      'class': rawData['characterClass'] ?? rawData['class'],
      'level': rawData['level'],
      'hp': rawData['hitPoints'] ?? rawData['hp'],
      'raw': rawData,
      'createdAt': FieldValue.serverTimestamp(),
    };

    final docRef = await _db.collection('usuarios').doc(user.uid).collection('characters').add(data);
    return docRef.id;
  }

  /// Recupera um documento de personagem por [docId] (retorna `null` se não existir)
  static Future<Map<String, dynamic>?> getCharacter(String docId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw FirebaseAuthException(code: 'NO_USER', message: 'Usuário não autenticado');

    final snap = await _db.collection('usuarios').doc(user.uid).collection('characters').doc(docId).get();
    if (!snap.exists) return null;
    // Retorna os dados do documento como Map
    return snap.data();
  }

  /// Recupera as configurações do usuário em `usuarios/{uid}/settings`.
  /// Retorna `null` se o documento não existir ou o usuário não estiver autenticado.
  static Future<Map<String, dynamic>?> getUserSettings({String? uid}) async {
    final currentUid = uid ?? FirebaseAuth.instance.currentUser?.uid;
    if (currentUid == null) return null;

    final snap = await _db.collection('usuarios').doc(currentUid).collection('settings').doc('prefs').get();
    if (!snap.exists) return null;
    return snap.data();
  }

  /// Salva as configurações do usuário em `usuarios/{uid}/settings/prefs` usando merge.
  static Future<void> setUserSettings(Map<String, dynamic> settings) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw FirebaseAuthException(code: 'NO_USER', message: 'Usuário não autenticado');

    await _db.collection('usuarios').doc(user.uid).collection('settings').doc('prefs').set(settings, SetOptions(merge: true));
  }

  /// Adiciona uma quest (tarefa/missão) na subcoleção `quests` do usuário.
  /// Campos: title, description, difficulty, isCompleted, reward, createdAt
  static Future<String> addQuest({
    required String title,
    required String description,
    required int levelRequirement,
    required String status, // 'active' | 'completed' | 'failed'
    required Map<String, dynamic> reward, // { 'gold': int, 'items': List<String> }
    String? location,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw FirebaseAuthException(code: 'NO_USER', message: 'Usuário não autenticado');

    final data = {
      'title': title,
      'titleLower': title.toLowerCase(),
      'description': description,
      'levelRequirement': levelRequirement,
      'status': status,
      'reward': reward,
      'location': location ?? '',
      'createdAt': FieldValue.serverTimestamp(),
      'ownerId': user.uid,
    };
    // grava como subcoleção dentro do documento do usuário
    try {
      final docRef = await _db.collection('usuarios').doc(user.uid).collection('quests').add(data);
      // Mantemos o registro de atividade no histórico do usuário
      await addActivityLog(type: 'create_quest', targetId: docRef.id, description: 'Criou missão $title', metadata: {'levelRequirement': levelRequirement, 'status': status});
      return docRef.id;
    } catch (e, st) {
      // log para ajudar no diagnóstico em cliente
      debugPrint('FirestoreService.addQuest error: $e');
      debugPrint('$st');
      rethrow;
    }
  }

  /// Adiciona uma entrada de diário/journal na subcoleção `journals`.
  /// Campos: title, body, mood, tags (lista), createdAt
  static Future<String> addJournalEntry({
    required String title,
    required String body,
    required String mood,
    required List<String> tags,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw FirebaseAuthException(code: 'NO_USER', message: 'Usuário não autenticado');

    final data = {
      'title': title,
      'titleLower': title.toLowerCase(),
      'body': body,
      'mood': mood,
      'tags': tags,
      'createdAt': FieldValue.serverTimestamp(),
      'ownerId': user.uid,
    };
    try {
      final docRef = await _db.collection('usuarios').doc(user.uid).collection('journals').add(data);
      await addActivityLog(type: 'create_journal', targetId: docRef.id, description: 'Criou entrada de diário $title', metadata: {'tags': tags});
      return docRef.id;
    } catch (e, st) {
      debugPrint('FirestoreService.addJournalEntry error: $e');
      debugPrint('$st');
      rethrow;
    }
  }

  /// Adiciona uma conquista/achievement na subcoleção `achievements`.
  /// Campos: name, description, points, achieved (bool), metadata
  static Future<String> addAchievement({
    required String name,
    required String description,
    required int points,
    required bool achieved,
    Map<String, dynamic>? metadata,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw FirebaseAuthException(code: 'NO_USER', message: 'Usuário não autenticado');

    final data = {
      'name': name,
      'nameLower': name.toLowerCase(),
      'description': description,
      'points': points,
      'achieved': achieved,
      'metadata': metadata ?? {},
      'createdAt': FieldValue.serverTimestamp(),
      'ownerId': user.uid,
    };
    try {
      final docRef = await _db.collection('usuarios').doc(user.uid).collection('achievements').add(data);
      await addActivityLog(type: 'create_achievement', targetId: docRef.id, description: 'Criou achievement $name', metadata: {'points': points});
      return docRef.id;
    } catch (e, st) {
      debugPrint('FirestoreService.addAchievement error: $e');
      debugPrint('$st');
      rethrow;
    }
  }
}
