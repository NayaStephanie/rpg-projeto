import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService {
  static const String _languageKey = 'selected_language';
  
  // Idiomas suportados
  static const List<Locale> supportedLocales = [
    Locale('pt', 'BR'),
    Locale('en', 'US'),
  ];
  
  // Salva a preferência de idioma
  static Future<void> setLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
  }
  
  // Carrega a preferência de idioma
  static Future<Locale> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_languageKey) ?? 'pt';
    
    // Retorna o locale correspondente
    switch (languageCode) {
      case 'en':
        return const Locale('en', 'US');
      case 'pt':
      default:
        return const Locale('pt', 'BR');
    }
  }
  
  // Retorna o nome do idioma em formato legível
  static String getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'pt':
      default:
        return 'Português';
    }
  }
  
  // Lista de idiomas disponíveis para seleção
  static const List<Map<String, String>> availableLanguages = [
    {'code': 'pt', 'name': 'Português'},
    {'code': 'en', 'name': 'English'},
  ];
}