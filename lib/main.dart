import 'package:flutter/material.dart';
import 'utils/app_routes.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/character/race_list_screen.dart';
import 'screens/about/about_screen.dart';
import 'package:device_preview/device_preview.dart';
import 'package:app_rpg/screens/recuperar/recuperar_senha_screen.dart';
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
        AppRoutes.races: (_) => const RaceListScreen(),
        AppRoutes.about: (_) => const AboutScreen(), // Substituído pela tela Sobre
        AppRoutes.recuperarSenha: (_) => const RecuperarSenhaScreen(), // Adicionada a rota para Recuperar Senha
      },
    );
  }
}
