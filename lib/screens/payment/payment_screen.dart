import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_rpg/services/subscription_service.dart';

class PaymentScreen extends StatefulWidget {
  final bool fromSignup;
  
  const PaymentScreen({
    super.key,
    this.fromSignup = false,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  String _selectedPlan = 'mensal';
  String _selectedPayment = 'cartao';
  bool _isProcessing = false;
  
  // Controladores para os campos de cartão
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardNameController = TextEditingController();
  final TextEditingController _cardExpiryController = TextEditingController();
  final TextEditingController _cardCvvController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _cardNumberController.dispose();
    _cardNameController.dispose();
    _cardExpiryController.dispose();
    _cardCvvController.dispose();
    super.dispose();
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
                image: AssetImage("lib/assets/images/image_dracon_2.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.7),
          ),
          
          // Conteúdo
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Header
                    _buildHeader(),
                    const SizedBox(height: 30),
                    
                    // Planos
                    _buildPlansSection(),
                    const SizedBox(height: 30),
                    
                    // Métodos de Pagamento
                    _buildPaymentMethodsSection(),
                    const SizedBox(height: 30),
                    
                    // Formulário de Cartão
                    if (_selectedPayment == 'cartao') ...[
                      _buildCardForm(),
                      const SizedBox(height: 30),
                    ],
                    
                    // Resumo do Pedido
                    _buildOrderSummary(),
                    const SizedBox(height: 30),
                    
                    // Botões de Ação
                    _buildActionButtons(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '👑 Upgrade Premium',
                style: GoogleFonts.jimNightshade(
                  fontSize: 36,
                  color: Colors.amber,
                  shadows: [
                    Shadow(
                      offset: const Offset(2, 2),
                      blurRadius: 4,
                      color: Colors.black.withOpacity(0.7),
                    ),
                  ],
                ),
              ),
              Text(
                'Desbloqueie todo o potencial do RPG Maker',
                style: GoogleFonts.cinzel(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlansSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2C1810).withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.amber.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Escolha seu Plano',
            style: GoogleFonts.jimNightshade(
              fontSize: 24,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 20),
          
          // Plano Mensal
          _buildPlanOption(
            'mensal',
            'Plano Mensal',
            'R\$ 9,90',
            '/mês',
            'Ideal para testar',
            Icons.calendar_month,
          ),
          const SizedBox(height: 12),
          
          // Plano Anual
          _buildPlanOption(
            'anual',
            'Plano Anual',
            'R\$ 99,90',
            '/ano',
            'Economize 17% • Mais popular',
            Icons.event,
            isPopular: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPlanOption(
    String planId,
    String title,
    String price,
    String period,
    String description,
    IconData icon, {
    bool isPopular = false,
  }) {
    final isSelected = _selectedPlan == planId;
    
    return GestureDetector(
      onTap: () => setState(() => _selectedPlan = planId),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.amber.withOpacity(0.2) : Colors.grey.shade800.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.amber : Colors.grey.shade600,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.amber : Colors.white70,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: GoogleFonts.cinzel(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (isPopular) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'POPULAR',
                            style: GoogleFonts.cinzel(
                              fontSize: 8,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: GoogleFonts.cinzel(
                      fontSize: 11,
                      color: Colors.white70,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  price,
                  style: GoogleFonts.cinzel(
                    fontSize: 18,
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  period,
                  style: GoogleFonts.cinzel(
                    fontSize: 11,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: isSelected ? Colors.amber : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2C1810).withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.amber.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Método de Pagamento',
            style: GoogleFonts.jimNightshade(
              fontSize: 24,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 20),
          
          _buildPaymentOption('cartao', 'Cartão de Crédito', Icons.credit_card),
          const SizedBox(height: 12),
          _buildPaymentOption('pix', 'PIX', Icons.qr_code),
          const SizedBox(height: 12),
          _buildPaymentOption('boleto', 'Boleto Bancário', Icons.receipt_long),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(String paymentId, String title, IconData icon) {
    final isSelected = _selectedPayment == paymentId;
    
    return GestureDetector(
      onTap: () => setState(() => _selectedPayment = paymentId),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.amber.withOpacity(0.2) : Colors.grey.shade800.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.amber : Colors.grey.shade600,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.amber : Colors.white70,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.cinzel(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: isSelected ? Colors.amber : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2C1810).withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.amber.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dados do Cartão',
            style: GoogleFonts.jimNightshade(
              fontSize: 24,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 20),
          
          // Número do Cartão
          _buildTextField(
            controller: _cardNumberController,
            label: 'Número do Cartão',
            hint: '1234 5678 9012 3456',
            icon: Icons.credit_card,
          ),
          const SizedBox(height: 16),
          
          // Nome no Cartão
          _buildTextField(
            controller: _cardNameController,
            label: 'Nome no Cartão',
            hint: 'João Silva',
            icon: Icons.person,
          ),
          const SizedBox(height: 16),
          
          Row(
            children: [
              // Data de Validade
              Expanded(
                child: _buildTextField(
                  controller: _cardExpiryController,
                  label: 'Validade',
                  hint: 'MM/AA',
                  icon: Icons.calendar_today,
                ),
              ),
              const SizedBox(width: 16),
              // CVV
              Expanded(
                child: _buildTextField(
                  controller: _cardCvvController,
                  label: 'CVV',
                  hint: '123',
                  icon: Icons.lock,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.cinzel(
            fontSize: 14,
            color: Colors.amber,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          style: GoogleFonts.cinzel(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.cinzel(color: Colors.white54),
            prefixIcon: Icon(icon, color: Colors.amber),
            filled: true,
            fillColor: Colors.grey.shade800.withOpacity(0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade600),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade600),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.amber, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderSummary() {
    final price = _selectedPlan == 'mensal' ? 'R\$ 9,90' : 'R\$ 99,90';
    final period = _selectedPlan == 'mensal' ? 'mensal' : 'anual';
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2C1810).withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.amber.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resumo do Pedido',
            style: GoogleFonts.jimNightshade(
              fontSize: 24,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 20),
          
          // Benefícios Premium
          _buildBenefit('✨', 'Personagens ilimitados'),
          _buildBenefit('☁️', 'Armazenamento na nuvem'),
          _buildBenefit('🎨', 'Temas exclusivos'),
          _buildBenefit('🔄', 'Backup automático'),
          _buildBenefit('📱', 'Acesso a recursos beta'),
          
          const SizedBox(height: 20),
          const Divider(color: Colors.amber),
          const SizedBox(height: 20),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Plano $period',
                style: GoogleFonts.cinzel(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                price,
                style: GoogleFonts.cinzel(
                  fontSize: 24,
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBenefit(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            emoji,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: GoogleFonts.cinzel(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Botão Principal
        SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
            ),
            onPressed: _isProcessing ? null : _processPayment,
            child: _isProcessing
                ? const CircularProgressIndicator(
                    color: Colors.black,
                    strokeWidth: 2,
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.security, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Finalizar Pagamento',
                        style: GoogleFonts.cinzel(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Garantia
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.green.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.verified_user,
                color: Colors.green,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'Garantia de 7 dias • Pagamento 100% seguro',
                style: GoogleFonts.cinzel(
                  fontSize: 12,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _processPayment() async {
    setState(() => _isProcessing = true);
    
    try {
      // Simula processamento de pagamento
      await Future.delayed(const Duration(seconds: 2));
      
      // Ativa o plano premium
      await SubscriptionService.upgradeToPremium();
      
      if (mounted) {
        // Mostra sucesso
        _showSuccessDialog();
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog();
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2C1810),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: const BorderSide(color: Colors.amber, width: 2),
          ),
          title: Column(
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                'Pagamento Aprovado!',
                style: GoogleFonts.jimNightshade(
                  color: Colors.amber,
                  fontSize: 24,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: Text(
            'Parabéns! Agora você é um usuário Premium e tem acesso a todos os recursos exclusivos.',
            style: GoogleFonts.cinzel(
              color: Colors.white,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                ),
                onPressed: () {
                  Navigator.of(context).pop(); // Fecha o dialog
                  if (widget.fromSignup) {
                    // Se veio do cadastro, volta para o fluxo normal
                    Navigator.of(context).pop();
                  } else {
                    // Se veio das configurações, volta
                    Navigator.of(context).pop();
                  }
                },
                child: Text(
                  'Continuar',
                  style: GoogleFonts.cinzel(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2C1810),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: const BorderSide(color: Colors.red, width: 2),
          ),
          title: Row(
            children: [
              const Icon(Icons.error, color: Colors.red),
              const SizedBox(width: 8),
              Text(
                'Erro no Pagamento',
                style: GoogleFonts.jimNightshade(
                  color: Colors.red,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          content: Text(
            'Não foi possível processar o pagamento. Tente novamente ou escolha outro método.',
            style: GoogleFonts.cinzel(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Tentar Novamente',
                style: GoogleFonts.cinzel(
                  color: Colors.amber,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}