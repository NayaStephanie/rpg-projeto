// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'add_quest_screen.dart';
import 'add_journal_screen.dart';
import 'add_achievement_screen.dart';
import 'list_quests_screen.dart';
import 'list_journals_screen.dart';
import 'list_achievements_screen.dart';
import '../api/dnd_monsters_list_screen.dart';

class ManageCollectionsScreen extends StatelessWidget {
  const ManageCollectionsScreen({super.key});

  Widget _buildAction(BuildContext context, {required IconData icon, required String title, required String buttonText, required VoidCallback onPressed}) {
    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF767676).withOpacity(0.35),
      foregroundColor: Colors.white,
      textStyle: GoogleFonts.imFellEnglish(fontSize: 14),
      minimumSize: const Size(92, 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF767676).withOpacity(0.15),
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(title, style: GoogleFonts.imFellEnglish(fontSize: 18)),
        trailing: ElevatedButton(onPressed: onPressed, style: buttonStyle, child: Text(buttonText, style: GoogleFonts.imFellEnglish())),
        onTap: onPressed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Gerenciar Conteúdos', style: GoogleFonts.imFellEnglish(fontSize: 20)),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Image.asset(
              'lib/assets/images/image_dracon_inicio.png',
              fit: BoxFit.cover,
            ),
          ),
          Container(color: Colors.black.withOpacity(0.65)),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 96, 16, 16),
            child: ListView(
              children: [
                _buildAction(
                  context,
                  icon: Icons.flag,
                  title: 'Minhas Missões',
                  buttonText: 'Ver',
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ListQuestsScreen())),
                ),
                _buildAction(
                  context,
                  icon: Icons.bug_report,
                  title: 'Monstros (DND5e)',
                  buttonText: 'Ver',
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DndMonstersListScreen())),
                ),
                _buildAction(
                  context,
                  icon: Icons.add_task,
                  title: 'Nova Missão',
                  buttonText: 'Criar',
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddQuestScreen())),
                ),
                _buildAction(
                  context,
                  icon: Icons.book,
                  title: 'Meu Diário',
                  buttonText: 'Ver',
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ListJournalsScreen())),
                ),
                _buildAction(
                  context,
                  icon: Icons.note_add,
                  title: 'Nova Entrada',
                  buttonText: 'Criar',
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddJournalScreen())),
                ),
                _buildAction(
                  context,
                  icon: Icons.emoji_events,
                  title: 'Conquistas',
                  buttonText: 'Ver',
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ListAchievementsScreen())),
                ),
                _buildAction(
                  context,
                  icon: Icons.thumb_up,
                  title: 'Nova Conquista',
                  buttonText: 'Criar',
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddAchievementScreen())),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
