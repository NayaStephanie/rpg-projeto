import 'dart:convert';
import 'package:app_rpg/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Duration _cacheDuration = Duration(hours: 24);

class Dnd5eService {
  static const _base = 'https://www.dnd5eapi.co/api';

  /// Retorna lista de monstros (index, name)
  static Future<List<Map<String, dynamic>>> fetchMonsters() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'dnd_monsters_cache';
    final raw = prefs.getString(key);
    if (raw != null) {
      try {
        final parsed = jsonDecode(raw) as Map<String, dynamic>;
        final cachedAt = DateTime.parse(parsed['cachedAt'] as String);
        if (DateTime.now().difference(cachedAt) < _cacheDuration) {
          return List<Map<String, dynamic>>.from(parsed['data'] as List);
        }
      } catch (_) {}
    }

    final data = await ApiService.fetchJson('$_base/monsters');
    if (data is Map<String, dynamic> && data['results'] is List) {
      final list = List<Map<String, dynamic>>.from(data['results']);
      await prefs.setString(key, jsonEncode({'cachedAt': DateTime.now().toIso8601String(), 'data': list}));
      return list;
    }
    return [];
  }

  /// Retorna detalhes de um monstro por `index` (ex: 'adult-black-dragon')
  static Future<Map<String, dynamic>> fetchMonsterDetail(String index) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'dnd_monster_$index';
    final raw = prefs.getString(key);
    if (raw != null) {
      try {
        final parsed = jsonDecode(raw) as Map<String, dynamic>;
        final cachedAt = DateTime.parse(parsed['cachedAt'] as String);
        if (DateTime.now().difference(cachedAt) < _cacheDuration) {
          return Map<String, dynamic>.from(parsed['data'] as Map);
        }
      } catch (_) {}
    }

    final data = await ApiService.fetchJson('$_base/monsters/$index');
    if (data is Map<String, dynamic>) {
      await prefs.setString(key, jsonEncode({'cachedAt': DateTime.now().toIso8601String(), 'data': data}));
      return Map<String, dynamic>.from(data);
    }
    return {};
  }
}
