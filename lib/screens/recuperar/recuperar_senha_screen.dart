// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_localizations.dart';
import '../../services/auth_service.dart';

class RecuperarSenhaScreen extends StatefulWidget {
  const RecuperarSenhaScreen({super.key});

  @override
  State<RecuperarSenhaScreen> createState() => _RecuperarSenhaScreenState();
}

class _RecuperarSenhaScreenState extends State<RecuperarSenhaScreen> {
  final TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String _getTranslatedText(String key) {
    final localizations = AppLocalizations.of(context);
    return localizations?.translate(key) ?? key;
  }

  String? _validarEmail(String? value) {
    if (value == null || value.isEmpty) {
      return _getTranslatedText("enterEmail");
    }
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!regex.hasMatch(value)) {
      return _getTranslatedText("validEmail");
    }
    return null;
  }

  // Função para exibir SnackBar estilizado
  void _mostrarSnackBar(BuildContext context, String mensagem,
      {IconData? icone, Color cor = Colors.red}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icone ?? Icons.info_outline, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                mensagem,
                style: GoogleFonts.imFellEnglish(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: cor.withOpacity(0.85),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _enviar() {
    if (!_formKey.currentState!.validate()) {
      _mostrarSnackBar(context, _getTranslatedText("enterValidEmail"), icone: Icons.warning_amber_rounded, cor: Colors.orange);
      return;
    }

    showDialog(context: context, barrierDismissible: false, builder: (_) => const Center(child: CircularProgressIndicator()));

    AuthService.sendPasswordReset(email: emailController.text.trim()).then((_) {
      if (mounted) Navigator.of(context).pop();
      _mostrarSnackBar(context, "${_getTranslatedText("recoveryEmailSent")} ${emailController.text}", icone: Icons.email_outlined, cor: Colors.green);
    }).catchError((e) {
      if (mounted) Navigator.of(context).pop();
      if (kDebugMode) {
        print('Erro ao enviar email de recuperação: $e');
      }
      _mostrarSnackBar(context, 'Não foi possível enviar o email de recuperação. Verifique sua conexão e tente novamente.', icone: Icons.error_outline, cor: Colors.red);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fundo
          Image.asset(
            "lib/assets/images/image_fundo.png",
            fit: BoxFit.cover,
          ),

          // Conteúdo
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 165),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Título
                  Text(
                    _getTranslatedText("recoverPassword"),
                    style: GoogleFonts.jimNightshade(
                      fontSize: 60,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 70),

                  // Campo de email
                  TextFormField(
                    controller: emailController,
                    style: GoogleFonts.imFellEnglish(
                        color: Colors.white, fontSize: 18),
                    decoration: InputDecoration(
                      hintText: _getTranslatedText("enterEmailRecover"),
                      hintStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.black.withAlpha((0.20 * 255).toInt()),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                    ),
                    validator: _validarEmail,
                  ),
                  const SizedBox(height: 50),

                  // Botão ENVIAR
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF767676).withOpacity(0.35),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 65),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: GoogleFonts.imFellEnglish(
                          fontSize: 26,
                        ),
                      ),
                      onPressed: _enviar,
                      child: Text(_getTranslatedText("sendRecoveryEmail")),
                    ),
                  ),

                  const SizedBox(height: 50),

                  // Botão VOLTAR
                  SizedBox(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF767676).withOpacity(0.35),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 65),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: GoogleFonts.imFellEnglish(
                          fontSize: 26,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(_getTranslatedText("back")),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
