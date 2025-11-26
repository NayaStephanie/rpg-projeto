
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'utils/app_routes.dart';
import 'utils/app_localizations.dart';
import 'utils/language_manager.dart';
import 'screens/auth/login_screen.dart';
import 'package:device_preview/device_preview.dart';

import 'screens/auth/signup_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/character/race_list_screen.dart';
import 'screens/about/about_screen.dart';
import 'package:app_rpg/screens/recuperar/recuperar_senha_screen.dart';
import 'screens/character/race_detail_screen.dart';
import 'screens/character/class_screen.dart';
import 'screens/character/background_screen.dart';
import 'screens/character/background_detail_screen.dart';
import 'screens/ficha/summary_screen.dart';
import 'screens/character/attributes_screen.dart';
import 'screens/character/starting_equipment_screen.dart';
import 'package:app_rpg/screens/ficha_pronta/ficha_pronta.dart';
import 'screens/api/dnd_monsters_list_screen.dart';

// ignore: unused_import
import 'package:get_it/get_it.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';



// Chave global para acessar o MyApp
final GlobalKey<MyAppState> myAppKey = GlobalKey<MyAppState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Inicializa o Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inicializa o gerenciador de linguagem
  await LanguageManager().initializeLanguage();
  
  runApp(
    DevicePreview(
      enabled: false, // Mudar para true para ativar o Device Preview
      builder: (context) => ChangeNotifierProvider(
        create: (context) => LanguageManager(),
        child: MyApp(key: myAppKey),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageManager>(
      builder: (context, languageManager, child) {
        return MaterialApp(
          title: 'RPGo!',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          locale: languageManager.currentLocale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('pt', ''),
            Locale('en', ''),
          ],
      initialRoute: AppRoutes.login, // Começa na tela de login
      routes: {
        AppRoutes.login: (_) => const LoginScreen(),
        
        AppRoutes.signup: (_) => const SignupScreen(),
        AppRoutes.home: (_) => const HomeScreen(),
        AppRoutes.races: (_) => const RaceScreen(),
        AppRoutes.about: (_) => const AboutScreen(), 
        AppRoutes.recuperarSenha: (_) => const RecuperarSenhaScreen(), 
        AppRoutes.raceDetail: (_) => const RaceDetailScreen(),
        AppRoutes.classScreen: (_) => const ClassScreen(),
        AppRoutes.backgroundScreen: (_) => const BackgroundScreen(),
        AppRoutes.backgroundDetailScreen: (_) => const BackgroundDetailScreen(),
        AppRoutes.summaryScreen: (_) => const SummaryScreen(),
        AppRoutes.attributeScreen: (_) => const AttributesScreen(),
        AppRoutes.startingEquipmentScreen: (_) => const StartingEquipmentScreen(),
        AppRoutes.characterSheet: (_) => const CharacterSheet(), // Nova rota para a ficha final (sem personagem existente)
        AppRoutes.dndMonsters: (_) => const DndMonstersListScreen(),
        
      },
    );
      },
    );
  }
}