import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  // Controllers para os campos
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitSupport() {
    // Validações básicas
    if (_nameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _subjectController.text.trim().isEmpty ||
        _descriptionController.text.trim().isEmpty) {
      _showSnackBar(
        "Por favor, preencha todos os campos obrigatórios.",
        Icons.warning_amber_rounded,
        Colors.orange,
      );
      return;
    }

    // Validação de email básica
    if (!_emailController.text.contains('@')) {
      _showSnackBar(
        "Por favor, insira um email válido.",
        Icons.email_outlined,
        Colors.red,
      );
      return;
    }

    // Simula envio do ticket
    _showSnackBar(
      "Solicitação enviada com sucesso! Entraremos em contato em breve.",
      Icons.check_circle_outline,
      Colors.green,
    );

    // Limpa os campos após envio
    Future.delayed(const Duration(seconds: 2), () {
      _nameController.clear();
      _emailController.clear();
      _subjectController.clear();
      _descriptionController.clear();
    });
  }

  void _showSnackBar(String message, IconData icon, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.cinzel(fontSize: 14),
              ),
            ),
          ],
        ),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
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
          
          // Overlay escuro
          Container(
            color: Colors.black.withOpacity(0.6),
          ),

          // Conteúdo
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Header com botão voltar
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
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Título
                  Text(
                    "Suporte",
                    style: GoogleFonts.jimNightshade(
                      fontSize: 60,
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
                  const SizedBox(height: 10),
                  
                  Text(
                    "Como podemos ajudar você?",
                    style: GoogleFonts.cinzel(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),

                  // Card do formulário
                  Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C1810).withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.amber.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nome
                        _buildLabel("Nome Completo *"),
                        _buildTextField(
                          controller: _nameController,
                          hintText: "Seu nome completo",
                          icon: Icons.person_outline,
                        ),
                        const SizedBox(height: 20),

                        // Email
                        _buildLabel("Email *"),
                        _buildTextField(
                          controller: _emailController,
                          hintText: "seu.email@exemplo.com",
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 20),

                        // Assunto
                        _buildLabel("Assunto *"),
                        _buildTextField(
                          controller: _subjectController,
                          hintText: "Descreva brevemente o problema",
                          icon: Icons.subject_outlined,
                        ),
                        const SizedBox(height: 20),

                        // Descrição
                        _buildLabel("Descrição Detalhada *"),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.amber.withOpacity(0.5),
                              width: 1,
                            ),
                          ),
                          child: TextField(
                            controller: _descriptionController,
                            maxLines: 5,
                            style: GoogleFonts.cinzel(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            decoration: InputDecoration(
                              hintText: "Descreva o problema em detalhes...",
                              hintStyle: GoogleFonts.cinzel(
                                color: Colors.white54,
                                fontSize: 14,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(15),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Botão Enviar
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: _submitSupport,
                            icon: const Icon(Icons.send_outlined),
                            label: Text(
                              "Enviar Solicitação",
                              style: GoogleFonts.cinzel(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Informações de contato
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.amber.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Outras formas de contato",
                          style: GoogleFonts.cinzel(
                            color: Colors.amber,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildContactInfo(
                              Icons.email_outlined,
                              "Email",
                              "suporte@rpgapp.com",
                            ),
                            _buildContactInfo(
                              Icons.access_time_outlined,
                              "Horário",
                              "24h/7 dias",
                            ),
                            _buildContactInfo(
                              Icons.schedule_outlined,
                              "Resposta",
                              "Até 24h",
                            ),
                          ],
                        ),
                      ],
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

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: GoogleFonts.cinzel(
          color: Colors.amber,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.amber.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: GoogleFonts.cinzel(
          color: Colors.white,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.cinzel(
            color: Colors.white54,
            fontSize: 14,
          ),
          prefixIcon: Icon(icon, color: Colors.amber),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(15),
        ),
      ),
    );
  }

  Widget _buildContactInfo(IconData icon, String title, String info) {
    return Column(
      children: [
        Icon(icon, color: Colors.amber, size: 24),
        const SizedBox(height: 8),
        Text(
          title,
          style: GoogleFonts.cinzel(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          info,
          style: GoogleFonts.cinzel(
            color: Colors.white70,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}