
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class HomePage extends StatelessWidget {
  final VoidCallback onPlay;
  final VoidCallback onRecords;

  const HomePage({
    super.key,
    required this.onPlay,
    required this.onRecords,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(23, 25, 23, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Row(
            children: [
              Text(
                'TIC TAC TOE',
                style: TextStyle(
                  color: GameColors.ink,
                  fontWeight: FontWeight.w900,
                  fontSize: 19,
                  letterSpacing: 1.5,
                ),
              ),
              Spacer(),
              Icon(
                Icons.grid_view_rounded,
                color: GameColors.sage,
                size: 25,
              ),
            ],
          ),
          const SizedBox(height: 34),
          Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF50384F),
                  Color(0xFF332A3B),
                ],
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'WELCOME BACK',
                  style: TextStyle(
                    color: CoverColors.silverMuted,
                    fontSize: 10,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 13),
                const Text(
                  'Ready to play?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 29,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Your next match is waiting.',
                  style: TextStyle(
                    color: CoverColors.silverMuted,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: onPlay,
                    style: FilledButton.styleFrom(
                      backgroundColor: CoverColors.gold,
                      foregroundColor: CoverColors.background,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text(
                      'Play now',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 27),
          const Text(
            'CHOOSE YOUR GAME',
            style: TextStyle(
              color: GameColors.muted,
              fontSize: 11,
              letterSpacing: 1.7,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _modeCard(
                  'Two players',
                  'Play together',
                  Icons.people_alt_rounded,
                  GameColors.sage,
                  onPlay,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: _modeCard(
                  'Play with AI',
                  'Challenge computer',
                  Icons.smart_toy_rounded,
                  GameColors.burgundy,
                  onPlay,
                ),
              ),
            ],
          ),
          const SizedBox(height: 27),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Your progress',
                  style: TextStyle(
                    color: GameColors.ink,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              TextButton(
                onPressed: onRecords,
                child: const Text(
                  'View records',
                  style: TextStyle(color: GameColors.sage),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: GameColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: GameColors.border),
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.insights_rounded,
                  size: 35,
                  color: GameColors.sage,
                ),
                SizedBox(height: 12),
                Text(
                  'Your statistics will appear here',
                  style: TextStyle(
                    color: GameColors.ink,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Play your first match to start building your records.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: GameColors.muted,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _modeCard(
      String title,
      String subtitle,
      IconData icon,
      Color color,
      VoidCallback onTap,
      ) {
    return Material(
      color: GameColors.surface,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: GameColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 17),
              Text(
                title,
                style: const TextStyle(
                  color: GameColors.ink,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: const TextStyle(
                  color: GameColors.muted,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
