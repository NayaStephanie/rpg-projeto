
import 'package:flutter/material.dart';
import 'utils/app_routes.dart';
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
import 'package:app_rpg/screens/ficha_pronta/ficha_pronta.dart';


// ignore: unused_import
import 'package:get_it/get_it.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: true, // Mudar para true para ativar o Device Preview
      builder: (context) => const MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RPGo!',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
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
        AppRoutes.characterSheet: (_) => const CharacterSheet(), // Nova rota para a ficha final (sem personagem existente)
        
      },
    );
  }
}