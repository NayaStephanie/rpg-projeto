import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

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

    final data = {
      'name': rawData['name'],
      'nameLower': (rawData['name'] as String?)?.toLowerCase(),
      'race': rawData['race'],
      'class': rawData['characterClass'] ?? rawData['class'],
      'level': rawData['level'],
      'hp': rawData['hitPoints'] ?? rawData['hp'],
      // Preserve any provided createdAt (from the model) otherwise set server timestamp
      'createdAt': rawData['createdAt'] ?? FieldValue.serverTimestamp(),
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
}
