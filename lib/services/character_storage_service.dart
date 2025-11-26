// ignore_for_file: avoid_print, provide_deprecation_message

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_rpg/models/character_model.dart';
import 'package:app_rpg/services/avatar_storage_service.dart';
import 'package:app_rpg/services/subscription_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Classe para resultado do salvamento
class SaveResult {
  final bool success;
  final String? errorMessage;
  final bool requiresUpgrade;
  
  SaveResult({
    required this.success,
    this.errorMessage,
    this.requiresUpgrade = false,
  });
}

class CharacterStorageService {
  static const String _charactersKey = 'saved_characters';

  // Gera a chave final para um uid; se uid for nulo, retorna chave global (legacy)
  static String _keyForUid(String? uid) {
    if (uid == null || uid.isEmpty) return _charactersKey;
    return 'saved_characters_$uid';
  }
  
  // Salva um personagem com verificação de limite
  static Future<SaveResult> saveCharacter(CharacterModel character) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Pega a lista existente de personagens (scoped por uid quando disponível)
      List<CharacterModel> characters = await getAllCharacters();
      
      // Verifica se é uma atualização de personagem existente
      bool isUpdate = characters.any((c) => c.id == character.id);
      
      if (!isUpdate) {
        // Se não é atualização, verifica o limite
        bool canCreate = await SubscriptionService.canCreateCharacter(characters.length);
        if (!canCreate) {
          return SaveResult(
            success: false,
            errorMessage: SubscriptionService.getLimitationMessage(),
            requiresUpgrade: true,
          );
        }
      }
      
      // Remove personagem existente com mesmo ID (atualização)
      characters.removeWhere((c) => c.id == character.id);
      
      // Adiciona o novo/atualizado personagem
      characters.add(character);
      
      // Converte para JSON e salva
      List<String> charactersJson = characters
          .map((c) => jsonEncode(c.toJson()))
          .toList();
        final user = FirebaseAuth.instance.currentUser;
        final key = _keyForUid(user?.uid);

        bool success = await prefs.setStringList(key, charactersJson);
      
      return SaveResult(success: success);
    } catch (e) {
      print('Erro ao salvar personagem: $e');
      return SaveResult(
        success: false,
        errorMessage: 'Erro ao salvar personagem: $e',
      );
    }
  }
  
  // Versão anterior mantida para compatibilidade (deprecated)
  @deprecated
  static Future<bool> saveCharacterLegacy(CharacterModel character) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Pega a lista existente de personagens
      List<CharacterModel> characters = await getAllCharacters();
      
      // Remove personagem existente com mesmo ID (atualização)
      characters.removeWhere((c) => c.id == character.id);
      
      // Adiciona o novo/atualizado personagem
      characters.add(character);
      
      // Converte para JSON e salva
      List<String> charactersJson = characters
          .map((c) => jsonEncode(c.toJson()))
          .toList();
      
      final user = FirebaseAuth.instance.currentUser;
      final key = _keyForUid(user?.uid);
      return await prefs.setStringList(key, charactersJson);
    } catch (e) {
      print('Erro ao salvar personagem: $e');
      return false;
    }
  }
  
  // Pega todos os personagens salvos
  static Future<List<CharacterModel>> getAllCharacters() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final user = FirebaseAuth.instance.currentUser;
      final userKey = _keyForUid(user?.uid);

      // Leitura final:
      // - Se o usuário estiver autenticado, só retornamos os personagens presentes
      //   na chave específica do usuário (`saved_characters_{uid}`).
      //   NÃO migramos automaticamente dados legados (global) para a conta do
      //   usuário para evitar vazamento de dados entre perfis no mesmo navegador.
      // - Se não houver usuário autenticado, retornamos os dados legados (global).
      List<String>? charactersJson;
      if (user != null) {
        charactersJson = prefs.getStringList(userKey);
      } else {
        charactersJson = prefs.getStringList(_charactersKey);
      }

      if (charactersJson == null) return [];

      return charactersJson
          .map((jsonString) => CharacterModel.fromJson(jsonDecode(jsonString)))
          .toList();
    } catch (e) {
      print('Erro ao carregar personagens: $e');
      return [];
    }
  }
  
  // Pega um personagem específico pelo ID
  static Future<CharacterModel?> getCharacterById(String id) async {
    try {
      List<CharacterModel> characters = await getAllCharacters();
      return characters.where((c) => c.id == id).firstOrNull;
    } catch (e) {
      print('Erro ao buscar personagem: $e');
      return null;
    }
  }
  
  // Deleta um personagem
  static Future<bool> deleteCharacter(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<CharacterModel> characters = await getAllCharacters();
      
      // Encontra o personagem a ser deletado para remover seu avatar
      final characterToDelete = characters.where((c) => c.id == id).firstOrNull;
      
      // Remove o personagem da lista
      characters.removeWhere((c) => c.id == id);
      
      // Salva a lista atualizada
        List<String> charactersJson = characters
          .map((c) => jsonEncode(c.toJson()))
          .toList();

        final user = FirebaseAuth.instance.currentUser;
        final key = _keyForUid(user?.uid);

        final success = await prefs.setStringList(key, charactersJson);
      
      // Se a deleção foi bem-sucedida e o personagem tinha avatar, deleta a imagem
      if (success && characterToDelete?.avatarPath != null) {
        await AvatarStorageService.deleteAvatarImage(characterToDelete!.avatarPath!);
      }
      
      return success;
    } catch (e) {
      print('Erro ao deletar personagem: $e');
      return false;
    }
  }
  
  // Limpa todos os personagens (usado para testes/debug)
  static Future<bool> clearAllCharacters() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final user = FirebaseAuth.instance.currentUser;
      final key = _keyForUid(user?.uid);
      return await prefs.remove(key);
    } catch (e) {
      print('Erro ao limpar personagens: $e');
      return false;
    }
  }
}