import 'package:flutter/material.dart';
import 'utils/app_routes.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/character/race_list_screen.dart';
import 'screens/character/race_detail_screen.dart' as race_detail;
import 'screens/character/class_screen.dart'; // Ensure this file defines 'ClassScreen'
import 'screens/about/about_screen.dart';
import 'screens/recuperar/recuperar_senha_screen.dart';
import 'screens/character/background_screen.dart';
import 'screens/character/background_detail_screen.dart';
import 'screens/ficha/summary_screen.dart';
import 'screens/character/attributes_screen.dart';

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
        AppRoutes.raceDetail: (_) => const race_detail.RaceDetailScreen(),
        AppRoutes.classScreen: (_) => const ClassScreen(),
        AppRoutes.about: (_) => const AboutScreen(),
        AppRoutes.recuperarSenha: (_) => const RecuperarSenhaScreen(),
        AppRoutes.backgroundScreen: (_) => const BackgroundScreen(),
        AppRoutes.backgroundDetailScreen: (_) => const BackgroundDetailScreen(),
        AppRoutes.summaryScreen: (_) => const SummaryScreen(),
        AppRoutes.attributeScreen: (_) => const AttributesScreen(),
      },
    );
  }
}
