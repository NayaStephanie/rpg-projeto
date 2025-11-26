// ignore_for_file: deprecated_member_use, use_build_context_synchronously, avoid_print, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_rpg/services/subscription_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
// foundation already imported above
import '../../services/auth_service.dart';
import 'package:app_rpg/screens/payment/payment_screen.dart';
import '../../utils/app_localizations.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String storageOption = "local"; // valor padrão

  // Controllers para pegar valores dos campos
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController confirmarSenhaController = TextEditingController();

  // Estado para requisitos da senha (atualiza dinamicamente)
  bool _pwdHasMin = false;
  bool _pwdHasUpper = false;
  bool _pwdHasLower = false;
  bool _pwdHasSpecial = false;

  @override
  void initState() {
    super.initState();
    senhaController.addListener(_onPasswordChanged);
  }

  @override
  void dispose() {
    senhaController.removeListener(_onPasswordChanged);
    nomeController.dispose();
    emailController.dispose();
    telefoneController.dispose();
    senhaController.dispose();
    confirmarSenhaController.dispose();
    super.dispose();
  }

  String _getTranslatedText(String key) {
    final localizations = AppLocalizations.of(context);
    return localizations?.translate(key) ?? key;
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

          // Conteúdo central
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Título
                Text(
                  _getTranslatedText('signup'),
                  style: GoogleFonts.jimNightshade(
                    fontSize: 60,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 40),

                // Nome de usuário
                _buildTextField(_getTranslatedText("name"), controller: nomeController),
                const SizedBox(height: 20),

                // Email
                _buildTextField(_getTranslatedText("email"), controller: emailController),
                const SizedBox(height: 20),

                // Número de telefone
                _buildTextField(_getTranslatedText("phone"), controller: telefoneController),
                const SizedBox(height: 20),

                // Senha
                _buildTextField(_getTranslatedText("password"), controller: senhaController, isPassword: true),

                // Helper visual dinâmico com requisitos da senha
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPasswordRequirementRow('Mínimo 8 caracteres', _pwdHasMin),
                      _buildPasswordRequirementRow('Pelo menos uma letra maiúscula', _pwdHasUpper),
                      _buildPasswordRequirementRow('Pelo menos uma letra minúscula', _pwdHasLower),
                      _buildPasswordRequirementRow('Pelo menos um dígito ou caractere especial', _pwdHasSpecial),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Confirmar senha
                _buildTextField(_getTranslatedText("confirmPassword"), controller: confirmarSenhaController, isPassword: true),
                const SizedBox(height: 30),

                // Opções de armazenamento
                Row(
                  children: [
                    Radio<String>(
                      value: "local",
                      groupValue: storageOption,
                      activeColor: Colors.white,
                      onChanged: (value) {
                        setState(() {
                          storageOption = value!;
                        });
                      },
                    ),
                    Expanded(
                      child: Text(
                        _getTranslatedText("saveLocally"),
                        style: GoogleFonts.imFellEnglish(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Radio<String>(
                      value: "cloud",
                      groupValue: storageOption,
                      activeColor: Colors.white,
                      onChanged: (value) {
                        setState(() {
                          storageOption = value!;
                        });
                      },
                    ),
                    Expanded(
                      child: Text(
                        _getTranslatedText("saveInCloud"),
                        style: GoogleFonts.imFellEnglish(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // Botão Cadastrar
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF767676).withOpacity(0.35),
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
                    _handleSignup(context);
                  },
                  child: Text(_getTranslatedText("signup")),
                ),
                const SizedBox(height: 30),

                // Botão Voltar
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    _getTranslatedText("back"),
                    style: GoogleFonts.imFellEnglish(
                      fontSize: 26,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget auxiliar para criar campos de texto
  Widget _buildTextField(String hint, {bool isPassword = false, TextEditingController? controller}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: GoogleFonts.imFellEnglish(color: Colors.white, fontSize: 18),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.black.withAlpha((0.20 * 255).toInt()),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white),
        ),
      ),
    );
  }

  // Função para exibir SnackBar customizado
  void _mostrarSnackBar(BuildContext context, String mensagem,
      {IconData? icone, Color cor = Colors.red}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icone ?? Icons.error_outline, color: Colors.white),
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

  // Handler que une validacao, criação no Firebase e fluxo de pagamento
  void _handleSignup(BuildContext context) async {
    String nome = nomeController.text.trim();
    String email = emailController.text.trim();
    String telefone = telefoneController.text.trim();
    String senha = senhaController.text.trim();
    String confirmarSenha = confirmarSenhaController.text.trim();

    if (nome.isEmpty || email.isEmpty || telefone.isEmpty || senha.isEmpty || confirmarSenha.isEmpty) {
      _mostrarSnackBar(context, "Por favor, preencha todos os campos.", icone: Icons.warning_amber_rounded, cor: Colors.orange);
      return;
    }

    if (senha != confirmarSenha) {
      _mostrarSnackBar(context, "As senhas não coincidem.", icone: Icons.lock_outline, cor: Colors.red);
      return;
    }

    // Validação de força da senha (regras mínimas)
    final pwdErrors = _validatePassword(senha);
    if (pwdErrors.isNotEmpty) {
      // Mostra erros concatenados em uma única snackbar para feedback claro
      final mensagem = 'Senha inválida:\n' + pwdErrors.map((s) => '• $s').join('\n');
      _mostrarSnackBar(context, mensagem, icone: Icons.lock, cor: Colors.orange);
      return;
    }

    // Mostra loading
    showDialog(context: context, barrierDismissible: false, builder: (_) => const Center(child: CircularProgressIndicator()));

    try {
      // Cria usuário no Firebase e salva dados no Firestore via AuthService
      await AuthService.signUp(name: nome, phone: telefone, email: email, password: senha);

      // Salva o tipo de armazenamento escolhido
      await SubscriptionService.setStorageType(storageOption);

      if (storageOption == "cloud") {
        Navigator.of(context).pop(); // fecha loading antes de ir para pagamento
        final paymentResult = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PaymentScreen(fromSignup: true),
          ),
        );

        if (paymentResult == true) {
          _mostrarSnackBar(context, "Cadastro Premium realizado com sucesso! Bem-vindo! 🎉", icone: Icons.workspace_premium, cor: Colors.amber);
        } else {
          await SubscriptionService.setStorageType("local");
          await SubscriptionService.setPremiumStatus(false);
          _mostrarSnackBar(context, "Cadastro realizado como versão gratuita (máximo 2 personagens)", icone: Icons.check_circle_outline, cor: Colors.green);
        }
      } else {
        await SubscriptionService.setPremiumStatus(false);
        Navigator.of(context).pop();
        _mostrarSnackBar(context, "Cadastro realizado com sucesso! (Versão gratuita - máximo 2 personagens)", icone: Icons.check_circle_outline, cor: Colors.green);
      }

      await Future.delayed(const Duration(seconds: 2));
      if (mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (mounted) Navigator.of(context).pop();

      String mensagem;
      switch (e.code) {
        case 'email-already-in-use':
          mensagem = 'Este email já está cadastrado. Tente recuperar a senha ou usar outro email.';
          break;
        case 'invalid-email':
          mensagem = 'O email informado é inválido.';
          break;
        case 'weak-password':
          mensagem = 'Senha fraca. Use pelo menos 8 caracteres, com letras maiúsculas, minúsculas e caracteres especiais/dígitos.';
          break;
        case 'operation-not-allowed':
          mensagem = 'Criação de conta desabilitada. Verifique as configurações do Firebase.';
          break;
        case 'network-request-failed':
          mensagem = 'Falha de rede. Verifique sua conexão com a internet.';
          break;
        default:
          mensagem = e.message ?? 'Erro ao criar conta: ${e.code}';
      }

      _mostrarSnackBar(context, mensagem, icone: Icons.error_outline, cor: Colors.red);
      // Log para debugging (somente no modo de desenvolvimento)
      if (kDebugMode) {
        if (kDebugMode) debugPrint('FirebaseAuthException signup: code=${e.code} message=${e.message}');
      }
    } on FirebaseException catch (e) {
      // Erros do Firestore ou plugins Firebase
      if (mounted) Navigator.of(context).pop();
      if (kDebugMode) {
        if (kDebugMode) debugPrint('FirebaseException signup: code=${e.code} message=${e.message}');
      }
      _mostrarSnackBar(context, 'Ocorreu um erro no serviço. Tente novamente mais tarde.', icone: Icons.error_outline, cor: Colors.red);
    } catch (e) {
      if (mounted) Navigator.of(context).pop();
      if (kDebugMode) {
        if (kDebugMode) debugPrint('Signup error: $e');
      }
      _mostrarSnackBar(context, 'Ocorreu um erro. Tente novamente mais tarde.', icone: Icons.error_outline, cor: Colors.red);
    }
  }

  // Valida a senha localmente e retorna lista de erros (vazia = senha ok)
  List<String> _validatePassword(String senha) {
    final errors = <String>[];
    if (senha.length < 8) {
      errors.add('Mínimo 8 caracteres.');
    }
    if (!RegExp(r'[A-Z]').hasMatch(senha)) {
      errors.add('Pelo menos uma letra maiúscula.');
    }
    if (!RegExp(r'[a-z]').hasMatch(senha)) {
      errors.add('Pelo menos uma letra minúscula.');
    }
    if (!RegExp(r'[0-9!@#\$%\^&\*()_+\-=[\]{};:\"\\|,.<>\/?]').hasMatch(senha)) {
      errors.add('Pelo menos um dígito ou caractere especial.');
    }
    return errors;
  }

  // Observador do campo de senha que atualiza os indicadores visuais
  void _onPasswordChanged() {
    final s = senhaController.text;
    final hasMin = s.length >= 8;
    final hasUpper = RegExp(r'[A-Z]').hasMatch(s);
    final hasLower = RegExp(r'[a-z]').hasMatch(s);
    final hasSpecial = RegExp(r'[0-9!@#\$%\^&\*()_+\-=[\]{};:\"\\|,.<>\/?]').hasMatch(s);

    if (hasMin != _pwdHasMin || hasUpper != _pwdHasUpper || hasLower != _pwdHasLower || hasSpecial != _pwdHasSpecial) {
      setState(() {
        _pwdHasMin = hasMin;
        _pwdHasUpper = hasUpper;
        _pwdHasLower = hasLower;
        _pwdHasSpecial = hasSpecial;
      });
    }
  }

  // Helper visual para cada requisito da senha
  Widget _buildPasswordRequirementRow(String text, bool satisfied) {
    final pwdText = senhaController.text;
    final isEmpty = pwdText.isEmpty;

    Color color;
    IconData icon;
    if (isEmpty) {
      // estado neutro antes do usuário digitar
      color = Colors.grey;
      icon = Icons.radio_button_unchecked;
    } else if (satisfied) {
      // requisito atendido
      color = Colors.green;
      icon = Icons.check_circle;
    } else {
      // requisito falhado
      color = Colors.redAccent;
      icon = Icons.cancel;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 16,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              style: GoogleFonts.imFellEnglish(
                color: color,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
