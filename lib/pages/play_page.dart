
import 'package:flutter/material.dart';

import '../services/ai_engine.dart';
import '../theme/app_theme.dart';

class PlayPage extends StatefulWidget {
  final void Function({
  required String playerX,
  required String playerO,
  required bool vsAI,
  required AiDifficulty difficulty,
  }) onStartGame;

  const PlayPage({
    super.key,
    required this.onStartGame,
  });

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  final playerX = TextEditingController(text: 'Player One');
  final playerO = TextEditingController(text: 'Player Two');

  String selectedMode = 'local';
  AiDifficulty difficulty = AiDifficulty.medium;

  @override
  void dispose() {
    playerX.dispose();
    playerO.dispose();
    super.dispose();
  }

  void startGame() {
    widget.onStartGame(
      playerX: playerX.text.trim().isEmpty
          ? 'Player One'
          : playerX.text.trim(),
      playerO: selectedMode == 'ai'
          ? 'Computer'
          : playerO.text.trim().isEmpty
          ? 'Player Two'
          : playerO.text.trim(),
      vsAI: selectedMode == 'ai',
      difficulty: difficulty,
    );
  }

  @override
  Widget build(BuildContext context) {
    final vsAI = selectedMode == 'ai';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(23),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Let's play",
            style: TextStyle(
              color: GameColors.ink,
              fontSize: 29,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 7),
          const Text(
            'Choose your opponent and start a match.',
            style: TextStyle(
              color: GameColors.muted,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 29),
          const Text(
            'GAME MODE',
            style: TextStyle(
              color: GameColors.muted,
              fontSize: 10,
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 13),
          _modeTile(
            'Two players',
            'Play with a friend on the same device',
            Icons.people_alt_rounded,
            'local',
            GameColors.sage,
          ),
          const SizedBox(height: 12),
          _modeTile(
            'Play against AI',
            'Challenge your computer opponent',
            Icons.smart_toy_rounded,
            'ai',
            GameColors.burgundy,
          ),
          const SizedBox(height: 28),
          if (vsAI) ...[
            const Text(
              'CHOOSE DIFFICULTY',
              style: TextStyle(
                color: GameColors.muted,
                fontSize: 10,
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 13),
            _difficultyCard(
              'Easy',
              'A relaxed opponent',
              AiDifficulty.easy,
              GameColors.sage,
            ),
            const SizedBox(height: 10),
            _difficultyCard(
              'Medium',
              'Thinks ahead and blocks',
              AiDifficulty.medium,
              GameColors.gold,
            ),
            const SizedBox(height: 10),
            _difficultyCard(
              'Hard',
              'Optimal strategic play',
              AiDifficulty.hard,
              GameColors.burgundy,
            ),
          ],
          const SizedBox(height: 25),
          const Text(
            'PLAYER DETAILS',
            style: TextStyle(
              color: GameColors.muted,
              fontSize: 10,
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          _nameField('Your name (Player X)', playerX, GameColors.sage),
          if (!vsAI) ...[
            const SizedBox(height: 14),
            _nameField(
              'Second player (Player O)',
              playerO,
              GameColors.burgundy,
            ),
          ],
          const SizedBox(height: 30),
          SizedBox(
            height: 55,
            child: FilledButton.icon(
              onPressed: startGame,
              style: FilledButton.styleFrom(
                backgroundColor: GameColors.sage,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text(
                'Start match',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _modeTile(
      String title,
      String subtitle,
      IconData icon,
      String mode,
      Color color,
      ) {
    final selected = selectedMode == mode;

    return InkWell(
      onTap: () => setState(() => selectedMode = mode),
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeInOutCubic,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: selected
              ? color.withValues(alpha: 0.09)
              : GameColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? color : GameColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 28, color: color),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: GameColors.ink,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: GameColors.muted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              selected ? Icons.check_circle : Icons.circle_outlined,
              color: selected ? color : GameColors.muted,
            ),
          ],
        ),
      ),
    );
  }

  Widget _difficultyCard(
      String title,
      String subtitle,
      AiDifficulty value,
      Color color,
      ) {
    final selected = difficulty == value;

    return InkWell(
      onTap: () => setState(() => difficulty = value),
      borderRadius: BorderRadius.circular(15),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 13,
        ),
        decoration: BoxDecoration(
          color: selected
              ? color.withValues(alpha: 0.09)
              : GameColors.surface,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: selected ? color : GameColors.border,
            width: selected ? 1.4 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: GameColors.ink,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: GameColors.muted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              selected ? Icons.check_circle : Icons.circle_outlined,
              color: selected ? color : GameColors.muted,
            ),
          ],
        ),
      ),
    );
  }

  Widget _nameField(
      String label,
      TextEditingController controller,
      Color color,
      ) {
    return TextField(
      controller: controller,
      maxLength: 16,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        counterText: '',
        labelText: label,
        filled: true,
        fillColor: GameColors.surface,
        prefixIcon: Icon(Icons.person_outline, color: color),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: GameColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: GameColors.border),
        ),
      ),
    );
  }
}
