import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'pt': {
      // App geral
      'appTitle': 'RPGo!',
      
      // Autenticação
      'login': 'Entrar',
      'signup': 'Cadastrar',
      'email': 'E-mail',
      'password': 'Senha',
      'forgotPassword': 'Esqueceu a senha?',
      'emailOrPasswordIncorrect': 'Email ou senha incorretos',
      'welcome': 'Bem-vindo ao RPGo!',
      
      // Navegação principal
      'characters': 'Personagens',
      'createCharacter': 'Criar',
      'settings': 'Configurações',
      'about': 'Sobre',
      'support': 'Suporte',
      'language': 'Idioma',
      'portuguese': 'Português',
      'english': 'English',
      
      // Criação de personagem
      'race': 'Raça',
      'class': 'Classe',
      'background': 'Antecedente',
      'attributes': 'Atributos',
      'equipment': 'Equipamentos',
      'summary': 'Resumo',
      'characterSheet': 'Ficha do Personagem',
      'selectRace': 'Selecione uma Raça',
      'selectClass': 'Selecione uma Classe',
      'selectBackground': 'Selecione um Antecedente',
      'selectLanguage': 'Selecionar Idioma',
      
      // Atributos
      'strength': 'Força',
      'dexterity': 'Destreza',
      'constitution': 'Constituição',
      'intelligence': 'Inteligência',
      'wisdom': 'Sabedoria',
      'charisma': 'Carisma',
      
      // Raças
      'human': 'Humano',
      'elf': 'Elfo',
      'dwarf': 'Anão',
      'halfling': 'Halfling',
      'dragonborn': 'Draconato',
      'gnome': 'Gnomo',
      'halfElf': 'Meio-Elfo',
      'halfOrc': 'Meio-Orc',
      'tiefling': 'Tiefling',
      
      // Classes
      'barbarian': 'Bárbaro',
      'bard': 'Bardo',
      'cleric': 'Clérico',
      'druid': 'Druida',
      'fighter': 'Guerreiro',
      'monk': 'Monge',
      'paladin': 'Paladino',
      'ranger': 'Patrulheiro',
      'rogue': 'Ladino',
      'sorcerer': 'Feiticeiro',
      'warlock': 'Bruxo',
      'wizard': 'Mago',
      
      // Botões e ações
      'next': 'Próximo',
      'previous': 'Anterior',
      'save': 'Salvar',
      'cancel': 'Cancelar',
      'confirm': 'Confirmar',
      'back': 'Voltar',
      'close': 'Fechar',
      'edit': 'Editar',
      'delete': 'Excluir',
      'yes': 'Sim',
      'no': 'Não',
      
      // Validações de login
      'enterEmail': 'Informe seu email',
      'validEmail': 'Digite um email válido',
      'enterPassword': 'Informe sua senha',
      'passwordTooShort': 'Senha muito curta',
      'dontHaveAccount': 'Não tem conta? ',
      'signUpHere': 'Cadastre-se aqui',
      
      // Cadastro
      'name': 'Nome',
      'phone': 'Telefone',
      'confirmPassword': 'Confirmar Senha',
      'enterName': 'Digite seu nome',
      'enterPhone': 'Digite seu telefone',
      'enterConfirmPassword': 'Confirme sua senha',
      'passwordsDontMatch': 'Senhas não coincidem',
      'signupSuccess': 'Cadastro realizado com sucesso!',
      'alreadyHaveAccount': 'Já tem conta? ',
      'loginHere': 'Entre aqui',
      'saveLocally': 'Salvar localmente (grátis)',
      'saveInCloud': 'Salvar na nuvem (pago)',
      'storageOption': 'Opção de Armazenamento',
      
      // Recuperar senha
      'recoverPassword': 'Recuperar Senha',
      'sendRecoveryEmail': 'Enviar',
      'enterEmailRecover': 'Digite seu email para recuperar a senha',
      'recoveryEmailSent': 'Um link de recuperação foi enviado para',
      'enterValidEmail': 'Digite um email válido',
      
      // Configurações e outras telas
      'errorLoadingSettings': 'Erro ao carregar configurações',
      'languageChangedRestart': 'Idioma alterado. Reinicie o aplicativo para aplicar as mudanças.',
      'premiumActive': 'Premium Ativo',
      'freeVersion': 'Versão Gratuita',
      'storage': 'Armazenamento',
      'cloud': 'Nuvem',
      'local': 'Local',
      'limit': 'Limite',
      'charactersLimit': 'personagens',
      'selectInterfaceLanguage': 'Selecione o idioma da interface:',
      'premiumBenefits': 'Benefícios Premium',
      'upgradeToPremium': 'Fazer Upgrade para Premium',
      'advancedOptions': 'Opções Avançadas',
      'backToFreeVersion': 'Voltar para Versão Gratuita',
      'confirmReset': 'Confirmar Reset',
      'confirmBackToFree': 'Tem certeza que deseja voltar para a versão gratuita?',
      'backToFreeSuccess': 'Voltou para versão gratuita',
      'resetError': 'Erro ao resetar:',
      'languageChangeError': 'Erro ao alterar idioma:',
      
      // Suporte
      'howCanWeHelp': 'Como podemos ajudar você?',
      'fullName': 'Nome Completo',
      'fullNameHint': 'Seu nome completo',
      'subject': 'Assunto',
      'subjectHint': 'Descreva brevemente o problema',
      'detailedDescription': 'Descrição Detalhada',
      'descriptionHint': 'Descreva o problema em detalhes...',
      'sendRequest': 'Enviar Solicitação',
      'fillAllFields': 'Por favor, preencha todos os campos obrigatórios.',
      'validEmailPlease': 'Por favor, insira um email válido.',
      'requestSentSuccess': 'Solicitação enviada com sucesso! Entraremos em contato em breve.',
      'otherContactMethods': 'Outras formas de contato',
      'schedule': 'Horário',
      'twentyFourSeven': '24h/7 dias',
      'response': 'Resposta',
      'upToTwentyFourHours': 'Até 24h',
      
      // Diálogos comuns
      'deleteCharacter': 'Excluir Personagem',
      'confirmDeleteCharacter': 'Tem certeza que deseja excluir',
      'loading': 'Carregando...',
      'processando': 'Processando...',
      'aguarde': 'Aguarde...',
      'operationComplete': 'Operação concluída',
      'operationError': 'Erro na operação',
      'tryAgain': 'Tentar novamente',
      
      // Mensagens de validação
      'error': 'Erro',
      'success': 'Sucesso',
      'warning': 'Aviso',
      'information': 'Informação',
      'pleaseSelectRace': 'Por favor, selecione uma raça antes de prosseguir.',
      'pleaseSelectClass': 'Por favor, selecione uma classe antes de prosseguir.',
      'aboutProject': 'Sobre o Projeto',
      
      // About Screen
      'aboutWhatIs': 'O que é o RPGo!?',
      'aboutWhatIsContent': 'RPGo! é um aplicativo completo para criação e gerenciamento de personagens de RPG de mesa baseado no sistema D&D 5ª Edição. Desenvolvido para facilitar a vida de jogadores e mestres, oferece uma interface intuitiva e recursos poderosos para dar vida aos seus personagens.',
      'aboutHowItWorks': 'Como Funciona',
      'aboutHowItWorksContent': 'O aplicativo guia você através de um processo passo-a-passo para criar seu personagem: escolha da raça, classe, antecedente, distribuição de atributos e equipamentos iniciais. Cada etapa é cuidadosamente projetada para seguir as regras oficiais do D&D 5e.',
      'aboutFeatures': 'Recursos Principais',
      'aboutFeaturesContent': '• Criação completa de personagens\n• Cálculos automáticos de CA, modificadores e saving throws\n• Gerenciamento de equipamentos e inventário\n• Interface temática medieval\n• Suporte a múltiplos idiomas\n• Fichas organizadas e fáceis de usar',
      'aboutTechnology': 'Tecnologia',
      'aboutTechnologyContent': 'Desenvolvido em Flutter para garantir uma experiência fluida em todas as plataformas. Utiliza design responsivo, persistência local de dados e arquitetura moderna para performance otimizada.',
      'aboutVersion': 'Versão',
      'aboutVersionContent': 'Versão atual: 1.0.0\nÚltima atualização: Dezembro 2024\nCompatível com regras D&D 5ª Edição',
      'aboutFooter': 'Que sua jornada seja épica e suas aventuras inesquecíveis!',
      // Gerenciamento em nuvem
      'manageCloudCharacters': 'Gerenciar Personagens (Nuvem)',
      'manageCloudInventory': 'Gerenciar Inventário (Nuvem)',
    },
    'en': {
      // App general
      'appTitle': 'RPGo!',
      
      // Authentication
      'login': 'Login',
      'signup': 'Sign Up',
      'email': 'Email',
      'password': 'Password',
      'forgotPassword': 'Forgot Password?',
      'emailOrPasswordIncorrect': 'Incorrect email or password',
      'welcome': 'Welcome to RPGo!',
      
      // Main navigation
      'characters': 'Characters',
      'createCharacter': 'Create Character',
      'settings': 'Settings',
      'about': 'About',
      'support': 'Support',
      'language': 'Language',
      'portuguese': 'Português',
      'english': 'English',
      
      // Character creation
      'race': 'Race',
      'class': 'Class',
      'background': 'Background',
      'attributes': 'Attributes',
      'equipment': 'Equipment',
      'summary': 'Summary',
      'characterSheet': 'Character Sheet',
      'selectRace': 'Select a Race',
      'selectClass': 'Select a Class',
      'selectBackground': 'Select a Background',
      'selectLanguage': 'Select Language',
      
      // Attributes
      'strength': 'Strength',
      'dexterity': 'Dexterity',
      'constitution': 'Constitution',
      'intelligence': 'Intelligence',
      'wisdom': 'Wisdom',
      'charisma': 'Charisma',
      
      // Races
      'human': 'Human',
      'elf': 'Elf',
      'dwarf': 'Dwarf',
      'halfling': 'Halfling',
      'dragonborn': 'Dragonborn',
      'gnome': 'Gnome',
      'halfElf': 'Half-Elf',
      'halfOrc': 'Half-Orc',
      'tiefling': 'Tiefling',
      
      // Classes
      'barbarian': 'Barbarian',
      'bard': 'Bard',
      'cleric': 'Cleric',
      'druid': 'Druid',
      'fighter': 'Fighter',
      'monk': 'Monk',
      'paladin': 'Paladin',
      'ranger': 'Ranger',
      'rogue': 'Rogue',
      'sorcerer': 'Sorcerer',
      'warlock': 'Warlock',
      'wizard': 'Wizard',
      
      // Buttons and actions
      'next': 'Next',
      'previous': 'Previous',
      'save': 'Save',
      'cancel': 'Cancel',
      'confirm': 'Confirm',
      'back': 'Back',
      'close': 'Close',
      'edit': 'Edit',
      'delete': 'Delete',
      'yes': 'Yes',
      'no': 'No',
      
      // Login validations
      'enterEmail': 'Enter your email',
      'validEmail': 'Enter a valid email',
      'enterPassword': 'Enter your password',
      'passwordTooShort': 'Password too short',
      'dontHaveAccount': "Don't have an account? ",
      'signUpHere': 'Sign up here',
      
      // Signup
      'name': 'Name',
      'phone': 'Phone',
      'confirmPassword': 'Confirm Password',
      'enterName': 'Enter your name',
      'enterPhone': 'Enter your phone',
      'enterConfirmPassword': 'Confirm your password',
      'passwordsDontMatch': 'Passwords do not match',
      'signupSuccess': 'Registration successful!',
      'alreadyHaveAccount': 'Already have an account? ',
      'loginHere': 'Login here',
      'saveLocally': 'Save locally (free)',
      'saveInCloud': 'Save in cloud (paid)',
      'storageOption': 'Storage Option',
      
      // Recover password
      'recoverPassword': 'Recover Password',
      'sendRecoveryEmail': 'Send Recovery Email',
      'enterEmailRecover': 'Enter your email to recover password',
      'recoveryEmailSent': 'A recovery link has been sent to',
      'enterValidEmail': 'Enter a valid email',
      
      // Settings and other screens
      'errorLoadingSettings': 'Error loading settings',
      'languageChangedRestart': 'Language changed. Restart the app to apply changes.',
      'premiumActive': 'Premium Active',
      'freeVersion': 'Free Version',
      'storage': 'Storage',
      'cloud': 'Cloud',
      'local': 'Local',
      'limit': 'Limit',
      'charactersLimit': 'characters',
      'selectInterfaceLanguage': 'Select the interface language:',
      'premiumBenefits': 'Premium Benefits',
      'upgradeToPremium': 'Upgrade to Premium',
      'advancedOptions': 'Advanced Options',
      'backToFreeVersion': 'Back to Free Version',
      'confirmReset': 'Confirm Reset',
      'confirmBackToFree': 'Are you sure you want to go back to the free version?',
      'backToFreeSuccess': 'Back to free version',
      'resetError': 'Error resetting:',
      'languageChangeError': 'Error changing language:',
      
      // Support
      'howCanWeHelp': 'How can we help you?',
      'fullName': 'Full Name',
      'fullNameHint': 'Your full name',
      'subject': 'Subject',
      'subjectHint': 'Briefly describe the problem',
      'detailedDescription': 'Detailed Description',
      'descriptionHint': 'Describe the problem in detail...',
      'sendRequest': 'Send Request',
      'fillAllFields': 'Please fill in all required fields.',
      'validEmailPlease': 'Please enter a valid email.',
      'requestSentSuccess': 'Request sent successfully! We will contact you soon.',
      'otherContactMethods': 'Other contact methods',
      'schedule': 'Schedule',
      'twentyFourSeven': '24h/7 days',
      'response': 'Response',
      'upToTwentyFourHours': 'Up to 24h',
      
      // Common dialogs
      'deleteCharacter': 'Delete Character',
      'confirmDeleteCharacter': 'Are you sure you want to delete',
      'loading': 'Loading...',
      'processando': 'Processing...',
      'aguarde': 'Please wait...',
      'operationComplete': 'Operation completed',
      'operationError': 'Operation error',
      'tryAgain': 'Try again',
      
      // Error messages
      'error': 'Error',
      'success': 'Success',
      'warning': 'Warning',
      'information': 'Information',
      'pleaseSelectRace': 'Please select a race before proceeding.',
      'pleaseSelectClass': 'Please select a class before proceeding.',
      'aboutProject': 'About the Project',
      
      // About Screen
      'aboutWhatIs': 'What is RPGo!?',
      'aboutWhatIsContent': 'RPGo! is a complete application for creating and managing tabletop RPG characters based on the D&D 5th Edition system. Developed to make life easier for players and masters, it offers an intuitive interface and powerful features to bring your characters to life.',
      'aboutHowItWorks': 'How It Works',
      'aboutHowItWorksContent': 'The app guides you through a step-by-step process to create your character: race selection, class, background, attribute distribution, and starting equipment. Each step is carefully designed to follow official D&D 5e rules.',
      'aboutFeatures': 'Main Features',
      'aboutFeaturesContent': '• Complete character creation\n• Automatic calculations for AC, modifiers, and saving throws\n• Equipment and inventory management\n• Medieval themed interface\n• Multi-language support\n• Organized and easy-to-use character sheets',
      'aboutTechnology': 'Technology',
      'aboutTechnologyContent': 'Developed in Flutter to ensure a smooth experience across all platforms. Uses responsive design, local data persistence, and modern architecture for optimized performance.',
      'aboutVersion': 'Version',
      'aboutVersionContent': 'Current version: 1.0.0\nLast update: December 2024\nCompatible with D&D 5th Edition rules',
      'aboutFooter': 'May your journey be epic and your adventures unforgettable!',
      // Cloud management
      'manageCloudCharacters': 'Manage Characters (Cloud)',
      'manageCloudInventory': 'Manage Inventory (Cloud)',
    },
  };

  String translate(String key) {
    final langCode = locale.languageCode;
    return _localizedValues[langCode]?[key] ?? 
           _localizedValues['pt']?[key] ?? 
           key;
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['pt', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}