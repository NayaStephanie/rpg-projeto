import 'package:shared_preferences/shared_preferences.dart';

class SubscriptionService {
  static const String _premiumKey = 'is_premium_user';
  static const String _storageTypeKey = 'storage_type';
  static const int maxFreeCharacters = 2;

  // Verifica se o usuário é premium
  static Future<bool> isPremiumUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_premiumKey) ?? false;
  }

  // Define o status premium do usuário
  static Future<void> setPremiumStatus(bool isPremium) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_premiumKey, isPremium);
  }

  // Obtém o tipo de armazenamento (local ou cloud)
  static Future<String> getStorageType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_storageTypeKey) ?? 'local';
  }

  // Define o tipo de armazenamento
  static Future<void> setStorageType(String storageType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageTypeKey, storageType);
  }

  // Verifica se pode criar mais personagens
  static Future<bool> canCreateCharacter(int currentCharacterCount) async {
    final isPremium = await isPremiumUser();
    
    if (isPremium) {
      return true; // Usuários premium podem criar quantos personagens quiserem
    }
    
    return currentCharacterCount < maxFreeCharacters;
  }

  // Obtém o limite de personagens baseado na assinatura
  static Future<int> getCharacterLimit() async {
    final isPremium = await isPremiumUser();
    return isPremium ? -1 : maxFreeCharacters; // -1 significa ilimitado
  }

  // Mensagem de limitação para usuários gratuitos
  static String getLimitationMessage() {
    return 'Versão gratuita limitada a $maxFreeCharacters personagens.\nFaça upgrade para criar personagens ilimitados e salvar na nuvem!';
  }

  // Simula upgrade para premium (em produção seria integrado com sistema de pagamento)
  static Future<bool> upgradeToPremium() async {
    // Em uma implementação real, aqui seria feita a integração com:
    // - Google Play Billing (Android)
    // - App Store Connect (iOS)
    // - Stripe/PayPal (Web)
    
    // Por enquanto, vamos simular o upgrade
    await setPremiumStatus(true);
    await setStorageType('cloud');
    return true;
  }

  // Informações sobre os benefícios premium
  static Map<String, dynamic> getPremiumFeatures() {
    return {
      'unlimited_characters': 'Personagens ilimitados',
      'cloud_storage': 'Armazenamento na nuvem',
      'backup_sync': 'Backup automático e sincronização',
      'priority_support': 'Suporte prioritário',
      'exclusive_features': 'Recursos exclusivos futuros',
    };
  }

  // Reset para versão gratuita (útil para testes)
  static Future<void> resetToFree() async {
    await setPremiumStatus(false);
    await setStorageType('local');
  }
}