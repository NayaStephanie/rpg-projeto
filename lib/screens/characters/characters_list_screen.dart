import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_rpg/models/character_model.dart';
import 'package:app_rpg/services/character_storage_service.dart';
import 'package:app_rpg/services/subscription_service.dart';
import 'package:app_rpg/screens/ficha_pronta/ficha_pronta.dart';
import 'package:app_rpg/screens/settings/settings_screen.dart';
import 'dart:io';
class CharactersListScreen extends StatefulWidget {
  const CharactersListScreen({super.key});

  @override
  State<CharactersListScreen> createState() => _CharactersListScreenState();
}

class _CharactersListScreenState extends State<CharactersListScreen> {
  List<CharacterModel> _characters = [];
  bool _loading = true;
  bool _isPremium = false;
  int _characterLimit = 2;

  @override
  void initState() {
    super.initState();
    _loadCharacters();
  }

  Future<void> _loadCharacters() async {
    setState(() => _loading = true);
    try {
      final characters = await CharacterStorageService.getAllCharacters();
      final isPremium = await SubscriptionService.isPremiumUser();
      final limit = await SubscriptionService.getCharacterLimit();
      
      setState(() {
        _characters = characters;
        _isPremium = isPremium;
        _characterLimit = limit;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      _showErrorSnackBar('Erro ao carregar personagens');
    }
  }

  Future<void> _deleteCharacter(String characterId) async {
    final success = await CharacterStorageService.deleteCharacter(characterId);
    if (success) {
      _loadCharacters(); // Recarrega a lista
      _showSuccessSnackBar('Personagem excluído com sucesso');
    } else {
      _showErrorSnackBar('Erro ao excluir personagem');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showDeleteConfirmation(CharacterModel character) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: const Color(0xFF2C1810),
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(
              color: Colors.amber,
              width: 2,
            ),
            ),
          title: Text(
            'Excluir Personagem',
            style: GoogleFonts.jimNightshade(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
          content: Text(
            'Tem certeza que deseja excluir "${character.name}"?',
            style: GoogleFonts.imFellEnglish(
              color: Colors.white70,
              fontSize: 18,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancelar',
                style: GoogleFonts.cinzel(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteCharacter(character.id);
              },
              child: Text(
                'Excluir',
                style: GoogleFonts.cinzel(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _openCharacterSheet(CharacterModel character) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CharacterSheet(existingCharacter: character),
      ),
    ).then((_) => _loadCharacters()); // Recarrega a lista quando voltar
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
            color: Colors.black.withOpacity(0.6),
          ),
          
          // Conteúdo
          SafeArea(
            child: Column(
              children: [
                // Status premium e configurações no topo
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Botão de configurações
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SettingsScreen(),
                            ),
                          ).then((_) => _loadCharacters());
                        },
                        icon: Icon(
                          Icons.settings,
                          color: Colors.white.withOpacity(0.8),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Status premium com informações
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _isPremium ? Colors.amber : Colors.grey.shade700,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: _isPremium ? Colors.amber : Colors.grey,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _isPremium ? Icons.workspace_premium : Icons.person,
                                  color: _isPremium ? Colors.black : Colors.white,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _isPremium ? 'Premium' : 'Gratuito',
                                  style: GoogleFonts.cinzel(
                                    color: _isPremium ? Colors.black : Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (!_isPremium) ...[
                            const SizedBox(height: 4),
                            Text(
                              '${_characters.length}/$_characterLimit personagens',
                              style: GoogleFonts.cinzel(
                                color: Colors.white70,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Header com título centralizado
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: Stack(
                    children: [
                      // Botão de voltar posicionado à esquerda
                      Positioned(
                        left: 0,
                        top: 0,
                        child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ),
                      // Título centralizado
                      Center(
                        child: Text(
                          'Personagens',
                          style: GoogleFonts.jimNightshade(
                            fontSize: 48,
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
                      ),
                    ],
                  ),
                ),
                
                // Lista de personagens
                Expanded(
                  child: _loading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : _characters.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.person_off,
                                    size: 80,
                                    color: Colors.white.withOpacity(0.5),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Nenhum personagem encontrado',
                                    style: GoogleFonts.jimNightshade(
                                      fontSize: 24,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Crie seu primeiro personagem!',
                                    style: GoogleFonts.jimNightshade(
                                      fontSize: 18,
                                      color: Colors.white54,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              itemCount: _characters.length,
                              itemBuilder: (context, index) {
                                final character = _characters[index];
                                return _buildCharacterCard(character);
                              },
                            ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterCard(CharacterModel character) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: const Color(0xFF2C1810).withOpacity(0.9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.amber.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () => _openCharacterSheet(character),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header do card com avatar, nome e botão de delete
              Row(
                children: [
                  // Avatar do personagem
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.amber,
                        width: 2,
                      ),
                      color: Colors.grey.shade800,
                    ),
                    child: character.avatarPath != null
                        ? ClipOval(
                            child: kIsWeb
                                ? Image.network(
                                    character.avatarPath!,
                                    fit: BoxFit.cover,
                                    width: 60,
                                    height: 60,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.person,
                                        color: Colors.white,
                                        size: 30,
                                      );
                                    },
                                  )
                                : Image.file(
                                    File(character.avatarPath!),
                                    fit: BoxFit.cover,
                                    width: 60,
                                    height: 60,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.person,
                                        color: Colors.white,
                                        size: 30,
                                      );
                                    },
                                  ),
                          )
                        : const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 30,
                          ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          character.name,
                          style: GoogleFonts.jimNightshade(
                            fontSize: 28,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${character.race} ${character.characterClass}',
                          style: GoogleFonts.jimNightshade(
                            fontSize: 18,
                            color: Colors.amber,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => _showDeleteConfirmation(character),
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                      size: 24,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Informações básicas - todas na mesma linha
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildInfoChip('Nível ${character.level}'),
                  _buildInfoChip('PV ${character.hitPoints}'),
                  _buildInfoChip('CA ${character.armorClass}'),
                  _buildInfoChip(character.background),
                ],
              ),
              const SizedBox(height: 8),
              
              // Data de criação
              Text(
                'Criado em ${_formatDate(character.createdAt)}',
                style: GoogleFonts.jimNightshade(
                  fontSize: 14,
                  color: Colors.white54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.amber.withOpacity(0.4),
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.jimNightshade(
          fontSize: 14,
          color: Colors.amber,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}