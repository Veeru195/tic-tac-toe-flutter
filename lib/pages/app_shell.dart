
import 'package:flutter/material.dart';

import '../services/ai_engine.dart';
import '../widgets/bottom_navigation.dart';
import 'home_page.dart';
import 'play_page.dart';
import 'game_page.dart';
import 'records_page.dart';
import 'profile_page.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int currentIndex = 0;

  void changePage(int index) {
    setState(() => currentIndex = index);
  }

  void startGame({
    required String playerX,
    required String playerO,
    required bool vsAI,
    required AiDifficulty difficulty,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GamePage(
          playerX: playerX,
          playerO: playerO,
          vsAI: vsAI,
          difficulty: difficulty,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(
        onPlay: () => changePage(1),
        onRecords: () => changePage(2),
      ),
      PlayPage(onStartGame: startGame),
      RecordsPage(isActive: currentIndex == 2),
      ProfilePage(isActive: currentIndex == 3),
    ];

    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: currentIndex,
          children: pages,
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: currentIndex,
        onTap: changePage,
      ),
    );
  }
}
