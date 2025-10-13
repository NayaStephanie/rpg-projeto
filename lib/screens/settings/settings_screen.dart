// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_rpg/services/subscription_service.dart';
import 'package:app_rpg/services/language_service.dart';
import 'package:app_rpg/utils/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isPremium = false;
  String _storageType = 'local';
  int _characterLimit = 2;
  bool _loading = true;
  String _selectedLanguage = 'pt';

  String _getTranslatedText(String key) {
    return AppLocalizations.of(context)?.translate(key) ?? key;
  }

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() => _loading = true);
    
    try {
      final isPremium = await SubscriptionService.isPremiumUser();
      final storageType = await SubscriptionService.getStorageType();
      final limit = await SubscriptionService.getCharacterLimit();
      final currentLocale = await LanguageService.getLanguage();
      
      setState(() {
        _isPremium = isPremium;
        _storageType = storageType;
        _characterLimit = limit;
        _selectedLanguage = currentLocale.languageCode;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      _showSnackBar(_getTranslatedText('errorLoadingSettings'), isError: true);
    }
  }

  Future<void> _upgradeToPremium() async {
    // Navega para a tela de pagamento
    final result = await Navigator.pushNamed(context, '/payment');
    
    // Se voltou da tela de pagamento, recarrega as configurações
    if (result == true || mounted) {
      _loadSettings();
    }
  }

  Future<void> _resetToFree() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2C1810),
        title: Text(
          _getTranslatedText('confirmReset'),
          style: GoogleFonts.cinzel(color: Colors.white),
        ),
        content: Text(
          _getTranslatedText('confirmBackToFree'),
          style: GoogleFonts.cinzel(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              _getTranslatedText('cancel'),
              style: GoogleFonts.cinzel(color: Colors.white70),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              _getTranslatedText('confirm'),
              style: GoogleFonts.cinzel(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await SubscriptionService.resetToFree();
        _showSnackBar(_getTranslatedText('backToFreeSuccess'), isError: false);
        _loadSettings();
      } catch (e) {
        _showSnackBar('${_getTranslatedText('resetError')} $e', isError: true);
      }
    }
  }

  Future<void> _changeLanguage(String languageCode) async {
    try {
      await LanguageService.setLanguage(languageCode);
      if (mounted) {
        setState(() {
          _selectedLanguage = languageCode;
        });
        _showSnackBar(AppLocalizations.of(context)?.translate('languageChangedRestart') ?? 'Idioma alterado. Reinicie o aplicativo para aplicar as mudanças.', isError: false);
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('${_getTranslatedText('languageChangeError')} $e', isError: true);
      }
    }
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
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
                image: AssetImage("lib/assets/images/image_fundo.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.6),
          ),
          
          SafeArea(
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              AppLocalizations.of(context)?.translate('settings') ?? 'Configurações',
                              style: GoogleFonts.jimNightshade(
                                fontSize: 36,
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
                          ],
                        ),
                        const SizedBox(height: 30),

                        // Status da assinatura
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2C1810).withOpacity(0.9),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _isPremium ? Colors.amber : Colors.grey,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    _isPremium ? Icons.workspace_premium : Icons.person,
                                    color: _isPremium ? Colors.amber : Colors.white,
                                    size: 32,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    _isPremium ? _getTranslatedText('premiumActive') : _getTranslatedText('freeVersion'),
                                    style: GoogleFonts.cinzel(
                                      color: _isPremium ? Colors.amber : Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              
                              Text(
                                '${_getTranslatedText('storage')}: ${_storageType == "cloud" ? _getTranslatedText('cloud') : _getTranslatedText('local')}',
                                style: GoogleFonts.cinzel(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                              
                              if (!_isPremium) ...[
                                const SizedBox(height: 8),
                                Text(
                                  '${_getTranslatedText('limit')}: $_characterLimit ${_getTranslatedText('charactersLimit')}',
                                  style: GoogleFonts.cinzel(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Seleção de Idioma
                        Text(
                          AppLocalizations.of(context)?.translate('language') ?? 'Idioma',
                          style: GoogleFonts.cinzel(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2C1810).withOpacity(0.9),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getTranslatedText('selectInterfaceLanguage'),
                                style: GoogleFonts.cinzel(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 16),
                              
                              DropdownButtonFormField<String>(
                                value: _selectedLanguage,
                                dropdownColor: const Color(0xFF2C1810),
                                style: GoogleFonts.cinzel(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.black.withOpacity(0.3),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(color: Colors.grey),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(color: Colors.grey),
                                  ),
                                ),
                                items: LanguageService.availableLanguages.map((language) {
                                  return DropdownMenuItem<String>(
                                    value: language['code'],
                                    child: Text(
                                      language['name']!,
                                      style: GoogleFonts.cinzel(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  if (newValue != null && newValue != _selectedLanguage) {
                                    _changeLanguage(newValue);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Benefícios Premium
                        if (!_isPremium) ...[
                          Text(
                            _getTranslatedText('premiumBenefits'),
                            style: GoogleFonts.cinzel(
                              color: Colors.amber,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          ...SubscriptionService.getPremiumFeatures().entries.map(
                            (feature) => Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2C1810).withOpacity(0.7),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.amber.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.amber,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      feature.value,
                                      style: GoogleFonts.cinzel(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],

                        // Botões de ação
                        if (!_isPremium)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber,
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: _upgradeToPremium,
                              icon: const Icon(Icons.workspace_premium),
                              label: Text(
                                _getTranslatedText('upgradeToPremium'),
                                style: GoogleFonts.cinzel(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        
                        if (_isPremium) ...[
                          Text(
                            _getTranslatedText('advancedOptions'),
                            style: GoogleFonts.cinzel(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red.withOpacity(0.8),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: _resetToFree,
                              icon: const Icon(Icons.arrow_downward),
                              label: Text(
                                _getTranslatedText('backToFreeVersion'),
                                style: GoogleFonts.cinzel(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}