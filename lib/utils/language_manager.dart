import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageManager extends ChangeNotifier {
  static final LanguageManager _instance = LanguageManager._internal();
  factory LanguageManager() => _instance;
  LanguageManager._internal();

  Locale _currentLocale = const Locale('pt', '');

  Locale get currentLocale => _currentLocale;

  /// Inicializa o idioma a partir das preferências salvas
  Future<void> initializeLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString('language') ?? 'pt';
    
    _currentLocale = Locale(savedLanguage, '');
    notifyListeners();
  }

  /// Altera o idioma e salva a preferência
  Future<void> changeLanguage(String languageCode) async {
    if (languageCode == _currentLocale.languageCode) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', languageCode);
    
    _currentLocale = Locale(languageCode, '');
    notifyListeners();
  }

  /// Retorna true se o idioma atual for português
  bool get isPortuguese => _currentLocale.languageCode == 'pt';

  /// Retorna true se o idioma atual for inglês  
  bool get isEnglish => _currentLocale.languageCode == 'en';

  /// Retorna o código do idioma atual
  String get currentLanguageCode => _currentLocale.languageCode;
}