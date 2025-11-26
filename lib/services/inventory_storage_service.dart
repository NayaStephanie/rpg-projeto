// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class InventoryStorageService {
  static const String _key = 'local_inventories';

  /// Recupera todos os itens locais (lista de Map)
  static Future<List<Map<String, dynamic>>> getAllItems() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (_) {
      return [];
    }
  }

  /// Salva (adiciona/atualiza) um item local. O [item] deve conter um campo 'id'.
  static Future<void> saveItem(Map<String, dynamic> item) async {
    final prefs = await SharedPreferences.getInstance();
    final items = await getAllItems();
    final idx = items.indexWhere((i) => i['id'] == item['id']);
    if (idx >= 0) items[idx] = item;
    else items.add(item);
    await prefs.setString(_key, jsonEncode(items));
  }

  /// Remove item local por id
  static Future<bool> deleteItem(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final items = await getAllItems();
    final newList = items.where((i) => i['id'] != id).toList();
    await prefs.setString(_key, jsonEncode(newList));
    return true;
  }
}
